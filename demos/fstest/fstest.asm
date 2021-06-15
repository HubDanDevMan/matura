%include "../src/filesystem.asm"


mov al, "x"
mov edi, 0x500
mov cx, 512*2		; 2 sectors
call memset


; This chunk writes "x"es to the first 2 sector, look at the binary file with hexdump and notice the "x"s (0x78)
;	 |
;	 |
;	\|/
;	 v

WriteSector 0,0,1,2,0x500
nop
mov ah, 0x0e
mov al, "D"
int 0x10
jmp $

; mov al, byte
; mov edi, dest
; mov cx, bytes
memset:
	mov byte [edi], al
	inc edi
	loop memset
	ret

align 512

times 512*20 db 0
