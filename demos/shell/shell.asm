; ____  _          _ _ 
;/ ___|| |__   ___| | |
;\___ \| '_ \ / _ \ | |
; ___) | | | |  __/ | |
;|____/|_| |_|\___|_|_|
jmp main
%include "keyboard/keyboard.asm"
%include "library.asm
%include "shell/commands.asm"


%macro  ShellCmp 3
mov esi, %1
mov edi, %2
call compareString
cmp eax, 0
je %3
%macro

enter:
;main loop

main:
call clear_screen
call print_buffer
xor al, al
.shell_loop:
	call getKey
	cmp al, 0x02
	je .key_delete
	cmp al, 0x04
	je .key_enter
	call buffer_insert
	call print_buffer
	jmp .shell_loop
	.key_delete:
	call buffer_delete
	call print_buffer
	jmp .shell_loop
	.key_enter:
	call buffer_compare
	call buffer_wipe
	call print_buffer
	cmp dh, 21
	jne .skip
	call scroll_screen
	dec dh
	.skip:
	jmp .shell_loop


;buffer for string comparison
prebuffer:
db "[Flamingos$]:"
buffer:
times 255 db " "
db 0

;interrupt that gets ascii key from pressed button in al



;put al in buffer
buffer_insert:
	cmp ecx, 255
	je .return 			;exception for char limit
	mov edi, buffer
	add edi, ecx
	mov [edi], al
	inc ecx
	xor al, al
	.return:
	ret


;delete a character out of buffer
buffer_delete:
	cmp ecx, 0
	je getKey 			;exception for char limit
	mov edi, buffer
	add edi, ecx
	dec edi
	mov al, " "
	mov [edi], al
	dec ecx
	ret

;add another check if its outside vm
buffer_wipe:
	push edi
	mov edi, buffer
	.wipe_loop:
	mov al, " "
	mov byte[edi], al
	inc edi
	cmp byte[edi], 0
	jne .wipe_loop
	pop edi
	sub edi, 0xb8000
	mov eax, edi
	mov cl, 160
	div cl
	mov dl, al
	inc dh
	xor cl, cl
	ret

scroll_screen:
	mov esi, 0xb8000
	add esi, 160
	mov edi, 0xb8000
	.screen_loop
	mov dl, byte[esi]
	mov byte[edi],dl
	inc edi
	inc esi
	cmp esi, 0xb8FA0 + 160
	jne .screen_loop
	ret

;function for printing wbuffer into video memory
;add a buffer wiper for some reaseon enter does not work yet(keeps memory location)
print_buffer:
	push dx
	inc dh
	mov esi, prebuffer
	mov edi, 0xb8000
	sub edi, 160
	.check_line:
	dec dh
	add edi, 160
	cmp dh, 0
	jne .check_line
	pop dx
	.print_buffer_loop:
	mov dl, [esi]
	mov [edi], dl
	inc esi
	inc edi
	inc edi
	cmp byte[esi], 0
	je .return
	jmp .print_buffer_loop
	.return:
	ret





;function that clears the screen with a loop that inserts spaces
clear_screen:
	mov edi, 0xb8000
	mov ecx, 0
	mov al, " "
	.clear_screen_loop:
	mov [edi], al
	inc ecx
	inc edi
	inc edi
	cmp ecx, 1920
	je .return
	jmp .clear_screen_loop
	.return:
	mov ecx, 0
	mov eax, 0
	ret

buffer_compare:
	ShellCmp buffer,buffer_shutdown, shutdown



END_PADDING

















































;
