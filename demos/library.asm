; this function takes the value stored in eax and formats it in an 8 byte ASCII representation
; esi and edi should be 0
; mov edi, <bufferaddress>

formatHex:
	pusha
	mov cx, 8
	; copy top most bit to dl
	get_top_nibble:
	rol eax, 4
	mov dl, al
	and dl, 0x0F	; clear higher nibble of dl
	; convert to hex representation in ASCII
	add dl, 0x30
	cmp dl, "9"	; if the number is greater than Ascii 9 (0x39), it would turn it to a character, "A"=0x41 
	jle noAdd
	add dl, 0x07 	; turns 9 to ascii "9" and 10 to ascii "A"
	noAdd:
	mov byte [edi], dl
	inc edi
	loop get_top_nibble
	popa
	ret

;__________________________________________________________________________________________________________________________________________________________________________

;prints the stringbuffer by moving it into videomemory
; mov esi, <stringbuffer>
printBuff:
	pusha
	mov edi, 0xb8000
	printloop:
	mov dl, byte [esi]
	mov byte [edi], dl
	add edi, 2
	inc esi
	cmp byte [esi], 0
	jne printloop
	popa
	ret

;__________________________________________________________________________________________________________________________________________________________________________

;this functions shuts the program down
shutdown:	
	mov ah, 0x53
	mov al, 0x07		; 'Set power state' control word
	mov bx, 1 		; ALL devices
	mov cx, 3 		; Power State: OFF
	int 0x15

;__________________________________________________________________________________________________________________________________________________________________________

;function that clears the screen with a loop that inserts spaces
clear_screen:
	mov edi, 0xb8000
	mov ecx, 0
	mov al, 0
	.clear_screen_loop:
	mov [edi], al
	inc ecx
	inc edi
	inc edi
	cmp ecx, 1920
	je .return
	jmp .clear_screen_loop
	.return:
	mov ecx, 0
	mov eax, 0
	ret

;__________________________________________________________________________________________________________________________________________________________________________

;this function moves the length of a buffer (until it finds a zero) into cx
;move buffer (containing the string) into esi
getStringLength:
	;push cx
	xor cx, cx

	.loop:
	cmp byte[esi], 0	
	je .done			;jumps to .done if every character in esi has been analyzed
	inc esi				;moves to next character of the string
	inc cx				;inc cx for every loop to count characters
	jmp .loop
	
	.done:

	;pop cx

	ret
;__________________________________________________________________________________________________________________________________________________________________________
;this is a macro that compares two strings

;StrCmp pointer1, pointer2
%macro StrCmp 2
mov esi, %1
mov edi, %2
call compareString
%endmacro



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

;__________________________________________________________________________________________________________________________________________________________________________

; mov esi, source
; mov edi, dest
; mov ecx, count
strncpy:
	mov al, byte [esi]
	cmp al, 0
	je .done
	dec ecx
	jz .done
	mov byte [edi], al
	inc esi
	inc edi
	jmp strncpy
	.done:
	ret


