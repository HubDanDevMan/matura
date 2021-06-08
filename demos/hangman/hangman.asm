;	 _    _          _   _  _____ __  __          _   _ 
;	| |  | |   /\   | \ | |/ ____|  \/  |   /\   | \ | |
;	| |__| |  /  \  |  \| | |  __| \  / |  /  \  |  \| |
;	|  __  | / /\ \ | . ` | | |_ | |\/| | / /\ \ | . ` |
;	| |  | |/ ____ \| |\  | |__| | |  | |/ ____ \| |\  |
;	|_|  |_/_/    \_\_| \_|\_____|_|  |_/_/    \_\_| \_|
;
jmp _setup

%include "hangman/asciiart.asm"
%include "hangman/stringptrarray.asm"
%include "hangman/random.asm"
%include "hangman/wordlist.asm"
%include "cpuid/printHex.asm"
%define LINE_WIDTH 80
%define LINE_WIDTH_LOOP 2*7*80
%define LINE_WIDTH_HANGED_MAN 2*3*80

wordlength: resb 1
health: resb 1
letterspace: resb 1

_setup:
call getRandomString		;loads random stringaddress from wordlist into esi 
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
	mov bh, 5
	mov [health], bh
	mov bh, 0
	mov [letterspace], bh
	mov bl, 0
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
			inc bl
			add ecx, 2
			inc esi
			jmp .loopcmp
	
	.done:
	cmp bl, [wordlength]
	je .victory
	push ebx
	add edi, 2*LINE_WIDTH
	add edi, 60
	add edi, [letterspace]
	mov byte[edi], al
	sub edi, 2*LINE_WIDTH
	sub edi, 60
	sub edi, [letterspace]
	mov bh, 4
	add [letterspace], bh
	pop ebx
	cmp bh, 0
	je .onestrike
	jmp .loopKey

	.onestrike:
	mov bh, [health]
	dec bh
	mov [health], bh
	cmp bh, 4
	je .firststrike
	cmp bh, 3
	je .secondstrike
	cmp bh, 2
	je .thirdstrike
	cmp bh, 1
	je .fourthstrike
	cmp bh, 0
	je .gameover
	jmp .loopKey

	.victory:
	mov bl, [health] 
	sub [num], bl
	mov esi, buffvictory
	call printBuff
	jmp $
	
	.firststrike:
	mov esi, strike1buff
	add edi, LINE_WIDTH_HANGED_MAN
	call printStrike
	sub edi, LINE_WIDTH_HANGED_MAN
	jmp .loopKey

	.secondstrike:
	add edi, LINE_WIDTH_HANGED_MAN
	add edi, 2*LINE_WIDTH
	mov esi, strike2
	call printStrike
	sub edi, LINE_WIDTH_HANGED_MAN
	sub edi, 2*LINE_WIDTH
	jmp .loopKey

	.thirdstrike:
	add edi, LINE_WIDTH_HANGED_MAN
	add edi, 2*3*LINE_WIDTH
	mov esi, strike3
	call printStrike
	sub edi, LINE_WIDTH_HANGED_MAN
	sub edi, 2*3*LINE_WIDTH
	jmp .loopKey

	.fourthstrike:
	add edi, LINE_WIDTH_HANGED_MAN
	add edi, 2*8*LINE_WIDTH
	mov esi, strike4
	call printStrike
	sub edi, LINE_WIDTH_HANGED_MAN
	sub edi, 2*8*LINE_WIDTH
	jmp .loopKey

	.gameover:
	mov esi, buffdefeat
	call printBuff
	jmp $

printStrike:
	pusha
	mov ecx, 0
	.printloop:
	mov dl, byte[esi]
	mov byte[edi], dl
	add edi, 2
	inc esi
	inc ecx
	cmp byte[esi], 0
	jne .printloop
	add ecx, ecx
	sub edi, ecx
	popa
	ret

END_PADDING
                                                   
                                                    
                                                                               
