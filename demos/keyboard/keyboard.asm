jmp _start

%include "cpuid/printHex.asm"

TIME_OUT dw 65535 
DELAY dw 65535
ACK_RETRY db 4
DATA_PORT db 0x60
STATUS_REGISTER db 0x64
COMMAND_PORT db 0x64
SECOND_PORT db 0xd4
ACK_FLAG: resb 1
COMMAND_BYTE: resb 1
DATA_BYTE: resb 1
COMMAND_ARRAY times 8 dw 0

_start:

call reinitialise


jmp $

error:
mov ah, 0x0e 
mov al, "E"
int 0x10
jmp $

o:
mov ah, 0x0e
mov al, "O"
int 0x10
jmp $

e:
mov ah, 0x0e 
mov al, "A"
int 0x10
jmp $

reinitialise:
	mov dx, 0xf0
	mov [COMMAND_BYTE], dx
	mov dx, 2
	mov [DATA_BYTE], dx
	call sendCommand

	mov dx, 0xf4
	mov [COMMAND_BYTE], dx
	mov dx, 0
	mov [DATA_BYTE],dx
	call sendCommand


	call waitForScanCode
	
	ret

waitForScanCode:
	

sendCommand:				;move command byte into dl and if needed data byte into dh before calling the function
	call pollingSend		;check if the input buffer is empty
	
	mov cx, [ACK_RETRY]		;resend the command byte up to 3 times
	mov al, [COMMAND_BYTE]
	
	.sendCommandByte:
	out 0x60, al			;move command byte to data port
	call checkResponse		;check if the keyboard acknowledged the command
	mov dx, [ACK_FLAG]
	cmp dx, 0
	je .sendCommandByte		;loop if the device sent resend as response 
	
	mov al, [DATA_BYTE]
	cmp al, 0			;if there is a byte in DATA_BYTE that means that the command byte has a data byte that must be sent afterwards
	je .continue

	mov al, [SECOND_PORT]
	out 0x64, al			;signal the ps/2 controller that the next data port input should be sent to the second ps/2 port instead of the first 

	call pollingSend
	
	mov cx, [ACK_RETRY]
	mov al, [DATA_BYTE]
	
	.sendDataByte:
	out 0x60, al			;move data byte to data port
	call checkResponse
	mov dx, [ACK_FLAG]
	cmp dx, 0
	je .sendDataByte

	.continue:
	
	ret


checkResponse:				;checks wether the device sent an acknowledge or a resend
	push ax
	
	.checkAck:
	call delay
	dec cx
	cmp cx, 0
	je error
	in al, 0x60			;the response from the device is in the data port
	cmp al, 0xfe			;response byte for resend
	je .retry
	cmp al, 0xfa			;response byte for acknowledged
	je .ack
	cmp al, 0
	je error
	cmp al, 0xff
	je error
	jmp o

	.ack:
	mov dx, 1
	mov [ACK_FLAG], dx
	pop ax
	
	ret
	
	.retry:
	mov dx, 0			;if ACK_FLAG is 0 after the program returned from the function it resends the byte
	mov [ACK_FLAG], dx
	pop ax
	
	ret

pollingSend:				;checks for bit 1 in the status register. If it is clear you can send input to the data port otherwise you have to wait
	push ax
	mov cx, [TIME_OUT]	
	
	.pollingSendLoop:
	dec cx
	cmp cx, 0
	je error
	in al, 0x64
	bt ax, 1
	jc .pollingSendLoop		;loops until bit 1 is clear or a time out occured
	pop ax
	
	ret

pollingGet:
	push ax
	mov cx, [TIME_OUT]
	
	.pollingGetLoop:
	dec cx
	cmp cx, 0
	je error
	in al, 0x64
	bt ax, 0
	jnc .pollingGetLoop
	pop ax
	
	ret

delay:
	push cx
	mov cx, [DELAY]
	
	.waiting:
	dec cx 
	cmp cx, 0
	jne .waiting
	pop cx
	
	ret

END_PADDING
