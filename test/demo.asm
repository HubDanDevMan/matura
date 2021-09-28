%include "firststage.asm"
mov ax,0x2000
mov ss, ax
mov bp, 0x4000
mov sp, bp

mov ax, 0
mov es, ax
mov ds, ax

mov eax, 0x0000e820
mov edx, 0x534D415
mov ebx, 0
mov ecx, 24
mov edi, membuf
int 0x15

; loop
memloop:
or ebx, ebx
je done
mov eax, 0x0000e820
mov edx, 0x534D415
mov ebx, 0
mov ecx, 24
mov edi, membuf +24
int 0x15
jmp memloop

done:

jmp noerr
pusha
mov ah, 0xe
mov al, "E"
int 0x10
popa

mov di, errbuf
call formatHex
mov esi, errbuf
call printBuf

jmp $

errbuf:
times 3 db 0

noerr:

mov esi, membuf
mov edi, strbuf
mov ecx, 8*8
call hexdump



mov esi, strbuf
call printBuf
jmp $
; mov esi, <source>
; mov edi, <strbuf>
; mov ecx, <nrBytes>
hexdump:
	mov al, byte [esi]
	; params
	call formatHex
	inc edi
	mov byte [edi], " "
	inc edi
	inc esi
	db 0x66 	; use ECX instead of CX prefix
	loop hexdump
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

; mov esi, strbuf
printBuf:
	mov edi, 0xb8000
	.repprint:
	mov dl, byte[esi]
	mov byte [edi], dl
	inc esi
	add edi, 2
	cmp byte [esi], 0
	jne .repprint
	ret


strbuf: times 200 db " "
db 0
align 8
membuf: times 24*8 db 0
	
times 512*MAX_SECTORS-($-$$) db 0

