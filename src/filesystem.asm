; License: GPL-v3.0-only
; Full license text in ../LICENSE
; Original Author: Daniel Huber

; This file tries to implement a flat filesystem first with help of 
; write / read sector from disk macros and then with a file allocation
; system.
;;;; PUBLIC FUNCTIONS
; writeFile
;	Arguments:
;		esi = buffer location, data source address
;		edi = filename string pointer
;		ecx = file size in bytes !!! MUST BE ACCURATE !!!
;	returns eax 0 on success, -1 on error
;----------------------------------------------------------------------
; readFile
; 	Arguments
;		esi = filename
;		edi = buffer location, data destination address
;	returns eax 0 on success, -1 on error and file size in ecx
;----------------------------------------------------------------------
;;;; Functions used internally
; LBAtoCHS conversion
; CHStoLBA conversion
; mapCHS
; unmapCHS
; findInodeByName
;----------------------------------------------------------------------
;;;; DATA STRUCTURES DEFINED HERE
; SUPERBLOCK
; SB_CACHE	cached version of superblock
; BITMAP	free sector bitmap
; BM_CACHE	cached version of bitmap 
;----------------------------------------------------------------------
;;;; CONSTANTS
%define FILENAME_MAX_LENGTH 24
%define FILE_DISK_LOCATION_SIZE 4
%define FILE_LBA_SIZE 4
%define FILES_IN_SUPERBLOCK 32
%define INODE_SIZE (FILENAME_MAX_LENGTH + FILE_DISK_LOCATION_SIZE + FILE_LBA_SIZE)
%define SPT 63
%define HPC 16
%define BIT_MAP_SIZE HPC * 1024 * SPT

; Because this file is preincluded in kernelmain.asm, the set up functions
; defined below will run

; load the cached bitmap and cached superblock

; load SB_CACHE
mov ah, 2		; DISK_READ param
mov al, 2		; count
mov cl, 3		; sector
mov ch, 0		; cylinder
mov dh, 0		; head
mov dl, 0x80 		; disk
mov ebx, SB_CACHE

; load BM_CACHE
mov ah, 2		; DISK_READ param
mov al, 2		; count
mov cl, 5		; sector
mov ch, 0		; cylinder
mov dh, 0		; head
mov dl, 0x80 		; disk
mov ebx, BM_CACHE




; Inode layout

; struct inode_t
;	char fname[24]
;	unsigned int size;
;	unsigned int addr;
;endstruc



; Setup completed, continue in kernelmain.asm
jmp FSsetupDone

;;;;;; SUPERBLOCK on disk position =
; Create Superblock and superblock cache
align 512, db 0x90		; map superblock to disk sector boundaries
SB_CACHE: resb FILES_IN_SUPERBLOCK * INODE_SIZE

;; Currently, SUPERBLOCK is 2 sectors in size
align 1024, db 0
BM_CACHE: db 0, 0, 0, 0	; each 0 represents 8 used sectors

align 512, db 0xff	; rest sectors are free
; this makes it easy to access a value from the SB_CACHE
; SB_CACHE(3, size) will get us the size of Inode 3
%define SB_CACHE(_inode, x) SUPERBLOCK_START + _inode*18 + Inode. %+ x



