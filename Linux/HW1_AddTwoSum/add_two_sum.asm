section .data
    prompt_text1    db "Please enter the first integer: ", 0x00
    prompt_text2    db "Please enter the second integer: ", 0x00

section .bss
    integer1        resb 4
    integer2        resb 4
    sum             resb 4

section .text
    global _start


_start:
    ; Read the first integer from stdin.
    mov rax, prompt_text1
    call _printString
    
    ; sys_exit(0);
    mov rax, 60
    mov rdi, 0
    syscall


; Prints a Null-terminated string.
; input: rax - pointer to the string.
_printString:
    push rax                    ; Store the starting address of the string.
    mov rcx, 0                  ; rcx used as counter for string length.

_printString_nextChar:
    mov bl, [rax]               ; Fetch currently pointed character by rax.
    inc rax                     ; Increment the pointer.
    inc rcx                     ; Increment string length.
    cmp bl, 0x00                ; Check if current character is a null byte.
    jne _printString_nextChar   ; If not, continue to fetch the next character.
    dec rcx                     ; Decrement string length by one since even an empty string will have len=1.
    
    ; Set up sys_write.
    mov rax, 1                  ; id of sys_write = 1
    mov rdi, 1                  ; fd of stdout = 1
    pop rsi                     ; Pop the starting address of the string to rsi.
    mov rdx, rcx                ; string length.
    syscall
    ret


_readString:
    
