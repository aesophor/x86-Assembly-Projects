ExitProcess		proto
ReadInt64		proto
ReadString		proto
WriteInt64		proto
WriteString		proto
Crlf			proto
Randomize		proto
RandomRange		proto

.data
	buffer1		BYTE "我是u10516045 王冠中", 0
	buffer2		BYTE "請輸入Random Number的數量(少於50): ", 0
	buffer3		BYTE "請輸入Random Number的lowerbound: ", 0
	buffer4		BYTE "請輸入Random Number的upperbound: ", 0
	prompt		BYTE "Press ENTER to continue...", 0
	gap			BYTE ", ", 0
	randArray	QWORD 51 DUP(0)
	targetArray QWORD 51 DUP(0)
	itemcount	QWORD ?
	lowerbound	QWORD ?
	upperbound  QWORD ?
	temp		BYTE 100 DUP(0)

.code
main proc
	mov rdx, OFFSET buffer1
	call WriteString
	call Crlf

	mov rdx, OFFSET buffer2
	call WriteString
	call ReadInt64
	mov itemcount, rax
	call Crlf

	mov rdx, OFFSET buffer3
	call WriteString
	call ReadInt64
	mov lowerbound, rax
	call Crlf

	mov rdx, OFFSET buffer4
	call WriteString
	call ReadInt64
	mov upperbound, rax
	call Crlf

	call Randomize
	mov rcx, itemcount
	mov rsi, 0
L1:
	mov rax, upperbound
	sub rax, lowerbound
	call RandomRange
	add rax, lowerbound
	mov randArray[rsi], rax
	add rsi, TYPE randArray
	loop L1

	mov rsi, OFFSET randArray
	mov rcx, itemcount
	call WriteIntegerArray
	call Crlf

	mov rdx, OFFSET prompt
	call WriteString
	mov rdx, OFFSET temp
	mov rcx, 99
	call ReadString
	call Crlf

	mov rsi, OFFSET randArray
	mov rdi, OFFSET targetArray
	mov rcx, itemcount
	call ReverseIntegerArray

	mov rsi, OFFSET targetArray
	mov rcx, itemcount
	call WriteIntegerArray
	call Crlf

	mov rdx, OFFSET prompt
	call WriteString
	mov rdx, OFFSET temp
	mov rcx, 99
	call ReadString
	call Crlf
	mov ecx, 0
	call ExitProcess
main endp


WriteIntegerArray proc uses rsi rdx rax
WIA:
	mov rax, [rsi]
	call WriteInt64
	mov rdx, OFFSET gap
	call WriteString
	add rsi, 8
	loop WIA
	ret
WriteIntegerArray endp


ReverseIntegerArray proc
	push QWORD ptr [rsi]
	add rsi, 8
	loop RIA
	pop QWORD ptr [rdi]
	add rdi, 8
	ret

RIA:
	call ReverseIntegerArray
	pop QWORD ptr [rdi]
	add rdi, 8
	ret
ReverseIntegerArray endp

end