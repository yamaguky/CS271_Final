.extern _debug_dump_registers
.globl dump_registers
.type dump_registers, @function

dump_registers:
    subq $128, %rsp

    movq %rax,   0(%rsp)
    movq %rbx,   8(%rsp)
    movq %rcx,  16(%rsp)
    movq %rdx,  24(%rsp)
    movq %rsi,  32(%rsp)
    movq %rdi,  40(%rsp)
    movq %rbp,  48(%rsp)

    leaq 8(%rbp), %rax     
    movq %rax,  56(%rsp)

    movq %r8,   64(%rsp)
    movq %r9,   72(%rsp)
    movq %r10,  80(%rsp)
    movq %r11,  88(%rsp)
    movq %r12,  96(%rsp)
    movq %r13, 104(%rsp)
    movq %r14, 112(%rsp)
    movq %r15, 120(%rsp)

    # Now call the C function with pointer to register dump
    movq %rsp, %rdi
    call _debug_dump_registers

    # Clean up stack
    addq $128, %rsp
    ret
