%define SECTORS 8
%define END_PADDING times (512*SECTORS)-($-$$) db 0

mov ah, 0x02
mov al, SECTORS - 1
mov ch, 0x0
mov cl, 0x02
mov dh, 0x0
mov bx, 0x0

mov es, bx
mov bx, 0x7e00
int 0x13

jc error
jmp __start
error:
	mov ah, 0x0e
	mov al, 'B'
	int 0x10
	jmp $


times 510-($-$$) db 0
db 0x55, 0xaa
__start:
mov ah, 0x0e
mov al, "S"
int 0x10