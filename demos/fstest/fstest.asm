jmp start

; ReadSectors <CYL> <HEAD> <SECT> <NrOfSectors> <dest>
%macro WriteSector 5
        pusha
        mov ax, 0
        mov es, ax
        mov ebx, %5             ; Dest
        mov ah, 0x03            ; Set interrupt number
        mov al, %4              ; Number of sectors
        mov cx, %1              ; Cylinder
        ror cx, 8
        shl cl, 6
        or cl, %3               ; Sector number
        mov dh, %2              ; Head Number
        mov dl, 0x80            ; Drive number, constant as of now
        int 0x13
	popa
%endmacro
 
; ReadSectors <CYL> <HEAD> <SECT> <NrOfSectors> <source>
%macro ReadSector 5
	pusha
	mov ax, 0
        mov es, ax
        mov ebx, %5             ; Source
        mov ah, 0x02            ; Set interrupt number
        mov al, %4              ; Number of sectors
        mov cx, %1              ; Cylinder
        ror cx, 8
        shl cl, 6
        or cl, %3               ; Sector number
        mov dh, %2              ; Head Number
        mov dl, 0x80            ; Drive number, constant as of now
        int 0x13
	popa
%endmacro

start:
mov al, "x"
mov edi, 0x500
mov cx, 512*2		; 2 sectors
call memset


; This chunk writes "x"es to the first 2 sector, look at the binary file with hexdump and notice the "x"s (0x78)
;	 |
;	 |
;	\|/
;	 v

WriteSector 0,0,1,2,0x500




jmp $

; mov al, byte
; mov edi, dest
; mov cx, bytes
memset:
	mov byte [edi], al
	inc edi
	loop memset
	ret

END_PADDING
