
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
