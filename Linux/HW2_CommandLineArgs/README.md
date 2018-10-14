# Command line arguments inspection.

## Overview
In x86_64 linux, when a program is executed, its command line arguments are pushed onto the stack in the following order:

| Item | Location | Note |
| ---- | ---- | ---- |
| argc | rsp | Top |
| args[0] (i.e., *path) | rsp + 8 ||
| args[1] | rsp + 16 ||
| args[2] | rsp + 24 ||
| args[3] | rsp + 32 ||
| args[n] | rsp + 8 * (n-1) ||

You should copy the address in rsp to another register (e.g., to rax), and manipulate on rax!
(On x86 linux, the rsp should be replaced by esp, and the gap between arguments is 4 bytes.)

## Example
When one executes `./args punk ass nigga`, then the stack layout should be like this:

* 4
* mem address to "./args"
* mem address to "punk"
* mem address to "nigga"

Note that going beyond the program's stack would cause a segmentation fault, meaning that your program is trying to access some part of memory that is owned by another process,
which is prohibited by the operating system.


## Further Reading
[Stack frame layout on x86-64](https://eli.thegreenplace.net/2011/09/06/stack-frame-layout-on-x86-64/) by Eli Bendersky
[All About EBP](https://practicalmalwareanalysis.com/2012/04/03/all-about-ebp/) by andykhonig
