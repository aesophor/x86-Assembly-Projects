.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc
INCLUDE Macros.inc

BUFFER_SIZE = 50
FILENAME_SIZE = 257
.data
	endl EQU <0dh, 0ah>
	sysTime			SYSTEMTIME <>
	menuSelection	BYTE ?

	msgPromptX		BYTE "Please enter x: ", 0
	msgpromptY		BYTE "Please enter y: ", 0

	matrixStartX	BYTE ?
	matrixStartY	BYTE ?
	col				BYTE 0
	row				BYTE 0
	currentX		BYTE ?
	currentY		BYTE ?

	buffer			BYTE BUFFER_SIZE DUP(?)
	;filename		BYTE FILENAME_SIZE DUP(?)
	filename		BYTE "output.txt", 0
	fileHandle		HANDLE ?
	stringLength	DWORD ?
	bytesWritten	DWORD ?

	str1			BYTE "Cannot create file", endl, 0
	str2			BYTE "Bytes written to file [", 0
	str3			BYTE "]: ", 0

.code
main PROC
	; Show Time
	call restoreColors
	mGotoxy 26, 0
	call showTime

show_menu:
	; Display menu message.
	call restoreColors
	
	mWrite <endl, "請輸入選項 (1) Display 7x7 Matrix (2) Create File (3) Read File (4) Exit">
	call Crlf
	call ReadChar
	mov menuSelection, al

	call setColors

	.IF menuSelection == '1'
		mWrite <"Please produce and display a 7x7 Matrix on the screen: ", endl>

		; Get X from user.
		mWrite <"X: ">
		call ReadDec
		mov matrixStartX, al
		mov currentX, al

		; Get Y from user.
		mWrite <"Y: ">
		call ReadDec
		mov matrixStartY, al
		mov currentY, al

		; Set cursor position.
		mGotoxy matrixStartX, matrixStartY

		; Generate and print matrix.
		call Randomize
		.REPEAT
			.REPEAT
				mov eax, 256     ; Get random 0 to 255
				call RandomRange
				call writeDec

				inc col
				add currentX, 5
				mGotoxy currentX, currentY
			.UNTIL col > 5 
			mWrite endl

			mov al, matrixStartX
			mov currentX, al
			mov col, 0

			inc row
			inc currentY
			mGotoxy currentX, currentY
		.UNTIL row > 5
		jmp show_menu

	.ELSEIF menuSelection == '2'
		; Create a new text file
		mov edx, offset filename
		call CreateOutputFile
		mov fileHandle, eax

		; Check for errors.
		cmp eax, INVALID_HANDLE_VALUE
		jne file_create_ok
		mov edx, offset str1
		call WriteString
		jmp show_menu

	.ELSEIF menuSelection == '3'
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
		jmp show_menu

	.ELSE
		jmp quit

	.ENDIF


file_create_ok:
	; Ask the user to input a string.
	mWrite "Enter up to 50 characters and press [ENTER]: "
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
	
	jmp close_file

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
	jmp show_menu

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
	jmp show_menu

quit:	
	call WaitMsg
	invoke ExitProcess, 0
main ENDP

showTime PROC
	invoke GetLocalTime, ADDR sysTime
	mWrite "Current Time: "

	movzx eax, sysTime.wHour
	call WriteDec
	mWrite ":"
	movzx eax, sysTime.wMinute
	call WriteDec
	mWrite ":"
	movzx eax, sysTime.wSecond
	call WriteDec
	call Crlf
	ret
showTime ENDP

setColors PROC
	; Set text color
	mov eax, yellow + (blue * 16)
    call SetTextColor
	ret
setColors ENDP

restoreColors PROC
	; Restore text color
	mov eax, white + (black * 16)
    call SetTextColor
	ret
restoreColors ENDP

end main