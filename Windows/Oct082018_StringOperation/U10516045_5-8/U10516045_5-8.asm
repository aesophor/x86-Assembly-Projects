; Exercise 5-8

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitcode:DWORD
INCLUDE Irvine32.inc

.data
	buffer1  BYTE "我是U10516045王冠中!",0
	buffer2  BYTE "請輸入一字串(40字以下): ",0
	inarray  BYTE 41 DUP(0)
	maxsize = ($ - inarray)
	inlength DWORD ?
	pass	 DWORD ?

.code
main proc
	mov edx, OFFSET buffer1
	call WriteString
	call Crlf

	mov edx, OFFSET buffer2
	call WriteString

	mov edx, OFFSET inarray
	mov ecx, maxsize
	call ReadString
	mov inlength, eax
	add eax, eax
	add pass, eax
	mov ecx, pass

L0:
	mov pass, ecx
	mov edi, inlength
	dec edi
	mov esi, edi
	dec esi

	mov al, inarray[edi]
	mov ecx, edi
L1:
	mov dl, inarray[esi]
	mov inarray[edi], dl
	dec esi
	dec edi
	loop L1

	mov inarray[edi], al

	mov dh, 10
	mov dl, 12
	call Gotoxy

	mov edx, OFFSET inarray
	call WriteString
	mov eax, 500
	call Delay
	mov ecx, pass
	loop L0

	call Crlf

	call WaitMsg
	invoke ExitProcess, 0
main endp
end main