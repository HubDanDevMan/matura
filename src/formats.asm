; License: GPL-v3.0-only
; Full license text in ../LICENSE
; Original Authors:
; Daniel Huber
; Nick Gilgen
; Moray Yesilgüller

; This file contains formatting functions for hexadecimal to string
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


; FormatBin BITS DESTINATION_BUF
; BITS refers to the number of binary digits that should be parsed
%macro FormatBin 2
	mov ecx, %1
	mov edi, %2
	call formatBinFunc
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


; formats eax, ax or al as a binary number
formatBinFunc:
	pusha
	; we might print 32 bits but for that we need to start with 31. bit
	; thats why we decrement ecx first
	.loophead:
	dec ecx
	mov dl, "0"
	bt eax, ecx		; set carry flag based on bit Nr ECX of EAX
	jnc .noAdd		; if the bit Nr ECX of EAX is 1, then set the output in DL to "1"
	inc dl
	.noAdd:
	mov byte [edi], dl	; mov ascii character to the buffer
	inc edi			; increment char buffer pointer
	or ecx, ecx		; does it print last bit??
	jnz .loophead
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


