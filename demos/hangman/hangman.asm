;	 _    _          _   _  _____ __  __          _   _ 
;	| |  | |   /\   | \ | |/ ____|  \/  |   /\   | \ | |
;	| |__| |  /  \  |  \| | |  __| \  / |  /  \  |  \| |
;	|  __  | / /\ \ | . ` | | |_ | |\/| | / /\ \ | . ` |
;	| |  | |/ ____ \| |\  | |__| | |  | |/ ____ \| |\  |
;	|_|  |_/_/    \_\_| \_|\_____|_|  |_/_/    \_\_| \_|
;
jmp _setup

%include "hangman/asciiart.asm"			;include the file containing the buffers
%include "hangman/stringptrarray.asm"		;include getRandomString
%include "hangman/random.asm"
%include "hangman/wordlist.asm"			
%include "cpuid/printHex.asm"			;include printBuff
%define LINE_WIDTH 80				
%define LINE_WIDTH_LOOP 2*7*80			;2* to skip background color
%define LINE_WIDTH_HANGED_MAN 2*2*80-2*7

wordlength: resb 1
health: resb 1
letterspace: resb 1

_setup:
call getRandomString		;loads random stringaddress from wordlist into esi 
mov edx, esi			;save string in edx
call getStringLength		;counts characters in the string and loads length into cx
call draw			;uses cx to draw _ for every character in the string
mov esi, buff			;load the beginning screen into esi
call printBuff			;prints esi

call gameloop

halt:
jmp $



getStringLength:
	mov cx, 0
	.loop:
	cmp byte[esi], 0	
	je .done			;jumps to .done if every character in esi has been analyzed
	inc esi				;moves to next character of the string
	inc cx				;inc cx for every loop to count characters
	jmp .loop
	.done:
	mov [wordlength], cl		;loads cl into the variable wordlength to save registers
	ret

getKey:
	xor eax, eax			;ah=0 
	int 0x16			;ah=0 and int 0x16 waits for a keyboard input and loads it into al
	ret

draw:
	mov edi, buffRandomString	;moves the "Guess: " buffer into edi 
	.loop_:
	cmp cx, 0			
	je .done			;finishes when _ has been printed for every character in the string
	mov al, "_"			
	mov byte[edi], al		;print _ to video memory
	inc edi				
	dec cx 				;repeats the loop for every character in the string
	jmp .loop_
	.done:
	ret

gameloop:
	mov edi, 0xb8000		;move video memory to edi
	add edi, LINE_WIDTH_LOOP+14	;move location of character to be printed 7 lines down and 7 characters to the right
	mov bh, 5			
	mov [health], bh		;set health to 5
	mov bh, 0
	mov [letterspace], bh		;set letterspace to 0
	mov bl, 0
	.loopKey:
	mov ecx, 0			
	mov bh, 0
	call getKey			;moves keyboard input into al
	mov esi, edx			;restore original string

	.loopcmp:
		cmp byte[esi], 0	;jumps to .done when every character has been checked 
		je .done
		cmp byte[esi], al	;compares the character input to a character from the string
		je .success		
		inc esi			
		add ecx, 2		;add offset of 1 character to ecx
		jmp .loopcmp

		.success:
			add edi, ecx		;move offset to video memory in case the character input is not the first character
			mov byte[edi], al	;print character to video memory
			sub edi, ecx		;restores position in video memory
			inc bh			;bh>0 if character input was a success at least once
			inc bl			;counts how many times a word was a success 
			add ecx, 2		;add offset of 1 character to ecx
			inc esi
			jmp .loopcmp
	
	.done:
	cmp bl, [wordlength]			;compares the amount of succesful character inputs to the length of the string
	je .victory				;if it is equal the player guessed the entire word rigth
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
	cmp bh, 0				;checks wether or not the character was successful
	je .onestrike
	jmp .loopKey

	.onestrike:
	mov bh, [health]
	dec bh					;health is decremented every time the input is a wrong character
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
	sub [num], bl				;shows how often the player guessed wrong
	mov esi, buffvictory			
	call printBuff				;prints the victory screen
	jmp $
	
	.firststrike:
	mov esi, strike1buff			
	add edi, LINE_WIDTH_HANGED_MAN
	call printStrike			;prints the buffer for the first strike 2 lines below the line where the string is displayed
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
                                                   
                                                    
                                                                               
