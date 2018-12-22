.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc
INCLUDE test.inc

STUDENT STRUCT
	id		BYTE 9 DUP(?)
	stuname	BYTE 6 DUP(?)
	address	BYTE 6 DUP(?)
	score1	BYTE ?
	score2	BYTE ?
	score3	BYTE ?
	score4	BYTE ?
STUDENT ENDS
BUFFER_SIZE = 46

mWritenChar PROTO, source:PTR BYTE, count:DWORD
showrecord PROTO, point:PTR STUDENT
nrecordshow PROTO, point: PTR STUDENT, count:DWORD
findrecord PROTO, target:PTR STUDENT, nofstu:DWORD, pattern:PTR BYTE, nchar:DWORD, result:PTR DWORD
scoremean PROTO, target:PTR STUDENT, nofstu:DWORD, displacement:DWORD

.data
buffer		STUDENT BUFFER_SIZE DUP(<>)
filename	BYTE "testdata.txt", 0
fileHandle	HANDLE ?
stucount	DWORD ?
found		DWORD ?
dest		BYTE 10 DUP(0)
destcount	DWORD ?
city		BYTE 10 DUP(0)
citycount	DWORD ?
tempaddr	DWORD ?

.code
main PROC
	mov edx, offset filename
	call OpenInputFile
	mov fileHandle, eax

	cmp eax, INVALID_HANDLE_VALUE
	jne file_ok
	mWriteLn "Cannot open file"
	jmp quit

file_ok:
	mov edx, offset buffer
	mov ecx, sizeof buffer
	call ReadFromFile
	jnc buf_read_ok
	mWriteLn "Error reading file."
	jmp close_file

buf_read_ok:
	mWrite "File size: "
	call WriteDec
	mWrite " Bytes,    "
	mov edx, 0
	mov ebx, sizeof STUDENT
	div ebx
	mov stucount, eax
	call WriteDec
	mWrite " student's data input..."
	call Crlf

close_file:
	mov eax, fileHandle
	call CloseFile

MENU:
	call Crlf
	mWriteLn "(1) 全部顯示 (2) 成績統計 (3) 姓名搜尋 (4) 城市搜尋 (5) 結束"
	mChoose 5
	call Crlf
	.IF al == 1
		invoke nrecordshow, ADDR buffer, BUFFER_SIZE
	.ELSEIF al == 2
		mWrite "score1 的"
		invoke scoremean, ADDR buffer, BUFFER_SIZE, OFFSET STUDENT.score1
		mWrite "score2 的"
		invoke scoremean, ADDR buffer, BUFFER_SIZE, OFFSET STUDENT.score2
		mWrite "score3 的"
		invoke scoremean, ADDR buffer, BUFFER_SIZE, OFFSET STUDENT.score3
		mWrite "score4 的"
		invoke scoremean, ADDR buffer, BUFFER_SIZE, OFFSET STUDENT.score4
	.ELSEIF al == 3
		mWrite "請輸入姓名: "
		mReadString dest
		mov destcount, eax
		call Crlf
		mov eax, offset buffer
		add eax, offset STUDENT.stuname
		invoke findrecord, eax, BUFFER_SIZE, ADDR dest, destcount, ADDR found
		mov ebx, found
		.IF ebx == 0ffffffffh
			mWrite "not found"
		.ELSE
			mov eax, offset buffer
			add eax, found
			invoke showrecord, eax
		.ENDIF
		call Crlf
	.ELSEIF al == 4
		mWrite "請輸入城市: "
		mReadString city
		mov citycount, eax
		call Crlf
		mov ebx, BUFFER_SIZE
		mov eax, offset buffer
		mov tempaddr, eax
L0:
		add eax, offset STUDENT.address
		invoke findrecord, eax, ebx, ADDR city, citycount, ADDR found
		mov edx, found
		.IF edx != 0ffffffffh
			mov eax, tempaddr
			add eax, found
			add eax, SIZEOF STUDENT
			mov tempaddr, eax
			sub eax, SIZEOF STUDENT
			invoke showrecord, eax
			call Crlf
			mov ecx, sizeof STUDENT
			mov eax, found
			mov edx, 0
			div ecx
			inc eax
			sub ebx, eax
			jz MENU
			mov eax, tempaddr
			jmp L0
		.ELSEIF ebx == BUFFER_SIZE
			mWrite "not found"
		.ENDIF
		call Crlf
	.ELSE
		jmp quit
	.ENDIF
	jmp MENU

quit:
	call WaitMsg
	invoke ExitProcess, 0
main ENDP

scoremean PROC uses ecx edx eax ebx esi,
			target:PTR STUDENT, nofstu:DWORD, displacement:DWORD
	mov ecx, nofstu
	mov edx, 0
	mov eax, 0
	mov ebx, 0
	mov esi, target
	add esi, displacement
SM1:
	mov bl, byte ptr [esi]
	add eax, ebx
	add esi, sizeof STUDENT
	loop SM1
	mov ecx, nofstu
	div ecx
	mWrite "平均值: "
	call WriteDec
	mWriteSpace 3
	mov eax, edx
	mWrite "餘數: "
	call WriteDec
	call Crlf
	ret
scoremean ENDP

findrecord PROC uses esi edi ebx ecx edx,
		target:PTR STUDENT, nofstu:DWORD, pattern:PTR BYTE, nchar:DWORD, result:PTR DWORD
	cld
	mov esi, result
	mov dword ptr [esi], 0ffffffffh
	mov edx, 0
	mov ebx, nofstu
FR1:
	mov esi, target
	add esi, edx
	mov edi, pattern
	mov ecx, nchar
	repe cmpsb
	jz MATCH
	add edx, sizeof STUDENT
	dec ebx
	jnz FR1
	jmp QUIT
MATCH:
	mov esi, result
	mov dword ptr [esi], edx
QUIT:
	ret
findrecord ENDP

nrecordshow PROC uses ecx edi,
				point:PTR STUDENT, count:DWORD

	mov ecx, count
	mov edi, point
AA1:
	invoke showrecord, edi
	call Crlf
	add edi, SIZEOF STUDENT
	loop AA1

	ret
nrecordshow ENDP

showrecord PROC uses edi,
				point:PTR STUDENT

	mov edi, point
	invoke mWritenChar, edi, SIZEOF STUDENT.id
	mWriteSpace 3
	add edi, SIZEOF STUDENT.id
	invoke mWritenChar, edi, sizeof STUDENT.stuname
	mWriteSpace 3
	add edi, sizeof STUDENT.stuname
	invoke mWritenChar, edi, sizeof STUDENT.address
	mWriteSpace 3
	add edi, sizeof STUDENT.address
	mov eax, 0
	mov al, byte ptr [edi]
	call WriteDec
	mWriteSpace 3
	inc edi
	mov al, byte ptr [edi]
	call WriteDec
	mWriteSpace 3
	inc edi
	mov al, byte ptr [edi]
	call WriteDec
	mWriteSpace 3
	inc edi
	mov al, byte ptr [edi]
	call WriteDec
	mWriteSpace 3
	
	ret
showrecord ENDP

mWritenChar PROC uses esi edi ecx edx,
				source:PTR BYTE, count:DWORD

.data
	spaces BYTE 9 DUP(?)
.code
	cld
	mov edi, offset spaces
	mov ecx, 9
	mov al, 0
	rep stosb
	mov esi, source
	mov edi, offset spaces
	mov ecx, count
	rep movsb
	mov edx, offset spaces
	call WriteString
	ret
mWritenChar ENDP

END main