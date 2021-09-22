# The CPU 

The Processor (Central Processing Unit) is often refered to as the brain of a computer. On the
lowest level, it is made of circuits with thousands or up to billions of transistors. In
essence, a CPU reads and writes data to memory and performs operations on it based on the
instructions it receives. There are many different architectures and processor families but
this chapter will explain the most basic inner workings of a processor with a hypothetical
model. We will upgrade our CPU on the run to introduce new features and instructions, but
start off with a simple CPU that has 4 components:

- A Programm Counter (PC)
- Accumulator Register
- An Arithmetic Logic Unit (ALU)
- Random Access Memory (RAM)

The PC is a register that holds the address of the next instruction located in RAM.
First, it is important to understand what a register is. A register is a circuit
that can hold a binary value. The size of register is given in bits or in bytes. Our
registers are 8 bits wide, meaning they can hold any value between 0 and 255. 
Registers can be read and written to and will retain their value until they are
overwritten again. They are located on the CPU and most CPU operations are done *on*
data in regsiters. <br/>
Secondly, it is important to understand that RAM can be addressed by means of *numeric
values*, these values are also called a *memory address* and when the address is stored
in a register, it is called a *pointer*. So the PC is a pointer to the next instruction
in memory. <br/>
Now, the next question arises, what exactly is RAM? RAM is made of many fields that can store
one byte of data. They are similar to registers, in the sense that they hold data, a numeric
value between 0 and 255, until they are overwritten again. In RAM, there is a large number of
those fields while there may only be a few registers present. RAM takes the form of its
own separate hardware, namely RAM sticks. RAM is used by the CPU while it is running, but
once the computer is turned off, all the data present in RAM and in registers is deleted.
One key feature of RAM is that it truly is random access, meaning there is no particular order
in which data has to be stored or retrieved. Each one of those fields has an address and
these fields can contain normal data or also instructions for the CPU itself.<br/>
The accumulator register is just a register that the CPU uses for temporary storage, before
it is either stored in memory or overwritten. Many operations also just work on registers,
if we for example add two numbers, one number has to be stored in a register but the other
value can be stored in memory. In our hypothetical CPU there is only one register, namely
the accumulator.<br/>
The next component is the ALU which is a complex circuit that performs binary operations.
These operations range from arithmetic operations to bitwise operations of. All these
operations are circuits etched in the ALU and a instruction that uses
the ALU will execute as follow:

- Operands are loaded into the ALUs own registers.
- Instruction triggers the correct arithmetic circuits to perform the operation on the registers in the ALU.
- Result is then stored into the destination, our CPU defaults to storing it in the accumulator.

The ALU can be very complicated, depending on which arithmetic operations it supports. Common
ones are addition, subtraction, division, multiplication as well as binary operations like
xoring, anding and bitshifts. Our CPU will receive an ALU upgrade a bit later in this chapter.



Now that we have a basic understanding of the component, let's look at a possible instruction set (= All
instructions a processor can understand and execute):

| Instruction name | Arguments | Encoding |
| --- | --- | --- |
| LOAD | <NUMBER> | \x0F XX |
| ADD | <NUMBER> | \x7C XX |
| STORE | <ADDRESS> | \xE1 XX |

These instructions seems rather weird, haven't we all heard from a young age that
computers work with 1s and 0s? That is obviously true, but a binary instruction
can also be represented in a human readable form. This human readable form of the
most basic CPU instructions is called *assembly language*. The table also features
a column named encoding. Encoding refers the numeric value that the instruction has
and is represented here as a hexadecimal number. In memory, the instruction is 
stored in its binary representation.

Lets look at a instruction located in memory. It is encodes it as follows: `0b00001111 0b00000101`
which in hex is `\x0F \x05` and in human readable consists of the mnemonic
`LOAD` and the operand `5`.

Forward on, we will only use the hex representation and the human readable representation
because the binary one is cumbersome. Most instruction encodings are also numbers that were
chosen pretty randomly with the only requirement being that the encodings don't collide.
If both `LOAD` and `STORE` were encoded as `0F` the CPU would not know which operation to
perform.

So in our case,`\x0F` is the instruction that tells the CPU to `LOAD` a number in the accumulator.
and the `\x05` is the number we want it to hold. When our CPU has finished executing the first
instruction the accumulator holds the right value and the PC is incremented automatically to point
to the next instruction, which is then fetched from memory. Here, the next instruction is the following:

`\x7C \x03` or in human readable form:  `ADD 3`

The `\x7C` instruction triggers the ALU to perform an addition with the accumulator and
the value that followed the `\x7C` instruction, namely the `\x03`, which means that the value
in the accumulator will be updated to 8. The PC is incremented again and the next instruction is
fetched from memory: `\xE1 \x00` which disassembles into `STORE 0`. This instruction stores the `8` 
that is in the accumulator into the memory location `\x00`. This might be surprising, but 0 is a
valid memory address. That small field in RAM now holds the data which is saved for later.

So far we have familiarized ourselves with a cycle called the *fetch, decode, execute cycle*. It 
describes the steps taken for an instruction to be run by the CPU. Fetching is done by retrieving
the instruction from RAM at address held in the PC. Engineers have realized that having instructions in memory that must be repeated take up a lot of memory
and memory was very limited in the early days.

## Jumps and subroutines

Let's assume that a program should run forever. Our primitive CPU lacks such a feature because it
would require an infinite amount of RAM and the PC is a *register* that can only address 255 
instructions. The PC also points to the *next instruction*. What if our CPU allowed operations on
the PC register just like it does with the accumulator? Depicted below is an example of a 
dissasembly. The numbers on the left side display the address of the memory that is being
disassembled and on the right is the instruction mnemonic.
```
0x0 ->
0x2 ->
0x4 ->
0x6 ->
0x8 ->
0xa ->
```


In the early days of computing there was a fellow by the name of Alan Turing which came up with the concept of subroutines and they work by adding or subtracting the PC. Of course, general purpose
computers were not a thing in the early 50s. Turing merely described the concept of subroutines
and even stack based return adresses which we wil cover later.
