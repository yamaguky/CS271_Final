.extern _debug_dump_registers
.globl dump_registers
.type dump_registers, @function

dump_registers:
    subq $128, %rsp		# Allocates 128 bytes on the stack to store registers

    # Save caller-saved and callee-saved general-purpose registers
    movq %rax,   0(%rsp	
    movq %rbx,   8(%rsp)
    movq %rcx,  16(%rsp)
    movq %rdx,  24(%rsp)
    movq %rsi,  32(%rsp)
    movq %rdi,  40(%rsp)
    movq %rbp,  48(%rsp)

    leaq 8(%rbp), %rax    	# Load return address into %rax at [%rbp + 8]
    movq %rax,  56(%rsp)	# Save return address

    movq %r8,   64(%rsp)
    movq %r9,   72(%rsp)
    movq %r10,  80(%rsp)
    movq %r11,  88(%rsp)
    movq %r12,  96(%rsp)
    movq %r13, 104(%rsp)
    movq %r14, 112(%rsp)
    movq %r15, 120(%rsp)

    # Now call the C function with pointer to register dump
    movq %rsp, %rdi		# Pass pointer to saved registers as argument
    call _debug_dump_registers	# External C function processes the register dump 

    # Clean up stack
    addq $128, %rsp		# Restores the stack pointer to its original position
    ret				# Return to caller
