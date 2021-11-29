; License: GPL-v3.0-only
; Full license text in ../LICENSE
; Original Authors:
; Daniel Huber
; Nick Gilgen
; Moray Yesilgüller

; first stage bootloader loads the sectors into memory
%include "src/bootsector.asm"

; sets up interrupts and exception handling
%include "src/interrupts.asm"
%include "src/filesystem.asm"


jmp skip_includes
; here are all the include files that provide functionality to other programs.
; They do not need to run and the functions in these files will only be called
; explicitly.

; allows kernel code to call string formatting functions
;%include "src/formats.asm"
%include "./demos/library.asm"		; library functions


skip_includes:





mov esi, startupgreet
call printBuff



jmp $

;String Buffers
startupgreet: db "Welcome to FlamingOS!    "
strbuf: times 65 db " "
db " _____ _                 _              ___  ____                               "
db "|  ___| | __ _ _ __ ___ (_)_ __   __ _ / _ \/ ___|                              "
db "| |_  | |/ _` | '_ ` _ \| | '_ \ / _` | | | \___ \                              "
db "|  _| | | (_| | | | | | | | | | | (_| | |_| |___) |                             "
db "|_|   |_|\__,_|_| |_| |_|_|_| |_|\__, |\___/|____/                              "
db "                                  |___/                                         "
db "Developed by Nick Gilgen, Daniel Huber and Moray Yesilgueller"
times 9 db " "

db 0


; padd out so it aligns with a multiple of 512
times MAX_SECTORS*512-($-$$) db 0
