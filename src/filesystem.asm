; License: GPL-v3.0-only
; Full license text in ../LICENSE
; Original Author: Daniel Huber

; This file tries to implement a flat filesystem first with help of 
; write / read sector from disk macros and then with a file allocation
; system.

jmp skipFSfunc
diskaccesserror:
	mov edi, 0xb8000 + 80*2*20
	mov esi, diskerrbuf
	.errprint:
	mov dl, byte [esi]
	mov byte [edi], dl
	inc esi
	add edi, 2
	cmp byte[edi], 0
	jne .errprint
	stc			; for further error handling by programs
	ret


%define FILENAME_LENGTH 12
; The Inode struct
; to reference the location of fname use [SB_CACHE(inodeNr, fname)]
struc Inode
	.fname 		resb FILENAME_LENGTH
	.startloc	resb 3 			; packed value of CHS
	.size		resw 1			; Size in bytes
endstruc

diskerrbuf: db "An unsuccessful disk io occured", 0


skipFSfunc:





; this makes it easy to access a value from the SB_cache
; SB_CACHE(3, size) will get us the size of Inode 3
%define SB_CACHE(_inode, x) SUPERBLOCK_START + _inode*18 + Inode. %+ x


; 1) NumberOfInodes 2)
%macro CreateSuperblock 2
	times %1 * 
%endmacro





%define FILENAME_LENGTH 13






; WriteSectors <CYL> <HEAD> <SECT> <NrOfSectors> <source>
%macro WriteSector 5
	pusha
	mov ax, 0
	mov es, ax
	mov ebx, %5		; Destination
	mov ah, 0x03 		; Set interrupt number
	mov al, %4		; Number of sectors
	mov cx, %1		; Cylinder
	ror cx, 8
	shl cl, 6
	or cl, %3		; Sector number
	mov dh, %2			; Head Number
	mov dl, 0x80 		; Drive number, constant as of now
	int 0x13
	
	jc diskaccesserror
	popa
	ret
%endmacro

; ReadSectors <CYL> <HEAD> <SECT> <NrOfSectors> <source>
%macro ReadSector 5
	pusha
	mov ax, 0
	mov es, ax
	mov ebx, %5		; Source
	mov ah, 0x02 		; Set interrupt number
	mov al, %4		; Number of sectors
	mov cx, %1		; Cylinder
	ror cx, 8
	shl cl, 6
	or cl, %3		; Sector number
	mov dh, %2		; Head Number
	mov dl, 0x80 		; Drive number, constant as of now
	int 0x13
	
	jc diskaccesserror
	popa
	ret
%endmacro



%macro MakeFSEntry 0
	resb 12		; Filename 
	resw		; Cylinder and S
%endmacro
