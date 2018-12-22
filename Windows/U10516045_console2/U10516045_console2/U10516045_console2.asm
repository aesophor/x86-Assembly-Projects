.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc
INCLUDE Macros.inc

BUFFER_SIZE = 501
FILENAME_SIZE = 257
.data
	endl EQU <0dh, 0ah>
	menuSelection	BYTE ?

	buffer			BYTE BUFFER_SIZE DUP(?)
	filename		BYTE FILENAME_SIZE DUP(?)
	fileHandle		HANDLE ?
	stringLength	DWORD ?
	bytesWritten	DWORD ?

	str1			BYTE "Cannot create file", endl, 0
	str2			BYTE "Bytes written to file [", 0
	str3			BYTE "]: ", 0

.code
main PROC
	; Display menu message.
	mWrite "File I/O. (1) Create & Write to File (2) Open & Read File (3) Quit"
	call Crlf
	call ReadChar
	mov menuSelection, al

	.IF menuSelection == '1'
		; Ask the user to input filename.
		mWrite "Enter the filename and press [ENTER]: "
		mov ecx, FILENAME_SIZE
		mov edx, offset filename
		call ReadString

		; Create a new text file
		mov edx, offset filename
		call CreateOutputFile
		mov fileHandle, eax

		; Check for errors.
		cmp eax, INVALID_HANDLE_VALUE
		jne file_create_ok
		mov edx, offset str1
		call WriteString
		jmp quit

	.ELSEIF menuSelection == '2'
		; Ask the user to input filename.
		mWrite "Enter the filename and press [ENTER]: "
		mov ecx, FILENAME_SIZE
		mov edx, offset filename
		call ReadString

		; Open the file for input
		mov edx, offset filename
		call OpenInputFile
		mov fileHandle, eax

		; Check for errors
		cmp eax, INVALID_HANDLE_VALUE
		jne file_read_ok
		mWrite <"Cannot open file", endl>
		jmp quit

	.ELSE
		jmp quit

	.ENDIF


file_create_ok:
	; Ask the user to input a string.
	mWrite "Enter up to 500 characters and press [ENTER]: "
	call Crlf
	mov ecx, BUFFER_SIZE
	mov edx, offset buffer
	call ReadString
	mov stringLength, eax

	; Write the buffer to the output file.
	mov eax, fileHandle
	mov edx, offset buffer
	mov ecx, stringLength
	call WriteToFile
	mov bytesWritten, eax
	call CloseFile

	; Display the return value.
	mov edx, offset str2
	call WriteString
	mov edx, offset filename
	call WriteString
	mov edx, offset str3
	call WriteString
	mov eax, bytesWritten
	call WriteDec
	call Crlf
	jmp quit

file_read_ok:
	mov edx, offset buffer
	mov ecx, BUFFER_SIZE
	call ReadFromFile
	jnc check_buffer_size
	mWrite "Error reading file."
	call WriteWindowsMsg
	jmp close_file

check_buffer_size:
	cmp eax, BUFFER_SIZE
	jb buf_size_ok
	mWrite <"Error: buffer too small for this file", endl>
	jmp quit

buf_size_ok:
	mov buffer[eax], 0
	mWrite "File size: "
	call WriteDec
	call Crlf

	; Display the buffer.
	mWrite <"Buffer: ", endl, endl>
	mov edx, offset buffer
	call WriteString
	call Crlf

close_file:
	mov eax, fileHandle
	call CloseFile

quit:	
	call WaitMsg
	invoke ExitProcess, 0
main ENDP

end main