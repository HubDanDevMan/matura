jmp main

%include "keyboard/keyboard.asm"
%include "library.asm"
%define BUFFER_LENGTH 255

main:
call clear_screen

;mov edi, 0xb8000				;move video memory to edi
mov esi, buffer					;move the memory address of the beginning of the buffer into esi

key_loop:
	call getKey				;get key

	cmp al, 0x01				;esc key sets the text editor into command mode
	je commandMode
	cmp al, 0x02				;backspace deletes a character
	je backspace
	cmp al, 0x03				;tab prints four times " " 
	je tab
	cmp al, 0x04				;enter makes a new line
	je enter
	cmp al, 0x07				;up arrow moves cursor one line upwards
	je up
	cmp al, 0x08				;left arrow moves cursor one character to the left
	je left 
	cmp al, 0x09				;right arrow moves cursor one character to the right
	je right
	cmp al, 0x10				;down arrow moves cursor one line downwards
	je down

	call shiftBufferRight			;shifts all characters to the right of the cursor one character further to the right
	mov byte [esi], al			;move input at cursor location into the buffer
	call printBuffer			;prints buffer
	inc esi
	;add edi, 2
	jmp key_loop				;repeat

	
	backspace:
	cmp esi, buffer
	je key_loop
	;sub edi, 2				;go back one space
	dec esi
	call shiftBufferLeft			;move all characters right of the deleted characters one to the left
	call printBuffer
	jmp key_loop

	tab:
	jmp key_loop
	
	enter:
	jmp key_loop
	
	up:
	jmp key_loop
	
	left:
	cmp esi, buffer			;checks if the cursor is already at the beginning of the text
	je key_loop
	;sub edi, 2
	dec esi
	jmp key_loop
	
	right:
	cmp byte [esi], 0		;checks if the cursor is already at the end of the text
	je key_loop			;prevents the cursor from moving to far to the right
	;add edi, 2
	inc esi
	jmp key_loop

	down:
	jmp key_loop


	commandMode:			;commandMode allows the user to use more commands
	call getKey

	cmp al, "i"			;insert (go back to insert mode)
	je key_loop
	cmp al, "k"			;move up
	je upK
	cmp al, "h"			;move left
	je leftH
	cmp al, "l"			;move right
	je rightL
	cmp al, "j"			;move down
	je downJ


	jmp commandMode			;repeat

	
	upK:
	jmp commandMode

	leftH:
	jmp commandMode

	rightL:
	jmp commandMode

	downJ:
	jmp commandMode


printBuffer:				;prints entire buffer again
	push edi
	push esi
	
	mov esi, buffer
	mov edi, 0xb8000

	.printLoop:
	mov al, byte [esi]		;print character in buffer to screen
	mov byte [edi], al
	inc esi
	;add edi, 2
	cmp byte [esi], 0
	jne .printLoop			;next character

nop
nop
nop
nop
	.continue:

	pop esi
	pop edi

	ret


shiftBufferRight:

	xor ecx, ecx
	dec cx				;sets cx and esi to minus one so that the first loop doesnt affect them (in case that there are no characters on the right) 
	dec esi
	.checkBufferLoop:
	inc cx				;counts the number of characters in the buffer on the right side of the cursor
	inc esi
	cmp byte [esi], 0		;check for the end of the buffer
	jne .checkBufferLoop

	cmp cx, 0 			;if there are no characters on the right side dont shitft them
	je .continue
	dec esi

	.shiftLoop:
	mov dl, byte [esi]	
	inc esi
	mov byte [esi], dl		;store character in dl and move it one space to the right
	sub esi, 2			;go back two spaces to get the next character
	cmp cx, 2			;if there are two characters on the right side of the cursor jmp to lastshift
	je .lastShift

	dec cx
	jmp .shiftLoop			;repeat

	.lastShift:
	mov dl, byte [esi]
	inc esi
	mov byte [esi], dl
	dec esi				;only go one space back where the new character can be printed

	.continue:

	ret


shiftBufferLeft:

	push edi
	push esi
	;cmp byte [esi], 0		
	;je .continue

	.shiftLoopLeft:
	inc esi
	cmp byte [esi], 0
	je .continue
	
	mov dl, byte [esi]		;take character and move it to the left
	dec esi
	mov byte [esi], dl
	inc esi

	jmp .shiftLoopLeft


	.continue:

	dec esi
	mov byte [esi], 0	;move 0 to end of buffer

	call clear_screen

	pop esi
	pop edi

	ret

	;dec cx				;sets cx and esi to minus one so that the first loop doesnt affect them (in case that there are no characters on the right) 
	;dec esi
	;.checkBufferLoop:
	;inc cx				;counts the number of characters in the buffer on the right side of the cursor
	;inc esi
	;mov dl, byte [esi]		;check for the end of the buffer
	;cmp dl, 0
	;jne .checkBufferLoop

	;cmp cx, 0 			;if there are no characters on the right side dont shitft them
	;je .continue
	;dec esi

	;.shiftLoop:
	;mov dl, byte [esi]	
	;inc esi
	;mov byte [esi], dl		;store character in dl and move it one space to the right
	;sub esi, 2			;go back two spaces to get the next character
	;cmp cx, 2			;if there are two characters on the right side of the cursor jmp to lastshift
	;je .lastShift

	;dec cx
	;jmp .shiftLoop			;repeat

	;.lastShift:
	;mov dl, byte [esi]
	;inc esi
	;mov byte [esi], dl
	;dec esi				;only go one space back where the new character can be printed

	;.continue:

	;ret

shutdownTextEditor:
	call shutdown

buffer: times BUFFER_LENGTH db 0
db 0

END_PADDING