LBAtoCHS:
; SECTORS START AT 1, NOT 0
	; 63 sectors per track
	; 255 heads
	; 1024 cylinders
	
	;C = LBA // (HPC × SPT) 	; // = integer division, stored in EAX, 
    	;H = (LBA // SPT) mod HPC	; % = modulo, stored in EDX
    	;S = (LBA mod SPT) + 1
	;;;; Div returns mod result in edx and integer division
	;;;; result in eax

	; Get cylinder value
	mov ebx, SPT		; SPT
	shl ebx, 4		; equal to * HPC
	mov eax, edi
	xor edx, edx
	div ebx			; divide LBA by previous result
	mov esi, eax		; store C in esi

	; ESI clobbered

	; Get head value
	mov eax, edi		; copy LBA number
	mov ecx, SPT 
	xor edx, edx		; clear edx
	div ecx			; int div LBA//SPT
	; eax
	mov ecx, HPC
	xor edx, edx
	div ecx			; modulo HPC
	
	; save edx(H)
	push edx		

	; Get Sector number
	mov eax, edi		; copy LBA 
	mov edi, SPT

	xor edx, edx
	div edi			; LBA mod SPT
	inc edx			; + 1


	pop ecx

	xchg edx, ecx		; swap regs

	; esi = C		; assumed C < 1024
	; edx = H
	; ecx = S		it is assumed that S <= 63

	; format ch bits 0-7 and cl bits 8-9 of cylinder number

	cmp esi, 1024
	jg .invalidCHSFormat
	cmp ecx, 64
	jge .invalidCHSFormat
	
	
	ret

	.invalidCHSFormat:
		mov eax, -1	; return ERROR
		ret

;maps (esi,edx,ecx) tuple to correct position in ch, cl and dh
mapCHS:

	mov ax, 0b0000_0011_0000_0000 ; isolate cylinder number with bitmask 
	and ax, si ; ax contains bit 8 and 9 of cylinder in bit 6 and 7
	shr ax, 2	; fix bit position
	add cl, al	; cl[0:5] contains S and  cl[6:7] has top C bits

	mov bx, si	; move low eight bits of C in sil to ch
	mov ch, bl

	shl dx, 8	; effectively mov dl (H) to dh and clear dl 

	xor eax, eax		; return SUCCESS

	ret

; moves the packed CHS address in cx and dh into esi(c),edx(h),ecx(s)
 unmapCHS:
 	; set bitmask for ecx 

	xor esi, esi

	; Cylinder ch + cl[6-7]
 	mov eax, 0b0000_0000_0000_0000_0000_0000_1100_0000
	and eax, ecx
	shl eax, 2
	mov al, ch
	mov esi, eax

	; sector 
	and ecx, 0b0000_0000_00000_0000_0000_0000_0011_1111	; bitmask bit 0-5
	
	; head
	shr dx, 8	; shift head number in dh to dl and clear dh
	xor dh, dh
	ret

; CHS values are in cx and dx
; returns LBA in EAX
toLBA:
	; isolate CHS values as follows:
	; EBX = C
	; EDI = H
	; ESI = S
	xor ebx, ebx
	xor esi, esi
	xor edi, edi

	; CYLINDER
	mov bl, ch		; extract lower cylinder number to ebx
	mov bh, 0b1100_0000	; set bitmask to extract cylinder number
	and bh, cl
	shr bh, 6		; shift bits 14 and 15 of bx to 8 and 9

	; HEAD
	mov di, dx		; copy head number to edi
	and di, 0xff00
	shr di, 8

	; SECTOR
	mov esi, ecx
	and esi, 0b0011_1111 	; mask only bits 0-5 of esi

	; CHS values are isolated, now perform LBA conversion
	; As mentioned above, LBA = (C * HPC + H) * SPT + S - 1
	mov eax, ebx		; mov C to eax
	mov ebx, HPC
	mul ebx			; multiply with HPC (16)
	add eax, edi		; add H to eax
	mov ebx, SPT
	mul ebx			; multiply eax with SPT (63)
	add eax, esi		; add S
	dec eax			; decrement by 1

	;cmp eax, 		; check 
	jmp .noErr
	xor eax, eax		; return -1
	dec eax
	.noErr:
	ret

findBitChainIndex:
; Takes argument NumberOfSectors<ECX> and returns sector number that contains
; continuos sector space requested
; it's needed by the filesystem for the sector allocator algorithm
; returns length of the chain in ECX and start position of chain in EAX
	mov ebx, BM_CACHE	; EBX points to the first byte in the BITMAP array
	.bitmapBytePtrLoop:
		xor edx, edx		; clear out upper bits of edx 
		mov dl, byte [ebx]	; dl holds byte pointed to by [EBX]
		xor edi, edi 		; set up bittest index (set to 0)
		.testBit:			; another loop head for each bit
			bt edx, edi	; check if bit number <edi> in BYTE is 1
					; if true, the bt instruction sets the carry flag
			jnc .bitIsZero	; bit is 0
			;.bitIsSet:	; increment counter of 1s since last 0
				inc eax
				cmp eax, ecx	; check if the counter has reached the desired amount
				jne .notEnoughBits
				; return the start position (in bits) of the bitchain with <ecx> many
				; consecutive 1s
				mov eax, ebx
				sub eax, BM_CACHE	; EAX will contain the BYTE offset relative to the BM
				shl eax, 3		; multiply the BYTE offset with 8 (bits per byte)
				; #####################################################################
				sub eax, ecx	; transform to start bit position
				inc eax		; correct starting address	
				; #####################################################################
				;each shift left is equal to *2 mul, 3 shift left is *= 2*2*2, so *8
				add eax, edi	; add the bit offset in Byte to the BYTE offset as bits  
				; return value (Sector Number with sequential N free sectors) is in eax
				ret
			.bitIsZero:
				xor eax, eax	; reset the counter of 1s since last 0 
			.notEnoughBits:
			inc edi
			cmp edi, 8		; check if last bit (bit 8) has been reached
			jl .testBit		; if edi is 8, then redo the bit test but at bitpo+=1
			; else just redo
	.redoBMByteLoop:
	inc ebx
	cmp ebx, BIT_MAP_SIZE + BM_CACHE		; EBX(Bitmap ptr) should not point past the bitmap
	jle .bitmapBytePtrLoop	; if EBX (:=BYTE Pointer) is greater than the bitmap size, do not loop
	; If every BYTE in BITMAP has been scanned without a matching index,
	; return -1, signifying an ERROR
	mov eax, -1
	ret


; mov esi, stringname
; returns superblock inode index or -1 on no file found
findInodeByName:
	mov edi, SB_CACHE
	add edi, 32		; add string offset
	mov edx, esi		; copy filename
	xor ecx, ecx ; counter
	.loop:
		call compareString
		or eax, eax		; check if return value is 0
		jz .found
		mov esi, edx		; move  value to start of string again
		add edi, INODE_SIZE	; point to next inode in superblock
		inc ecx
		cmp ecx, FILES_IN_SUPERBLOCK
		jne .loop
		; If loop = 0 then file not found
		mov eax, -1
		ret
	.found:
		mov eax, ecx
		ret
		; calculate 
; returns inode index in superblock or -1 if superblock is full
findFreeInode:
	xor ecx, ecx
	mov edi, SB_CACHE
	; always checks first byte of each filename member of an inode in superblock, if 0 then free
	; filename is first member in inode
	.find:
		cmp byte [edi], 0
		je .found
		add edi, INODE_SIZE
		inc ecx
		cmp ecx, FILES_IN_SUPERBLOCK
		jne .find
	mov eax, -1
	ret
	.found:
	mov eax, ecx
	ret



FSsetupDone:
