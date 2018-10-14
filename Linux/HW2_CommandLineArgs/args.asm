%include "../asm_stdio.inc"

section .data
    argc_label      db "argc: ", 0x00
    argv_label1     db "argument[", 0x00
    argv_label2     db "]: ", 0x00

section .bss
    argc            resb 8
    argv_no         resb 8
    text_buffer     resb 8

section .text
    global _start


_start:
    ; Print argc.
    pop rax
    mov [argc], rax

 _printArgc:
    print argc_label
    printVal [argc], text_buffer, 8
    print newline
   
_printArgs:
    ; Print the LHS labels.
    print argv_label1
    printVal [argv_no], text_buffer, 2
    print argv_label2
    ; Print the acutal argument.
    pop rbx
    mov rbx, [rbx]                      ; rbx now contains address to the string.
    mov [text_buffer], rbx              ; move the address into text_buffer.
    print text_buffer
    print newline
    ; Continue to print the next argument.
    mov rcx, [argc]
    mov rax, [argv_no]
    inc rax
    mov [argv_no], rax
    cmp rax, rcx
    jne _printArgs

    exit 0
