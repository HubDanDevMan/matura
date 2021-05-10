; License: GPL-v3.0-only
; Full license text in ../LICENSE
; Original Author: Daniel Huber

; This file tries to implement a flat filesystem first with help of 
; write / read sector from disk macros and then with a file allocation
; system.


; WriteSectors <HEAD-CYL-SECT> <NrOfSectors> <source>
%macro WriteSector 2
	mov ah, 0x02 		; Set interrupt number
	mov al, %2		; Number of sectors
	mov dl, DISK_NUMBER
	; pack 4 byte HCS value, need to develop algorithm
	int 0x13
%endmacro

; ReadSectors <HEAD-CYL-SECT> <NrOfSectors> <dest>
%macro WriteSector 2
	mov ah, 0x02 		; Set interrupt number
	mov al, %2		; Number of sectors
	mov dl, DISK_NUMBER

	int 0x13
%endmacro

