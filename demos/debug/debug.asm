%define BACKSPACE 	 80

;debug function prints out all registers

main:
	call get_ip 					;call function without return pushes ip
	get_ip:
	pushf 						;flags into stack


	mov eax, 0xABCDEF12 				;test register
	mov ebx, 0xBCDEF123
	mov ecx, 0xCDEF1234
	mov edx, 0xDEF12345

	push ds 					;push changing registers
	push edx
	push ecx
	push ebx
	push eax

	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0




;move register to print into eax and then move into buffer at edi

	pop eax
	mov edi, eaxbuff
	call hex_isolate
	pop eax
	mov edi, ebxbuff
	call hex_isolate
	pop eax
	mov edi, ecxbuff
	call hex_isolate
	pop eax
	mov edi, edxbuff
	call hex_isolate
	mov eax, cs
	mov edi, csbuff
	call hex_isolate
	mov eax, ss
	mov edi, ssbuff
	call hex_isolate
	pop ax
	mov edi, dsbuff
	call hex_isolate
	mov eax, gs
	mov edi, gsbuff
	call hex_isolate
	mov eax, es
	mov edi, esbuff
	call hex_isolate
	mov eax, fs
	mov edi, fsbuff
	call hex_isolate
	pop ax
	mov edi, flbuff
	call hex_isolate
	pop ax
	mov edi, ipbuff
	call hex_isolate
	call print_buff
	jmp $
	


;isolates 4 bits from highest to lowest and transform into ascii

hex_isolate:
	mov edx, eax
	shr edx, 24 			;shifts to isolate highest 8 bits
	ror dx, 4 			;isolate highest 4 bits
	call hex_buff 			;move into buffer
	shr dx, 12 			;repeat for smaller 
	call hex_buff
	mov edx, eax
	shl edx, 8
	shr edx, 24
	ror dx, 4
	call hex_buff
	shr dx, 12
	call hex_buff
	mov dl, ah
	ror dx, 4
	call hex_buff
	shr dx, 12
	call hex_buff
	mov dl, al
	ror dx, 4
	call hex_buff
	shr dx, 12
	call hex_buff
	ret

;transform to ascii and move into buffer
hex_buff:
	mov ch, 0000_1111b 		;white letters black background
	mov cl, dl 			
	cmp cl, 10 			;if bigger then 10 add 7
	jl smaller
	add cl, 7
	smaller:
	add cl, 0x30
	mov [edi],cl 			;move into buffer
	add edi, 2
	ret

;function that prints out the buffer
print_buff:
	mov esi, prebuff		;moves esi to the buffer
	mov edi, 0xb8000
	buff_loop: 							
	mov dl, byte [esi] 		;take byte out of buffer into video memory
	mov byte [edi], dl
	add edi, 2 			;moves 2 bytes for video memory
	inc esi
	cmp byte [esi],0 
	jne buff_loop
	ret

;buffer where the register values are put into
;also contains labels

prebuff:
db "eax:  "  							
eaxbuff: times BACKSPACE-6 db " "								
db "ebx:  "
ebxbuff: times BACKSPACE-6 db " "
db "ecx:  "
ecxbuff: times BACKSPACE-6 db " "
db "edx:  "
edxbuff: times BACKSPACE-6 db " "
db "cs:   "
csbuff: times BACKSPACE-6 db " "
db "ss:   "
ssbuff: times BACKSPACE-6 db " "
db "ds:   "
dsbuff: times BACKSPACE-6 db " "
db "gs:   "
gsbuff: times BACKSPACE-6 db " "
db "es:   "
esbuff: times BACKSPACE-6 db " "
db "fs:   "
fsbuff: times BACKSPACE-6 db " "
db "flags:"
flbuff: times BACKSPACE-6 db " "
db "ip:   "
ipbuff: times BACKSPACE-6 db " "
db 0 						



END_PADDING
