%include "../asm_stdio.inc"

section .data
    argc_label      db "argc: ", 0x00
    argv_label1     db "argument[", 0x00
    argv_label2     db "]: ", 0x00

section .bss
    argc            resb 8
    argv_no         resb 8

section .text
    global _start


_start:
    ; Print argc.
    pop rbx
    mov [argc], rbx

 _printArgc:
    print argc_label
    printVal [argc]
    print newline
   
_printArgs:
    ; Print the LHS labels.
    print argv_label1
    printVal [argv_no]
    print argv_label2
    ; Print the acutal argument.
    pop rbx
    print rbx
    print newline
    ; Continue to print the next argument.
    mov rax, [argv_no]
    inc rax
    mov [argv_no], rax

    mov rcx, [argc]
    cmp rax, rcx
    jne _printArgs

    exit 0
