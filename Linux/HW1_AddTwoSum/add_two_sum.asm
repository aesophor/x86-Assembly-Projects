section .data
    newline             db 10
    
    prompt_text1        db "Please enter the first integer: "
    prompt_text1_len    equ $ - prompt_text1
    
    prompt_text2        db "Please enter the second integer: "
    prompt_text2_len    equ $ - prompt_text2

section .text
    global _start

_start:
    ; Print prompt1.
    ; sys_write(stdout, prompt_text1, prompt_text1_len);
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_text1
    mov rdx, prompt_text1_len
    syscall

    ; Print prompt2
    ; sys_write(stdout, prompt_text2, prompt_text2_len);
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_text1
    mov rdx, prompt_text2_len
    syscall

    ; Exit
    ; sys_exit(0);
    mov rax, 60
    mov rdi, 0
    syscall
