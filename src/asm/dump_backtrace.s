.globl  _dump_backtrace
.type   _dump_backtrace, @function

# Constants (see `man dladdr` for Dl_info layout) 
#https://man7.org/linux/man-pages/man3/dladdr.3.html
.equ    MAX_FRAMES,   64   # hard cap on walked frames           
.equ    DLINFO_SZ,    32   # sizeof(struct Dl_info) → see dlfcn.h
.equ    SLOT_SZ,      48   # DLINFO_SZ + 16 for guaranteed 16-B alignment

_dump_backtrace:
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %rbx
        pushq   %r12
        pushq   %r13
        pushq   %r14

        xorq    %r14, %r14            #depth counter                      
        movq    (%rbp), %rbx          #current frame pointer              
        leaq    -1(%rsp), %r13        #prevent seg fault


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
        subq    $SLOT_SZ, %rsp        # reserve one aligned Dl_info slot  
        leaq    (%rsp), %rsi          # rsi = &Dl_info                    
        call    dladdr@PLT            # see `man dladdr`                  

        # populate printf args
        movq    24(%rsp), %rdx        # symbol address (dli_saddr)        
        movq    16(%rsp), %rcx        # symbol name   (dli_sname)         
        movq     0(%rsp), %r8         # image name    (dli_fname)         
        
        leaq    backtrace_format_str(%rip), %rdi
        movq    %r14, %rsi            # depth index                       
        xorq    %r9, %r9
        call    printf@PLT

        addq    $SLOT_SZ, %rsp        # release Dl_info slot              

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
