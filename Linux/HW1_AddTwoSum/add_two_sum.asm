section .data
    prompt_text1    db "Please enter the first integer: ", 0x00
    prompt_text2    db "Please enter the second integer: ", 0x00

section .bss
    num1            resb 4
    num2            resb 4
    sum             resb 4
    num1_text       resb 4
    num2_text       resb 4
    sum_text        resb 4

section .text
    global _start


_start:
    ; Read the first integer from stdin.
    mov rax, prompt_text1
    call _printString 
    mov rax, num1_text
    mov rcx, 4
    call _readBinary
    mov [num1], rax

    ; Read the second integer from stdin.
    mov rax, prompt_text2
    call _printString
    mov rax, num2_text
    mov rcx, 4
    call _readBinary
    mov [num2], rax

    ; Add two numbers.
    xor rax, rax
    xor rbx, rbx
    mov eax, [num1]
    mov ebx, [num2]
    add rax, rbx
    mov rsi, sum_text
    mov rcx, 4
    call _printDecimal

    ; Set up sys_exit.
    mov rax, 60
    mov rdi, 0
    syscall


; Prints a Null-terminated string.
; input: rax - pointer to the string.
_printString:
    push rax                    ; Store the starting address of the string.
    xor rcx, rcx                ; Clear rcx and use it as counter for string length.
    ; Loop through the string to check string length until a 0x00 is found.
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
    mov rdx, rcx                ; String length.
    syscall
    ret


; Prints binary in decimal.
; input : rax - binary value to be converted to ascii.
;         rcx - number of digits.
;         rsi - pointer to where ascii digits will be stored.
_printDecimal:
    add rsi, rcx                ; rdi points to last ascii digit.
    ; Divide binary by 10 and get each digit in reverse order,
    ; and convert each digit to ascii one by one.
_printDecimal_nextChar:
    mov rbx, 10                 ; Divisor = 10.
    xor rdx, rdx                ; Clear rdx prior to division.
    div rbx                     ; Divide binary by 10. Remainder will be in rdx.
    or dl, 0x30                 ; Tag 0x30 to remainder to make it ascii.
    mov [rsi], dl
    dec rsi
    cmp rax, 0
    jne _printDecimal_nextChar
    ; Set up sys_write
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall
    ret


; Reads input from stdin as plain string.
; input : rax - pointer to the buffer to store input.
;         rcx - number of characters to read.
_readString:
    push rax
    push rcx
    ; Set up sys_read.
    mov rsi, rax                ; Starting address of input buffer.
    mov rdx, rcx                ; Input string length.
    mov rax, 0                  ; id of sys_read = 0.
    mov rdi, 0                  ; fd of stdin = 0.
    syscall
    ; Restore registers to previous state.
    pop rcx
    pop rax
    ret


; Reads input from stdin as binary
; input : rax - pointer to the buffer to store input
;         rbx - pointer to the buffer to store output
;         rcx - number of bytes to read.
_readBinary:
    call _readString            ; Read string of numbers into [rax].
    mov rsi, rax                ; Copy input buffer address to rsi.
    xor rax, rax                ; Clear rax and use it to store binary result.
    ; Loop through the string and convert it to binary.
_readBinary_nextChar:
    mov rdx, 10                 ; Multiplier = 10. Make sure rdx is always 10.
    mul rdx                     ; Multiply rax (binary result) by 10.
    xor rbx, rbx                ; Clear rbx and use it to store next character.
    mov bl, [rsi]               ; Fetch currently pointed character by rax.
    and bl, 0xf                 ; Strip off 0x30.
    add rax, rbx                ; Add it to rax (binary result).
    
    inc rsi                     ; Increment the pointer.
    mov bl, [rsi]               ; Check if next character is newline (0xa) char.
    cmp bl, 0xa                 
    jne _readBinary_nextChar    ; Loop until a newline char is found.
    ; At this point, rax should hold the binary result.
    ret
