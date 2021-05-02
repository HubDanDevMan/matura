%include 'imports.asm'



;function to print all registers onto a video memory array
;still needs to be made 32 bit

main: 				
	call get_ip 				;only way to push instruction pointer into stack
	get_ip: 					;by calling a funtion without return
	pushf 						;pushes flag registers onto stack

	push dx 					;push all registers used for video memory array
	push cx 					;onto stack
	push bx
	push ax

	mov cx,0 					;clean registers
	mov dx, 0
	mov ch, 0000_1111b 			;video memory array parameters	
	mov ax, 0x0b800		
	mov ds, ax
 	mov bx, 1440 				;start location
 	

	
	pop ax 						;register to print is stored in ax
	call print_reg_func			;fuction to print
	pop ax
	call print_reg_func
	pop ax
	call print_reg_func
	pop ax
	call print_reg_func
	mov ax, cs
	call print_reg_func
	mov ax, ss
	call print_reg_func
	mov ax, ds
	call print_reg_func
	mov ax, gs
	call print_reg_func
	mov ax, es
	call print_reg_func
	mov ax, fs
	call print_reg_func
	pop ax
	call print_reg_func
	pop ax
	call print_reg_func
	

	jmp stop


;the print register fuction works by isolating 4 bits into a register and 
;translating it into hexadecimal it starts from the highest 4 bits and moves
;down

print_reg_func:
	mov cl, 0  						;clean register
	mov dl, ah 						;take higher 8 bits from ax
	ror dx, 4 						;rotate the higher 4 bits into dl
	mov cl, dl 						;store higher 4 bits in cl to print
	call print_hex_char 			
	shr dx, 12 						;shift dx by 12 to isolate lower 4 bits
	mov cl, dl 						;store lower 4 bits for printin
	call print_hex_char
	mov dl, al 						;same as before but with lower 8 bits from ax
	ror dx, 4 
	mov cl, dl
	call print_hex_char
	shr dx, 12
	mov cl, dl
	call print_hex_char
	add bx, 152 					;new line in video memory
	ret 				
	

;this fuction translates decimals into hexadecimals in ascii and prints it
;into video memory

print_hex_char: 		
	cmp cl, 10  					;if below 10 only add 0x30
	jl smaller
	add cl, 7 						;if above 10 also add 7 to gain letters
	smaller:
	add cl, 0x30
	mov [bx],cx 					;move character into video memory
	add bx, 2
	ret

stop:
END
