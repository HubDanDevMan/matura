# Processes

A process is defined as a computer program that is currently being executed. A program is a 
series of instructions and static data that are stored as a file on a disc. The instructions
by themselves do nothing, the bytes must first be transformed by the operating system into 
something usable for the CPU. When a program is loaded into memory it becomes a process and 
this can be generalized into four sections:

- The Stack:

The stack contains a data such as method parameters, local variables and return adresses. The stack is use for temporary data.
- The Heap:

The heap contains Memory that is dynamically allocated during the run time of the process.
- The Data

The data is the section containing the static and global variables.
- The Text

The text contains the current activity, this is represented by the value of the program counter it also contains the contents of the processor's registers.

Further iformation on these four sections can be found within the memory chapter.

Processes can be further categorized into what is called aprocess life cycle. The process life cycle is
a categorization of the different states a process or program can be in. A process life cycle can vary
from one operating system to another and the names are also not standardized. The aforementioned 
categorisation consists of 5 different stages:

- Start:

The original state in which a process is first initiated in.
- Ready:

A ready process in in wait for the processor to allocate them via the operating system. Processes will
likely enter this state after the Start state. The other likely reason why a process enters this stage
is because the OS scheduler(part of the operating system that manages CPU allocation to processes) will
interrupt the process to assign the CPU to another process.
- Running:

In this state the process has been assigned the CPU by the OS scheduler and executes its instructions.
- Waiting:

This is the stage in which the process is waiting for a resource such as waiting for a file to become available
or waiting for user input.
- Exit/Terminate:

This is the last state a process enters when it has finished with its execution. The process is then removed
from main memory.

## Threads

Threads are the most basic unit of CPU utilisation, meaning that this is the smallest amount that we can split
the workload of the CPU. Threads consist of a stack, a set of registers and a program counter. Usually a process
is tied to strictly one thread meaning that the CPU does not split the workload over multiple threads. However in
modern programming often multiple threads are used by one process to perform different tasks independently at the
same time.


## Program

A program is a file containing a set of instructions. These instructions can be written in many different 
programming languages such as: Python, C or C++. The CPU however cammpt read these instructions yet they 
first need to be translated into something that the computer can use.


## Executables

### Binary executables

The executable files used on DOS since the 90\' and its descendants (like Windows) use a format called the MZ
executable. The MZ file format has been upgraded multiple times over the course of history. Its latest revision
is called the Portable Executable (PE) and is merely built on top of the MZ format. The extension used for
MZ and PE is typically **.exe** to identify *binary executables* i.e. instructions and data for the
processor. Windows supports most DOS legacy formats due to backwards compatibility. These includes formats
such as **.COM**. The default command line interpreter on Windows CMD is the graphical version of the
text-only DOS command line interpreter and is used to start programs and navigate the system. A program
name can be typed in to the prompt and DOS would execute it. Because the developers of DOS noticed that
typing out the file extension for every program is annoying, they made typing the extension obsolete.
The text editor on DOS was *EDLIN.EXE* but starting the program was done by typing `EDLIN` into the command
prompt. After typing the name of the program into the prompt, the interpreter checks wether the program name
is associated with a **.exe** or a **.com** file and if so, the program would be run and the user was able
to interact with the program until it quits, upon which the user will be prompted again. 

### Scripts

There is also a different type of executables, namely *scripts*. Scripts are written in a human readable
scripting language. They rely on software to interprete the instructions at run time in contrast of
hardware (such as the CPU). The interpreting software is a program that contains instructions for
the CPU. Windows uses the **.bat** or **.cmd** extension for scripts written for `cmd.exe` and for
the newer PowerShell scripts with extension **.ps1** it will use `powershell.exe`. The command line
interpreter will 

### Executables on unix-like systems

Unix-like operating systems differ greatly from Windows NT ones. They rarely rely on extensions to
identify executables but rather *file signatures*. Binary executables unix systems with the exception of MacOS
contain the `\x7fELF` signature. 

# **MORE IN CHAPTER FILES !!!!**

A special type of file signature can be found on
scripts. Even though they are made of plain ASCII characters the author of the file creates the
signature by him or herself. In scripts for Unix-like operating systems the format is as follows:
`#!/path/to/the/script/interpreter -parameters\n` followed by instructions in the scripting language that can
be interpreted by the interpreter specified in the path. The *shebang* ("#!") is the script signature
and tells the kernel that the program is not in a binary format such as ELF (Linux) or Mach-O
(MacOS Darwin), the unix-like counterparts to Windows *.exe* (PE). When the executable is invoked,
the kernel will first invoke the interpreter, which is a binary executable and pass the name of the script
to the interpreter.



Do processes, threads, ipc and daemons(init)[^proc1][^proc2][^proc3]




stuff:
[^proc1]: https://web.archive.org/web/20200916133128/https://pages.cs.wisc.edu/~remzi/OSTEP/
[^proc2]: https://www.tutorialspoint.com/operating_system/os_processes.htm
[^proc3]: https://medium.com/@imdadahad/a-quick-introduction-to-processes-in-computer-science-271f01c780da
https://www.cs.uic.edu/~jbell/CourseNotes/OperatingSystems/4_Threads.html 












