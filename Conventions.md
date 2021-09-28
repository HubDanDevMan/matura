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
add the comment`; 42 is the number of WHATEVER` so it's clear why 42 and not 39.

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
```
%define BIOS_VIDEO_INT 0x10
%define PRINT_CHARACTER_ARG 0x0e

; mov si, <string>
printString:
; prints the string pointed to by si
pusha
mov ah, PRINT_CHARACTER_ARG               ; sets parameter for bios call to print char
  .print_string_loop:
    mov al, [si]
    int BIOS_VIDEO_INT                    ; calls bios to print single char
    inc si
    cmp byte [si], 0x00                   ; compares if reached end of string
    jne .print_string_loop
  popa
  ret
```
