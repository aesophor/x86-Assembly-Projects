%include "../asm_stdio.inc"

section .data
    prompt_text1    db "Please enter the first integer: ", 0x00
    prompt_text2    db "Please enter the second integer: ", 0x00

section .bss
    num1_text       resb 8
    num2_text       resb 8
    sum_text        resb 8 
    num1            resb 8
    num2            resb 8
    sum             resb 8
    
section .text
    global _start


_start: 
    ; Read the first integer from stdin.
    print prompt_text1
    readVal num1_text, 8                ; Read 8 characters into num1_text
    mov [num1], rax                     ; Result of readBinary stored in rax.

    ; Read the second integer from stdin.
    print prompt_text2
    readVal num2_text, 8                ; Read 8 characters into num2_text.
    mov [num2], rax                     ; Result of readBinary stored in rax.

    ; Add two numbers, and store addition result to sum.
    mov rax, [num1]
    mov rbx, [num2]
    add rax, rbx
    mov [sum], rax

    ; Print the result in ascii.
    printVal rax
    exit 0
