# Filesystems and resource management

As mentioned before, one of an operating systems tasks is the managing of resources.
One of those resources is storage. There are 3 main reasons why storage (and many other
hardware devices) are hanlded by the OS.

1. The OS provides a layer of abstraction for the running application programs
2. Talking to the hardware reqires a certain privilege level (IO privileges).
3. Operating systems provide consistency across all files, users and processes.

We will look at them in greater detail further in this chapter.
But first, we will have a look what a filesystem actually is. It controls and organizes
how data is stored and retrived from a storage device. It structures a storage
device in files and directories and their metadata. Modern filesystems also provide mechanism for
error detection and encryption.

## Storage devices

Storage devices such as hard disks, floppy disks, USB flash drive and SSDs have no notion of files.
The only thing these devices know are *sectors*. Sectors are the smallest container a storage device can work on
and they can usually hold 512, 2048 or 4096 bytes of data. These devices are attached to the computer through
IO ports, sometimes in the form of SATA connectors or USB slots, where they can receive
commands from the CPU on the system. A command can be to `READ` sector number ***x*** to RAM address ***y***
or `WRITE` from RAM addres ***y*** to sector ***x***. This command is sent through specific IO
pins from the CPU to the storage device. The device then executes the command or returns an
error if for example sector ***x*** is not a valid sector. Remembering sector numbers is tedious, for both
humans and computers. This is where filesystems come to help.

## Primitive filesystems

Let's look at a simple filesystem that stores all the files sequentally on the
storage device, starting from sector 0. This might seem like a good idea, but when we want to retrieve a file from
such a filesystem (now *FS* for short) we would not now where it is located exactly.
We would know what the first files position is, namely the first sector of the medium but we don't know the files
length and therefore we won't now the  position of the following files. This is where a key component comes into play.
The _superblock_ is an array, usually located at the beginning of a storage device, that holds the _metadata_
(data about data) of files. A superblock entry may hold the name of the file, it's starting sector number and flags
such as owner ID and permissions (_read_, _write_ and _execute_). Whenever we want to read a file from disk, we check
the superblock first and find that the file we are looking for is located on sector _x_ and has size _y_. The CPU
instructs the device to `READ` _y_ sectors starting from sector _x_ into a specified RAM address.
