; CPUID is a instruction to see all the available CPU extensions, some of them
; are:
; Floating Point Instructions (FPU coprocessor)
; Vector extension/SIMD:	SSE, MMX, AVX-2, AVX-512
; Virtualisation: 		VT-X / AMD-V
; Cryptography: 		AES-ISA, RD-Seed/-RAND, SHA-Extensions

pushfd
pop eax
bt eax, 21
jc cpuid_present
; no carry error

mov ah, 0x0e
mov al, "e"
int 0x10
jmp $

cpuid_present:
	mov ah, 0x0e
	mov al, "s"
	int 0x10
	jmp $




END_PADDING
