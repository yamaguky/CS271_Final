#include <stdio.h>

#include "debug.h"

char const *regnames[] = {
    "rax",
    "rbx",
    "rcx",
    "rdx",
    "rsi",
    "rdi",
    "rbp",
    "rsp",
    "r8",
    "r9",
    "r10",
    "r11",
    "r12",
    "r13",
    "r14",
    "r15",
};

extern void _dump_backtrace(void);

/* Internal helper function */
void _debug_dump_registers(long const *regs)
{
    for (int i = 0; i < 16; i++) {
        printf("%s\t%ld (0x%lx)\n", regnames[i], regs[i], (unsigned long)regs[i]);
    }
}


void dump_backtrace(void)
{
    _dump_backtrace();              
}
