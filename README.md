# debian-debootstrap-ports

[![actions](https://github.com/ioerror/debian-debootstrap-ports/actions/workflows/actions.yml/badge.svg?branch=main)](https://github.com/ioerror/debian-debootstrap-ports/actions/workflows/actions.yml)
 [![Docker Pulls](https://img.shields.io/docker/pulls/ioerror/debian-debootstrap-ports)](https://hub.docker.com/r/ioerror/debian-debootstrap-ports)
[![CI](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/ioerror/debian-debootstrap-ports/blob/main/LICENSE)
 
 `debian-debootstrap-ports` Docker image for multiple architectures (ports)

## Usage

Before using this Docker image, you need to configure binfmt-support on your Docker host. This works both locally and remotely (e.g., using boot2docker or swarm).

```console
$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

Once configured, you can run a `powerpc` image from your `x86_64` Docker host.

```console
$ $ docker run -it --rm ioerror/debian-debootstrap-ports:powerpc-trixie-sid
root@12c7a97fd7d8:/# uname -a
Linux 12c7a97fd7d8 5.15.133.1-microsoft-standard-WSL2 #1 SMP Thu Oct 5 21:02:42 UTC 2023 ppc GNU/Linux
root@12c7a97fd7d8:/#
```

## Supported ports

Port            | Architecture          | Description
| ------------- | --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
alpha           | Alpha	                | Port to the 64-bit RISC Alpha architecture.                                                                                                                                        |
hppa            | HP PA-RISC            | Port to Hewlett-Packard's PA-RISC architecture.                                                                                                                                    |
m68k            | Motorola 68k          | Port to the Motorola 68k series of processors — in particular, the Sun3 range of workstations, the Apple Macintosh personal computers, and the Atari and Amiga personal computers. |
powerpc/ppc64   | Motorola/IBM PowerPC  | Port for many of the Apple Macintosh PowerMac models, and CHRP and PReP open architecture machines.                                                                                |
sh4             | SuperH                | Port to Hitachi SuperH processors. Also supports the open source J-Core processor.                                                                                                 |

## Source of Images

The images provided in this repository are sourced from [Debian other ports](https://www.debian.org/ports/#portlist-other).

## Original Project

This project is based on [multiarch/debian-debootstrap](https://github.com/multiarch/debian-debootstrap), which supports a wide range of other architectures.
This project was forked from [urbanogilson/debian-debootstrap-ports](https://github.com/urbanogilson/debian-debootstrap-ports).

## License

This project is licensed under the [MIT License](LICENSE).
