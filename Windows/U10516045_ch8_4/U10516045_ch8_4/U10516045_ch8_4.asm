.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE test.inc

.data
	msg1	BYTE "Please enter a number (0~18): ", 0
	inval	DWORD ?
	msg2	BYTE "Too large. Retry!", 0

.code
main PROC
L0:
	mov edx, OFFSET msg1
	call WriteString
	call ReadDec
	call Crlf
	mov inval, eax
	.IF eax > 18
		mov edx, OFFSET msg2
		call WriteString
		call Crlf
		jmp L0
	.ENDIF

	mov ebx, 0
	.REPEAT
		INVOKE BinomialCoefficient, ebx
		inc ebx
	.UNTIL ebx > inval

	call Crlf
	call WaitMsg
	INVOKE ExitProcess, 0
main ENDP

END main