

;this is a program that detects key inputs and prints
;it out in hex

redo: 				;loop for detecting key inputs in ah
xor ax,ax
checkloop:
int 0x16
cmp ah, 0
je checkloop

 					;print out register once change is detected
mov dl,al
ror dx,4
mov cl,ah
ror cx,4

mov ah, 0x0e
mov al, cl
call print_hex_char
shr cx,12
mov al,cl
call print_hex_char
mov al, dl
call print_hex_char
shr dx, 12
mov al, dl
call print_hex_char
call backspace_carrige_return
jmp redo

print_hex_char:
	cmp al, 10
	jl smaller
	add al, 7
	smaller:
	add al, 0x30
	int 0X10
	ret

backspace_carrige_return:
	mov al, 0x0a
	int 0x10
	mov al, 0x0D
	int 0x10
	ret

jmp $


END_PADDING
