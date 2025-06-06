.extern _debug_dump_registers
.globl dump_registers
.type dump_registers, @function

dump_registers:
    subq $128, %rsp		# Allocates 128 bytes on the stack to store registers.

    # Save caller-saved and callee-saved general-purpose registers.
    movq %rax,   0(%rsp)	# Save %rax.
    movq %rbx,   8(%rsp)	# Save %rbx.
    movq %rcx,  16(%rsp)	# Save %rcx.
    movq %rdx,  24(%rsp)	# Save %rdx.
    movq %rsi,  32(%rsp)	# Save %rsi.
    movq %rdi,  40(%rsp)	# Save %rdi.
    movq %rbp,  48(%rsp)	# Save %rbp.

    leaq 8(%rbp), %rax    	# Load return address into %rax at [%rbp + 8]. 
    movq %rax,  56(%rsp)	# Save return address.

    movq %r8,   64(%rsp)	# Save %r8.
    movq %r9,   72(%rsp)	# Save %r9.
    movq %r10,  80(%rsp)	# Save %r10.
    movq %r11,  88(%rsp)	# Save %r11.
    movq %r12,  96(%rsp)	# Save %r12.
    movq %r13, 104(%rsp)	# Save %r13.
    movq %r14, 112(%rsp)	# Save %r14.
    movq %r15, 120(%rsp)	# Save %r15.

    # Now call the C function with pointer to register dump
    movq %rsp, %rdi		# Pass pointer to saved registers as argument.
    call _debug_dump_registers	# External C function processes the register dump. 

    # Clean up stack
    addq $128, %rsp		# Restores the stack pointer to its original position.
    ret				# Return to caller.
