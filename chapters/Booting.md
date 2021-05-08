# Booting
Whenever a computer starts up, there is a fixed set of instructions that
have to be performed to initialize the system correctly. This routine is
called a system startup. In IBM-PC compatible systems, the system startup
is done by the Basic Input Output System (BIOS). The BIOS is firmware
that is stored on the motherboard and executed. One of the BIOS's main
tasks is doing the Power-On Self-Test which checks the presence and the
integrity off hardware components such as the processor, RAM, keyboard,
GPU as well as storage devices. If system critical components such as 
RAM or the processor are not present, the PC speaker will let of a beep
and turn off. After a successfull POST, the BIOS will write some basic
information of the hardware into the Bios Data Area (BDA). The BDA is a
data structure that is located in memory at location 0x400-0x4FF and
can be read later by the operating system. Slightly newer BIOSes also
write to the Extended BDA where more modern hardware information can be
found. Afterwards, the BIOS configures hardware such as the system clock
to keep in sync with time and sets up interrupt handlers (more about
interrupts in chapter XXXXXXXX). Finally, the BIOS will search all the
attached storage devices for a bootloader sector. The search order can be
set in the BIOS's settings. Identifying a bootloader sector of a disk is
done by comparing the 511. and 512. byte of the first sector of the disk
with the values 0x55 and 0xAA respectively. These values were initially
arbitrarily chosen by the original equipment manufacterers as the 
identifying number for bootsectors. When the BIOS finds a valid
bootloader sector, it will load the entire sector into RAM at the fixed
location 0x7C00. Yet again, this value was chosen randomly by the OEM's
back in the 1970s but to this day, IBM-PC compatible systems will load
the bootsector into that location. After a successfull load, the BIOS
will transfer control to the bootloader by telling the CPU to fetch
instructions from location 0x7C00.


# Bootloader

