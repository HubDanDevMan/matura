%define APM_COMMAND 0x53
; This file uses the Advanced Power Management Specification to disconnect all the
; attached devices and shuts the CPU off. This is how a computer can truly
; shut down

; to not shutoff the demo immediatly, there is a delay function that uses
; a loop 

; Display message
mov esi, strbuf
call printBuff


; Delay loop
mov ecx, 0xafffffff
.redo:
	dec ecx
	jnz .redo



; check if APM supported 
mov ah, APM_COMMAND
mov al, 0 		; APM command to check if APM available
xor bx, bx		; bx needs to be cleared
int 0x15 
jnc noerr

; no APM support 
; ERROR:
mov esi, errmsg
call printBuff
jmp $ 			; halt cpu

; disconnects all devices and shuts the CPU off
; this shutdown is only available in post 1995ish bioses
; otherwise each individual device has to be turned off
; individualy

; if APM is not present, this code wont run and turnoff is not available
noerr:
	mov ah, APM_COMMAND
	mov al, 0x07		; 'Set power state' control word
	mov bx, 1 		; ALL devices
	mov cx, 3 		; Power State: OFF
	int 0x15

	; If code below is still executed, despite APM support, shutdown was unsuccessful
	mov esi, errmsg		; display errormessage
	call printBuff
	jmp $			; halt






strbuf: db "The OS will shutdown eventually...                                 ", 0
errmsg: db "Shutdown was unsuccessful                                          ", 0
%include "library.asm"


END_PADDING
