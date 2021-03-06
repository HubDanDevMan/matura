# FlamingOS Repository

### Original Authors:
- Daniel Huber
- Nick Gilgen
- Moray Yesilgüller

### License:
GPL-v3.0-only
All the source code, Makefiles and Files in this directory
***with the exception of the license text*** are licensed
under the GPL-v3.0-only.
Full licensetext available in LICENSE file.

### Preamble

We are students of Kantonsschule in Baden (CH) and this is our
Maturaarbeit(MA). A MA is a graded task where students plan and
create their own project that they will (hopefully) accomplish
within ~9 Months. The project should pose a challenge to students
and most importantly result in skill improvements such as
- General project management
- Time management
- Team work and coordination
- Complience with school and scientific guidelines
- Endurance

We decided to create an operating system not only because it is
difficult but also because we are genuinely curious in learning
more about the technologies we treat as "black boxes" but use
every day.
We hope that this project inspires technology enthusiasts to
create their own projects and for readers to learn something
about operating systems.

### High-level overview: 

| File or Directory | Content |
| --- | --- |
| src/ | Higher level Files such as <br /> - bootloader<br /> - filesystem <br /> - interrupts <br /> - stringformats <br />- kernelmain <br /> |
| lib/ | Various functions to be used in dynamic linking of programs |
| macros/ | Includes various macros to make code more readable <br /> and less repetitive |
| test/ | Test file with debug functions and build file to quickly test and debug code |
| assets/ | Images and similar files |
| demos/ | Finished test programs that fulfill their purpose (e.g. graphics rendering, ) |
| Makefile | File to build source. See [Build](##Build) |
| README.md | This file |
| LICENSE | Full license text |
| Conventions.md | Guide for readable and elegant code |
| Arbeitsjournal.md | Weekly student's work log of this project |
| TODO.md | Upcoming changes that should be made |

### Requirements

Some external programs are required to build the different components
of this project from source. 

The building process is automated with `GNU Make` 

In order to build the operating system, the only
program required is `nasm`. It is cross platform and has been tested
successfully in this project on Windows, Mac and Linux.

To emulate the OS directly, the `qemu` package is required,
specifically `qemu-system-x86_64`. It also works on all three major
platforms, although on Windows a VNC client is required.

For building the paper, `pandoc` is used. It is cross platform, but
has not been tested yet in the context of this project.

Nasm only works on x86 machines but qemu and pandoc work
on ARM machines aswell.


### Build

To compile, go into the top level directory and type `Make`.
If you want to run the OS directly in QEMU (virtual machine)
type `Make run`.
Cleaning is not really necessary, because there is no use of
header files in assembly language. There are also no intermediate
build files.
You can also build the paper with `make paper` which creates a PDF
with all the chapters, including images, from scratch.

### Contribute
Commits to this repo are currently only accepted if they're from the
original authors, but you are welcome to fork this repo and make changes
under the terms of the license. 

 

