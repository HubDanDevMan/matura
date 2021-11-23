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
END_PADDING
