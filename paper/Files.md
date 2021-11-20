# Files

One of the most convenient and widely used features provided by operating systems are files. Files in
the traditional sense are persistent sequences of bytes associated with a *file type*. A traditional
file is stored on a storage medium such as a hard disk and is *remembered* by the computer unless it is
instructed to delete it. Traditional files can contain an arbitrary amount of data only limited by disk
space and filesystem support.


## File signatures

Magic numbers are more or less arbritarily chosen
numberic or textual constanst used across most of computer science but in the context of files
they are seen as *file signatures*. Every file that has a special format such as JPEG, MP3, ZIP,
PDF as well as ASCII-text. There are obviosly many more but these are very common. Most files
of the aforementioned format have a specific file signature, a magic number located within the first
few bytes of the file. It can be thought of as file extension stored in the file itself and not in
the file name (metadata). The only difference is that extensions differ from the file signatures.
Here is a small list of file signatures:

| File type | Signature |
|----|----|
| JPEG | &#255;&#216;&#255;&#219; |
| MP3 | &#255;&#251; |
| ZIP | PK\\x03\\x04 |
| PDF | \%PDF- |

Whenever a user opens a file from Finder on MacOS or any similar file manager that does not contain a
file extension it will open the file with the correct program nonetheless. One problem arises, namely
ASCII has no directly associated file signature with it and script files as well as PDF files have an
ASCII file signature. If a user was to write a file that *accidentaly* contained a filesignature used
for a non-ascii format such as `%PDF-`for PDFs, the file manager will try to open the file in a PDF
file viewer. The file will be interpreted incorrectly and seem corrupted. This is why using file
extensions is still a good idea, even in operating systems that support extensionless files.

## Executables

Executables are files that can be *run*. They are sometimes called *programs* but executables refer
strictly to the files, specificly files containing *instructions and data*. Whenever their name is
typed into the command prompt, the executable is run and when finished, the user will be returned to
the prompt. However, there are multiple types of files. A JPEG image is a excellent container for
photographs and pictures but it is a terrible format to store instructions and data for a computer.
It is a bad idea to execute a JPEG file because the instructions contained within the file are garbage
at best or nefarious (such as malware) at worst. Operating systems have mechanisms to deter users from
running non-executable files but the OS itself has to know wether a file is runnable or not. These files
are identified in some operating systems by their _extension_ or their _file signature_. An extension is
a small appendix to the file name. It is of format `filename.extension`. The Windows NT family of operating
systems relies heavily on extensions to differentiate between executables and regular files. 

## Pseudofiles

Because files are organized and structured in hierarchical filesystem, some operating systems use special
files that are actually *interfaces* to *device drivers*. In practice this means that a special file can
refer to a file that when `read` and `write` operations are performed on it, a driver intercepts the regular
read and write commands and performs the operations not to a regular file but rather to a device. In unix-like
OSes there a myriad of device files located in the `/dev` directory. Hard disks are named in `sd*` where `*`
is an alphabetical character in order that the OS detected the device. `/dev/sda` is the first hard disk,
`/dev/sdb` is the second and so forth. Accessing hard disks through `/dev/sd*` allows *raw* access to the
device instead of the traditional file system interface where files are stored according to the filesystem
structure. There are other special files in `/dev`such as `/dev/mem` that allows access to the whole system
memory. Additionally there are input devices such as `/dev/input/mouse*` where `*`is the number in which the
mouse was detected at startup. Mouse devices are a *character device* which means that operations are performed
bytewise. Reading from `/dev/input/mouse0` allows a user or a program to view the bytes that are send from the
mouse device. A display server (more in chapter Userinterfaces) reads from this device via the device file
interface. The *"files"* located in `/dev` are not only device interfaces, there are so called *pseude device files*
as well. An example of those is `/dev/null`, which is essentially the garbage bin or trash. Writing to `/dev/null`,
the data is simply discarded and can not be recovered be reading from it. Reading operations are not implemented for
the Null-device. Another infamous device file in this directory is `/dev/urandom` or in some OSes `/dev/random`. Urandom is a pseudo device file
that only supports the `read` operation and returns random data. It is frequently used to seed random number
generators or to generate cryptographically secure keys. Writing to Urandom is also not permitted. The kernel regularly
adds random data such as mouse input and alike to Urandom and performs cryptographical operations on the data to make
it seem more random. Every `read` operation alters the content in Urandom and reading multiple times from it yields
different data. This pseudo device interface makes it very practical to get random numbers.
Windows also has device files and pseudo device files but they are not necessarily located in a directory, depending
on the system configuration. The Windows 10 device file structure can be accessed with help of the *WinObj* tool which
implements the `\\?\Device` folder[^windev]. WinObj used the WindowsNT native API internally but allows access to device interfaces
via file paths. For example, a raw hard disk partition can be accessed by writing to `\\.\Device\Harddisk*\partition#`
with `*` being the number of the disk in which it was detected at startup and `#` referring to the partition number.
Many special files in unix-like operating systems also exist in Windows, although named differently. Compatibility layers
such as `zerodrv`implement drivers for unix-like equivalent special device files `\\?\Device/zero` and `\\?\Devices\null`
on Windows.

[^windev]: https://superuser.com/questions/1204522/dev-sda-equivalent-in-windows
### Character devices
### Block devices
