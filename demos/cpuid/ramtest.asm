jmp _start



;RAMsize:
;xor eax, eax
;int 0x12
;mov [lowmemory], ax
;
;xor ebx, ebx
;
;xor si, si
;clc
;mov edi, rambuff
;repeat:
;mov eax, 0xe820
;mov ecx, 24
;mov edx, 0x534d4150
;int 0x15
;jc error


;error:
;mov ah, 0x0e
;mov al, "e"
;int 0x10
;jmp $

END_PADDING
