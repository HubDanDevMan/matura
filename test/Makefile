AS=nasm
ASMFLAGS=-fbin -w+all -O0
IF=demo.asm
OF=flamingos.bin
VIRT=qemu-system-x86_64
VIRTFLAGS=-cpu SandyBridge -drive format=raw,media=disk,file=
OLDDIR=old

make: $(IF)
	$(AS) $(ASMFLAGS) $(IF) -o $(OF)

run: make
	$(VIRT) $(VIRTFLAGS)$(OF)

clean: $(OF) demo.asm
	mv demo.asm $(OLDDIR)/old.asm
	cp $(OLDDIR)/boilerplate.asm demo.asm
	rm $(OF)
	
	
