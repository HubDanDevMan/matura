jmp _start

%define LINE_WIDTH 80
base: resq 1
length: resq 1
type: resd 1

_start:
xor ax, ax
mov al, 0x02
int 0x10

xor ebx, ebx
xor eax, eax
mov es, ax
;mov edi, rambuff
mov edi, 0x5000
mov edx, 0x534d4150

repeat:
	mov eax, 0xe820
	mov ecx, 24
	int 0x15
	jc error
	cmp ebx, 0
	je done
	add edi, 24
	inc esi
	jmp repeat

done:
mov ecx, esi
;mov esi, rambuff
mov esi, 0x5000
mov edi, 0xb8000
;mov esi, testbuff
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
mov cx, 4
call print
pop cx
add edi, 2*76
loop .loopprint

jmp $

error:
mov ah, 0x0e
mov al, "e"
int 0x10
jmp $


print:
	.baseloop:
	mov dl, byte[esi]
	mov byte[edi], dl
	inc esi
	add edi, 2
	loop .baseloop
	ret


rambuff: times 400 db 0
testbuff:
db "eeeeeeeaaaaeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeaaaaaaaaaaaAAAAaaaaaa"
db 0

END_PADDING
