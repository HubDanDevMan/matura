jmp _start

TIME_OUT db 16000
ACK_RETRY db 4

_start:

mov dl, 0xf5
mov dh, 0
call sendCommand

mov dl, 0xf2
call sendCommand




jmp $

error:
mov ah, 0x0e 
mov al, "E"
int 0x10
jmp $


sendCommand:				;move command byte into dl and if needed data byte into dh befor calling the function
	call pollingSend
	mov cx, [ACK_RETRY]
	.sendCommandByte:
	mov al, dl
	out 0x60, al
	call checkAck
	cmp bl, 0
	je .sendCommandByte
	mov bl, 0 
	
	cmp dh, 0
	je .continue

	out 0x64, 0xd4
	call pollingSend
	mov cx, [ACK_RETRY]
	.sendDataByte:
	mov al, dh
	out 0x60, al
	call checkAck
	cmp bl, 0
	je .sendDataByte
	mov bl, 0

	.continue:
	mov dh, 0
	ret

checkAck:
	.checkAck:
	dec cx
	cmp cx, 0
	je error
	in al, 0x60
	cmp al, 0xfe
	je .retry
	cmp al, 0xfa
	je .ack
	jmp error

	.ack:
	mov bl, 1
	ret
	
	.retry:
	mov bl, 0
	ret

pollingSend:
	mov cx, [TIME_OUT]
	.pollingSendLoop:
	dec cx
	cmp cx, 0
	je error
	in al, 0x64
	bt al, 1
	jc .pollingSendLoop
	ret

END_PADDING
