;	 _    _          _   _  _____ __  __          _   _ 
;	| |  | |   /\   | \ | |/ ____|  \/  |   /\   | \ | |
;	| |__| |  /  \  |  \| | |  __| \  / |  /  \  |  \| |
;	|  __  | / /\ \ | . ` | | |_ | |\/| | / /\ \ | . ` |
;	| |  | |/ ____ \| |\  | |__| | |  | |/ ____ \| |\  |
;	|_|  |_/_/    \_\_| \_|\_____|_|  |_/_/    \_\_| \_|
;
jmp _setup

%include "hangman/stringptrarray.asm"
%include "hangman/random.asm"
%include "hangman/wordlist.asm"
%include "cpuid/printHex.asm"
%define LINE_WIDTH_LOOP 2*7*80

wordlength: resb 1
health: resb 1

_setup:
;call getRandomString		;loads random stringaddress from wordlist into esi 
mov esi, strtest
mov edx, esi
call getStringLength
call draw
mov esi, buff
call printBuff

call gameloop

halt:
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
	mov [wordlength], cl
	ret

getKey:
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

gameloop:
	mov edi, 0xb8000
	add edi, LINE_WIDTH_LOOP+14
	mov bl, 5
	mov [health], bl
	.loopKey:
	mov ecx, 0
	mov bh, 0
	call getKey
	mov esi, edx

	.loopcmp:
		cmp byte[esi], 0
		je .done
		cmp byte[esi], al
		je .success
		inc esi
		add ecx, 2
		jmp .loopcmp

		.success:
			add edi, ecx
			mov byte[edi], al
			sub edi, ecx
			inc bh
			add ecx, 2
			inc esi
			jmp .loopcmp
	
	.done:
	cmp bh, 0
	je .onestrike
	jmp .loopKey

	.onestrike:
	dec bl
	cmp bl, 0
	je .gameover
	jmp .loopKey

	.gameover:
	mov al, "e"
	mov ah, 0x0e
	int 0x10
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
db "Guess: "
buffRandomString: times 73 db " "
db 0

strtest db "elephant", 0


END_PADDING


