%define END times 2352-($-$$) db 0

mov ah, 0x02
mov al, 0x01
mov ch, 0x0
mov cl, 0x02
mov dh, 0x0
mov bx, 0x0
mov es, bx
mov bx, 0x7e00
int 0x13
jc error
jmp start
error:
mov ah, 0x0e
mov al, 'e'
int 0x10
jmp $
times 510-($-$$) db 0
db 0x55, 0xaa
start:
jmp main
