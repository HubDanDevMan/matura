%include "firststage.asm"

rdseed ax
mov ah, 0x0e
int 0x10






jmp $
times 512*MAX_SECTORS-($-$$) db 0

