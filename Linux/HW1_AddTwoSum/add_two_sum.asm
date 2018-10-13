section .data
    prompt_text1    db "Please enter the first integer: ", 0x00
    prompt_text2    db "Please enter the second integer: ", 0x00

section .bss
    integer1        resb 1
    integer2        resb 1
    sum             resb 1

section .text
    global _start


_start:
    ; Read the first integer from stdin.
    mov rax, prompt_text1
    call _printString
    mov rsi, integer1
    mov rcx, 4
    call _readInt

    ; Read the second integer from stdin.
    mov rax, prompt_text2
    call _printString
    mov rsi, integer2
    mov rcx, 4
    call _readInt

    ; Add two integers, and print the sum.
    mov rax, [integer1]
    add rax, [integer2]
    mov [sum], rax

    mov rsi, sum
    call _printInt

    ; sys_exit(0);
    mov rax, 60
    mov rdi, 0
    syscall


; Prints a null byte terminated string.
; input: rax - pointer to the string.
_printString:
    push rax                    ; Store the starting address of the string.
    mov rcx, 0                  ; rcx used as counter for string length.
_printString_nextChar:
    inc rax                     ; Navigate to the next character in the string.
    inc rcx                     ; Increment string length.
    mov bl, [rax]               ; Check if the next character is a null byte.
    cmp bl, 0x00
    jne _printString_nextChar   ; If not, continue to fetch the next character.
    
    mov rax, 1                  ; sys_write(1, text, text_length);
    mov rdi, 1
    pop rsi                     ; Pop the starting address of the string to rsi.
    mov rdx, rcx
    syscall
    ret


; Converts binary into ASCII and print them out.
; input: rsi - pointer to the binary buffer.
_printInt:
    push rsi
    mov rax, [rsi]          ; Load the value of sum into rax (in binary).
    mov rbx, 10
    mov rcx, 0              ; Counter for string length.
_printInt_pushNextDigitToStack:
    mov rdx, 0              ; Clear the higher part.
    div rbx
    add dl, 0x30            ; Convert the remainder to Ascii.
    push rdx
    inc rcx                 ; Increment string length counter.
    cmp rax, 0
    jnz _printInt_pushNextDigitToStack

    ; Pop digits from stack in reverse order directly into buffer.
    mov rdx, rcx            ; Copy string length to rdx.
_printInt_nextDigitToBuffer:
    pop rax
    mov [rsi], byte al
    inc rsi
    dec rcx
    cmp rcx, 0
    jnz _printInt_nextDigitToBuffer

    mov rax, 1
    mov rdi, 1
    pop rsi 
    syscall
    ret

; Reads an integer from stdin to the specified location in memory.
; input: rsi - pointer to input buffer.
;        rcx - the length of characters to read from stdin.
_readInt:
    push rcx
    push rsi
_readInt_clearBuffer:
    mov [rsi], byte 0x00
    inc rsi
    dec rcx
    cmp rcx, 0
    jnz _readInt_clearBuffer

    mov rax, 0
    mov rdi, 0
    pop rsi
    pop rdx
    syscall

    push rsi
    mov rcx, 10
    mov rax, 0              ; rax used to store the binary.
_readInt_nextAsciiToBin:
    mov rbx, 0
    mov bl, [rsi]
    sub bl, 0x30
    mul rcx                 ; Multiply rax (sum) by rcx (10). sum *= 10.
    add rax, rbx            ; Add bl (next digit) to rax (sum). sum += next_digit.
    
    inc rsi                 ; Navigate to the next ascii character.
    mov bl, [rsi]
    cmp bl, 0x00
    jnz _readInt_nextAsciiToBin
    
    pop rsi
    mov [rsi], rax          ; Store the converted binary into the specified buffer.
    ret
