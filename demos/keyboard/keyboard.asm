jmp _start

%include "cpuid/printHex.asm"

TIME_OUT dq 16000
ACK_RETRY db 4
DATA_PORT db 0x60
STATUS_REGISTER db 0x64
SECOND_PORT db 0xd4

_start:
mov dh, 0
mov dl, 0xf5				;command byte for disable scanning. to identify the keyboard it must first be disabled
call sendCommand

mov dl, 0xf2				;command byte for identify. The device returns up to two response bytes
call sendCommand

call pollingGet
cmp bl, 0
je printdeviceinfo
in al, DATA_PORT
mov ah, al
call pollingGet
cmp bl, 0
je printdeviceinfo
in al, DATA_PORT

cmp ah, 0xAB
jne printdeviceinfo
cmp al, 0x41
jne also
mov esi, keyboardtranslationbuff
jmp printdeviceinfo
also:
cmp al, 0xc1
jne notranslation
mov esi, keyboardtranslationbuff
jmp printdeviceinfo
notranslation:
cmp al, 0x83
jne printdeviceinfo
mov esi, keyboardbuff

printdeviceinfo:
call printBuff

jmp $

error:
mov ah, 0x0e 
mov al, "E"
int 0x10
jmp $


sendCommand:				;move command byte into dl and if needed data byte into dh before calling the function
	call pollingSend		;check if the input buffer is empty
	mov cx, [ACK_RETRY]		;resend the command byte up to 3 times
	mov al, dl			
	.sendCommandByte:
	out DATA_PORT, al		;move command byte to data port
	call checkAck			;check if the keyboard acknowledged the command
	cmp bl, 0
	je .sendCommandByte		;loop if the device sent resend as response
	mov bl, 0 
	
	cmp dh, 0			;if there is a byte in dh that means that the command byte has a data byte that must be sent afterwards
	je .continue

	push ax 
	mov al, SECOND_PORT
	out STATUS_REGISTER, al		;signal the ps/2 controller that the next data port input should be sent to the second ps/2 port instead of the first 
	pop ax
	call pollingSend
	mov cx, [ACK_RETRY]
	mov al, dh
	.sendDataByte:
	out DATA_PORT, al		;move data byte to data port
	call checkAck
	cmp bl, 0
	je .sendDataByte
	mov bl, 0
	mov dh, 0

	.continue:
	ret

checkAck:				;checks wether the device sent an acknowledge or a resend
	push ax
	.checkAck:
	dec cx
	cmp cx, 0
	je error
	in al, DATA_PORT		;the response from the device is in the data port
	cmp al, 0xfe			;response byte for resend
	je .retry
	cmp al, 0xfa			;response byte for acknowledged
	je .ack
	jmp error

	.ack:
	mov bl, 1
	pop ax
	ret
	
	.retry:
	mov bl, 0			;if bl is 0 after the program returned from the function it resends the byte
	pop ax
	ret

pollingSend:				;checks for bit 1 in the status register. If it is clear you can send input to the data port otherwise you have to wait
	push ax
	mov cx, TIME_OUT		
	.pollingSendLoop:
	dec cx
	cmp cx, 0
	je error
	in al, STATUS_REGISTER
	bt ax, 1
	jnc .pollingSendLoop		;loops until bit 1 is clear or a time out occured
	pop ax
	ret

pollingGet:
	push ax
	mov bl, 0
	mov cx, TIME_OUT
	.pollingGetLoop:
	dec cx
	cmp cx, 0
	je .continue
	in al, STATUS_REGISTER
	bt ax, 0
	jnc .pollingGetLoop
	mov bl, 1
	.continue:
	pop ax
	ret

keyboardbuff:
db "Keyboard"
;times 80 - 8 " "
db 0
keyboardtranslationbuff:
db "Keyboard with translation"
;times 80 - 25 " "
db 0

END_PADDING
