; ____  _          _ _ 
;/ ___|| |__   ___| | |
;\___ \| '_ \ / _ \ | |
; ___) | | | |  __/ | |
;|____/|_| |_|\___|_|_|
                      
jmp main




enter:
;main loop
main:
call clear_screen
.shell_loop:
	call get_key
	cmp al, 0x08
	je .key_delete
	cmp al, 0x0d
	je .key_enter
	call buffer_key
	call print_buffer
	jmp .shell_loop
	.key_delete:
	call buffer_delete
	call print_buffer
	jmp .shell_loop
	.key_enter:
	;call buffer_compare
	;call buffer_wipe
	jmp .shell_loop


;buffer for string comparison
buffer:
times 255 db " "
db 0



;interrupt that gets ascii key from pressed button in al
get_key:
	xor eax,eax
	int 0x16
	ret


;put al in buffer
buffer_insert:
	cmp ecx, 255
	je get_key 			;exception for char limit
	mov edi, buffer
	add edi, ecx
	mov [edi], al
	inc ecx
	ret


;delete a character out of buffer
buffer_delete:
	cmp ecx, 0
	je get_key 			;exception for char limit
	mov edi, buffer
	add edi, ecx
	dec edi
	mov al, " "
	mov [edi], al
	dec ecx
	ret


;function for printing buffer into video memory
print_buffer:
	mov esi, buffer
	mov edi, 0xb8000
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





END_PADDING

















































;
