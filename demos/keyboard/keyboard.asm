jmp _start

TIME_OUT dw 65535 
DELAY dw 65535
ACK_RETRY db 4
SECOND_PORT db 0xd4
ACK_FLAG: resb 1
SHIFT_FLAG: resb 1
COMMAND_BYTE: resb 1
DATA_BYTE: resb 1
KEY_LUT_1_CH:					;Key lookuptable scan code set 1
	db " ", 0x01, "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "'", "^", 0x02, 0x03 	;0x01 = esc key ; 0x02 = backspace key ; 0x03 = tab key
	db "q", "w", "e", "r", "t", "z", "u", "i", "o", "p", " ", " ", 0x04, 0x06, "a", "s"	;0x04 = enter key
	db "d", "f", "g", "h", "j", "k", "l", " ", " ", " ", 0x05, " ", "y", "x", "c", "v" 	;0x05 = shift key
	db "b", "n", "m", ",", ".", "-", " ", " ", " ", " ", 0x06, " ", " ", " ", " ", " "	;0x06 = capsLock
	db " ", " ", " ", " ", " ", " ", " ", " ", 0x07, " ", " ", 0x08, " ", 0x09, " ", " "	;0x07 = up key ; 0x08 = left key ; 0x09 = right key
	db 0x10, " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "	;0x10 = down key
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", 0x11, " ", " ", " ", " ", " "	;0x11 = shift key released
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db 0

KEY_LUT_1_CH_shift:					;Key lookuptable scan code set 1 when shift/caps lock is pressed
	db " ", 0x01, "+", """, "*", "ç", "%", "&", "/", "(", ")", "=", "'", "^", 0x02, 0x03 	;0x01 = esc key ; 0x02 = backspace key ; 0x03 = tab key
	db "Q", "W", "E", "R", "T", "Z", "U", "I", "O", "P", " ", " ", 0x04, " ", "A", "S"	;0x04 = enter key
	db "D", "F", "G", "H", "J", "K", "L", " ", " ", " ", 0x05, " ", "Y", "X", "C", "V", 	;0x05 = shift key
	db "B", "N", "M", 0x3b, ":", "_", " ", " ", " ", " ", 0x06, " ", " ", " ", " ", " "	;0x3b = ascii for ; (; makes the rest of the line look like commentary) ; 0x06 = capsLock
	db " ", " ", " ", " ", " ", " ", " ", " ", 0x07, " ", " ", 0x08, " ", 0x09, " ", " "	;0x07 = up key ; 0x08 = left key ; 0x09 = right key
	db 0x10, " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "	;0x10 = down key
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", 0x11, " ", " ", " ", " ", " "	;0x11 = shift key released
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "
	db 0

_start:

call initialise

;mov edi, 0xb8000

call getKey

error:
mov ah, 0x0e 
mov al, "E"
int 0x10
jmp $

initialise:			;set scan code set. decides what the scan code for the different keys are.
	mov dx, 0xf0
	mov [COMMAND_BYTE], dx
	mov dx, 1
	mov [DATA_BYTE], dx
	call sendCommand

	mov dx, 0xf4		;enable scanning; sends scan code of a key to the I/O Port 0x60 (Data port)
	mov [COMMAND_BYTE], dx
	xor dx, dx		;no data byte
	mov [DATA_BYTE],dx
	call sendCommand
	
	ret


getKey:
	push ebx
	.scanCodeLoop:		;check if a key was pressed
	in al, 0x64
	bt ax, 0
	jnc .scanCodeLoop
	xor eax, eax
	in al, 0x60		;get scan code from data port
	cmp al, 0xaa
	je .upper_case
	cmp al, 0x2a
	je .upper_case
	cmp al, 0x3a
	je .upper_case
	cmp al, 0x80		
	ja .scanCodeLoop	;skip scan code when it's just a key that was released
	
	mov bl, [SHIFT_FLAG]
	cmp bl, 0
	jne .shift

	mov ebx, KEY_LUT_1_CH	;move memory address of the lookup table to ebx
	add ebx, eax		;the value of the scan code in eax equals the offset from the base memory address of the lookup table
	mov al, byte [ebx]	;move the value in the lookup table at the offset of the scan code value into al
	;mov byte [edi], al
	;add edi, 2
	;
	;
	;jmp .scanCodeLoop
	;
	;
	pop ebx
	ret

	.shift:
	sub eax, 12
	mov ebx, KEY_LUT_1_CH_shift
	add ebx, eax
	mov al, byte [ebx]

	;mov byte [edi], al
	;add edi, 2
	;jmp .scanCodeLoop

	pop ebx
	ret

	.upper_case:
	mov bl, [SHIFT_FLAG]
	not bl
	mov [SHIFT_FLAG], bl
	;mov al, bl
	;mov ah, 0x0e
	;int 0x10
	;xor ah, ah
	jmp .scanCodeLoop

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


checkResponse:				;checks wether the device sent an acknowledge or a resend (data port did or didn't receive the command)
	push ax
	
	.checkAck:
	call delay			;give the device time to send a response
	dec cx
	cmp cx, 0
	je error
	in al, 0x60			;the response from the device is in the data port
	cmp al, 0xfe			;response byte for resend
	je .retry
	cmp al, 0xfa			;response byte for acknowledged
	je .ack
	jmp error			;error

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

;END_PADDING
