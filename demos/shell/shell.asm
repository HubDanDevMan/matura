; ____  _          _ _ 
;/ ___|| |__   ___| | |
;\___ \| '_ \ / _ \ | |
; ___) | | | |  __/ | |
;|____/|_| |_|\___|_|_|
jmp main
%include "keyboard/keyboard.asm"
%include "library.asm"
%include "shell/commands.asm"


%macro  ShellCmp 3
mov esi, %1
mov edi, %2
call compareString
cmp eax, 0
je %3
%endmacro

enter:
;main loop

main:
call clear_screen
call print_buffer
xor al, al
.shell_loop:
	call getKey
	cmp al, 0x02
	je .key_delete
	cmp al, 0x04
	je .key_enter
	call buffer_insert
	call print_buffer
	jmp .shell_loop
	.key_delete:
	call buffer_delete
	call print_buffer
	jmp .shell_loop
	.key_enter:
	call buffer_compare
	call buffer_wipe
	call print_buffer
	cmp dh, 21
	jne .skip
	call scroll_screen
	dec dh
	.skip:
	jmp .shell_loop


;buffer for string comparison
prebuffer:
db "[Flamingos$]:"
buffer:
times 255 db " "
db 0

;interrupt that gets ascii key from pressed button in al



;put al in buffer
buffer_insert:
	cmp ecx, 255
	je .return 			;exception for char limit
	mov edi, buffer
	add edi, ecx
	mov [edi], al
	inc ecx
	xor al, al
	.return:
	ret


;delete a character out of buffer
buffer_delete:
	cmp ecx, 0
	je getKey 			;exception for char limit
	mov edi, buffer
	add edi, ecx
	dec edi
	mov al, " "
	mov [edi], al
	dec ecx
	ret

;add another check if its outside vm
buffer_wipe:
	push edi
	mov edi, buffer
	.wipe_loop:
	mov al, " "
	mov byte[edi], al
	inc edi
	cmp byte[edi], 0
	jne .wipe_loop
	pop edi
	sub edi, 0xb8000
	mov eax, edi
	mov cl, 160
	div cl
	mov dl, al
	inc dh
	xor cl, cl
	ret

scroll_screen:
	mov esi, 0xb8000
	add esi, 160
	mov edi, 0xb8000
	.screen_loop
	mov dl, byte[esi]
	mov byte[edi],dl
	inc edi
	inc esi
	cmp esi, 0xb8FA0 + 160
	jne .screen_loop
	ret

;function for printing wbuffer into video memory
;add a buffer wiper for some reaseon enter does not work yet(keeps memory location)
print_buffer:
	push dx
	inc dh
	mov esi, prebuffer
	mov edi, 0xb8000
	sub edi, 160
	.check_line:
	dec dh
	add edi, 160
	cmp dh, 0
	jne .check_line
	pop dx
	.print_buffer_loop:
	mov dl, [esi]
	mov [edi], dl
	inc esi
	inc edi
	inc edi
	cmp byte[esi], 0
	je .return
	jmp .print_buffer_loop
	.return:
	ret





;function that clears the screen with a loop that inserts spaces
;clear_screen:
;	mov edi, 0xb8000
;	mov ecx, 0
;	mov al, " "
;	.clear_screen_loop:
;	mov [edi], al
;	inc ecx
;	inc edi
;	inc edi
;	cmp ecx, 1920
;	je .return
;	jmp .clear_screen_loop
;	.return:
;	mov ecx, 0
;	mov eax, 0
;	ret

buffer_compare:
	ShellCmp buffer,buffer_shutdown, shutdown
	ShellCmp buffer,buffer_hangman, _setup
	ShellCmp buffer,buffer_paint, next
	ret

;	 _    _          _   _  _____ __  __          _   _ 
;	| |  | |   /\   | \ | |/ ____|  \/  |   /\   | \ | |
;	| |__| |  /  \  |  \| | |  __| \  / |  /  \  |  \| |
;	|  __  | / /\ \ | . ` | | |_ | |\/| | / /\ \ | . ` |
;	| |  | |/ ____ \| |\  | |__| | |  | |/ ____ \| |\  |
;	|_|  |_/_/    \_\_| \_|\_____|_|  |_/_/    \_\_| \_|
;

%include "hangman/asciiart.asm"			;include the file containing the buffers
%include "hangman/stringptrarray.asm"		;include getRandomString
%include "hangman/random.asm"
%include "hangman/wordlist.asm"			
;%include "cpuid/printHex.asm"			;include printBuff
;%include "keyboard/keyboard.asm"
%define LINE_WIDTH 80				

wordlength: resb 1
health: resb 1

_setup:
mov esi, clearscreen
call printBuff

mov esi, 0
xor cx, cx
call getRandomString		;loads random stringaddress from wordlist into esi 
mov edx, esi			;save string in edx
call getStringLength		;counts characters in the string and loads length into cx
mov [wordlength], cx
call draw			;uses cx to draw _ for every character in the string
mov esi, buff			;load the beginning screen into esi
call printBuff			;prints esi

call gameloop

