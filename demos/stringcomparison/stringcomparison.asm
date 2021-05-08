;this is a makro that compares two strings

;StrCmp pointer1, pointer2
%makro StrCmp 2
mov si, %1
mov di, %2
call compareString
%endmakro

compareString:
	dec di						;decrements di because it gets incremented in loop

	.loop:
	inc di 						;moves to adress of next letter
	lodsb 						;loads string byte at location si into al and increments si
	cmp [di],al 				;compares letter of di with loaded letter of si
	jne string_not_same 		;if not the same jumps to a message
	cmp al, 0 					;checks for the end of the string
	jne .loop 					;if not end of string continues loop

	;this will later be changed for the respective funktion that the string comparison shall execute
	mov ah, 0x0e 				;prints if same a y
	mov al, "y"
	int 0x10
	ret

string_not_same: 			;prints if not same a n
	mov ah, 0x0e
	mov al, "n"
	int 0x10
	ret


END_PADDING

