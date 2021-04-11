The CPU

The Processor(Central Processing Unit) is often refered to as the brain of a computer. In essence,
a CPU reads and writes to memory and performs operations on it, based on the instructions it receives.
There are many different architectures and processor families and this chapter will explain the basic
inner workings of a processor.

We start off with a simple, hypothetical processor* that has 4 components:
*(The CPU will be upgraded on the run to support more instructions and extensions)

1. A Programm Counter (PC)
2. Accumulator Register
3. An Arithmetic Logic Unit(ALU)
4. Random Access Memory(RAM)

The PC is essentially a counter that points to the next instruction in RAM.
Let's assume, this is a 8 bit CPU, that means we have a 8 bit wide PC aswell
as 256 bytes of RAM. Our PC can store any number between 0 and 255. Whatever
the value in the PC is will be the next instruction that the cpu executes.
Lets look at a possible instruction set (= All instructions a processor can
understand and execute):

| Instruction name | Arguments | Encoding |
| --- | --- | --- |
| LOAD | <NUMBER> | ** |
| ADD | <NUMBER> | ** |
| STORE | <ADDRESS> | ** |

This instruction seems rather weird, haven't we all heard from a young age that
computers work with 1s and 0s? That is obviously true, but a binary Instruction
can also be represented in a human readable form. Our hypothetical CPU encodes
it as follows:

1111000 00000010
which in hex is
0F 05
and again human readable consists of the mnemonic
LOAD and the operand 5

Forward on, we will only use the hex representation and the human readable representation
because the binary one is cumbersome.

So 0F is the instruction that tells the CPU to STORE something in the ACCumulator.
and the 05 is the number we want to store in it. But what is the Accumulator Register?

A Register is a small, very fast memory container that is located ON the CPU. In this
case it is 8 bits wide. The Accumulator holds a value that the CPU will perform an
operation on right now. Now it has the value 5 in it. Our CPU has finished executing
the first instruction. The PC is incremented and the next Instruction is fetched
from memory. The next instruction is the following:

7C 03    or in human readable form:  ADD 3

The 7C instruction triggers the ALU to perform an addition with the accumulator and
the value that followed the 7C instruction, namely the 03, which means that the value
in the Accumulator will be updated to 8. The ALU can be very complicated, depending on
which arithmetic operations it supports. Common ones are addition, subtraction, division,
multiplication aswell as binary operations like xoring, anding and bitshifts.

The following image displays a rather simple 4 bit add-gate and an xor gate. Division is
a heavy arithmetic operation that actually requires multiple CPU cycles for it to be executed.
Division logic also massively increases the complexity of an ALU. But for now, our ALU is a
simple adder. 
	


