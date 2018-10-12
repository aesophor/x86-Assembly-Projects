; Oct/01/2018

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitcode:DWORD
INCLUDE Irvine32.inc

.data
	buffer1 BYTE "我是U10516045xxx!",0
	buffer2 BYTE "請輸入一個數字字串:",0
	buffer3 BYTE 32 DUP(0)
	maxsize = ($ - buffer3)
	bytecount DWORD ?
	sum BYTE 0

.code
main PROC
	mov edx, OFFSET buffer1
	call WriteString
	call Crlf

	mov edx, OFFSET buffer2
	call WriteString

	mov edx, OFFSET buffer3
	mov ecx, maxsize
	call ReadString

	mov bytecount, eax
	call Crlf

	mov esi, OFFSET buffer3
	mov ecx, bytecount
	mov ebx, TYPE buffer3
	call DumpMem
	call DumpRegs
	call WaitMsg
	call Crlf
	mov esi, 0
	mov ecx, bytecount
	mov eax, 0
accumulate:
	add al, buffer3[esi]
	sub al, 30h
	inc esi
	loop accumulate
	call WriteInt
	call Crlf
	call WaitMsg

	INVOKE ExitProcess,0
main ENDP
END main
