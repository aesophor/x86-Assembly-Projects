; AddTwoSum_64.asm - Chapter 3 example.

ExitProcess proto
ReadInt64	proto
ReadString	proto
WriteInt64	proto
WriteHex64	proto
WriteString	proto
Crlf		proto

.data
sum qword 0
message1 BYTE "我是U10516046蔡宗祐!!!!",0
message2 BYTE "請輸入一個數字:",0
message3 BYTE "請按Enter結束!!!!",0
inbuf	BYTE 50 dup(0),0
inbuf_size =$ - inbuf

.code
main proc
	mov rdx,offset message1
	call WriteString
	call Crlf
	mov rdx,offset message2
	call WriteString
	call ReadInt64
	call Crlf
	mov	sum,rax
	call WriteInt64
	call Crlf
	mov	rax,sum
	call WriteHex64
	call Crlf
	mov rdx,offset message3
	call WriteString
	mov rdx,offset inbuf
	mov	rcx,inbuf_size
	call ReadString

	mov   ecx,0
	call  ExitProcess

main endp
end

