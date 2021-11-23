jmp prog

%include "./library.asm"
prog:
mov edi, 0

; get disk params
mov es, di
mov ah, 0x08
int 0x13
jc err

; head number
xor eax, eax
mov ax, dx 
mov edi, hexbufh
call formatHex

xor eax, eax
mov ax, cx 
mov edi, hexbufs
call formatHex

mov esi, strbuff
call printBuff
jmp $
err:
mov ah, 0x0e
mov al, "E"
int 0x10
jmp $

align 512
strbuff: db "Max Heads: 0x"
hexbufh: times 8 db 0
times 59 db " "
db "Max sectors: 0x"
hexbufs: times 8 db 0
times 80 db " "


END_PADDING
