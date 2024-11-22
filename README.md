# PwnDocker
PwnDocker is a Docker container designed primarily for hacking Linux-based programs across different architectures. It comes pre-installed with most commonly used debugging, exploitation, and automated analysis tools.

The default user is `hacker`, the default working directory is `/home/hacker/workspace`, and the default shell is `zsh` with the `oh-my-zsh` framework installed.

- Note: IDA Pro and Ghidra are not included in the container due to their bulky installation sizes.


## Build
```shell
git clone https://github.com/noobone123/PwnDocker.git
cd PwnDocker
docker build --build-arg UBUNTU_VERSION=22.04 -t pwn_docker:22.04 .
```
Ubuntu versions >= 22.04 are supported.

## Run
```shell
docker run -itd \                            # ...
    --cap-add=SYS_PTRACE \                   # Enable ptrace capabilities (required for debugging)
    -v /path/to/host/workspace:/home/hacker/workspace \  # Optional: Mount the host workspace directory to the container
    --privileged \                           # Optional: Grant privileged access (needed for certain tools like gdbserver)
    pwn_docker:22.04                          # The image name and tag
```
Feel free to adapt the commands above to suit your specific setup and use case.

## License
This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License](https://creativecommons.org/licenses/by-nc/4.0/).  
- **Non-Commercial**: You may not use this work for commercial purposes.  
- **Attribution**: Proper credit must be given to the original author and source.
