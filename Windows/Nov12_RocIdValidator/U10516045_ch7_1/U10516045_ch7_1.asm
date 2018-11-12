.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc

.data
	buffer1		BYTE "我是U10516045王冠中", 0
	buffer2		BYTE "請輸入一個身分證字號(LEN >= 10 會被忽略): ", 0
	buffer3		BYTE "身分證字號太短，請重新輸入!", 0
	buffer4		BYTE "身分證字號錯誤，請重新輸入!", 0
	buffer5		BYTE "身分證字號正確!", 0
	inarray		BYTE 11 DUP(0)
	maxsize = ($ - inarray)
	inlength	DWORD ?
	noid		BYTE 11 DUP(0)
	pass		BYTE ?

.code
main proc
L0:
	call Clrscr
	mov	edx, OFFSET buffer1
	call WriteString
	call Crlf
	mov edx, OFFSET buffer2
	call WriteString
	mov edx, OFFSET inarray
	mov ecx, maxsize
	call ReadString
	mov inlength, eax
	call Crlf
	.IF inlength != 10
		mov edx, OFFSET buffer3
		call WriteString
		call Crlf
		call WaitMsg
		jmp L0
	.ENDIF
	mov pass, 1
	mov al, inarray
	.IF al >= 97 && al <= 122
		sub al, 32
	.ENDIF
	.IF al < 65 || al >= 90
		mov pass, 0
	.ELSE
		.IF al >= 65 && al <= 72
			mov noid, 1
			sub al, 65
			mov [noid + 1], al
		.ELSEIF al == 73
			mov noid, 3
			mov BYTE PTR [noid + 1], 4
		.ELSEIF al == 74 || al == 75
			mov noid, 1
			sub al, 66
			mov [noid + 1], al
		.ELSEIF al >= 76 && al <= 78
			mov noid, 2
			sub al, 76
			mov [noid + 1], al
		.ELSEIF al == 79
			mov noid, 3
			mov BYTE PTR [noid + 1], 5
		.ELSEIF al >= 80 && al <= 86
			mov noid, 2
			sub al, 77
			mov [noid + 1], al
		.ELSEIF al == 87
			mov noid, 3
			mov BYTE PTR [noid + 1], 2
		.ELSEIF al == 88
			mov noid, 3
			mov BYTE PTR [noid + 1], 0
		.ELSEIF al == 89
			mov noid, 3
			mov BYTE PTR [noid + 1], 1
		.ELSE
			mov noid, 3
			mov BYTE PTR [noid + 1], 3
		.ENDIF
	.ENDIF
	mov esi, 1
	.REPEAT
		mov al, inarray[esi]
		.IF al >= 48 && al <= 57
			inc esi
			sub al, 48
			mov noid[esi], al
		.ELSE
			mov pass, 0
			.BREAK
		.ENDIF
	.UNTIL esi == 10
	.IF pass == 0
		mov edx, OFFSET buffer4
		call WriteString
		call Crlf
		call WaitMsg
		jmp L0
	.ENDIF
	mov eax, 0
	mov al, noid
	add al, [noid + 9]
	add al, [noid + 10]
	mov esi, 8
	.REPEAT
		mov ecx, esi
		neg ecx
		add ecx, 10
		.REPEAT
			add al, noid[esi]
			.IF CARRY?
				add ah, 1
			.ENDIF
			dec ecx
		.UNTIL ecx == 0
		dec esi
	.UNTIL esi == 0
	call WriteDec
	call Crlf
	mov edx, 0
	mov ebx, 10
	div ebx
	.IF EDX == 0
		mov edx, OFFSET buffer5
		call WriteString
	.ELSE
		mov edx, OFFSET buffer4
		call WriteString
	.ENDIF
	call Crlf
	call WaitMsg
	INVOKE ExitProcess, 0
main endp
end main