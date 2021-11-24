jmp __prog
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

; mov esi, source
; mov edi, dest
; mov ecx, count
strncpy:
	mov al, byte [esi]
	cmp al, 0
	je .done
	dec ecx
	jz .done
	mov byte [edi], al
	inc esi
	inc edi
	jmp strncpy
	.done:
	ret

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

	; returns 63 for some reason??
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
	mov eax, edx		; copy LBA (Now in edx)
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
	; isolate cylinder number with bitmask
	mov ax, 0b0000_0011_0000_0000
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
	; cx
	mov eax, 0b0000_0000_1100_0000
	and eax, ecx
	shl eax, 2
	mov al, cl
	mov esi, eax

	; sector
	mov cl, ch

	; head
	shr dx, 8	; shift head number in dh to dl and clear dh

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
	jb .noErr
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

mov edi, 0
call LBAtoCHS
; ecx = C
push ecx
push edx
; print C
mov eax, esi
mov edi, chexbuf
call formatHex

pop eax
mov edi, hhexbuf
call formatHex
pop eax
mov edi, shexbuf
call formatHex
mov esi, strbuf
call printBuf




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

formatHex:
	mov dl, al
	and dl, 0xF0
	shr dl, 4
	cmp dl, 0xa
	jl .noAdd
	add dl, 0x07
	.noAdd:
	add dl, 0x30
	mov byte [edi], dl
	and al, 0x0F 
	cmp al, 0x0a
	jl .noAdd2
	add al, 0x07
	.noAdd2:
	add al, 0x30
	inc edi
	mov byte [edi], al
	ret

; mov esi, strbuf
printBuf:
	mov edi, 0xb8000
	.repprint:
	mov dl, byte[esi]
	mov byte [edi], dl
	inc esi
	add edi, 2
	cmp byte [esi], 0
	jne .repprint
	ret


strbuf: db "Cylinders: 0x"
chexbuf: times 67 db " "
db "Heads: 0x"
hhexbuf: times 71 db " "
db "Sectors: 0x"
shexbuf: times 70 db " "
db 0

END_PADDING

