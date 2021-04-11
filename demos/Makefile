AS=nasm
ASMFLAGS=-fbin -w+all -O1
VIRT=qemu-system-x86_64
VIRTFLAGS=-drive format=raw,media=disk,file=


default:
ifeq  "$(origin IF)"  "undefined"
	@echo "Use make IF=DIRNAME [run]"
else
	$(AS) $(ASMFLAGS) $(IF)/$(IF).asm -o $(IF).bin
endif


# runs IF
run: default
	$(VIRT) $(VIRTFLAGS)$(IF).bin
	
clean:
	rm *.bin
