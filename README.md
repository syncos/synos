# Synos kernel
<a href="https://travis-ci.com/syncos/synos"><img src="https://travis-ci.com/syncos/synos.svg?branch=master"></img></a>

The Synos kernel is the kernel underlying the 'Micro Kernel Operating System'. It it built to be as modular and customizable as possible. The kernel is still under heavy development. Plans is to first finish support for X86_64 platform and some basic firmware such as file systems and power management.
# Contributing
You are more than welcome to give feedback, report issues, and open pull requests. If you have questions, do not hesitate to contact me!
# Configuring/Building
The `.config` file consists of all important variables for tweaking the kernel. The default values works for most user, although if you are planning on using it for other reasons then to reprogram it, it is recommended to set `DEBUG` to `FALSE` and `OPTIMIZE` to `TRUE`. The recommended compiler to use is gcc since it is proven to work, but it is still possible to change the compiler to for example clang and other binaries like the assembly compiler. 

Default config files exist in the `conf/` directory. You need to copy the correct configuration to .config for the kernel to compile.

With the default config for X86_64 (`cp conf/X86_64.config .config`), the binaries needed to build synos is: `make`, `gcc`, `g++`, `nasm`, and `ld` (if you are compiling on the same platform as the target, if not then you'll have to configure the config to use a cross-compiler). To be able to install synos to an iso file with grub, `grub`, `xorriso`, and `mtools` is also needed.

To compile the selected targets in `.config`, run:

    make
# Running
Currently, the only automated way to install synos is to install synos to an iso file along with grub:

    make grub INSTALL_DRIVE=...
This will create or overwrite `INSTALL_DRIVE` with the kernel. If no `INSTALL_DRIVE` is provided, the makefile will default back to `synos.iso`.

The makefile has a built in `qemu` option which is compatible with the output of `make grub`:

    make qemu INSTALL_DRIVE=...
# Documentation
Documentation is currenly very scarse. but more should hopefully show up in `docs/` in the future. The documentation system will probably use sphinx.
