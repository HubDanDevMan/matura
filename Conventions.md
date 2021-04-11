# Coding convetions for FlamingOS

| Type | Examples |
| --- | --- |
| constants: ALL_CAPS_SNAKE_CASE | ENDL, REF_COUNT |
| function labels: camelCase | `call writeDisk`<br/>`call getFileName` |
| local labels (loops etc.): .label | `.loop`<br/>`jmp loop` |
| stringlabels: nospacingnosymbols | hellomsg: db "hi",0  |
| macros: CamelCase | `DrawSquare 4,3` |

### Magic numbers
Add purpose of magic numbers in comments. So instead of just writing `add ax, 42`, 
add the comment`; 42 is the number of WHATEVER` so it's clear why 55 and not 39.

### General formatting
- Tabs are 4 spaces wide and comments should be aligned after 10 tabs *if possible*
- Functionbodies and loops are to be indented
- If macro is too heavy, create macrofile and include it.
- Group common subroutinges, such as creating and destroying stackframes<br/>together

### Function formatting:

- Description how to pass args
- Function label (camelCase)
- Docstring explaining the purpose *if necessary*
- Indent the function aswell as loop bodies


#### Example:
[//]: # (I KNOW IT LOOKS UGLY AS HELL BUT THIS IS MARKDOWN CODE FORMATTING FOR YOU.)
[//]: # (THIS IS AN ASSEMBLY CODE GUIDE, NOT MARKDOWN WRITE STYLE TUTORIAL.)
<code>
&semi; mov si, &lt;string&gt;<br/>
printString:<br/>
&semi; prints the string pointed to by si<br/>
&emsp;&emsp;pusha<br/>
&emsp;&emsp;mov ah, 0x0e	&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;	&semi; sets parameter for bios call to print char<br/>
&emsp;&emsp;.print_string_loop:<br/>
&emsp;&emsp;&emsp;&emsp;mov al, &lbrack;si&rbrack;<br/>
&emsp;&emsp;&emsp;&emsp;int BIOS_VIDEO_INT	&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;	&semi; calls bios to print single char<br/>
&emsp;&emsp;&emsp;&emsp;inc si<br/>
&emsp;&emsp;&emsp;&emsp;cmp byte &lbrack;si&rbrack;, 0x00	&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;	&semi; compares if reached end of string<br/>
&emsp;&emsp;&emsp;&emsp;jne .print_string_loop<br/>
&emsp;&emsp;popa<br/>
&emsp;&emsp;ret<br/>
</code>
