#define _GNU_SOURCE
#include <stdio.h>
#include <stdint.h>
#include <dlfcn.h>
#include <string.h>

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

extern const char backtrace_format_str[];  
extern void *get_rbp_pointer(void);

/* Internal helper function */
void _debug_dump_registers(long const *regs)
{
    for (int i = 0; i < 16; i++) {
        printf("%s\t%ld (0x%lx)\n", regnames[i], regs[i], (unsigned long)regs[i]);
    }
}



void dump_backtrace(void) {
    void **frame_pointer = get_rbp_pointer();

    long depth = 0;
    while (frame_pointer && frame_pointer[1] ) { 
        void *return_address = frame_pointer[1];

        Dl_info info;

        if (dladdr(return_address, &info)) {
            printf(backtrace_format_str, depth, info.dli_saddr, info.dli_sname ? info.dli_sname : "??", info.dli_fname ? info.dli_fname : "??");  
        }
        frame_pointer = (void **)frame_pointer[0];
        depth++;
    }
}

