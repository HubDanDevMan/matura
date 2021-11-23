jmp __prog

%include "cpuid/formatHex.asm"
; formatHex
; printBuf

; TYPEDEFS
struc inode_t
; FNAME
fname: resb 16
size: resw 1
addr: resb 4
endstruc


__prog:








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SUPERBLOCK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
align 8
SUPERBLOCK:


