# MUTILS
Library simulating a standard C library for the kernel. If this library isn't linked with the initimg, there is a big probability that the kernel will not link, if you do not provide your own C library, which is not adviced since another C library linked out of the box will probably not work.

Parts of the library are taken from <a href="https://github.com/dryc/libc11">The libc11 library</a>.