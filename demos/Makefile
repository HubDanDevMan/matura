AS=nasm
ASMFLAGS=-fbin -w+all -O1
INCL=firststage.asm
VIRT=qemu-system-x86_64
VIRTFLAGS=-drive format=raw,media=disk,file=
VIRTDEBUG=-gdb tcp::1234 -S
DBG=gdb
DBGFLGS=-ex 'target remote :1234'\
	-ex 'set disassembly-flavor'\
	-ex 'set architecture i8086'\
	-ex 'break *0x7e00'\
	-ex 'display/4i $$pc'\
	-ex 'continue'
	#-ix ../misc/gdbRealModeScript.txt
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



default:
ifeq  "$(origin IF)"  "undefined"
	@echo "\033[31mUse make IF=DIRNAME [run]\033[0m"
	exit 1
else
	$(AS) $(ASMFLAGS) -p $(INCL) $(IF)/$(IF).asm -o $(IF).bin
	@echo "default target done"
endif

# runs IF
run: default
	$(VIRT) $(VIRTFLAGS)$(IF).bin

debug: default
	$(VIRT) $(VIRTDEBUG) $(VIRTFLAGS)$(IF).bin & \
	sleep 1 # waiting for QEMU
	$(DBG) $(DBGFLGS)


clean:
	rm *.bin
