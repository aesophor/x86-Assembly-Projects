.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc

GenerateString PROTO
CopyString PROTO, source: PTR BYTE, destination: PTR BYTE, nchar: DWORD
SearchChar PROTO, targetarray: PTR BYTE, found: PTR DWORD, nchar: DWORD, key: BYTE
SetCursor PROTO, xpos: BYTE, ypos: BYTE
SearchString PROTO, targetarray: PTR BYTE, pattern: PTR BYTE, nchar: DWORD
CaseChange PROTO, targetarray: PTR BYTE

.data
msg1	BYTE "請輸入字串處理選項: (1) 產生 (2) 複製 (3) 字元搜尋 (4) 字串搜尋 (5) 大小寫轉換 (6) 結束: ", 0
choice	BYTE ?
msg2	BYTE "1234567890", 0
msg3	BYTE 70 DUP(32), 0
msg4	BYTE 70 DUP(32), 0
msg5	BYTE "請輸入要搜尋的字: ", 0
msg6	BYTE "Not found", 0
msg7	BYTE "搜尋的字在位置: ", 0
msg8	BYTE 11 DUP(0)
nbyte	DWORD ?
msg9	BYTE "請輸入要搜尋的字串(最多10字): ", 0
msgfail	BYTE "No such option, please retry.", 0
blankln	BYTE 80 DUP(32), 0
result	DWORD ?

.code
main PROC
TOP:
	invoke SetCursor, 0, 0
	mov edx, offset msg1
	call WriteString
	call ReadChar
	call Crlf
	.IF al < 49 || al > 54
		mov edx, offset msgfail
		call WriteString
		jmp TOP
	.ENDIF
	mov edx, offset blankln
	call WriteString
	sub al, 48
	mov choice, al
	.IF al == 6
		jmp FINISH
	.ELSEIF al == 5
		invoke CaseChange, ADDR msg4
		mov dh, 19
		mov dl, 0
		call Gotoxy
		mov edx, offset msg4
		call WriteString
	.ELSEIF al == 4
		invoke SetCursor, 0, 2
		mov edx, offset blankln
		call WriteString
		invoke setcursor, 0, 2
		mov edx, offset msg9
		call WriteString
		mov edx, offset msg8
		mov ecx, sizeof msg8
		call ReadString
		mov nbyte, eax
		invoke SearchString, addr msg4, addr msg8, nbyte
	.ELSEIF al == 3
		invoke SetCursor, 0, 2
		mov edx, offset msg5
		call WriteString
		call ReadChar
		call Crlf
		invoke SetCursor, 0, 3
		mov edx, offset blankln
		call WriteString
		invoke SearchChar, addr msg4, addr result, 70, al
		invoke SetCursor, 0, 2
		mov edx, offset blankln
		call WriteString
		.IF result > 70
			mov edx, offset msg6
			call WriteString
		.ELSE
			mov edx, offset msg7
			call WriteString
			mov eax, result
			inc eax
			call WriteDec
		.ENDIF
		call Crlf
	.ELSEIF al == 2
		invoke CopyString, addr msg3, addr msg4, 70
	.ELSE
		invoke GenerateString
	.ENDIF
	jmp TOP

FINISH:
	call Crlf
	call WaitMsg
	invoke ExitProcess, 0
main ENDP

SetCursor PROC uses edx,
			xpos: BYTE, ypos: BYTE
	mov dh, ypos
	mov dl, xpos
	call Gotoxy
	ret
SetCursor ENDP

GenerateString PROC uses edx ecx esi eax
	mov dh, 20
	mov dl, 0
	call Gotoxy
	mov edx, offset msg2
	mov ecx, 7
L0:
	call WriteString
	loop L0
	call Crlf
	mov esi, offset msg3
	mov ecx, 70
	call Randomize
L1:
	mov eax, 60
	call RandomRange
	.IF eax < 26
		add al, 65
	.ELSEIF eax < 34
		mov al, 32
	.ELSE
		add al, 63
	.ENDIF
	mov [esi], al
	inc esi
	loop L1
	mov edx, offset msg3
	call WriteString

	ret
GenerateString ENDP

CopyString PROC uses esi edi ecx edx,
			source: PTR BYTE, destination: PTR BYTE, nchar: DWORD
	cld
	mov esi, source
	mov edi, destination
	mov ecx, nchar
	rep movsb
	mov dh, 19
	mov dl, 0
	call Gotoxy
	mov edx, destination
	call WriteString

	ret
CopyString ENDP

SearchChar PROC uses edi esi ecx eax,
			targetarray: PTR BYTE, found: PTR DWORD, nchar: DWORD, key: BYTE
	mov esi, found
	mov DWORD PTR [esi], 0FFFFFFFFh
	mov edi, targetarray
	mov ecx, nchar
	mov al, key
	cld
	repne scasb
	jnz QUIT
	dec edi
	sub edi, targetarray
	mov DWORD PTR [esi], edi
QUIT:
	ret
SearchChar ENDP

SearchString PROC uses esi edi ecx ebx edx,
				targetarray: PTR BYTE, pattern: PTR BYTE, nchar: DWORD
				LOCAL temp1: DWORD, temp2: DWORD, tempaddr: DWORD
	invoke SetCursor, 0, 3
	mov edx, offset blankln
	call WriteString
	invoke SetCursor, 0, 3
	cld
	mov temp2, 70
	mov esi, pattern
	mov edi, targetarray
SS3:
	invoke SearchChar, edi, ADDR temp1, temp2, BYTE PTR [esi]
	.IF temp1 > 70
		jmp SS2
	.ELSE
		mov ecx, nchar
		add edi, temp1
		mov tempaddr, edi
		mov ebx, temp1
		sub temp2, ebx
		repe cmpsb
		.IF ZERO?
			sub edi, targetarray
			mov edx, offset msg7
			call WriteString
			mov eax, edi
			inc eax
			sub eax, nchar
			call WriteDec
			jmp SS1
		.ELSE
			mov edi, tempaddr
			inc edi
			dec temp2
			mov esi, pattern
			jmp SS3
		.ENDIF
	.ENDIF
SS2:
	mov edx, offset msg6
	call WriteString
SS1:
	ret
SearchString ENDP

CaseChange PROC uses esi edi ecx eax,
			targetarray: PTR BYTE
	cld
	mov esi, targetarray
	mov edi, targetarray
	mov ecx, 70
CC1:
	lodsb
	.IF al >= 65 && al <= 90
		add al, 32
	.ELSEIF al >= 97 && al <= 122
		sub al, 32
	.ENDIF
	stosb
	loop CC1
	ret
CaseChange ENDP

END main