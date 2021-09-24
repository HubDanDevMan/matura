# Files

One of the most convenient and widely used features provided by operating systems are files. Files in
the traditional sense are persistent sequences of bytes associated with a *file type*. A traditional
file can


## File signatures

Magic numbers are more or less arbritarily chosen
numberic or textual constanst used across most of computer science but in the context of files
they are seen as *file signatures*. Every file that has a special format such as JPEG, MP3, ZIP,
PDF as well as ASCII-text. There are obviosly many more but these are very common. Most files
of the aforementioned format have a specific file signature, a magic number located within the first
few bytes of the file. It can be thought of as file extension stored in the file itself and not in
the file name (metadata). The only difference is that extensions differ from the file signatures.
Here is a small list of file signatures:
| File type | Signature |
|----|----|
| JPEG | "ÿØÿÛ" |
| MP3 | "ÿû" |
| ZIP | "PK\x03\x04" |
| PDF | "%PDF-" |
One problem arises, namely ASCII has no directly associated file signature with it. Script files as
well as PDF files have an ASCII file signature. If a user was to write a file that randomly 

Whenever a user
opens a file from Finder on MacOS or any similar file manager that does not contain a file extension
it will open the file with the correct program nonetheless. 


