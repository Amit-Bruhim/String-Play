.extern printf
.extern scanf
.extern pstrlen
.extern swapCase
.extern pstrijcpy

.section .rodata
scanf_fmt:
    .string "%d"
scanf_fmt2:
    .string "%d%d"
demo:
    .string "\033[0;32mnum: %d\n\033[0m"
first_string_length:
    .string "\033[0;32mfirst pstring length: %d, \033[0m"
second_string_length:
    .string "\033[0;32msecond pstring length: %d\n\033[0m"
wrong_option_string:
    .string "\033[0;31minvalid option!\n\033[0m"
wrong_input_string:
    .string "\033[0;31minvalid input!\n\033[0m"
details_string:
    .string "\033[0;32mlength: %d, string: %s\n\033[0m"

.align 8
.JT:
    .quad .L1
    .quad .L2
    .quad .L3
    .quad .L4

.section .text

.global run_func
.type run_func, @function 
run_func:
    # start
    pushq %rbp
    movq %rsp, %rbp 
   
    # save the arguments
    movq %rdi, %r12
    movq %rsi, %r13
    movq %rdx, %r14
    xorq %r15, %r15

    # switch - case
    leaq -30(%r12), %r15
.point:
    cmpq $4, %r15
    ja .L2
    cmpq $1, %r15
    jl .L2
    cmpq $2, %r15
    je .L2
    dec %r15
    jmp *.JT(,%r15,8)

# wrong input
.L2:
    movq $wrong_option_string, %rdi
    call printf
    xorq %rax, %rax

    # break
    jmp .DONE

# pstrlen
.L1:
    # print the first string's length
    movq %r13, %rdi
    call pstrlen
    movq $first_string_length, %rdi
    movq %rax, %rsi
    call printf
    xorq %rax, %rax

    # print the first string's length
    movq %r14, %rdi
    call pstrlen
    movq $second_string_length, %rdi
    movq %rax, %rsi
    call printf
    xorq %rax, %rax

    # break
    jmp .DONE

# swapCase
.L3:
    # change the first string
    movq %r13, %rdi
    call swapCase
    xorq %rax, %rax
    movq %r13, %rdi
    call pstrlen
    movq %rax, %rsi
    movq $details_string, %rdi
    movq %r13, %rdx
    incq %rdx
    xorq %rax, %rax
    call printf

    # change the second string
    movq %r14, %rdi
    call swapCase
    xorq %rax, %rax
    movq %r14, %rdi
    call pstrlen
    movq %rax, %rsi
    movq $details_string, %rdi
    movq %r14, %rdx
    incq %rdx
    xorq %rax, %rax
    call printf

    jmp .DONE

# pstrijcpy
.L4:
    # get i,j from the user
    subq $16, %rsp
    movq $scanf_fmt2, %rdi
    movq %rsp, %rsi
    leaq 8(%rsp), %rdx
    call scanf
    movl (%rsp), %r12d
    movl 8(%rsp), %r15d
    
    # check the indexes are valid

    # check that i<=j
    cmpq %r15, %r12
    jg .L4invalid

    # check that the i,j <= length
    movq %r13, %rdi
    call pstrlen
    cmpq %rax, %r12
    jge .L4invalid
    cmpq %rax, %r15
    jge .L4invalid
    movq %r14, %rdi
    call pstrlen
    cmpq %rax, %r12
    jge .L4invalid
    cmpq %rax, %r15
    jge .L4invalid
    
    jmp .L4valid
    
.L4invalid:
    # print invalid string
    movq $wrong_input_string, %rdi
    call printf
    xorq %rax, %rax
    jmp .strings_print

.L4valid:
    # call the function that changes the letters
    movq %r13, %rdi
    movq %r14, %rsi
    movq %r12, %rdx
    movq %r15, %rcx
    call pstrijcpy
    jmp .strings_print

.strings_print:
    # print the strings
    
    # print the first string
    movq %r13, %rdi
    call pstrlen
    movq %rax, %rsi
    movq $details_string, %rdi
    movq %r13, %rdx
    incq %rdx
    xorq %rax, %rax
    call printf

    # print the second string
    movq %r14, %rdi
    call pstrlen
    movq %rax, %rsi
    movq $details_string, %rdi
    movq %r14, %rdx
    incq %rdx
    xorq %rax, %rax
    call printf

    # break
    addq $16, %rsp
    jmp .DONE

# end
.DONE:
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret
