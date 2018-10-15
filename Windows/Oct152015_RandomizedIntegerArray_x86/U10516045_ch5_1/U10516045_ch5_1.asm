.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc

.data
	buffer1		BYTE "我是u10516045 王冠中", 0
	buffer2		BYTE "請輸入Random Number的數量(少於50): ", 0
	buffer3		BYTE "請輸入Random Number的lowerbound: ", 0
	buffer4		BYTE "請輸入Random Number的upperbound: ", 0
	randArray	DWORD 51 DUP(0)
	targetArray DWORD 51 DUP(0)
	itemcount	DWORD ?
	lowerbound	DWORD ?
	upperbound  DWORD ?

.code
main proc
	mov edx, OFFSET buffer1
	call WriteString
	call Crlf

	mov edx, OFFSET buffer2
	call WriteString
	call ReadInt
	mov itemcount, eax
	call Crlf

	mov edx, OFFSET buffer3
	call WriteString
	call ReadInt
	mov lowerbound, eax
	call Crlf

	mov edx, OFFSET buffer4
	call WriteString
	call ReadInt
	mov upperbound, eax
	call Crlf


	call Randomize
	mov ecx, itemcount
	mov esi, 0
L1:	
	mov ebx, lowerbound
	mov eax, upperbound
	call BetterRandomRange
	mov randArray[esi], eax
	add esi, TYPE randArray
	loop L1

	mov esi, OFFSET randArray
	mov ecx, itemcount
	call WriteIntegerArray

	call Crlf
	call WaitMsg
	call Crlf
	call Crlf

	mov esi, OFFSET randArray
	mov edi, OFFSET targetArray
	mov ecx, itemcount
	call ReverseIntegerArray

	mov esi, OFFSET targetArray
	mov ecx, itemcount
	call WriteIntegerArray

	call Crlf
	call WaitMsg
	invoke ExitProcess, 0
main endp


BetterRandomRange proc
	sub eax, ebx
	call RandomRange
	add eax, ebx
	ret
BetterRandomRange endp

WriteIntegerArray proc
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
WriteIntegerArray endp

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

end main