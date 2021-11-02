;this is a disassembled version of the binary verion of flamingos paint
;this is salvageable
;this is not salvagable fuck
jmp next
%include 'flamingos_paint/flamingos_paint_makros.asm'
next:


;this is the initialization for the video mode
mov    ah,0x0
mov    al,0x12
int    0x10
mov    cx,0x0
mov    dx,0x0

;find out what this is because ax gets used by other functions, most likely a function in makros
call   add_cursor
;call 0x270    imporatnt function
push   ax
xor    ax,ax


;From here on it looks like it is the check for keystrokes loop
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
je     0x393
cmp    ax,0x3042 		;B
je     0x39b
cmp    ax,0x2267 		;g
je     0x3a3
cmp    ax,0x2247 		;G
je     0x3ab
cmp    ax,0x1372 		;r
je     0x3b3
cmp    ax,0x1352 		;R
je     0x3bb
cmp    ax,0x1970 		;p
je     0x3c3
cmp    ax,0x1950 		;P
je     0x3cb
cmp    ax,0x2e63 		;c
je     0x3d3
cmp    ax,0x2e43 		;C
je     0x3db
cmp    ax,0x1177		;w
je     0x3e3
cmp    ax,0x1157 		;W
je     0x3eb
cmp    ax,0x2c7a 		;y
je     0x3f3
cmp    ax,0x1071 		;q
je     0x3fb
cmp    ax,0x1474 		;t
je     0x403
cmp    ax,0x11b 		;esc
je     0x353
jmp    0x2bb
;this is the end of keystroke check, 0x2bb is most likely start of loop

;from here on these are the actual functions for the keys, find each of them
;these all seem to be the moving fuctions
key_up:
call   remove_cursor 			;this might be remove cursor
call   key_up_draw
call   add_cursor 			;this might be add cursor
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


;ax gets pushed at the start find out what it does
;ax might be cursor position dunno

key_enter:
pop    ax
push   ax
call   key_enter_draw
jmp    keystroke_loop

pop    ax
call   0x27e
push   ax
jmp    0x2bb
pop    ax
call   0x281
push   ax
jmp    0x2bb
pop    ax
call   0x284
push   ax
jmp    0x2bb
pop    ax
call   0x287
push   ax
jmp    0x2bb
pop    ax
call   0x28a
push   ax
jmp    0x2bb
pop    ax
call   0x28d
push   ax
jmp    0x2bb
pop    ax
call   0x290
push   ax
jmp    0x2bb
pop    ax
call   0x293
push   ax
jmp    0x2bb
pop    ax
call   0x296
push   ax
jmp    0x2bb
pop    ax
call   0x299
push   ax
jmp    0x2bb
pop    ax
call   0x29c
push   ax
jmp    0x2bb
pop    ax
call   0x29f
push   ax
jmp    0x2bb
pop    ax
call   0x2a2
push   ax
jmp    0x2bb
pop    ax
call   0x2a5
push   ax
jmp    0x2bb
pop    ax
call   0x2a8
push   ax
jmp    0x2bb
;what in gods name is this
;these are colors delte this and redo


end:
END_PADDING
