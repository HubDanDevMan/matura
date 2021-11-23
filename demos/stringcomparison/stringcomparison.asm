;this is a makro that compares two strings

;StrCmp pointer1, pointer2
%macro StrCmp 2
mov esi, %1
mov edi, %2
call compareString
%endmacro



mov edi, 0xb8000
mov esi, cmpmsg1
call displayMSG

mov esi, Hello1
call displayMSG

mov esi, Hello2
add edi, 0x84
call displayMSG


mov edx, 0x1e0						; reset videomemory pointer
StrCmp Hello1,Hello2

mov esi, cmpmsg1
mov edi, 0xb8000 + 80*8					; reset videomemory pointer
call displayMSG


mov esi, Facts1 
mov edi, 0xb8000 + 80*10
call displayMSG

mov esi, Facts2
mov edi, 0xb8000 + 80*12 
call displayMSG


mov edx, 80*14
StrCmp Facts1,Facts2

jmp $





compareString:
	dec edi						;decrements di because it gets incremented in loop
	.loop:
	inc edi						;moves to adress of next letter
	
	lodsb 						;loads string byte at location si into al and increments si
	cmp [edi],al 					;compares letter of di with loaded letter of si
	jne string_not_same 				;if not the same jumps to a message
	cmp al, 0 					;checks for the end of the string
	jne .loop 					;if not end of string continues loop
	mov eax, 0
	ret

string_not_same: 			;prints if not same a n
	mov eax, -1
	ret

displayMSG:
	; set edi (dest in videome) and esi (strsrc)
	.loop:
	mov dl, byte [esi]
	mov byte [edi], dl
	add edi, 2
	inc esi
	cmp byte [esi], 0
	jne .loop
	ret

strequal: db "The strings are equal                                                     ",0
strnotequal: db "The strings are different                                                  ",0 

cmpmsg1: db "Comparing the following strings: "
times 80 - ($-cmpmsg1) db " "				; padds out until EOL
db 0
Hello1: db "I am a string ", 0 
Hello2: db "I am a string ", 0

Facts1: db "Linux is better than Windows ", 0
Facts2: db "Linux is better than MacOS ", 0


END_PADDING

