\section{Filesystems and resource management$

As mentioned before, one of an operating systems tasks is the managing of resources.
One of those resources is storage. There are 3 main reasons why storage (and many other
hardware devices) are hanlded by the OS.

1. The OS provides a layer of abstraction for the running application programs
2. Talking to the hardware reqires a certain privilege level (IO privileges).
3. Operating systems provide consistency across all files, users and processes.

We will look at them in greater detail further in this chapter.
But first, we will have a look at what a filesystem actually is. Remembering file names is easier for
humans than remembering the physical location of the file on the storage medium. Filesystems handle
the numbers and metadata of the file and the mapping of file names to actual file contents. It
controls and organizes how data is stored and retrived from a storage device. It structures a storage
device in files and directories and their metadata. Modern filesystems also provide mechanism for
error detection and encryption.

\subsection{Storage devices}

Storage devices such as hard disks, floppy disks, USB flash drive and SSDs have no notion of files.
The only thing these devices know are *sectors*. Sectors are the smallest container a storage device
can work on and they can usually hold 512, 2048 or 4096 bytes of data. These devices are attached to
the computer through IO ports, sometimes in the form of SATA connectors or USB slots, where they can
receive commands from the CPU on the system. A command can be to `READ` sector number ***x*** to RAM
address ***y*** or `WRITE` from RAM addres ***y*** to sector ***x***. This command is sent through
specific IO pins from the CPU to the storage device. The device then executes the command or returns
an error if for example sector ***x*** is not a valid sector. Remembering which files are located on
which sector numbers is tedious for both humans and computers. This is where filesystems come to help.

\subsection{The superblock}

The heart of the file system is a datastructure that contains every single file and directory: the
superblock. It holds the _metadata_ (i.e. data about data) about every single file/directory,
including its location on the storage device and additional information such as permissions, creation
and modification date but not the contents of the file itself. Said metadata of a file/directory is
grouped in together in a structure called *inode*. Every inode is of equal size and is associated
with an inode number. In essence, the superblock is an array of inodes, where the inode number is the
array index. Having files being uniquely identifiable by an inode number instead of a filename allows 
the use of *hard* and *soft links*. In a nutshell this means that a file can have multiple filenames.
This can be useful in cases where some programs expect a certain path for another program than the
present one on the system. For example a *makefile* expects the program *cc* (the C compiler) in
`/usr/bin/cc`. there are many different C compilers and they have different names. Let's say that the
users C compiler is GCC and located at `/bin/gcc/`. A soft or hard link can be created to maps the
filename in path `/usr/bin/cc` to `/bin/gcc`. If files were associated only by their name and not 
their inode number, links would not be possible and the OS would have to copy the the entire
executable GCC to the new location and store it under a different file name. Links allow the
filesystem to effectively safe storage space and thats why modern filesystems use inode numbers to
identify a file. In our case the whole space of the superblock is allocated upon disk formatting.
This leaves the possibility of 'running out of space' without the storage device being even remotely
full. This occures when all the inodes in the superblock are used up. This happens only when a
computer user creates many files that take up close to no space.

It is important to point out that Windows' NTFS groups file metadata differently. We are not going to
cover NTFS because the official version is proprietary. While most mechanism in NTFS are similar to
unix filesystem mechanisms, they often have a different name. The superblock is called the *Master
File Table* and inode numbers are called *FileID*s.

\subsection{Sector allocation}

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
represented in a bitmap than going through a linked list. The bitmap is also a lot faster, because a
copy can be stored in RAM for faster editing. Lastly, there is the *tree* but because it is used in
many different forms, namely *b*-tree or *b+*-tree etc., it will not be explained in this booklet.
Nonetheless, it also keeps track of used and unused sectors.

\subsection{Primitive filesystems}

To understand why these data structures ara needed to make a good filesystem we will start off with a
mediocre filesystem and add components to make it better on the run. This allows us to comprehend the 
reasoning behind the incorporation of the components that make up modern filesystems.
Let's have a look at a simple filesystem that stores all the files sequentally on the storage device,
starting from sector 0. This might seem like a good idea, but when we want to retrieve a file from
such a filesystem (now *FS* for short) we would not know where it is located exactly. We would know
what the first files position is, namely the first sector of the medium but we can't know the files
length and therefore we won't now the  position of the following files. This is where a key component
comes into play: the _superblock_. It is an array of inodes and our primitive FS stores the name of
the file in the inode itself together with other metadata. Our FS supports now various files and
because it works so well we start to organize our files. But organizing files without FS support for
directories is pretty much impossible. We decide to treat directories as regular files except that we
add a flag in the inode that marks it as a directory. In these _"files"_ we can store the inode number
of files that are stored in the directory. Now we need to add mechanisms for *path traversal* i.e. the
ability to specify the position of a file that is nested within multiple directories. This is done by
checking all the inodes in the directory until a file name matching an inodes file name field is
found. If the path traverses multiple directories, the previos step of looking for inodes with a
matching file name is done recursively.

\section{IMAGE OF PATH TRAVERSAL}

\subsection{For readers used to Windows, the path separator "/" is equivalent to the backslash "\" on Windows}


After using the filesystem for a while, we notice that storing the file name in the inode itself is a
dumb idea because an inode is of fixed size. We either preallocate a large inode size for a filename
or we force short file names to safe storage space. This is very restrictive but there is a solution.
Instead of storing the file name in the inode, we store it in the directory where the file is located
together with the inode number. This means that the contents of a directory entry file would look some
thing like this:
`'f' 'i' 'l' 'e' '.' 'm' 'd' '\0' '\x16'  'I' 'm' 'a' 'g' 'e' '.' 'p' 'n' 'g' '\0' '\x19'`
Every character between '' represents a byte on the disk. Notice the `'\0'`, it is our file name
terminator and tells us that the following byte is to be interpreted as an inode number. After the
inode number, the name of the next file starts and it ends with the next `'\0'`, which is again
followed by the inode number of the file. If the byte after an inode number is a `'\0'` the FS knows
that the directory doesn't have any more files.

Let us recap what we have so far.
We have the superblock that contains metadata about files in per-file inodes. The inode stores the
location of a file on the disk and contains a field that describes wether it is a regular file or a
directory. The directory contains the file names and the inode numbers of the files and subdirectories
that are inside the directory. To find a file the path (such as `Pics/Party/Kodak/img_012.png`) can
be used to find the inode of the corresponding file and then the file location on the storage medium.

Our FS is very advanced now. Nonetheless, some things must be cleared up first. Because the name of
a directory is stored within its *parent directory* (the directory that contains the subdirectory)
there must be a directory that does not have a name, because it does not have a parent directory
(unless there are infinitely many directories or a circular filesystem). This directory is the *root
directory* and every other directory is either a direct or indirect subdirectory. The root directory
is often shown as a plain "/". Windows users can think of it as the "C:\" drive but it is actually not
entirely the case. We will explain why shortly, but there are some things that are important to know
first. If a path starts with the "/" such as "/home/Terry/tasks.txt" then the path is an *absolute
path*. There is also a relative path and it depends on the *current working directory*. Let's say that
a program is run from "/home/Terry/". The current working directory is the aforementioned one. If the 
program wants to read the file "homework.txt" it can use the relative path to specify the file it
wants to read. The full path of the file is actually “/home/Terry/homework.txt“ but because the OS
knows the current working directory (cwd) it can resolve the inode number of the file. Relative paths
are very convenient but they still lack afeature in our FS. If we want to specify a path of the parent
directory that does not traverse the cwd we must give the absolute path of the parent directory and
then the following subdirectories. But this is another issue that can be solved. Every directory
contains at least 2 entries (with the exception of the root directory). These are "." and "..". The
"." is a directory entry file that points to itself. An example to understand it better is lets say
directory "/home/Terry/Pics" has the inode number 8 and its parent directory has the inode number 6.
The directory entry file will contain the following:
`'.' '\0' '\x08' '.' '.' '\0' '\x06' '\0'`
The first entry in the directory "." points to the itself! This means that in a relative path a "."
will always point to the directory itself. From a viewpoint in "/home/", "." is equal to "/home/".
This is not very spectacular but if you look at the file directory above you can see that ".." points
to a file with inode 6. This is the parent directory of ".". This is where it gets interesting. A
relative path can now contain a ".." and now we are able to give a relative path of every single file
on the filesystem. "../../" is the path of the parent's parent directory. Unlike the "..", the "."
does not have an effect on the path. "../pictures/pic.jpeg" is equal to "../pictures/././pic.jpeg".
The "." does have its usecase but it is largely to reasons unrelated to filesystems themselves.
More about "." and its purpose can be read in another chapter. With our fully fledged FS there are
also some speed improvements. If we would like to move a file from "pics/" to the parent directory the
FS only has to delete the entry of the <file to be moved> from the "pics/" directory entry file and
write the file name and inode number into the directory entry file of "..". This is a lot faster than 
copying the contents of the <file to be moved> and writing them to a new file and deleting the old
file. This FS also allows the renaming of open files, something that Windows still cannot do reliably. Windows will queue the
name change and commit it only after the file has been closed.

\subsection{Journaling filesystems}

Readers that have worked on old machines with primitive filesystems maybe have encountered one of the
most annoying things when trying to get work done: A crash. Back in the days a crash could mean that
the subsequent rebbot of the system took hours to complete. This is because the system crashed while
something was being written to disk and resulted in filesystem corruption because of an unfinished
write operation to the storage medium. Usually this was just an issue when a write access to the
superblock or other filesystem specific data structures was interrupted unexpectedly. In that case a
time consuming disk recovery had to be run to find and fix the error. Journaling file systems came to
fix the issue. A new area on the disk got assigned to the *journal file*. Whenever a write operation
to the disk is queued the FS will write the write parameters to the journal. This includes the sectors
that should be written to and the length of the data to be written to the storage medium. After the
write operation has been completed successfuly the FS clears the journal by overwriting it. Whenever
the system boots up the OS again the filesystem will first check the journal and if it finds an
unfinished query listed in the journal it will just fix the query. There is no need to check the
entirety of the FS and if the journal is empty the OS can just continue starting up normaly.
The journal file is not really a file but rather just a few sectors at a fixed location totaling a
fixed size for faster access times. Regular files might move around on the disk if they grow in size
or some other cases. 


