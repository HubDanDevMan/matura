[org 0x7c00]
%define MAX_SECTORS 8



mov ax, 0x1000
mov ss, ax
mov ax, 0x07e0
mov es, ax
mov bx, 0
; es:bx = data buffer (0x7e00)

mov si, 3			; number of retries
retry:
mov ah, 2
mov al, MAX_SECTORS-1	; number of sectors to load into memory
xor dh, dh			; head number 0
xor ch, ch  	    ; cylinder 0
mov cl, 0x02		; sector number
					; dl is set by bios and is disk number
int 0x13

jnc pre_kernel_main
; error handling
xor ax, ax			; reset disk
int 0x13
dec si
jnz retry

mov si, BOOT_LOADER_STRINGS.ERRMSG
call puts 			; Print boot successmessage
call printReg		; Display Errorcode in ax
jmp $

; include debug headers
; for register info aswell as

; mov si, <stringlabel>
puts:
	; prints NULL terminated string
	pusha
	xor bx, bx			; could interfer with page number
	mov ah, 0x0e
	puts_loop:			; is a do while loop 
	mov al, [si]
	int 0x10
	inc si
	cmp byte [si], 0
	jnz puts_loop
	popa
	ret


printHex:; prints al as hex
	; has more code (bytes) but easier on register transfer, works on speed critical applications
	pusha
	xor bx, bx
	xor dx, dx
	mov ah, 0x0e
	mov dh, al
	rol dx, 4
	mov al, dl
	cmp al, 0x0a
	jl .hex_smaller
	add al, 0x07 		; 7d more would turn 10+0x30 to "A"
	.hex_smaller:
	add al, 0x30 		; al= ascii value of hex value of top nibble in al

	int 0x10			; ah should stay 0xe
	; second nibble
	xor dl, dl
	rol dx, 4			; next nibble is now in dl, dh = 0
	mov al, dl
	cmp al, 0x0a
	jl .hex_smaller2
	add al, 0x07 		; 7d more
	.hex_smaller2:
	add al, 0x30 		; al= ascii value of hex value of top nibble in al

	int 0x10
	popa
	ret

	
printReg:
	; prints ax
	pusha
	rol ax, 8
	mov bh, ah
	call printHex
	mov al, bh
	call printHex
	popa
	ret

printD:
	; prints signed decimal 16-bit number in ax
	pusha
	push 0x0000			; End of string marker
	mov cx, 10

	bt si, 15			; test if num to print is negative, so add "-"
	jnc .print_dec_Full
	
	mov ah, 0xe
	mov al, "-"
	int 0x10			; print the "-"
	
	neg si				; value can be divided using div instead of idiv

	.print_dec_Full:
	mov ax, si			; copy value to print to dividing register

	.print_dec_rep:
		xor dx, dx		; prevent interference when dividing
		div cx			; divide value by 10
		; AX: Quotient, DX: Remainder
		cmp ax, 0x0000 	; if no quotient, print all pushed digits
		je .print_dec_digits

		xchg ax, dx		; swaps ax  with dx| ax: remainder (<10!)		
		add ax, 0x0e30	; ah:print, al:digit in ASCII
		push ax
		mov ax, dx		; keep dividing the remainder until it reaches 0
		jmp .print_dec_rep
		
		.print_dec_digits:
		mov ax, dx
		add ax, 0x0e30	; prints remaining digit
		int 0x10
		
		.dec_print_loop:
		pop ax			; not done at the end bc marker has to be deleted from stack
		cmp ax, 0x0000
		je .print_dec_done
		int 0x10
		jmp .dec_print_loop
		
	.print_dec_done:
	popa				; restores all the registers
	ret
pre_kernel_main:
	mov si, BOOT_LOADER_STRINGS.SUCCESSBOOTMSG
	call puts
	jmp kernel_main
	
BOOT_LOADER_STRINGS:
.ERRMSG: db "DISKERR", 0xa, 0xd, 0
.SUCCESSBOOTMSG: db "Boot successful", 0x0a, 0x0d, 0
times 510-($-$$) db 0
dw 0xaa55
; second stage 
kernel_main:
