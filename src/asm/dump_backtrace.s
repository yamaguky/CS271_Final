.globl _dump_backtrace
.type  _dump_backtrace, @function

# Constants
.equ    MAX_FRAMES,   64   # Max stack frames to walk
.equ    DLINFO_SZ,    32   # sizeof(struct Dl_info)
.equ    SLOT_SZ,      48   # DLINFO_SZ + 16 for alignment

_dump_backtrace:
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %rbx
        pushq   %r12
        pushq   %r13
        pushq   %r14

        xorq    %r14, %r14            # depth = 0
        movq    (%rbp), %rbx          # current frame pointer
        leaq    -1(%rsp), %r13        # for segfault guard

.Loop:
        cmpq    $MAX_FRAMES, %r14
        jge     .Done
        testq   %rbx, %rbx
        je      .Done
        cmpq    %r13, %rbx
        jb      .Done

        movq    (%rbx), %r12          # parent frame pointer
        testq   %r12, %r12
        je      .Done

        movq    8(%rbx), %rdi         # return address → rdi
        subq    $SLOT_SZ, %rsp        # reserve stack for Dl_info
        leaq    (%rsp), %rsi          # rsi = &Dl_info
        call    dladdr@PLT

        # printf("%3ld: [%lx] %s () %s\n", depth, ret_addr, symbol name, image name)
        movq    24(%rsp), %rdx        # dli_saddr
        movq    16(%rsp), %rcx        # dli_sname
        movq     0(%rsp), %r8         # dli_fname

        leaq    backtrace_format_str(%rip), %rdi
        movq    %r14, %rsi            # depth
        xorq    %r9, %r9              # clear r9 (not used)
        call    printf@PLT

        addq    $SLOT_SZ, %rsp        # deallocate Dl_info

        incq    %r14
        movq    %r12, %rbx
        jmp     .Loop

.Done:
        popq    %r14
        popq    %r13
        popq    %r12
        popq    %rbx
        popq    %rbp
        ret

.section .rodata
backtrace_format_str:
        .asciz  "%3ld: [%lx] %s () %s\n"
