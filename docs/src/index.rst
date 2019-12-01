.. synos documentation master file, created by
   sphinx-quickstart on Sat Nov  2 22:53:23 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Synos documentation
================================

The Synos kernel is the kernel underlying the 'Micro Kernel Operating System'. It it built to be as modular and customizable as possible. The kernel is still under heavy development. Plans is to first finish support for X86_64 platform and some basic firmware such as file systems and power management.

Contributing
================================

You are more than welcome to give feedback, report issues, and open pull requests. If you have questions, do not hesitate to contact me!

Configuring/Building
================================

The `.config` file consists of all important variables for tweaking the kernel. The default values works for most user, although if you are planning on using it for other reasons then to reprogram it, it is recommended to set `DEBUG` to `FALSE` and `OPTIMIZE` to `TRUE`. The recommended compiler to use is gcc since it is proven to work, but it is still possible to change the compiler to for example clang and other binaries like the assembly compiler. 

With the default config, the binaries needed to build Synos is: `make`, `gcc`, `g++`, `nasm`, and `ld`. To be able to install synos to an iso file with grub, `grub`, `xorriso`, and `mtools` is needed.

To compile the selected targets in `.config`, run:

    make all

Running
================================

Currently, the only automated way to install synos is to install synos to an iso file along with grub:

    make grub INSTALL_DRIVE=...

This will create or overwrite `INSTALL_DRIVE` with the kernel. If no `INSTALL_DRIVE` is provided, the script will default back to `synos.iso`.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   kernel/index.rst
   drivers/index.rst

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
