.globl dump_backtrace
.type dump_backtrace, @function

.globl get_rbp_pointer
.type get_rbp_pointer, @function

.globl backtrace_format_str
.type backtrace_format_str, @function

get_rbp_pointer: # This is for get a current bp
    movq %rbp, %rax
    ret

dump_backtrace:
    call _dump_backtrace
    ret


.section .rodata
backtrace_format_str:
.asciz "%3ld: [%lx] %s () %s\n"
