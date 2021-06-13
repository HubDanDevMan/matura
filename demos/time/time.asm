
mov ah, 0x0 			;paremeters for the interrupt
clc 				;clear carry flag to avoid problems 
int 0x1a 			;clock ticks since midnight


;the interrupt gives the amount of ticks since midnight which are about 18.2 per second

mov esi, clockbuff 		;print letters from buffer for UTC 			
call printBuff
mov edi, 0xb8008 		;video memory location

mov ax, cx 			;move upper ticks into ax
rol eax, 16 			;rotate left
mov ax, dx 			;move lower ticks into ax
mov edx, 0
mov ecx, 65520 			;divide by this to get hours (this number is the amount of ticks in an hour)
div ecx
mov cl, 10 			;seperate digits and print
div cl
mov dl, ah
call print

mov al, dl
call print
 				
mov al, 0xa 			;print :
call print

mov ax, dx 			;remainder of the hours into ax
mov cx, 1092 			;divide by this number to get minutes (this number is the amount of ticks in a minute)
mov dx, 0
div cx
mov cl, 10 			;seperate digits and print
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

clockbuff: db "UTC-"
numbuf: db 0

%include "cpuid/printHex.asm"

END_PADDING
