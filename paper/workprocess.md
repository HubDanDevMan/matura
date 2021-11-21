\section{Workprocess}

\subsection{Workflow}

Our first step was deciding what our project should look like. We knew that we wanted to do something related to computer science, but we were still uncertain of the details. 
Rather spontaneously did we decide to make an operating system. The exact content of our matura project was decided after we talked to several different teachers. We 
appreciated their oppinions and we were warned of the adversities we would have to face if we chose to go through with it. The first challenge was to find find a teacher 
willing to oversee our project because we decided to write the operating system in 16-bit assembly. None of the teachers were familiar enough with assembly language, since
it is an old and nowadays rarely used programming language. Nonetheless, we embraced the challenge after we talked to Dr. Günther Palfinger. He was kind enough to accept our 
request and oversee our project. After a few weeks Dr. Palfinger reviewed the contract we set up where we decided on the terms and conditions. The second challenge was 
getting to know the assembly language. We started the research on the programing language and computer science in general even before we finished the contract. It was rather
tough in the beginning because assembly is not comparable to high-level languages like python which we picked up in school. Assembly language is much more intricate considering 
that it is closer to machine language which is the language understood by a computer. We had to invest the first two to three months into research to comprehend the basics
of the language. Afterwards we each chose a task and started researching these specific topics individually. We listed the websites we used under the chapter "Sources".

\subsection{Tools}

Before we began programming we installed a virtual machine that 
allowed us to run Linux even though our host operating systems were either Windows or macOS. By using a virtual machine we protected our hardware from our own mistakes. The 
command line is a powerful tool that can, if used incorrectly, break your software and even hardware. But thanks to the virual machine we were able to isolate our host 
operating system from our working environment which was especially important as we were new to using the command line. Furthermore Linux is commonly used by specialists 
meaning that there are a lot of guides and tutorials to help beginners. On top of that there are more and usually better convenient, free and open-source applications. We 
then installed the Netwide Assembler or NASM for short which, as the name suggest, is an assembler. It translates the assembly source code into machine language
so that the hardware can read and execute the program. Additionally we installed QEMU, a software that allowed us to emulate an entire computer system. QEMU enabled us to 
test our programs quickly and efficiently. To write our code we used neo vim which is a text editor focused on extensibility and usability. 
It can be an extremly powerful text editor if the user has experience. While neo vim takes some getting used to it also provides the user with convenient shortcuts. 
Sometimes our code was faulty and we needed to debug it. For convience's sake we used an online debugger called GDB. This website provided us with quick and easy access to 
a reliable debugger. In order to save time and for simplicity and consitency we also used the make utility. We created a Makefile that contains instructions for building, 
emulating and debuging software. The command make executes the Makefile in the current directory and is followed by the name of the target(s). In our project the Makefile 
launches NASM, translating the source code, and then QEMU, emulating the operating system according to the parameters defined in the Makefile. 
