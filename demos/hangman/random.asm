;	 _    _          _   _  _____ __  __          _   _ 
;	| |  | |   /\   | \ | |/ ____|  \/  |   /\   | \ | |
;	| |__| |  /  \  |  \| | |  __| \  / |  /  \  |  \| |
;	|  __  | / /\ \ | . ` | | |_ | |\/| | / /\ \ | . ` |
;	| |  | |/ ____ \| |\  | |__| | |  | |/ ____ \| |\  |
;	|_|  |_/_/    \_\_| \_|\_____|_|  |_/_/    \_\_| \_|
;	                                                    
;	                                                    


;this is a random number generator to select the word used for hangman
;it gets a random number between 0 and 124 this works by divinding the
;clock ticks since midnight by 125 and using the remainder as the random number
;clock ticks are about 18.2 per second so we cannot predict the output number

getRandNr:
mov ax, 0 			;parameters for getting clock ticks
int 0x1a 			;clock ticks interrupt puts them in CX:DX
mov ax, dx 			;move into division format
mov dx, cx
mov ecx, 125
div ecx 			;divide by 125
mov ax, dx 			;move remainder into ax
ret




