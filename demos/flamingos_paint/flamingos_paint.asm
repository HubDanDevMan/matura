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




end:
END_PADDING
