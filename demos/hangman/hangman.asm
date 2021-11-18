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
%include "keyboard/keyboard.asm"
%define LINE_WIDTH 80				

wordlength: resb 1
health: resb 1

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
	mov bh, 5			
	mov [health], bh		;set health to 5
	mov bl, 0
	.loopKey:
	call getKey			;moves keyboard input into al
	call printUsedLetters		;prints al to show the already used characters
	mov esi, edx			;restore original string
	mov bh, 0

	.loopcmp:
		cmp byte[esi], 0	;jumps to .done when every character has been checked 
		je .done
		cmp byte[esi], al	;compares the character input to a character from the string
		je .success		
		inc esi			
		add edi, 2		;add offset of 1 character to video memory
		jmp .loopcmp

		.success:
			mov byte[edi], al	;print character to video memory
			inc bh			;bh>0 if character input was a success at least once
			inc bl			;counts how many times a word was a success 
			add edi, 2		;add offset of 1 character to video memory
			inc esi
			jmp .loopcmp
	
	.done:
	cmp bl, [wordlength]			;compares the amount of succesful character inputs to the length of the string
	je .victory				;if it is equal the player guessed the entire word rigth
	cmp bh, 0				;checks wether or not the character was successful
	je .onestrike
	jmp .loopKey

	.onestrike:
	mov edi, 0xb85a0			;set position in video memory to 1440 which is 2*9*80(2* for each character, 9*80 for 9 lines)
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
	mov edi, 0xb85bc			;set video memory location to the end of the "The word was: _" string
	mov esi, edx				
	call printString
	jmp $
	
	.firststrike:
	mov esi, strike1buff			
	call printString			;prints the buffer for the first strike 2 lines below the line where the string is displayed
	jmp .loopKey

	.secondstrike:
	add edi, 2*LINE_WIDTH
	mov esi, strike2
	call printString			;prints the buffer for the second strike 1 line below the begining of the first strike
	jmp .loopKey

	.thirdstrike:
	add edi, 2*3*LINE_WIDTH
	mov esi, strike3			;prints the buffer for the third strike 3 lines below the begining of the first strike
	call printString			
	jmp .loopKey

	.fourthstrike:
	add edi, 2*7*LINE_WIDTH
	mov esi, strike4
	call printString			;prints the buffer for the fourth strike 7 lines below the begining of the first strike
	jmp .loopKey

	.gameover:
	mov esi, buffdefeat
	call printBuff				;prints the "You lose!" screen
	mov edi, 0xb847c			;set video memory location to the end of the "The word was: _" string
	mov esi, edx
	call printString			
	jmp $

printString:					;main difference to printBuff: video memory location is not given here
	pusha
	.printloop:
	mov dl, byte[esi]			
	mov byte[edi], dl			;move character to video memory
	add edi, 2
	inc esi
	cmp byte[esi], 0
	jne .printloop
	popa
	ret

printUsedLetters:			
	mov edi, 0xb852c			;set location in video memory one line below the correctly guessed letters
	add edi, ecx				
	mov byte[edi], al
	add ecx, 4				;ecx holds offset so that another character can be printed after this one
	add edi, 2
	mov bh, ","
	mov byte[edi], bh			;set , after the character
	mov edi, 0xb846e			;reset video memory location to the _ of the "Guess: _" line
	ret

align 512
times 512 db 0
;END_PADDING
