;	 _    _          _   _  _____ __  __          _   _ 
;	| |  | |   /\   | \ | |/ ____|  \/  |   /\   | \ | |
;	| |__| |  /  \  |  \| | |  __| \  / |  /  \  |  \| |
;	|  __  | / /\ \ | . ` | | |_ | |\/| | / /\ \ | . ` |
;	| |  | |/ ____ \| |\  | |__| | |  | |/ ____ \| |\  |
;	|_|  |_/_/    \_\_| \_|\_____|_|  |_/_/    \_\_| \_|
;
jmp _main

%include "hangman/stringptrarray.asm"
%include "hangman/random.asm"
%include "hangman/wordlist.asm"
%include "cpuid/printHex.asm"

;resb wordlength

_main:
;call getRandomString		;loads random stringaddress from wordlist into esi 
mov esi, strtest
call getStringLength

call draw
mov esi, buff
call printBuff

mov cx, 5



jmp $



getStringLength:
	mov cx, 0
	.loop:
	cmp byte[esi], 0
	je .done
	inc esi
	inc cx
	jmp .loop
	.done:
;	mov wordlength, cx
	ret

getkey:
	xor eax, eax
	int 0x16
	ret

draw:
	mov edi, buffRandomString
	.loop_:
	cmp cx, 0
	je .done
	mov al, "_"
	mov byte[edi], al
	inc edi
	dec cx 
	jmp .loop_
	.done:
	ret

buff:
db " _    _          _   _  _____ __  __          _   _ " 
times 80-52 db " "
db "| |  | |   /\   | \ | |/ ____|  \/  |   /\   | \ | |" 
times 80-52 db " "
db "| |__| |  /  \  |  \| | |  __| \  / |  /  \  |  \| |" 
times 80-52 db " "
db "|  __  | / /\ \ | . ` | | |_ | |\/| | / /\ \ | . ` |" 
times 80-52 db " "
db "| |  | |/ ____ \| |\  | |__| | |  | |/ ____ \| |\  |" 
times 80-52 db " "
db "|_|  |_/_/    \_\_| \_|\_____|_|  |_/_/    \_\_| \_|" 
times 80-52 db " "
db " "
times 79 db " "
db "Your word: "
buffRandomString: times 69 db " "

db 0

strtest db "monkey", 0


END_PADDING


