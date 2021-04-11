; License: GPL-v3.0-only
; Full license text in ../LICENSE
; Original Author: Daniel Huber


[org 0x7c00]		; The BIOS loads this code section to memory location
					; 0x7c00. The org directive tells the assembler to
					; produce correctly aligned code when using absolute
					; addresses or when introducing padding.
					
[bits 16]			; Assembler directive to produce 16 bit x86 code instead
					; of 32 bit or 64 bit

mov ax, 0x1000			; Initialize the stack segment (ss)
mov ss, ax				; ss can only be loadet through register and not by
						; immediate value

mov ax, 0x07e0			; Initialize extra segment (es) indirectly to point 
mov es, ax				; to the 512 (0x200) bytes after 0x7c00

xor bx, bx				; set bx to 0

; es:bx = data buffer (0x7e00)
; this data buffer will be used by the next step,
; namely loading more sectors from disk into memory

; This is the heart of the boot loader
; because here the OS code (or kernel) will be loaded into memory
; We want the code to be loaded right next to our bootloader code
; in memory.

; Memory address      ^
; 0x8200 ->		| 4. Sector |
;  		   		|-----------| 
; 0x8000 ->		| 3. Sector |
;  		   		|-----------| 
; 0x7e00 ->		| 2. Sector | (data buffer start)    <- [ ES:BX ]
;  		   		|-----------| 
; 0x7c00 ->		|BOOTLOADER | (1. Sector of disk)
;  		   		|-----------| 
; 0x7a00 ->		|  <EMPTY>  |
; ...
; 
mov si, 3				; Set up retry counter in register

boot_retry:
mov ah, 2 				; BIOS function code READ
mov al, MAX_SECTORS-1 	; Number of sectors to load into memory
						; MAX_SECTORS is defined in the Makefile and added
						; at compile time
xor dh, dh				; Head number 0
xor ch, ch  	    	; Cylinder 0
mov cl, 0x02			; Sector number
int 0x13				; Tells the BIOS to perform the disk operation

jnc __main				; The BIOS sets the Carry Flag (CF) on error
						; therefore when CF is clear, there was no error
						; and the OS startup can continue
						
; error handling
xor ax, ax				; Function code RESET_DISK
int 0x13				; perform BIOS call

dec si 					; decrement counter
jnz boot_retry 			; reattempt at least 3 times

mov si, booterrmsg		; Print a Errormessage
call puts

; Retrieve Errorcode of last disk operation
mov ah, 0x01			; Function code STATUS_LAST_OPERATION
int 0x13				; Perform BIOS call, not only CF is set
						; but also an errorcode is placed in ax
						; to find out what error happened, consult
						; https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=01h:_Get_Status_of_Last_Drive_Operation

call printReg			; print out the errorcode (ax) to user
jmp $					; Boot loader will hang here, a shutdown will be needed




; This section is still less than 512 bytes, so the remaining empty space has
; been filled with primitive functions that will be used often while setting
; up the os. Most of these functions are for printing formatted data.
; The interesting part of the OS continues on label __main ca 40 lines below.

; include debug headers
; for register info aswell as

; mov si, <stringlabel>
puts:
	; prints NULL terminated string
	pusha 				; Saves all registers on the stack
	xor bx, bx			; Could interfer with page number
	mov ah, 0x0e 		; Set up print character parameter for BIOS
	
	.puts_loop:			; Loop head
		mov al, [si] 	; Loads the next string character
		int 0x10 		; Perform BIOS call to print a character on the screen
		
						; Just like any BIOS call, it can be done by using your own routine
						; which would just move the character to videomemory area, located
						; at 0xb8000 with the layout [4bit color,4bit bg color , ASCII-char]
						; But a bootsector has limited space and therefore the BIOS callroutine
						; is used.
						
		inc si 			; Point to the next ASCII character to be printed
		cmp byte [si], 0; Check if its Null (end of string marker)
		jnz .puts_loop 	; If not, keep printing characters
		
	popa 				; Restores all register from the stack
	ret					; resumes instructions from where it left off



printHex:; prints al as hex
	pusha
	xor dx, dx
	mov ah, 0x0e
	mov dh, al
	rol dx, 4
	mov al, dl
	cmp al, 0x0a
	jl .hex_smaller
	add al, 0x07 		; 7d more
	.hex_smaller:
	add al, "0" 		; al= ascii value of hex value of top nibble in al
						; \0 + "0" = 30, 1 + "0" = 31 or ASCII 1
	int 0x10			; ah should stay 0xe
	; second nibble
	xor dl, dl
	rol dx, 4			; next nibble is now in dl, dh = 0
	mov al, dl
	cmp al, 0x0a
	jl .hex_smaller2
	add al, 0x07 		; 7d more
	.hex_smaller2:
	add al, "0" 		; al= ascii value of hex value of top nibble in al

	int 0x10
	popa
	ret

	
printReg:
	; prints ax
	push ax
	push bx
	rol ax, 8
	mov bh, ah
	call printHex
	mov al, bh
	call printHex
	pop bx
	pop ax
	ret

printD:
	; prints signed decimal 16-bit number in si
	pusha
	push 0x0000			; End of string marker on stack
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

; Strings are just bytes laying around like code
; They are Null-terminated arrays to make printing
; of strings easier.
booterrmsg: db "DISKERROR!", 0xa, 0xd, "Errorcode: ", 0


times 510-($-$$) db 0 	; padds the remaining empty bytes with 0
						; to fill the sector entirely
				
dw 0xaa55				; Signature word
						; It must be located at the 511 and 512 byte
						; When the Bios sees a disk with the first sector
						; having the signature at said location it loads the sector
						; into memory and starts executing it
						
; Start of second sector 


__main:	
	
