; License: GPL-v3.0-only
; Full license text in ../LICENSE
; Original Authors:
; Daniel Huber
; Nick Gilgen
; Moray Yesilgüller

; This file contains formatting functions for decimal and hexadecimal to string
; conversions and vice versa

; FormatHex BYTES DESTINATION_BUF
; the number of nibbles to be parsed and reformatted
; 1 => AL bottom nibble
; 2 => AL
; 4 => AX
; 8 => EAX
%macro FormatHex 2
	mov cl, %1
	shl cl, 2
	rol eax, cl
	shr cl, 2
	mov edi, %2
	call formatHexFunc
%endmacro



; formats eax, ax or al as a hexadecimal number
formatHexFunc:
	pusha
	and cx, 0x0f			; extends cl to cx
	.get_hex_char:
	rol eax, 4
	mov dl, al
	and dl, 0x0F
	add dl, 0x30
	cmp dl, 0x39
	jle .no_add
	add dl, 7
	.no_add:
	mov byte [edi], dl
	inc edi


	loop .get_hex_char

	popa
	ret


; this function moves strings into video memory
; the programmer should assert that the segment registers are correct
printStringBuf:
	pusha
	mov edi, 0xb8000
	; build in segment misalignment check
	.repmv:
	mov dl, byte [esi]
	cmp dl, 0
	je .done
	mov byte [edi], dl
	add edi, 2
	inc esi
	jmp .repmv
	.done:
	popa
	ret


