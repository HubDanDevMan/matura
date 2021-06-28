# Interrupts

One of the key features of modern processors is theability to support *interrupts*.
Unlike many other processor features interrupts are not an arithmetic operation but rather the ability of a processor to *respond to a event*. 
In practice this means that a processor may be running a program and an event, such as a pressed key, 
*interrupts* the execution of the program and invokes a handler for the event. The handler will run and upon completion the processor will resume execution of the program.
