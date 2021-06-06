jmp proc

proc:



mov ah, 0x0
clc 
int 0x1a


mov esi, clockbuf
call printBuff
mov edi, 0xb8008

mov ax, cx
rol eax, 16
mov ax, dx
mov edx, 0
mov ecx, 65520
div ecx
mov cl, 10
div cl
mov dl, ah
call print

mov al, dl
add al, 2
call print

mov al, 0xa
call print

mov ax, dx
mov cx, 1092
mov dx, 0
div cx
mov cl, 10
div cl
mov dl, ah
call print

mov al, dl
call print


; clear out remaining line with " "
mov edi, 0xb8012
mov al, " "
mov cx, 0x2ff
clearloop:
	mov byte[edi], al
	add edi, 2
	loop clearloop


jmp $




print:
	mov ah, 0000_1111b
	add al, 0x30
	mov [edi],ax
	add edi, 2
	ret


printL:
	mov ah, 0000_1111b
	mov [edi],ax
	add edi, 2
	ret

clockbuf: db "UTC-"
numbuf: db 0

%include "cpuid/printHex.asm"

END_PADDING
