STDIN equ 0
STDOUT equ 1
STDERR equ 2

SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60


; Prints a Null-terminated string.
; Args: %1 - string
%macro printString 1
    mov rax, %1
    xor rcx, rcx                ; Clear rcx and use it as counter for string length.
    ; Loop through the string to check string length until a 0x00 is found.
%%nextChar:
    mov bl, [rax]               ; Fetch currently pointed character by rax.
    inc rax                     ; Increment the pointer.
    inc rcx                     ; Increment string length.
    cmp bl, 0x00                ; Check if current character is a null byte.
    jne %%nextChar  ; If not, continue to fetch the next character.
    dec rcx                     ; Decrement string length by one since even an empty string will have len=1.
    ; Set up sys_write.
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, %1                 ; Load the starting address of the string.
    mov rdx, rcx                ; String length.
    syscall
%endmacro


; Prints binary in decimal.
; Args: %1 - binary value to be converted to ascii.
;       %2 - pointer to where ascii digits will be stored.
;       %3 - buffer size.
%macro printDecimal 3
    mov rax, %1
    mov rsi, %2
    add rsi, %3                 ; rsi points to last ascii digit.
    xor rcx, rcx                ; Clear rcx nad use it as counter for string length.
    ; Divide binary by 10 and get each digit in reverse order,
    ; and convert each digit to ascii one by one.
%%nextChar:
    mov rbx, 10                 ; Divisor = 10.
    xor rdx, rdx                ; Clear rdx prior to division.
    div rbx                     ; Divide binary by 10. Remainder will be in rdx.
    or dl, 0x30                 ; Tag 0x30 to remainder to make it ascii.
    mov [rsi], dl               ; Move ascii digit to the buffer.
    inc rcx                     ; Increment string length.
    dec rsi                     ; Decrement pointer.
    cmp rax, 0                  ; Continue looping while rax > 0
    jg %%nextChar
    inc rsi                     ; Make sure rsi points to the first ascii digit.
    ; Set up sys_write
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rdx, rcx
    syscall
%endmacro


; Reads input from stdin as plain string.
; Args: %1 - pointer to the buffer to store input.
;       %2 - number of characters to read.
%macro readString 2
    ; Set up sys_read.
    mov rsi, %1                 ; Starting address of input buffer.
    mov rdx, %2                 ; Input string length.
    mov rax, SYS_READ
    mov rdi, STDIN
    syscall
%endmacro


; Reads input from stdin as binary
; Args: %1 - pointer to the buffer to store input
;       %2 - number of characters to read.
; Returns: rax - binary value.
%macro readBinary 2
    readString %1, %2           ; Read string of numbers into [rax].
    mov rsi, %1                 ; Copy input buffer address to rsi.
    xor rax, rax                ; Clear rax and use it to store binary result.
    ; Loop through the string until a newline char is found
    ; and convert the ascii digits to binary value.
%%nextChar:
    mov rdx, 10                 ; Multiplier = 10. Make sure rdx is always 10.
    mul rdx                     ; Multiply rax (binary result) by 10.
    xor rbx, rbx                ; Clear rbx and use it to store next character.
    mov bl, [rsi]               ; Fetch currently pointed character by rax.
    and bl, 0xf                 ; Strip off 0x30.
    add rax, rbx                ; Add it to rax (binary result).
    
    inc rsi                     ; Increment the pointer.
    mov bl, [rsi]               ; Check if next character is newline (0xa) char.
    cmp bl, 0xa                 
    jne %%nextChar
    ; At this point, rax should hold the binary result.
%endmacro


; Exits the program.
; Args: %1 - error code.
%macro exit 1
    mov rax, SYS_EXIT
    mov rdi, %1
    syscall
%endmacro
