# Useful Procedures / Macros
Here are some useful procedures collected from my weekly assignments. Requires Irvine32 library.

Each section contains two parts:
* Procedure implementation
* Example usage (predefined buffer + procedure call)

## Template
```
.386
.model flat,stdcall
.stack 4096
INCLUDE Irvine32.inc
ExitProcess PROTO, dwExitCode:DWORD

.data
    ; declare variables here

.code
main PROC
    ; write your code here
    invoke ExitProcess,0
main ENDP

; (additional procedures here)
END main
```

## Retrieve an Unsigned Integer from STDIN
```
itemcount DWORD ?
```
```
call ReadInt
mov itemcount, eax
```

## Menu
```
menu_prompt        BYTE "請選擇 (1) First Item (2) Second Item (3) Third Item (4) Exit",  0
input_error_prompt BYTE "Malformed Input. Retry!",  0
```
```
L3:
    call Clrscr
    mov edx, OFFSET menu_prompt
    call WriteString

    call ReadChar
    mov choice, al
    call Crlf

    cmp al, '4'
    jz L4

    mov ecx, itemcount
    mov esi, OFFSET randArray
    mov edi, OFFSET targetArray
L2:
    mov eax, [esi]
    mov [edi], eax
    add esi, 4
    add edi, 4
    loop L2

    mov al, choice
    cmp al, '1'
    jz no1
    cmp al, '2'
    jz no2
    cmp al, '3'
    jz no3

    mov edx, OFFSET input_error_prompt
    call WriteString
    call Crlf
    call WaitMsg
    jmp L3
no1:
    mov esi, OFFSET targetArray
    mov edi, esi
    add edi, gap
    call SelectionSort
    call WaitMsg
    mov esi, OFFSET targetArray
    mov edi, esi
    add edi, gap
    call WriteIntegerArray
    jmp L3
no2:
    mov esi, OFFSET targetArray
    mov edi, esi
    add edi, gap
    call InsertionSort
    call WaitMsg
    mov esi, OFFSET targetArray
    mov edi, esi
    add edi, gap
    call WriteIntegerArray
    jmp L3
no3:
    mov esi, OFFSET targetArray
    mov edi, esi
    add edi, gap
    call QuickSort
    call WaitMsg
    mov esi, OFFSET targetArray
    mov edi, esi
    add edi, gap
    call WriteIntegerArray
    jmp L3
L4:
    call Crlf
    call WaitMsg
    invoke ExitProcess,  0
```

## RandomRange with Upper & Lower Bounds
```
;------------------------------------------------
; BetterRandomRange
;
; Generates a random integer within the sepcified
; lowerbound and upperbound in EAX.
; Receives: EAX = upperbound
;           EBX = lowerbound
; Returns: EAX = random integer
;------------------------------------------------
BetterRandomRange PROC
    sub  eax, ebx
    call RandomRange
    add  eax, ebx
    ret
BetterRandomRange ENDP
```
```
call Randomize
mov eax, upperbound
mov ebx, lowerbound
call BetterRandomRange
```

## Write Integer Array
```
WriteIntegerArray PROC
WIA:
    mov eax, [esi]
    call WriteInt
    mov al, ','
    call WriteChar
    mov al, ' '
    call WriteChar
    add esi, 4
    loop WIA
    ret
WriteIntegerArray ENDP
```
```
randArray DWORD 51 DUP(0)
```
```
mov esi, OFFSET randArray
mov ecx, itemcount
call WriteIntegerArray
```

## Reverse Integer Array
```
ReverseIntegerArray proc
    push DWORD ptr [esi]
    add esi, 4
    loop RIA
    pop DWORD ptr [edi]
    add edi, 4
    ret
RIA:
    call ReverseIntegerArray
    pop DWORD ptr[edi]
    add edi, 4
    ret
ReverseIntegerArray endp
```
```
randArray DWORD 51 DUP(0)
targetArray DWORD 51 DUP(0)
```
```
mov esi, OFFSET randArray
mov edi, OFFSET targetArray
mov ecx, itemcount
call ReverseIntegerArray
```

## Generate Random Integer Array
```
GenRandomIntegerArray proc
    mov edi, 0
GRIA:
    mov eax, upperbound
    mov ebx, lowerbound
    call BetterRandomRange
    mov [esi][edi], eax
    add edi, TYPE esi
    loop GRIA
    ret
GenRandomIntegerArray endp
```
```
lowerbound DWORD ?
upperbound DWORD ?
```
```
mov esi, OFFSET randArray
mov ecx, itemcount
call GenRandomIntegerArray
```

## Generate a Fibonacci Sequence with the First n Items
```
GenerateFibonacci proc
    mov ebx, 0
    mov edx, 1
    mov [esi], edx
    dec ecx
    mov edi, TYPE esi
L1:
    mov eax, ebx
    add eax, edx
    mov [esi][edi], eax
    mov ebx, edx
    mov edx, eax
    add edi, TYPE esi
    Loop L1
    ret
GenerateFibonacci endp
```
```
mov esi, OFFSET fibArray
mov ecx, itemcount
call GenerateFibonacci
```

## Selection Sort
```
SelectionSort PROC
   mov ebx, esi
BSL1:
   push esi
   push edi
   call WriteIntegerArray
   pop edi
   pop esi
   call ReadChar
   call Crlf
   mov eax, [ebx]
   push ebx
BSL2:
   add ebx, 4
   cmp eax, [ebx]
   jle BSL3
   xchg eax, [ebx]
BSL3:
   cmp ebx, edi
   jl BSL2
   pop ebx
   mov [ebx], eax
   add ebx, 4
   cmp ebx, edi
   jl BSL1
   ret
SelectionSort ENDP
```
```
mov esi, OFFSET targetArray
mov edi, esi
add edi, gap
call SelectionSort
```
gap = itemcount * 4

