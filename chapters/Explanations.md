# Glossary
The world of computers is a fascinating but vast world. There are many different concepts in computer science and all of them are named.
Here are some of the more frequently used terms, some will be explained in great detail bit later if they are important.

| **Term** | **Explanation** |
| ---- | ---- |
| **Hardware** | Physical device/part of a computer. Examples are: <br/> - processor (CPU) - harddisk - keyboard - mouse |
| **Software** | Umbrella term for instructions and data for a computer. In its usual unit it is referred to as a *program*. A computer is ***made*** of *hardware* that can ***execute*** *software*. |
| **Programming language** | *Human readable*, formal language that allows programmers to write software. It can not be executed by a computer directly. Examples of programming languages are C, Java and Python |
| **Machine code** | *Processor readable* translation of a programming language. It is humanly unreadable because it is does not use characters but rather binary CPU instructions. It is the numeric value of a *CPU instruction*. |
| **Compiler** | A program that translates a programming language into machine code. |
| **CPU instructions** (opcode)| The most fundamental, simple operations that can be done by a processor, such as addition, multiplication, binary-xor). They are encoded in bytes and depending on the instruction set architecture can be multiple bytes long. More in chapter "The CPU" |
| **Instruction set architecture**(ISA) | An abstract computer model. Hardware that executes the ISA is an implementation of that ISA. Said ISA describes many low level CPU components and concepts such as CPU instructions and registers. Further explaine in chapter 'The CPU'. |
| **Operating system**00 (OS) | A program that manages the hardware and system respurces as well as a user interface. It provides a layer of abstraction for application programs. Examples of OSes are Windows 10, MacOS, Android and Ubuntu. Because operating systems are the central part of our project this booklet will explain the inner workings and components of an OS. |
| **Data structures** | Ways of organizing, accessing and finding data. Examples are: <br/> - _Arrays_: Items of single data type stored sequentally in memory. - _Linked list_: A list where the first element (a.k.a *head*) element points to the memory address of the next element, which will also point to the its next element et cetera. |
| **Protocol** | It can be seen as a language or grammar used in communication between programs or firmware. A protocol defines rules, syntax and synchronisation for communication. Examples are *http*, used between web servers and browsers or SMTP, the simple mail protocol used by e-mail servers. Hardware/firmware protocols are used to discover newly attached peripheral devices or for sending commands to devices. |


## Good to know

It is important to point out that every number can be described in another base. A base ten number can also be represented
as a binary number and vice versa. Computer programmers often work with base two due to the fact that computers support only a 
binary digits: _ON_ (1) and _OFF_ (0). 
This booklet will convey numbers with their base. All base 10 numbers used will not be prefixed, i.e. 26, 8, 124 and so on. 
Hexadecimal representation is prefered by may programmers and used here because hexadecimal numbers are easier to represent 
numbers in binary. There are less characters required to represent a number in base 16 than base 2. Numbers represenred in 
base 16 are prefixed with a '0x', examples are 0x5a (90), 0x7c00 (31744) and 0x200 (512). Hexadecimal notation is often used to
express memory addresses. Whenever binary numbers are displayed they are prefixed with a '0b', examples of it being 0b1001 (9) 
and 0b11001010 (202).

Srings are literal text for a computer. They can be seen as an array of characters, such as 'A', 'k' and '\*'. Characters are
associated with a numeric value. 'A' is equivalent to 0x41 (65). Sometimes strings contain characters that are not associated with a glyph. 0x42 represents a 'B' but 0x12 equates a charachter that is nowhere to be found in the alphabet, number characters (0-9) and other symbol lists such as `.,:;_+-*/=#$@%&!(){}[]` and alike. These characters are represented by an escape sequence, usually a backslash. Depicted below is a table with the most common escaped characters as well as their numeric value and their purpose:
| Character | Numeric value | Description |
|------|------|------|
| **\n** | 0xa | Newline character  |
| **\0** | 0x0 | Null-terminator used to mark an end of a primitive string |
| **\xf0** |  0xf0 | Hex escape sequence can represent any numeric value between 0x0 and 0xff (255), a 1 byte value |

There are a few more but these will not be encountered in this booklet.
