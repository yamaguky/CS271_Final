```
# CS271 Final Project - Debugging: Walking the Stack
### By Abdul Raziq, Kyohei Yamaguchi, and Christopher Vote


## Map of directories

project-root/  
|____include/  
|    |----debug.h  
|____lib/  
|    |----(empty)  
|____src/  
|    |----asm/  
|    |    |----dump_registers.s  
|    |    |----dump_backtrace.s  
|    |----debug.c  
|____test/  
|     |----main.c  
|____makefile  
|____README.md  
|____README.tx


## Built With
- **x86-64 Assembly Language (GNU AS, AT&T Syntax)**
- Performs function calls complying with System V ABI using C standard library linkage.

- **C**

## Running the Project
1. From the root directory, type `make`.
2. Type `make clean` to clean.

## Overview
This project implements two core debugging utilities in x86-64 assembly and C:
- `dump_registers`: Captures and displays general-purpose register values.
- `dump_backtrace`: Walks the call stack and prints a backtrace using saved frame pointers and `dladdr`.

The utilities are invoked from the C file debug.c. 

Assembly language is utilized for the 'dump_registers' and 'dump_backtrace' utilities.

The 'dump_registers' utility manually pushes register values to the stack, which are then dumped by the C function. 

It is necessary to move the registers manually so that caller-saved registers, like %rax and %rcx, will not be overwritten. 

The function walks up the stack using the frame pointer and extracts register values in specified order. 
A full dump is made of general-purpose register values, in both decimal and hexadecimal formats.

Register values are dumped in the following order:
%rax, %rbx, %rcx, %rdx, %rsi, %rdi, %rbp, %rsp, %r8, %r9, %r10, %r11, %r12, %r13, %r14, %r15.


The 'dump_backtrace' utility manually walks up the stack and calls dladder() from the C standard 
library to resolve return addresses to symbol names. That is, it converts return addresses for each
function to human-readable format. These are printed to standard output using the printf() function.


## Example output

rax	42 (0x2a)  
rbx	140720813640424 (0x7ffc1e1c0ae8)  
rcx	4 (0x4)  
rdx	3 (0x3)  
rsi	2 (0x2)  
rdi	1 (0x1)  
rbp	140720813640096 (0x7ffc1e1c09a0)  
rsp	140720813640104 (0x7ffc1e1c09a8)  
r8	5 (0x5)  
r9	6 (0x6)  
r10	140720813639392 (0x7ffc1e1c06e0)  
r11	515 (0x203)  
r12	1 (0x1)  
r13	0 (0x0)  
r14	103690382863800 (0x5e4e4c6fedb8)  
r15	139151193870336 (0x7e8ea97b1000)  
  0: [5e4e4c6fc149] g () test/main  
  1: [5e4e4c6fc185] f () test/main  
  2: [5e4e4c6fc1ba] main () test/main  
  3: [0] (null) () /lib/x86_64-linux-gnu/libc.so.6  
  4: [7e8ea942a200] __libc_start_main () /lib/x86_64-linux-gnu/libc.so.6  
```
