ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

LABEL maintainer="h1k0naka <h1k0naka@outlook.com>"

ENV DEBIAN_FRONTEND nointeractive
ENV TZ Asia/Shanghai

# Install software from apt source
RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    apt-transport-https \
    ca-certificates \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    apt-utils \
    cmake \
    python3 \
    ipython3 \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    python3-distutils \
    bison \
    rpm2cpio cpio \
    zstd \
    zsh \
    bat \
    elfutils \
    qemu-user-static \
    qemu-user \
    qemu-system \
    binwalk mtd-utils zlib1g-dev liblzma-dev gzip bzip2 tar squashfs-tools liblzo2-dev \
    telnet ftp ranger ripgrep \
    tzdata --fix-missing && \
    rm -rf /var/lib/apt/list/*

# install sasquatch
RUN git clone https://github.com/devttys0/sasquatch /opt/sasquatch && \
    cd /opt/sasquatch && \
    wget https://raw.githubusercontent.com/devttys0/sasquatch/82da12efe97a37ddcd33dba53933bc96db4d7c69/patches/patch0.txt && \
    mv patch0.txt patches && \
    ./build.sh

# install one_gadgets and seccomp-tools
RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

# Configure timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# Create a regular user "hacker" with sudo privileges
RUN apt install sudo && \
    useradd -m hacker && \
    usermod -aG sudo hacker && \
    echo 'hacker ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/hacker

# Switch to the new user before installing user-specific dependencies
USER hacker
ENV PATH="$PATH:/home/hacker/.local/bin"
# Set workspace directory
RUN mkdir /home/hacker/workspace
WORKDIR /home/hacker/workspace

# This is a script to automate Oh My Zsh installation in development containers.
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -t robbyrussell \
    -p git \
    -p z \
    -p extract \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting
RUN sudo usermod -s $(which zsh) hacker && ulimit -n 1024

# config vim
COPY .vimrc /home/hacker
# config tmux
COPY .tmux.conf /home/hacker

# Install pwndbg under the user environment
RUN git clone https://github.com/pwndbg/pwndbg.git /home/hacker/pwndbg && \
    cd /home/hacker/pwndbg && ./setup.sh
# Ensure that the pwndbg installation is properly configured
ENV TERM=xterm-256color

# install python packages
RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    ropgadget \
    z3-solver \
    smmap2 \
    apscheduler \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr \
    pebble \
    r2pipe \
    r2env \
    pwntools \
    virtualenvwrapper \
    pysocks \
    scapy \
    ipython \
    boofuzz \
    setuptools \
    pycrypto 

RUN python3 -m pip install --user unblob

# # install gef and pwngdb ...
# RUN bash -c "$(wget https://gef.blah.cat/sh -O -)"
# RUN git clone --depth 1 https://github.com/scwuaptx/Pwngdb.git ~/Pwngdb && \
#     cd ~/Pwngdb && mv .gdbinit .gdbinit-pwngdb && \
#     sed -i "s?source ~/peda/peda.py?# source ~/peda/peda.py?g" .gdbinit-pwngdb && \
#     echo "source ~/Pwngdb/.gdbinit-pwngdb" >> ~/.gdbinit

# RUN echo "export LC_CTYPE=C.UTF-8\n" >> ~/.zshrc

CMD ["/bin/zsh"]
