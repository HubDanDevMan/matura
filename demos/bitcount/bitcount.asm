%define BIT_CHAIN_LENGTH 	13
; This is just for the current test

%define BIT_MAP_SIZE		32
; BIT_MAP_SIZE refers to the number of BYTES in the BITMAP

jmp prog

; variables
;EAX : counts set bits since Last 0 bit; will point to the current bit index
;EBX : current byte pointer; will point to a byte in the Bitmap 
;ECX : holds length of desired bit chain, passed as arg 
;EDI : BITTEST index, [0-7]
;EDX : holds byte pointed to by EBX for higher speed (Registers are faster than RAM) 



findBitChainIndex:
; Takes argument NumberOfSectors<ECX> and returns sector number that contains
; continuos sector space requested
; it's needed by the filesystem for the sector allocator algorithm
; returns length of the chain in ECX and start position of chain in EAX
	mov ebx, BITMAP	; EBX points to the first byte in the BITMAP array
	.bitmapBytePtrLoop:
		xor edx, edx		; clear out upper bits of edx 
		mov dl, byte [ebx]	; dl holds byte pointed to by [EBX]
		xor edi, edi 		; set up bittest index (set to 0)
		.testBit:			; another loop head for each bit
			bt edx, edi	; check if bit number <edi> in BYTE is 1
					; if true, the bt instruction sets the carry flag
			jnc .bitIsZero	; bit is 0
			;.bitIsSet	; increment counter of 1s since last 0
				inc eax
				cmp eax, ecx	; check if the counter has reached the desired amount
				jne .notEnoughBits
				; return the start position (in bits) of the bitchain with <ecx> many
				; consecutive 1s
				mov eax, ebx
				sub eax, BITMAP	; EAX will contain the BYTE offset relative to the BM
				shl eax, 3	; multiply the BYTE offset with 8 (bits per byte)
				;each shift left is equal to *2 mul, 3 shift left is *= 2*2*2, so *8
				add eax, edi	; add the bit offset in Byte to the BYTE offset as bits  
				; return value (Sector Number with sequential N free sectors) is in eax
				ret
			.bitIsZero:
				xor eax, eax	; reset the counter of 1s since last 0 
			.notEnoughBits:
			inc edi
			cmp edi, 8		; check if last bit (bit 8) has been reached
			jl .testBit		; if edi is 8, then redo the bit test but at bitpo+=1
			; else just redo
	.redoBMByteLoop:
	inc ebx
	cmp ebx, BIT_MAP_SIZE
	jle .bitmapBytePtrLoop	; if EBX (:=BYTE Pointer) is greater than the bitmap size, do not loop
	; If every BYTE in BITMAP has been scanned without a matching index,
	; return -1, signifying an ERROR
	mov eax, -1
	ret

prog:

; mov ecx, 0b00000000000000000000000010001001
; bsf eax, ecx


; setup
mov ecx, BIT_CHAIN_LENGTH	; ecx contains the length of the desired bit chain
call findBitChainIndex		; 
nop
nop
nop
add al, 0x30
mov ah, 0x0e
int 0x10

jmp $
mov eax, esi
; print eax

mov esi, strbuf
call print

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


; BIT MAP
; FREE SECTOR := 1
; EMPTY SECTOR := 0
align 8
BITMAP:
dd 0b1111_1111_1111_1111_1111_1111_1111_1100
times 7 dd 0xFFFF_FFFF	; all are unoccupied
END_PADDING
