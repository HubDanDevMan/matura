AS=nasm
ASMFLAGS=-fbin -w+all -O1 -d MAX_SECTORS=8
SRCDIR=src
IF=kernelmain.asm
OF=flamingos.bin
VIRT=qemu-system-x86_64
VIRTFLAGS=-drive format=raw,media=disk,file=
DOCS=$(ls chapters/)
OUTDOC=paper

make: $(SRCDIR)/$(IF)
	$(AS) $(ASMFLAGS) $(SRCDIR)/$(IF) -o $(OF)

run: make
	$(VIRT) $(VIRTFLAGS)$(OF)

clean: $(OF)
	rm $(OF)

paper: $(DOCS)
	cat chapters/*.md > $(OUTDOC).md
	pandoc $(OUTDOC).md -o $(OUTDOC).pdf
	rm $(OUTDOC).md
