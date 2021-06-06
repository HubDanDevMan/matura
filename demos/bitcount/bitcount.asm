jmp prog
countConsecutiveOnes:
; takes a char in al and counts longest chain of ones.
; it's needed by the filesystem for the sector allocator algorithm
; returns length of the chain in cx and position of chain start in dx
	mov cx, 0
	mov dl, 0
	.lhead:
	cmp al, 0
	je done
	mov al, bl
	shl bl, 1
	and al, bl
	inc dl
	jmp .lhead
	done:
	ret


prog:
mov esi, strbuf
call print

jmp $

mov al, 0b0011_1100
call countConsecutiveOnes
add byte [charbuf], al
mov esi, strbuf
call print

mov ah, 0x0e
mov al, "3"
int 0x10
jmp $

print:
	mov edi, 0xb8000
	lhead:
	cmp byte [esi], 0
	je .ploop
	mov dl, byte [esi]
	mov byte [edi], dl
	add edi, 2
	inc esi
	jmp lhead
	.ploop:
	ret


align 8
strbuf: db "longest chain: "
charbuf: db "0", 0


END_PADDING
