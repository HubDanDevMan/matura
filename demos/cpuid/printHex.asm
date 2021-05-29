; this function takes the value stored in eax and formats it in an 8 byte ASCII representation
; esi and edi should be 0
; mov edi, <bufferaddress>

formatHex:
	pusha
	mov cx, 8
	; copy top most bit to dl
	.get_top_nibble:
	rol eax, 4
	mov dl, al
	and dl, 0x0F	; clear higher nibble of dl
	; convert to hex representation in ASCII
	add dl, 0x30
	cmp dl, "9"	; if the number is greater than Ascii 9 (0x39), it would turn it to a character, "A"=0x41 
	jle .noAdd
	add dl, 0x07 	; turns 9 to ascii "9" and 10 to ascii "A"
	.noAdd:
	mov byte [edi], dl
	inc edi
	loop .get_top_nibble
	popa
	ret

;prints the stringbuffer by moving it into videomemory
; mov esi, <stringbuffer>
printBuff:
	pusha
	mov edi, 0xb8000
	.printloop:
	mov dl, byte [esi]
	mov byte [edi], dl
	add edi, 2
	inc esi
	cmp byte [esi], 0
	jne .printloop
	popa
	ret


