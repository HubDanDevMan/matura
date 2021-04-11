AS=nasm
ASMFLAGS=-fbin -w+all -O1
SRCDIR=src
IF=kernelmain.asm
OF=flamingos.bin
VIRT=qemu-system-x86_64
VIRTFLAGS=-drive format=raw,media=disk,file=

make: $(IF)
	$(AS) $(ASMFLAGS) $(SRCDIR)/$(IF) -o $(OF)

run: make
	$(VIRT) $(VIRTFLAGS)$(OF)

	
