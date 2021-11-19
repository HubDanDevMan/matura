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
%define LIGHT_MAGENTA			0b1101
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
	DrawSquare al,PIXEL 		;pixel size
	call add_cursor
	ret

remove_cursor:                  ;checks colour of the pixel next to the
	add cx, 2 					;cursor and replaces the cursor with the colour
	add dx, 2
	mov ah, 0x0d
	int 0x10
	sub cx, 2
	sub dx, 2
	DrawSquare al,CURSOR
	ret


add_indicator:
	push cx
	push dx
	mov dx, 4
	mov cx, 632
	DrawSquare al, PIXEL
	pop dx
	pop cx
	ret

add_cursor: 					;simply adds a white cursor on cursor location
	DrawSquare WHITE,CURSOR
	ret

color_change_cycle:
	cmp al, 16
	je color_change_cycle_end
	inc al
	ret

color_change_cycle_end:
	mov al, 1
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
key_change_light_grey:
	mov al, LIGHT_GREY
	ret


;This is the loop for checking which button was pressed and calles the respective fuctions
;keystroke_loop:
;xor    ax,ax
;int    0x16
;cmp    ah,0x0
;je     keystroke_loop
;cmp    ax,0x4800 		;up
;je     key_up
;cmp    ax,0x5000 		;down
;je     key_down
;cmp    ax,0x4b00 		;left
;je     key_left
;cmp    ax,0x4d00 		;right
;je     key_right
;cmp    ax,0x1c0d  		;Enter
;je     key_enter
;cmp    ax,0x3062 		;b
;je     key_blue
;cmp    ax,0x3042 		;B
;je     key_light_blue
;cmp    ax,0x2267 		;g
;je     key_green
;cmp    ax,0x2247 		;G
;je     key_light_green
;cmp    ax,0x1372 		;r
;je     key_red
;cmp    ax,0x1352 		;R
;je     key_light_red
;cmp    ax,0x1970 		;p
;je     key_black
;cmp    ax,0x1950 		;P
;je     key_brown
;cmp    ax,0x2e63 		;c
;je     key_cyan
;cmp    ax,0x2e43 		;C
;je     key_light_cyan
;cmp    ax,0x1177		;w
;je     key_white
;cmp    ax,0x1157 		;W
;je     key_light_grey
;cmp    ax,0x2c7a 		;y
;je     key_yellow
;cmp    ax,0x1071 		;q
;je     key_dark_grey
;cmp    ax,0x1474 		;t
;je     0x403
;cmp    ax,0x11b 		;esc
;je     key_dark_grey
;jmp    keystroke_loop
;this is the end of keystroke check, 0x2bb is most likely start of loop

;from here on these are the actual functions for the keys, find each of them
;these all seem to be the moving fuctions
;key_up:
;call   remove_cursor 			;this might be remove cursor
;call   key_up_draw
;call   add_cursor 			;this might be add cursor
;jmp    keystroke_loop
;
;key_down:
;call   remove_cursor
;call   key_down_draw
;call   add_cursor
;jmp    keystroke_loop
;
;key_left:
;call   remove_cursor
;call   key_left_draw
;call   add_cursor
;jmp    keystroke_loop

;key_right:
;call   remove_cursor
;call   key_right_draw
;call   add_cursor
;jmp    keystroke_loop
;
;
;ax gets pushed at the start find out what it does
;ax might be cursor position dunno
;
;key_enter:
;pop    ax
;push   ax
;call   key_enter_draw
;jmp    keystroke_loop




;key_blue:
;pop    ax
;call   key_change_blue
;push   ax
;jmp    keystroke_loop

;key_black:
;pop    ax
;call   key_change_black
;push   ax
;jmp    keystroke_loop

;key_green:
;pop    ax
;call   key_change_green
;push   ax
;jmp    keystroke_loop

;key_cyan:
;pop    ax
;call   key_change_cyan
;push   ax
;jmp    keystroke_loop

;key_red:
;pop    ax
;call   key_change_red
;push   ax
;jmp    keystroke_loop
;
;key_magenta:
;pop    ax
;call   key_change_magenta
;push   ax
;jmp    keystroke_loop
;
;key_brown:
;pop    ax
;call   key_change_brown
;push   ax
;jmp    keystroke_loop
;
;key_light_grey:
;pop    ax
;call   key_change_light_grey
;push   ax
;jmp    keystroke_loop
;
;key_dark_grey:
;pop    ax
;call   key_change_dark_grey
;push   ax
;jmp    keystroke_loop
;
;key_light_blue:
;pop    ax
;call   key_change_light_blue
;push   ax
;jmp    keystroke_loop
;
;key_light_green:
;pop    ax
;call   key_change_green
;push   ax
;jmp    keystroke_loop
;
;key_light_cyan:
;pop    ax
;call   key_change_light_cyan
;push   ax
;jmp    keystroke_loop
;
;key_light_red:
;pop    ax
;call   key_change_light_red
;push   ax
;jmp    keystroke_loop
;
;key_light_magenta:
;pop    ax
;call   key_change_light_magenta
;push   ax
;jmp    keystroke_loop
;
;key_yellow:
;pop    ax
;call   key_change_yellow
;push   ax
;jmp    keystroke_loop
;
;key_white:
;pop    ax
;call   key_change_white
;push ax
;jmp keystroke_loop



