%define BACKSPACE 	times 154 db " "
;why is this the offset for backspace? 
;only thing i can think of is the labels for registers only count for some
;reason this somehow equals 70 spaces

; for some reason the first stage shows up


;debug function prints out all registers

main:
	call get_ip 					;call function without return pushes ip
	get_ip:
	pushf 							;flags into stack


	mov eax, 0xB00B 				;test register
	mov ebx, 0xBCDEF123
	mov ecx, 0xCDEF1234
	mov edx, 0xDEF12345

	push ds 						;push changing registers
	push edx
	push ecx
	push ebx
	push eax

	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0
	mov ax, 0x0b800					;video memory parameters
	mov ds, ax
	mov bx, 800




;move register to prnt into eax and then move into buffer at edi

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
	jmp end
	


;isolates 4 bits from highest to lowest and transform into ascii

hex_isolate:
	mov edx, eax
	shr edx, 24
	ror dx, 4
	call hex_buff
	shr dx, 12
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
	mov ch, 0000_1111b
	mov cl, dl
	cmp cl, 10
	jl smaller
	add cl, 7
	smaller:
	add cl, 0x30
	mov [edi],cl
	add edi, 2
	ret


print_buff:
	mov si, prebuff
	mov bx, 800
	add si, 2 							;for some reason this fixes the spacing
	buff_loop: 							;problem
	mov cx, [si]
	;mov ch, 0000_1111b 				;makes sure only white gets printed
	mov [bx], cx
	add si, 2
	add bx, 2
	cmp cx, 0 
	jne buff_loop
	ret



prebuff:
db "eax:  "  							;for some reason these do not work
eaxbuff: 								;look into it
BACKSPACE
db "ebx:  "
ebxbuff:
BACKSPACE
db "ecx:  "
ecxbuff:
BACKSPACE
db "edx:  "
edxbuff:
BACKSPACE
db "cs:   "
csbuff:
BACKSPACE
db "ss:   "
ssbuff:
BACKSPACE
db "ds:   "
dsbuff:
BACKSPACE
db "gs:   "
gsbuff:
BACKSPACE
db "es:   "
esbuff:
BACKSPACE
db "fs:   "
fsbuff:
BACKSPACE
db "fl:   "
flbuff:
BACKSPACE
db "ip:   "
ipbuff:
db "s"
times 40 db 0 							;does not stop why?



end:
END_PADDING
