jmp ___main

%include "cpuid/printHex.asm"				;include printBuff and formatHex
%define LINE_WIDTH 80		
%define FREE_LINE (LINE_WIDTH-5)
	
___main:
xor eax, eax						;cpuid leaf 0
mov ds, ax							
mov es, ax

cpuid								;if eax=0: returns the CPU's manufacturer ID string which is always 12 characters long
mov edi, buffmanu					;move a buffer into edi before characters are moved into the buffer
mov [edi], ebx						;first 4 characters
mov [edi+4], edx					;next 4 characters
mov [edi+8], ecx					;last 4 characters



mov eax, 0x80000001					
cpuid								;if eax=0x80000001: returns feature flags about the CPU in EDX and ECX
bt edx, 29							;the 29th bit of edx is 1 if the CPU supports 64-bit instructions and registers
jc longmodes

longmodens:							;overwrites Longmodeyes with Longmode no 
mov cx, 22 							 
mov edi, Longmodeyes
mov esi, Longmodeno
rep movsb							;22 characters are moved from esi to edi

longmodes:							
mov edi, bufflm						;move a buffer into edi and 
mov esi, Longmodeyes				;Longmodeyes into esi so that printBuff can print the string

modelid:
mov eax, 1 							;cpuid leaf 1
cpuid								;if eax=1: returns information about the family and model of the CPU in eax

;												EAX
; _______________________________________________________________________________________________
;|31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|41|13|21|11|10|09|08|07|06|05|04|03|02|01|00|
;|-----------|-----------------------|-----------|-----|-----|-----------|-----------|-----------|
;| reserved  |  extended family ID   | extended  |res- |CPU  | family ID |   model   |stepping ID|
;| 			 |						 | model ID  |erved|type |     		 |			 |			 |
;|___________|_______________________|___________|_____|_____|___________|___________|___________|

mov esi, eax						
and eax, 0x00000f00					;clear eax except for family ID
cmp ah, 0x0f						;if family ID = 15 jump to ExtFam
je ExtFam
shr ax, 8 							;if family ID in not = 15 the family ID is the value family ID field
mov edi, fambuff                    ;move buffer into edi for formatHex
call formatHex						;formatHex converts content of eax into ascii and moves it into the buffer in edi; read printHex.asm for more information
cmp al, 0x06						
je ExtModel							;if family ID = 6 jump to ExtModel


model:
mov eax, esi
and eax, 0x000000f0 				;clear eax except for model ID
mov edi, modbuff					
call formatHex
jmp halt							

ExtFam:								;if family ID = 15 the actual family ID is derived from extended family ID + family ID 
mov eax, esi		
and eax, 0x0ff00f00					;clear eax except for extended family ID and family ID
shr eax, 4
shl ax, 8
shr eax, 12
mov edi, fambuff
call formatHex

ExtModel:							;if family ID = 6 or 15 the actual model ID is derived from extended model ID + model 
mov eax, esi				
and eax, 0x000f00f0					;clear eax except for extended model ID and model
shl ax, 8
shr eax, 12
mov edi, modbuff
call formatHex

brand:								;this segment of code moves the CPU's brand string into the buffer 
mov edi, brandbuff					
mov eax, 0x80000002					;if eax=0x80000002: returns 4 characters in eax, ebx, ecx and edx each
cpuid
call brandstr						;brandstr moves the content of eax, ebx, ecx and edx into edi
mov eax, 0x80000003					;if eax=0x80000004: returns next 16 characters in eax, ebx, ecx and edx
cpuid 
call brandstr
mov eax, 0x80000004					;if eax=0x80000004: returns last 16 characters in eax, ebx, ecx and edx
cpuid
call brandstr

halt:
mov esi, strbuff					;move buffers into esi before printBuff
call printBuff						;prints the buffers; read printHex.asm for more information
jmp $								;halt


brandstr:
mov [edi], eax
mov [edi+4], ebx
mov [edi+8], ecx
mov [edi+12], edx
add edi, 16							;add 16 to edi to allow brandstr to be called again
ret


strbuff:
db "CPU manufacturer: "
strmanulength equ $-strbuff							;determines length of string one line above
buffmanu: times LINE_WIDTH-strmanulength db " "		;subtract given string two lines above from line width
db "Family: "
fambuff: times FREE_LINE-3 db " "					;FREE_LINE is 5 characters shorter than LINE_WIDTH - 3 is the length of the string above;
db "Model: "
modbuff: times FREE_LINE-2 db " "

Longmodeyes:
db "Longmode supported"
strlmlength equ $-Longmodeyes
bufflm: times LINE_WIDTH-strlmlength db " "

Brandbuff:
db "Brand: "
strbrandlength equ $-Brandbuff
brandbuff: times LINE_WIDTH-strbrandlength db 0

Longmodeno:
db "Longmode not supported"
db 0

END_PADDING
