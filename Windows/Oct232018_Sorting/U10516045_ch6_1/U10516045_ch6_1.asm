.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc
.data
	buffer1		BYTE	"�ڬO u10516045 ���a��", 0
	buffer2		BYTE	"�п�J Random Number ���ƶq(�֩�50): ", 0
	buffer3		BYTE	"�п�J Random Number �� Lowerbound: ", 0
	buffer4		BYTE	"�п�J Random Number �� Upperbound: ", 0
	buffer5		BYTE	"�п�� (1) Selection Sort (2) Insertion Sort (3) Quick Sort (4) Exit", 0
	buffer6		BYTE	"Malformed Input. Retry!", 0
	randArray	DWORD	51 DUP(0)
	targetArray	DWORD	51 DUP(0)
	itemcount	DWORD	?
	lowerbound	DWORD	?
	upperbound	DWORD	?
	gap			DWORD	?
	choice		BYTE	?

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

	sub esi, 4
	mov gap, esi
L3:
	call Clrscr
	mov esi, OFFSET randArray
	mov edi, esi
	add edi, gap
	call WriteIntegerArray

	call Crlf
	mov edx, OFFSET buffer5
	call WriteString
	call ReadChar
	mov choice, al
	call Crlf

	cmp al, '4'
	jz L4

	mov ecx, itemcount
	mov esi, OFFSET randArray
	mov edi, OFFSET targetArray
L2:
	mov eax, [esi]
	mov [edi], eax
	add esi, 4
	add edi, 4
	loop L2

	mov al, choice
	cmp al, '1'
	jz no1
	cmp al, '2'
	jz no2
	cmp al, '3'
	jz no3
	mov edx, OFFSET buffer6
	call WriteString
	call Crlf
	call WaitMsg
	jmp L3

no1:
	mov esi, OFFSET targetArray
	mov edi, esi
	add edi, gap
	call SelectionSort
	call WaitMsg

	mov esi, OFFSET targetArray
	mov edi, esi
	add edi, gap
	call WriteIntegerArray
	jmp L3
no2:
	mov esi, OFFSET targetArray
	mov edi, esi
	add edi, gap
	call InsertionSort
	call WaitMsg

	mov esi, OFFSET targetArray
	mov edi, esi
	add edi, gap
	call WriteIntegerArray
	jmp L3
no3:
	mov esi, OFFSET targetArray
	mov edi, esi
	add edi, gap
	call QuickSort
	call WaitMsg
	mov esi, OFFSET targetArray
	mov edi, esi
	add edi, gap
	call WriteIntegerArray
	jmp L3
L4:
	call Crlf
	call WaitMsg
	invoke ExitProcess, 0
main endp

;
BetterRandomRange PROC
;
;
;
;
;
;
;
;

	sub eax, ebx
	call RandomRange
	add eax, ebx
	ret
BetterRandomRange ENDP

;
WriteIntegerArray PROC
;
;
;
;
;
;
;

WIA:
	mov eax, [esi]
	call WriteInt
	mov al, ','
	call WriteChar
	mov al, ' '
	call WriteChar
	add esi, 4
	cmp esi, edi
	jle WIA
	ret
WriteIntegerArray ENDP

;
SelectionSort PROC
;
;
;
;
;
	mov ebx, esi
BSL1:
	push esi
	push edi
	call WriteIntegerArray
	pop edi
	pop esi
	call ReadChar
	call Crlf
	mov eax, [ebx]
	push ebx
BSL2:
	add ebx, 4
	cmp eax, [ebx]
	jle BSL3
	xchg eax, [ebx]
BSL3:
	cmp ebx, edi
	jl BSL2
	pop ebx
	mov [ebx], eax
	add ebx, 4
	cmp ebx, edi
	jl BSL1
	ret
SelectionSort ENDP

;
QuickSort PROC
;
;
;
;
;
	push esi
	push edi
	mov esi, OFFSET targetArray
	mov edi, esi
	add edi, gap
	call WriteIntegerArray
	pop edi
	pop esi
	call ReadChar
	call Crlf
	cmp esi, edi
	jae QSL1
	push esi
	mov eax, [edi]
	mov ebx, esi
	sub esi, 4
QSL2:
	cmp eax, [ebx]
	jle QSL3
	add esi, 4
	mov edx, [esi]
	xchg edx, [ebx]
	mov [esi], edx
QSL3:
	add ebx, 4
	cmp ebx, edi
	jnz QSL2
	add esi, 4
	mov edx, [esi]
	xchg edx, [edi]
	mov [esi], edx
	push esi
	add esi, 4
	call QuickSort
	pop edi
	pop esi
	sub edi, 4
	call QuickSort
QSL1:
	ret
QuickSort ENDP

;
InsertionSort PROC
;
;
;
;
;
	mov ebx, esi
ISL1:
	push esi
	push edi
	call WriteIntegerArray
	pop edi
	pop esi
	call ReadChar
	call Crlf
	mov eax, ebx
	cmp eax, edi
	ja ISL2
	mov eax, [ebx]
	push ebx
	mov edx, ebx
	sub edx, 4
ISL4:
	cmp edx, esi
	jb ISL3
	cmp eax, [edx]
	jae ISL3
	push eax
	mov eax, [edx]
	mov [ebx], eax
	pop eax
	sub ebx, 4
	sub edx, 4
	jmp ISL4
ISL3:
	mov [ebx], eax
	pop ebx
	add ebx, 4
	jmp ISL1
ISL2:
	ret
InsertionSort ENDP

end main