halt:
jmp $



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
	cmp al, 0x01
	je shutdown				;if the user presses the esc key the program shuts down
	cmp al, 0x04
	je _setup			;if the user presses the enter key the program restarts
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
	.waitforkeyW:
	call getKey
	cmp al, 0x01
	je shutdown				;if the user presses the esc key the program shuts down
	cmp al, 0x04
	je _setup				;if the user presses the enter key the program restarts
	jmp .waitforkeyW
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
	.waitforkeyL:
	call getKey
	cmp al, 0x01
	je shutdown
	cmp al, 0x04				
	je _setup				;if the user presses the enter key the game restarts
	jmp .waitforkeyL
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
	

;END_PADDING

jmp next
%include 'flamingos_paint/flamingos_paint_makros.asm'
next:

;this is the initialization for the video mode
mov    ah,0x0
mov    al,0x12
int    0x10
mov    cx,0x0
mov    dx,0x0
call   add_cursor
push   ax
xor    ax,ax

;This is the loop for checking which button was pressed and calles the respective fuctions
keystroke_loop:
xor    ax,ax
int    0x16
cmp    ah,0x0
je     keystroke_loop
cmp    ax,0x4800 		;up
je     key_up
cmp    ax,0x5000 		;down
je     key_down
cmp    ax,0x4b00 		;left
je     key_left
cmp    ax,0x4d00 		;right
je     key_right
cmp    ax,0x1c0d  		;Enter
je     key_enter
cmp    ax,0x3062 		;b
je     key_blue
cmp    ax,0x3042 		;B
je     key_light_blue
cmp    ax,0x2267 		;g
je     key_green
cmp    ax,0x2247 		;G
je     key_light_green
cmp    ax,0x1372 		;r
je     key_red
cmp    ax,0x1352 		;R
je     key_light_red
cmp    ax,0x1970 		;p
je     key_black
cmp    ax,0x1950 		;P
je     key_brown
cmp    ax,0x2e63 		;c
je     key_cycle
cmp    ax,0x2e43 		;C
je     key_light_cyan
cmp    ax,0x1177		;w
je     key_white
cmp    ax,0x1157 		;W
je     key_light_grey
cmp    ax,0x2c7a 		;y
je     key_yellow
cmp    ax,0x1071 		;q
je     key_dark_grey
cmp    ax,0x1474 		;t
je     0x403
cmp    ax,0x11b 		;esc
je     key_dark_grey
jmp    keystroke_loop


;these are the functions for moving around
key_up:
call   remove_cursor 			;remove cursor fuction in makros
call   key_up_draw
call   add_cursor 			;add cursor function in makros
jmp    keystroke_loop

key_down:
call shutdown
call   remove_cursor
call   key_down_draw
call   add_cursor
jmp    keystroke_loop

key_left:
call   remove_cursor
call   key_left_draw
call   add_cursor
jmp    keystroke_loop

key_right:
call   remove_cursor
call   key_right_draw
call   add_cursor
jmp    keystroke_loop



;fuction for printing numbers
key_enter:
pop    ax
push   ax
call   key_enter_draw
jmp    keystroke_loop

;functions for changing colours
key_cycle:
pop ax
call color_change_cycle
call add_indicator
push ax
jmp keystroke_loop

key_blue:
pop    ax
call   key_change_blue
call add_indicator
push   ax
jmp    keystroke_loop

key_black:
pop    ax
call   key_change_black
call add_indicator
push   ax
jmp    keystroke_loop

key_green:
pop    ax
call   key_change_green
call add_indicator
push   ax
jmp    keystroke_loop

key_cyan:
pop    ax
call   key_change_cyan
call add_indicator
push   ax
jmp    keystroke_loop

key_red:
pop    ax
call   key_change_red
call add_indicator
push   ax
jmp    keystroke_loop

key_magenta:
pop    ax
call   key_change_magenta
call add_indicator
push   ax
jmp    keystroke_loop

key_brown:
pop    ax
call   key_change_brown
call add_indicator
push   ax
jmp    keystroke_loop

key_light_grey:
pop    ax
call   key_change_light_grey
call add_indicator
push   ax
jmp    keystroke_loop

key_dark_grey:
pop    ax
call   key_change_dark_grey
call add_indicator
push   ax
jmp    keystroke_loop

key_light_blue:
pop    ax
call   key_change_light_blue
call add_indicator
push   ax
jmp    keystroke_loop

key_light_green:
pop    ax
call   key_change_green
call add_indicator
push   ax
jmp    keystroke_loop

key_light_cyan:
pop    ax
call   key_change_light_cyan
call add_indicator
push   ax
jmp    keystroke_loop

key_light_red:
pop    ax
call   key_change_light_red
call add_indicator
push   ax
jmp    keystroke_loop

key_light_magenta:
pop    ax
call   key_change_light_magenta
call add_indicator
push   ax
jmp    keystroke_loop

key_yellow:
pop    ax
call   key_change_yellow
call add_indicator
push   ax
jmp    keystroke_loop

key_white:
pop    ax
call   key_change_white
call add_indicator
push ax
jmp keystroke_loop




end:
;END_PADDING
END_PADDING
