; License: GPL-v3.0-only
; Full license text in ../LICENSE
; Original Authors:
; Daniel Huber
; Nick Gilgen
; Moray Yesilgüller

; first stage bootloader loads the sectors into memory
%include "src/bootsector.asm"

; sets up interrupts, allows for exception handling
%include "src/interrupts.asm"


; endless loop
jmp $
; padd out so it aligns with a multiple of 512
times MAX_SECTORS*512-($-$$) db 0
