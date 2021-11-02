;;;;; LINEAR FEEDBACK SHIFT REGISTER
; 2**32 random number generator
;;;;; NOT CRYPTOGRAPHICALLY SECURE

;>>> LSFR SIZE is fixed to 32

; esi => seed
; eax => output, every new output bit shifts eax left
; edi => temporary result 1
; edx => temporary result 2
; ecx => Feedback iteration counter


; 0 and 1 are not valid seeds !! 
mov esi,  0x1234567890abcdef	; <- SEED 
mov ecx, 256*256*256*256		; Number of Feedbacks
mov ah, 0x0e
rand:
	xor al, al
	shr esi, 1
	; print bit
	adc al, 0x30
	int 0x10

	; calculate new leftmost bit with maskbits
	; edi holds 1. temp val
	; edl holds 2. temp val
	mov edi, 1
	mov edx, 2

	and edi, esi	; set edi to bit 1 of esi
	and edx, esi	; set edx to bit 2 of esi

	shr edx, 1	; set bit 2 of esi in edx to rightmost bit
	xor edi, edx 	; calculate next bit
	; edi now holds the bit
	ror edi, 1	; calculated bit is now leftmost
	or esi, edi	; set leftmost bit of LFSR accordingly
							        
	dec ecx		; do it 16 times
	jnz rand

; done
jmp $

END_PADDING
