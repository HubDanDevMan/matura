%include "firststage.asm"

mov bx, 0xcfff

redo:
	in al, 0x61
	or al, 0x02
	out 0x61, al
	; add delay
	mov cx, bx
	repeat:
		dec cx
		jnz repeat
	in al, 0x61
	and al, 0b1111_1100
	out 0x61, al
	jmp redo
	

jmp $
times 512*MAX_SECTORS-($-$$) db 0

