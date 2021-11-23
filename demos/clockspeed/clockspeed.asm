jmp _main

%include "library.asm"
_main:


mov ax, 0x5F03
mov bh, 0
int 0x10

mov al, bl
mov edi, numbuf
call formatHex

mov esi, strbuf
call printBuff

jmp $

strbuf: db "CLOCKSPEED: "
numbuf: db " "
db 0
db 0

END_PADDING
