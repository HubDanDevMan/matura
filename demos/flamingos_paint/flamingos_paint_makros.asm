%define BLACK				0b0000
%define BLUE				0b0001
%define GREEN				0b0010
%define CYAN				0b0011
%define RED 				0b0100
%define MAGENTA				0b0101
%define BROWN				0b0110
%define LIGHT_GREY			0b0111
%define DARK_GREY			0b1000
%define LIGHT_BLUE			0b1001
%define LIGHT_GREEN			0b1010
%define LIGHT_CYAN			0b1011
%define LIGHT_RED			0b1100
%define LIGHT_MAGENTA		0b1101
%define YELLOW				0b1110
%define WHITE				0b1111
%define PIXEL_MOVE			7
%define PIXEL				6
%define CURSOR				2


;drawPixel(Row,Column,Color)
;drawSquare Colour,Row,Column,TargetRow,Targetcolumn
%macro DrawSquare 2
	mov ah, 0x0c
	mov al, %1
	mov bx, %2
	mov di, %2
	call squareDrawLoopStart
%endmacro
squareDrawLoopStart:
	push bp
	mov bp, sp
	sub sp, 4
	mov [bp-2], cx				
	mov [bp-4], dx
	add bx, dx
	add di, cx
squaredrawloop:
	cmp cx, di				;checks whether it has reched end of the row
	je	squaredraw2			;jumps to the column incrementer
	int 0x10				;prints pixel at current location
	inc cx					;increments cx by 1
	jmp squaredrawloop 		;restarts the loop
squaredraw2:
	mov cx, [bp-2]
	cmp dx, bx				;checks wheather it has reached end of column
	je squareend			;exit for loop at end of square
	inc dx					;increments row by 1
	jmp squaredrawloop      ;returns back to the original loop
squareend:
	mov cx,[bp-2]			;returns original values of the cursor and
	mov dx,[bp-4]   		;moves them out of stack 
	add sp,4
	pop bp
	ret
	

;aight lets start drawing with a cursor start without the cursor
;the int 16 AH=0x00 gives you the values for the bios scan data in ah again
;i can use that to determine what key was pressed and make funktions that
;store a certain pixel coordiante and draw a square in that coordinate
key_up_draw:					;moves cursor in certain directions based on
sub dx, PIXEL_MOVE				;key pressed
ret
key_down_draw:
add dx, PIXEL_MOVE
ret
key_left_draw:
sub cx, PIXEL
ret
key_right_draw:
add cx, PIXEL
ret
key_enter_draw:					;puts selected color onto the screen as
	drawSquare al,PIXEL 		;pixel size
	call add_cursor
	ret

remove_cursor:                  ;checks colour of the pixel next to the
	add cx, 2 					;cursor and replaces the cursor with the colour
	add dx, 2
	mov ah, 0x0d
	int 0x10
	sub cx, 2
	sub dx, 2
	drawSquare al,CURSOR
	ret

add_cursor: 					;simply adds a white cursor on cursor location
	drawSquare WHITE,CURSOR
	ret



key_change_blue: 				;changes colour based on key pressed
	mov al, BLUE
	ret
key_change_light_blue:
	mov al, LIGHT_BLUE
	ret
key_change_green:
	mov al, GREEN
	ret
key_change_light_green:
	mov al, LIGHT_GREEN
	ret
key_change_red:
	mov al, RED
	ret
key_change_light_red:
	mov al, LIGHT_RED
	ret
key_change_magenta:
	mov al, MAGENTA
	ret
key_change_light_magenta:
	mov al, LIGHT_MAGENTA
	ret
key_change_cyan:
	mov al, CYAN
	ret
key_change_light_cyan:
	mov al, LIGHT_CYAN
	ret
key_change_white:
	mov al, WHITE
	ret
key_change_black:
	mov al, BLACK
	ret
key_change_yellow:
	mov al, YELLOW
	ret
key_change_dark_grey:
	mov al, DARK_GREY
	ret
key_change_brown:
	mov al, BROWN
	ret


;key_change_light_grey:				i have no fucking clue as to why grey
;	mov al, LIGHT_GREY 				does not work so its a feature now
;	ret 							grey just crashed the terminal
