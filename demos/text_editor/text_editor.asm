jmp main

%include "keyboard/keyboard.asm"
%include "library.asm"
%define BUFFER_LENGTH 0x200
%define LINE_WIDTH 80
cursor: resb 1

main:
call clear_screen

mov esi, buffer					;move the memory address of the beginning of the buffer into esi
mov edi, 0xb8001

key_loop:
	
	mov byte [edi], 0xf0

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

	mov byte [edi], 0x0f
	add edi, 2

	
	jmp key_loop				;repeat

	
	backspace:
	cmp esi, buffer
	je key_loop
	dec esi
	mov byte [edi], 0x0f

	cmp byte [esi], 0x0a
	jne .noNewLineBackspace

	cmp byte [esi-1], 0x0a
	je .multipleEnter

	dec edi
	.findCursorBackspace:
	sub edi, 2
	;cmp byte [edi], " "
	;je .findCursorBackspace
	cmp byte [edi], 0
	je .findCursorBackspace

	add edi, 3

	call shiftBufferLeft			;move all characters right of the deleted characters one to the left
	call printBuffer
	
	jmp key_loop

	.multipleEnter:
	sub edi, 158

	.noNewLineBackspace:
	sub edi, 2

	call shiftBufferLeft			;move all characters right of the deleted characters one to the left
	call printBuffer

	jmp key_loop

	


	tab:
	
	jmp key_loop
	


	
	enter:
	mov byte [edi], 0x0f
	xor edx, edx

	mov eax, edi				
	sub eax, 0xb8000			;get position of cursor
	mov bx, 2*LINE_WIDTH
	div bx					;get line of cursor
	inc ax
	and eax, 0x0000ffff

	mov bx, 2*LINE_WIDTH
	mul bx					;multiply line (+1) with LINE_WIDTH to get the position of the next line
	add eax, 0xb8000		
	
	mov edi, eax				;cursor moved to next line
	inc edi
	
	call shiftBufferRight			;make space for 0x0a
	mov byte [esi], 0x0a			;marks new line for the printBuffer function

	push edi
	call clear_screen			
	pop edi

	call printBuffer			
	inc esi
	
	jmp key_loop
	



	up:
	
	jmp key_loop




	left:
	cmp esi, buffer			;checks if the cursor is already at the beginning of the text
	je key_loop
	dec esi
	mov byte [edi], 0x0f

	cmp byte [esi], 0x0a
	jne .noNewLineLeft
	cmp byte [esi-1], 0x0a
	je .multipleEnterLeft

	dec edi
	.findCursorLeft:
	sub edi, 2
	;cmp byte [edi], " "
	;je .findCursorLeft
	cmp byte [edi], 0
	je .findCursorLeft

	add edi, 3
	jmp key_loop

	.multipleEnterLeft:
	sub edi, 158

	.noNewLineLeft:
	sub edi, 2

	jmp key_loop



	
	right:
	cmp byte [esi], 0		;checks if the cursor is already at the end of the text
	je key_loop			;prevents the cursor from moving to far to the right
	mov byte [edi], 0x0f
	cmp byte [esi], 0x0a
	jne .noNewLineRight

	inc esi
	xor dx, dx
	mov eax, edi
	sub eax, 0xb8000
	mov bx, 2*LINE_WIDTH
	div bx
	inc ax
	mul bx
	add eax, 0xb8000
	mov edi, eax
	inc edi

	jmp key_loop

	.noNewLineRight:
	inc esi
	
	add edi, 2

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
	cmp al, 0x0a
	jne .noNewLine
	; newline in buffer

	xor eax, eax
	xor edx, edx
	sub edi, 0xb8000
	mov eax, edi
	add edi, 0xb8000
	mov ebx, 2*LINE_WIDTH
	div bx
	and edx, 0x0000ffff
	mov eax, 2*LINE_WIDTH
	sub eax, edx
	add edi, eax
	inc esi
	jmp .printLoop
	
	.noNewLine:
	mov byte [edi], al
	inc esi
	add edi, 2
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

	push esi
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
	cmp cx, 1
	je .lastShift

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

	pop esi

	ret


shiftBufferLeft:

	push edi			;push edi because of clear_screen
	push esi

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


buffer: times BUFFER_LENGTH db 0
db 0


END_PADDING
