

mov edi, 0xb8000
add edi, 1280


mov ah, 0x0
clc 
int 0x1a


mov al,'U'
call printL
mov al, 'T'
call printL
mov al, 'C'
call printL
mov al, '-'
call printL

mov ax, cx
rol eax, 16
mov ax, dx
mov edx, 0
mov ecx, 65520
div ecx
mov cl, 10
div cl
mov dl, ah
call print
mov al, dl
add al, 2
call print
mov al, 0xa
call print
mov ax, dx
mov cx, 1092
mov dx, 0
div cx
mov cl, 10
div cl
mov dl, ah
call print
mov al, dl
call print
jmp end




print:
mov ah, 0000_1111b
add al, 0x30
mov [edi],ax
add edi, 2
ret


printL:
mov ah, 0000_1111b
mov [edi],ax
add edi, 2
ret

end:
END_PADDING
