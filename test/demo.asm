%include "firststage.asm"



jmp $
times 512*MAX_SECTORS-($-$$) db 0

