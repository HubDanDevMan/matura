%include "firststage.asm" 

jmp ___main

%include "printHex.asm"				;include printBuff and formatHex
%define LINE_WIDTH 80		
%define FREE_LINE (LINE_WIDTH-5)
	
___main:
xor eax, eax						;set eax to 0
mov ds, ax							
mov es, ax

cpuid								;if eax=0 
mov edi, buffm
mov [edi], ebx
mov [edi+4], edx
mov [edi+8], ecx

mov eax, 0x80000001
cpuid

bt edx, 29
jc longmodes

longmodens:
mov cx, 22 
mov edi, Longmodeyes
mov esi, Longmodeno
rep movsb

longmodes:
mov edi, bufflm
mov esi, Longmodeyes

modelid:
mov eax, 1 
cpuid

push eax
and eax, 0x00000f00
shr eax, 8
mov edi, fambuff
call formatHex
shl eax, 8
cmp ah, 0x0f
je ExtModel
cmp ah, 0x06
je ExtModel

model:
pop eax
push eax
and eax, 0x000000f0
mov edi, modbuff
call formatHex
jmp halt

ExtModel:
pop eax
push eax
shr al, 4
shl eax, 4
and eax, 0xf00000f0
mov edi, modbuff
call formatHex
jmp halt

halt:
mov esi, strbuff
call printBuff
pop eax
jmp $

strbuff:
db "CPU manufacturer: "
strmlength equ $-strbuff
buffm: times LINE_WIDTH-strmlength db " "

db "Family: "
fambuff: times FREE_LINE-3 db " "
db "Model: "
modbuff: times FREE_LINE-2 db " "
;db "....: "
;..buff: times FREE_LINE db " "
;db "....: "
;..buff: times FREE_LINE db " "

Longmodeyes:
db "Longmode supported"
strlmlength equ $-Longmodeyes
bufflm: times LINE_WIDTH-strlmlength db " "
db 0

Longmodeno:
db "Longmode not supported"
db 0


times 510*MAX_SECTORS-($-$$) db 0
