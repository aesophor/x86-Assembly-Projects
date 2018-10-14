%include "../asm_stdio.inc"

section .data
    text1           db "Printing the stack (*rsp+0 ~ *rsp+(8 * n)) by rsp.", 0x00
    text2           db "Printing the stack by pop.", 0x00
    argc_label      db "argc: ", 0x00
    argv_label1     db "argument[", 0x00
    argv_label2     db "]: ", 0x00

section .bss
    argc            resb 8
    argv_no         resb 8
    stack_ptr       resb 8

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


    print text1
    print newline
    mov rax, rsp                    ; Copy the address held by rsp to rax.
    mov [stack_ptr], rax            ; Also create a copy in memory.

_printArgsByRsp:
    ; Print the LHS labels.
    print argv_label1
    printVal [argv_no]
    print argv_label2
    ; Print the argument.
    mov rax, [stack_ptr]            ; Dereference the pointer
    print [rax]                     ; and print its content.
    print newline
    ; Increment stack_ptr by 8 and write it back to memory.
    mov rax, [stack_ptr]
    add rax, 8
    mov [stack_ptr], rax
    ; Continue to print the next argument if there's still any of them.
    mov rcx, [argv_no]
    inc rcx
    mov [argv_no], rcx
    cmp rcx, [argc]
    jne _printArgsByRsp


    mov qword [argv_no], 0          ; Reset argv_no
    print newline
    print text2
    print newline

_printArgsByPop:
    ; Print the LHS labels.
    print argv_label1
    printVal [argv_no]
    print argv_label2
    ; Print the argument.
    pop rbx
    print rbx
    print newline
    ; Increment argv_no and write it back to memory.
    mov rax, [argv_no]
    inc rax
    mov [argv_no], rax
    ; Continue to print the next argument if there's still any of them.
    mov rcx, [argc]
    cmp rax, rcx
    jne _printArgsByPop

    exit 0
