.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc

.data
	msg1			BYTE "請輸入十進制的被加數: (超過16個數字會被忽略) ", 0
	msg2			BYTE "請輸入十進制的加數: (超過16個數字會被忽略) ", 0
	instring		BYTE 17 DUP(0)
	maxsize	= ($ - instring)
	digitcount		DWORD ?
	packed_a		QWORD 0
	packed_b		QWORD 0
	unadjusted_sum	QWORD 0
	packed_sum		QWORD 0
	final_carry		BYTE  0

.code
main PROC
	mov edx, OFFSET msg1
	call WriteString
	mov edx, OFFSET instring
	mov ecx, maxsize
	call ReadString
	mov digitcount, eax
	call Crlf

	mov esi, OFFSET instring
	mov edi, OFFSET packed_a
	mov ecx, digitcount
	call Asc2Packed

	mov edx, OFFSET msg2
	call WriteString
	mov edx, OFFSET instring
	mov ecx, maxsize
	call ReadString
	mov digitcount, eax
	call Crlf
	
	mov esi, OFFSET instring
	mov edi, OFFSET packed_b
	mov ecx, digitcount
	call Asc2Packed

	mov esi, OFFSET packed_a
	mov edi, OFFSET packed_b
	mov edx, OFFSET packed_sum
	mov ecx, SIZEOF packed_a
	mov ebx, OFFSET unadjusted_sum
	call AddPacked

	; Display the sum.
	mov al, ' '
	call WriteChar
	mov esi, OFFSET packed_a
	call PrintQWORDPacked
	call Crlf

	mov al, '+'
	call WriteChar
	mov esi, OFFSET packed_b
	call PrintQWORDPacked
	call Crlf

	mov ecx, 17
	mov al, '-'
L0: call WriteChar
	loop L0
	call Crlf

	mov al, ' '
	call WriteChar
	mov esi, OFFSET unadjusted_sum
	call PrintQWORDPacked
	call Crlf

	mov eax, 0
	mov al, final_carry
	call WriteDec
	mov esi, OFFSET packed_sum
	call PrintQWORDPacked
	call Crlf
	call Crlf

	call WaitMsg
	invoke ExitProcess, 0
main endp

;
Asc2Packed PROC uses ESI EDI ECX EBX EAX
;
;
;
;
	mov ebx, 0
	add esi, ecx
	dec esi
a2p1: push ebx
	shr ebx, 1
	.IF CARRY?
		mov ah, [esi]
		sub ah, 30h
		shl al, 4
		shr ax, 4
		mov [edi], al
		inc edi
	.ELSE
		mov al, [esi]
		sub al, 30h
		.IF ecx == 1
			mov BYTE PTR [edi], al
		.ENDIF
	.ENDIF
	pop ebx
	inc ebx
	dec esi
	loop a2p1
	ret
Asc2Packed ENDP
;
AddPacked PROC
;
;
;
;
;
;
;
;
;
	pushad
	clc

;

L1:	mov al, [esi]
	adc al, [edi]
	mov [ebx], al
	daa
	mov [edx], al


	inc esi
	inc edi
	inc ebx
	inc edx
	loop L1


	mov al, 0
	adc al, 0
	mov final_carry, al

	popad
	ret
AddPacked ENDP

;
PrintQWORDPacked PROC uses ESI EAX
;
;
;
	add esi, 4
	mov eax, DWORD PTR [esi]
	call WriteHex
	sub esi, 4
	mov eax, DWORD PTR [esi]
	call WriteHex
	ret
PrintQWORDPacked ENDP

END main