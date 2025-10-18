.extern printf
.extern scanf
.section .rodata

.section .text

.global pstrlen
.type pstrlen, @function 
pstrlen:
    # start
    pushq %rbp
    movq %rsp, %rbp 

    # return the length
    xorq %rax, %rax
    movb (%rdi), %al

    # end
    movq %rbp, %rsp
    popq %rbp
    ret

.global swapCase
.type swapCase, @function 
swapCase:
    # start
    pushq %rbp
    movq %rsp, %rbp

    # save the pointer
    movq %rdi, %r15

    # skip the length byte
    incq %r15
.loop:
    # read byte from the string
    movb (%r15), %al
    # if we're at the end of the string - exit
    cmpb $0x0, %al
    je .DONE

.checkUpperCase:
    # check if the char is a uppercase letter
    cmpb $0x41, %al
    jl .checkLowCase
    cmpb $0x5a, %al
    ja .checkLowCase
    jmp .switchDOWN

.checkLowCase:
    # check if the char is a lowcase letter
    cmpb $0x61, %al
    jl .next
    cmpb $0x7a, %al
    ja .next
    jmp .switchUP

.switchUP:
    # change the letter from lowercase to uppercase
    movb (%r15), %al
    subb $32, %al
    movb %al, (%r15)
    jmp .next

.switchDOWN:
    # change the letter from uppercase to lowercase 
    movb (%r15), %al
    addb $0x20, %al
    movb %al, (%r15)
    jmp .next

.next:
    # increment the pointer, and continue to next iteration
    incq %r15
    jmp .loop

.DONE:
    # end
    movq %rbp, %rsp
    popq %rbp
    ret

.global pstrijcpy
.type pstrijcpy, @function 
pstrijcpy:
    # start
    pushq %rbp
    movq %rsp, %rbp

    # change the letters
    incq %rdi
    incq %rsi
    xorq %rax, %rax
    movq %rdx, %r12
.loop1:
    cmpq %rax, %rdx
    je .loop2
    decq %rdx
    incq %rdi
    incq %rsi
    jmp .loop1

.loop2:
    cmpq %r12, %rcx
    jl .DONE2
    movb (%rsi), %al
    movb %al, (%rdi)
    incq %rdi
    incq %rsi
    incq %r12
    jmp .loop2

.DONE2:
    # end
    movq %rbp, %rsp
    popq %rbp
    ret


