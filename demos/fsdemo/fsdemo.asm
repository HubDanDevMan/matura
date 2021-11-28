jmp __prog

%include "library.asm"


struc inode_t
fname: resb 16
size: resw 1
addr: resb 4
endstruc

%define INODE_SIZE (16 + 2 + 4)
align 8
; The Superblock is an array of inodes
SUPERBLOCK: resb 32 * INODE_SIZE 
%define inode(index, member) (SUPERBLOCK + (index * INODE_SIZE) + member)

; register assignment macro for inodes

; GetInode Member
; mov edi, INDEX
; returns pointer in EDI
%macro GetInode 1
	mov eax, INODE_SIZE
	mul edi
	; EAX has result (32 least significant bits of MUL)
	mov edi, eax
	add edi, SUPERBLOCK
	add edi, %1
%endmacro

; The following functions are used for mapping a LBA (Logical Block Addressing)
; to CHS Addressing and vice versa
; LBA = (C  * HPC + head) * SPT + (sectors -1)
; SPT = 63, reported by harddisk, sectors per track
; HPC = 16, also reported by harddisk, heads per cylinder

%define SPT 63
%define HPC 16

;;;; LBA Format:
; 0 - (2^28-1) direct sector addressing

;;;; CHS Format:
; ch = low cylinder number
; cl[0:5] = sector number
; cl[6-7] = upper cylinder number
; dh = head number
; dl = drive number, stays the same throughout the whole OS
; because we use only 1 drive, drive Nr. 0x80!!!
; Note: cylinder number is a 10 bit number



; mov edi, logicalblockadress
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


__prog:

; populate superblock


; test LBA|CHS conversion
	; esi = C
	; edx = H
	; ecx = S

mov edi, 16127
call LBAtoCHS

push ecx
push edx

mov eax, esi
mov edi, chexbuf
call formatHex

pop eax
mov edi, hhexbuf
call formatHex

pop eax
mov edi, shexbuf
call formatHex





;maps (esi,edx,ecx) tuple to correct position in ch, cl and dh

mov esi, 0x13
mov edx, 0xf
mov ecx, 0x3f

call mapCHS
;call toLBA


call unmapCHS



mov esi, strbuf
call printBuff






jmp $
; mov esi, <source>
; mov edi, <strbuf>
; mov ecx, <nrBytes>
hexdump:
	mov al, byte [esi]
	; params
	call formatHex
	inc edi
	mov byte [edi], " "
	inc edi
	inc esi
	db 0x66 	; use ECX instead of CX prefix
	loop hexdump
	ret

	
strbuf: db "Cylinders: 0x"
chexbuf: times 67 db " "
db "Heads: 0x"
hhexbuf: times 71 db " "
db "Sectors: 0x"
shexbuf: times 70 db " "
db "LBA: 0x"
lbabuff: times 60 db " "
db 0

END_PADDING

