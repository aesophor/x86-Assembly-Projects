; Exercise 5-5: Calculate the Fibonacci numbers.

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitcode:DWORD
INCLUDE Irvine32.inc

.data
	buffer1  BYTE "我是U10516045王冠中!",0
	buffer2  BYTE "請輸入Fibonacci Sequence的數量(<48): ",0
	fibArray DWORD 48 DUP(0)
	itemno   DWORD ?

.code
main proc
	mov edx, OFFSET buffer1
	call WriteString
	call Crlf

	mov edx, OFFSET buffer2
	call WriteString
	call ReadInt

	mov itemno, eax
	call Crlf

	mov ebx, 0
	mov edx, 1
	mov fibArray, edx

	; loop it
	mov ecx, itemno
	dec ecx
	mov esi, TYPE fibArray

L1:
	mov eax, ebx
	add eax, edx
	mov fibArray[esi], eax
	mov ebx, edx
	mov edx, eax
	add esi, TYPE fibArray
	Loop L1

	mov ecx, itemno
	mov esi, 0

L2:
	mov eax, fibArray[esi]
	call WriteDec
	add esi, TYPE fibArray
	mov al, ','
	call WriteChar
	mov al, ' '
	call WriteChar
	loop L2

	call Crlf
	call WaitMsg
	invoke ExitProcess, 0
main endp
end main
