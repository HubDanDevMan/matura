; License: GPL-v3.0-only
; Full license text in ../LICENSE
; Original Author: Daniel Huber

; This program sets up interrupt handlers for exceptions such as:
; DIV by 0, Double Fault, x87 FPU Error and Invalid Opcode
; and traps such as Breakpoint or Overflow

; defining the interrupt entries
; in the Interrupt Vector Table, similar to an array index

%define DIV0_IV		0x00			; zero division error
%define TRAP_IV		0x01			; single step, trap flag
%define NMI_IV		0x02			; non maskable interrupt (PS/2 keyboard/mouse, timer)
; Breakpoint:		0x03
; Overflow:		0x04
; Bound range exceeded: 0x05
%define INV_OC_IV	0x06			; invalid opcode exception
; no Co-processor found:0x07
%define DBL_FAULT_IV	0x08			; double fault
; ... there are some more exceptions but we will ignore them
; because they are rare and writing an appropriate interrupt handler
; takes up too much time


; this macro writes a far pointer
; into the IVT

; usage:	AddToIVT <INT_NUM> <INT_HANDLER_PTR>
; example:	AddToIVT DIV0_IV div0_ExceptionHandler
%macro AddToIVT 2
	; to work, data segment must be set to 0
	mov dx, cs 		; copy current code segment
	mov ebx, %1 << 2	; because the interrupt vector is aligned to 4,
				; the effective memory location of the entry is
				; equal to IV * 4 (which is the same as << 2)
	mov si, %2		; moves the interrupt handler pointer to si
	mov [ebx], si
	mov [ebx+2], dx 	; moves the code segment into the IVT two bytes
				; above the function pointer
%endmacro


; Adding the entries
AddToIVT DIV0_IV,div0_ExceptionHandler
AddToIVT TRAP_IV,trapSignleStep_Handler
AddToIVT INV_OC_IV,invalidOpcode_ExceptionHandler



; here are the various interrupt handlers
; because we dont want them to run now
jmp _ints_done

div0_ExceptionHandler:
	iret

trapSignleStep_Handler:
	iret

invalidOpcode_ExceptionHandler:
	iret

_ints_done:
