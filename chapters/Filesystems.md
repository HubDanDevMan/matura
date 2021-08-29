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
The only thing these devices know are *sectors*. Sectors are the smallest container a storage device
can work on and they can usually hold 512, 2048 or 4096 bytes of data. These devices are attached to
the computer through IO ports, sometimes in the form of SATA connectors or USB slots, where they can
receive commands from the CPU on the system. A command can be to `READ` sector number ***x*** to RAM
address ***y*** or `WRITE` from RAM addres ***y*** to sector ***x***. This command is sent through
specific IO pins from the CPU to the storage device. The device then executes the command or returns
an error if for example sector ***x*** is not a valid sector. Remembering which files are located on
which sector numbers is tedious for both humans and computers. This is where filesystems come to help.

## The superblock

The heart of the file system is a datastructure that contains every single file and directory: the
superblock. It holds the _metadata_ about every single file/directory, including its location within the filesystem and information such as permissions, creation and modification_date. 

## Sector allocatiom

Another importand data structure in filesystems is used by the *sector allocator* to keep track of the
occupied and free sectors of the disk. It is important to keep track of which sectors are in use and
which are unused. This data structure is usually a _linked list_,_bitmap_ or some form of _tree_. The
linked list approach is a common one. Every sector is an item in the list and contains the location of
the next free sector *a.k.a* next item in the list. The filesystem will only have to remember the
location of the first free sector. But if a sector that is part of the linked list gets corrupted due
to *data rot* (the decay of data on storage devices due to radiation or age), the whole rest of the
list (free sectors) is lost. Redundancy of the data structure that keeps track of the free sectors is
crucial in modern filesystems. Copying a linked list is easier said than done and thats when bitmaps
come into play. Bitmaps are easy to copy and mantain and are more reliable than linked lists. They
take up more space than linked lists because the filesystem keeps track of every single sector on the
disk within the bitmap. Tha bitmap can be thought of as an array of ***N*** bits where ***N*** is the
number of sectors (512, 2048 or today 4096 bytes). Every sector on the disk is enumerated and it is
represented in the bimap (a.k.a *bit array*) at bit number ***N***. Said bit in the bitmap will be
either 1 (free) or 0 (empty). Whenever a new file has to be written to disk, the filesystem will check
wether there is enough space on the disk and figure out which sectors it can allocate to the file.
Because storage devices are optimized to read sectors sequentally, the bitmap implementation of a
sector allocator can result in faster read/write speeds because it is easier to find sequental sectors
represented in a bitmap than going through a linked list. The bitmap is also a lot faster, because a copy can be stored in RAM for faster editing. Lastly, there is the *tree* but because it is used in many different forms, namely *b*-tree or *b+*-tree etc., it will not be explained in this booklet.
Nonetheless, it also keeps track of used and unused sectors.

## Primitive filesystems

Let's look at a simple filesystem that stores all the files sequentally on the storage device,
starting from sector 0. This might seem like a good idea, but when we want to retrieve a file from
such a filesystem (now *FS* for short) we would not now where it is located exactly. We would know
what the first files position is, namely the first sector of the medium but we don't know the files
length and therefore we won't now the  position of the following files. This is where a key component
comes into play. The _superblock_ is an array, usually located at the beginning of a storage device,
that holds the _metadata_ (data about data) of files. A superblock entry may hold the name of the file,
it's starting sector number and flags such as owner ID and permissions (_read_, _write_ and _execute_).
Whenever we want to read a file from disk, we check the superblock first and find that the file we are
looking for is located on sector _x_ and has size _y_. The CPU instructs the device to `READ` _y_
sectors starting from sector _x_ into a specified RAM address.


## The file structure

Another critical filesystems componen[ or rather integration method is the support of multiple
superblocks. The superblock is an array of Inodes, Inodes representing a file/directory within a fi)thysy stem.
