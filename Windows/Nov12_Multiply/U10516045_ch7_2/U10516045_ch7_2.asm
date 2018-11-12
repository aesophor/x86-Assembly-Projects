;
;
;
;
;
;
;
;
.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc

.data
	msg1			BYTE "我是U10516045王冠中", 0
	msg2			BYTE "請輸入被乘數: ", 0
	msg3			BYTE "請輸入乘數: ", 0
	msg4			BYTE " * 65536 * 65536", 0
	msg5			BYTE " + ", 0
	multiplicand	QWORD 0
	multiplier		DWORD ?

.code
main proc
	mov edx, OFFSET msg1
	call WriteString
	call Crlf
	mov edx, OFFSET msg2
	call WriteString
	call ReadDec
	mov DWORD PTR [multiplicand], eax
	call Crlf
	mov edx, OFFSET msg3
	call WriteString
	call ReadDec
	mov multiplier, eax
	call Crlf
	call multiply

	call WriteDec
	push edx
	mov edx, OFFSET msg5
	call WriteString
	pop edx
	mov eax, edx
	call WriteDec
	mov edx, OFFSET msg4
	call WriteString
	call Crlf

	call WaitMsg
	invoke ExitProcess, 0
main endp

multiply proc
	mov eax, 0
	mov edx, 0
L0:
	mov ebx, multiplier
	shr ebx, 1
	pushfd
	mov multiplier, ebx
	.IF CARRY?
		add eax, DWORD PTR [multiplicand]
		adc edx, DWORD PTR [multiplicand + 4]
	.ENDIF
	popfd
	.IF ZERO?
		jmp L1
	.ENDIF
	mov ebx, DWORD PTR [multiplicand]
	shld DWORD PTR [multiplicand + 4], ebx, 1
	shl DWORD PTR [multiplicand], 1
	jmp L0
L1:
	ret
multiply endp
end main