
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
- Exit/Terminate:


## Program





Do processes, threads, ipc and daemons(init)




stuff:
https://web.archive.org/web/20200916133128/https://pages.cs.wisc.edu/~remzi/OSTEP/
https://www.tutorialspoint.com/operating_system/os_processes.htm
https://medium.com/@imdadahad/a-quick-introduction-to-processes-in-computer-science-271f01c780da













