.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc

.data
endl EQU <0dh, 0ah>
message LABEL BYTE
	BYTE "This program is a simple demonstration of"
	BYTE "console mode output, using the GetStdHandle"
	BYTE "and WriteConsole functions.", endl
messageSize DWORD ($ - message)

stdinHandle		HANDLE 0 ; handle to stdin
stdoutHandle	HANDLE 0 ; handle to stdout
bytesWritten	DWORD ?	 ; number of bytes written
input_buf	    BYTE 41 DUP(0)
bytesRead		DWORD ?  ; number of bytes read

.code
main PROC
	; Get the handle to stdout.
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov stdinHandle, eax

	; Get the handle to stdout.
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov stdoutHandle, eax


	; Read a string from stdin.
	invoke ReadConsole, stdinHandle, addr input_buf, 40, addr bytesRead, 0

	; Write a string to stdout.
	invoke WriteConsole, stdoutHandle, addr input_buf, bytesRead, addr bytesWritten, 0

	call WaitMsg
	invoke ExitProcess, 0
main ENDP
END main