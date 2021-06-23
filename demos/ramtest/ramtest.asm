jmp _start

;%include "ramtest/hexdump.asm"
%define LINE_WIDTH 80
base: resq 1
length: resq 1
type: resd 1

_start:
xor ax, ax
mov al, 0x02
int 0x10

xor esi, esi
xor ebx, ebx
xor eax, eax
mov es, ax
mov edi, rambuff
mov edx, 0x534d4150

repeat:
	inc si
	mov eax, 0xe820
	mov ecx, 24
	int 0x15
	jc error
	cmp ebx, 0
	je done
	add edi, 24
	jmp repeat

done:
mov cx, si
mov esi, rambuff
mov edi, formatbuff
call formatLoop
mov edi, 0xb8000
mov esi, formatbuff
;mov esi, testbuff
;call formatLoop

.loopprint:
push cx
mov cx, 16
call print
pop cx
add edi, 2*64

push cx
mov cx, 16
call print
pop cx
add edi, 2*64

push cx
mov cx, 2
call print
pop cx
add edi, 2*78
loop .loopprint

jmp $

error:
mov ah, 0x0e
mov al, "e"
int 0x10
jmp $



print:
	push dx
	.baseloop:
	mov dl, byte[esi]
	mov byte[edi], dl
	inc esi
	add edi, 2
	loop .baseloop
	pop dx
	ret

formatLoop:
	push cx
	mov cx, 160
	.loopformat:
	mov al, byte [esi]
	call formatHex
	inc esi
	inc edi
	loop .loopformat
	pop cx
	ret

;moveeax:
;	xor eax, eax
;	push cx
;	mov cx, 4
;	.loopmove:
;	rol eax, 8
;	mov al, byte[esi]
;	inc esi
;	loop .loopmove
;	call formatByte
;	add esi, 8
;	pop cx

formatByte:
	pusha
	xor eax, eax
	mov cx, 2
	mov ah, byte[esi]
	; copy top most bit to dl
	get_top_nibble:
	rol ax, 4
	mov dl, al
	and dl, 0x0F	; clear higher nibble of dl
	; convert to hex representation in ASCII
	add dl, 0x30
	cmp dl, "9"	; if the number is greater than Ascii 9 (0x39), it would turn it to a character, "A"=0x41 
	jle noAdd
	add dl, 0x07 	; turns 9 to ascii "9" and 10 to ascii "A"
	noAdd:
	mov byte [esi], dl
	;inc esi
	loop get_top_nibble
	.return:
	popa
	ret

formatHex:
	mov dl, al
	and dl, 0xF0
	shr dl, 4
	cmp dl, 0xa
	jl .noAdd
	add dl, 0x07
	.noAdd:
	add dl, 0x30
	mov byte [edi], dl
	and al, 0x0F 
	cmp al, 0x0a
	jl .noAdd2
	add al, 0x07
	.noAdd2:
	add al, 0x30
	inc edi
	mov byte [edi], al
	ret

rambuff: times 400 db 0
formatbuff: times 400 db 0
;testbuff:
;db "eeeeeeeaaaaeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeaaaaaaaaaaaAAAAaaaaaa"
;db 0

END_PADDING
