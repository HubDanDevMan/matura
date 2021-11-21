AS=nasm
ASMFLAGS=-fbin -w+all -O1 -d MAX_SECTORS=8
SRCDIR=src
IF=kernelmain.asm
OF=flamingos.bin
VIRT=qemu-system-x86_64
VIRTFLAGS=-drive format=raw,media=disk,file=
DOCS=$(ls paper/)

VIRTDEBUG=-gdb tcp::1234 -S
DBG=gdb
DBGFLGS=-ex 'target remote :1234'\
	-ex 'set disassembly-flavor intel'\
	-ex 'set architecture i8086'\
	-ex 'break *0x7e00'\
	-ex 'display/4i $$pc'\
	-ex 'continue'
MOBILEFLAGS=-nographic

# DeBuGger FLaGS:
# 1: connect to qemu
# 2: set the architecture to i8086 for 16 bit mode
# 3: set a breakpoint at 7e00, the position AFTER the bootsector has done its job
# 4: display the next 4 disassembled instructions relative to the program counter (IP)
# 5: start single stepping the OS at the breakpoint
######################
# SHORT GUIDE TO GDB #
######################
# si 		-> Single step (1 instruction)
# info reg 	-> show contents of registers
# break *0xbeef -> sets a breakpoint at memory location 0xbeef
# quit 		-> exit
######################
# note that there are NO SYMBOLS available, as the format is .bin
# if the kernel was a PE-file (UEFI BOOT), symbols CAN be available
# but most kernels will strip the symbols


make: $(SRCDIR)/$(IF)
	$(AS) $(ASMFLAGS) $(SRCDIR)/$(IF) -o $(OF)

run: make
	$(VIRT) $(VIRTFLAGS)$(OF)

mobile: make
	$(VIRT) $(MOBILEFLAGS) $(VIRTFLAGS)$(OF)

debug: make
	$(VIRT) $(VIRTDEBUG) $(VIRTFLAGS)$(OF) & \
	$(DBG) $(DBGFLGS)

clean:
	test -f $(OF) && rm $(OF)
	test -f *.pdf && rm *.pdf
	test -f tex* && rm -r tex*

papers: paper/Titlepage.tex
	pandoc paper/Titlepage.tex -o Paper.pdf
