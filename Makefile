AS=nasm
ASMFLAGS=-fbin -w+all -O1 -d MAX_SECTORS=8
SRCDIR=src
IF=kernelmain.asm
OF=flamingos.bin
VIRT=qemu-system-x86_64
VIRTFLAGS=-drive format=raw,media=disk,file=

make: $(SRCDIR)/$(IF)
	$(AS) $(ASMFLAGS) $(SRCDIR)/$(IF) -o $(OF)

run: make
	$(VIRT) $(VIRTFLAGS)$(OF)

clean: $(OF)
	rm $(OF)
