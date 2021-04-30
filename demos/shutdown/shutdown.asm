%define APM_COMMAND 0x53
; This file uses the Advanced Power Management Specification to disconnect all the
; attached devices and shuts the CPU off. This is how a computer can truly
; shut down

; to not shutoff the demo immediatly, there is a delay function that uses
; a loop 


call delay		; gives a delay of a few seconds 

mov ah, 0x0e
mov al, "."
int 0x10


; check if APM supported 
mov ah, APM_COMMAND
mov al, 0 		; APM command to check if APM available
xor bx, bx		; bx needs to be cleared
int 0x15 
jnc noerr

; capital "E" means no APM support 
mov al, "E"
err:
	mov ah, 0x0e
	int 0x10
	jmp $

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
	mov al, "e"		; lowercase 'e' means Shutdown failed
	jmp err




; busy delay counting down from ecx

delay:
mov ecx, 0xfffffff
.redo:
	dec ecx
	jnz .redo
	ret

END_PADDING
