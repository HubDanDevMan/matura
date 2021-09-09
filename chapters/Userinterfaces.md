# User interfaces

Most definitely, every reader has interacted with a computer before. But most likely there was no
direct interaction with the kernel. Not only is it tedious to interact with the kernel but also
extremely time consuming. This is where the user interfaces (UIs) come to help.

## The shell

The shell is the outermost layer of an OS. Users interact with the shell to start, pause and quit
programs. Most readers will be familiar with a *graphical user interface*, GUI for short. GUIs come
with a desktop and a taskbar where programs can be started by clicking on the icon. A GUI provides
graphical windows that can be moved around with a mouse or a trackpad. Fortunately for users GUIs
hide away a lot of the complexity of the OS. Users might think that their browser such as Chrome or
Firefox is the only program that is running when they click their browsers icon in the taskbar. But
actually many other programs are already running before users even get to see their desktops taskbar,
let alone their login screen.

## Windowing systems

GUIs are made of programs that facilitate windows, icons, menus and pointing with a cursor. One of 
the components is a program called the display server. It is responsible for the communication of all 
the programs that have a graphical output. This communication occurs through a display server protocol
and the programs communicating with the display server are its clients. In windowing systems every program has its own *window buffer*. It is a dedicated area in memory that the graphical program can
write its own graphical output to. Whenever the program has finished rendering its own window it will message the display server over the aforementioned display server protocol. The display server has
access to all the window buffers and creates a single frame for a coomputer screen out of all the windows in a routine called *compositing*.

drawing pixels on the
screen that together form the magnificent windows and desktop background pictures we know and love. 
The display server, part of a *windowing system*, is responsible for much more than setting pixels on the screen. It defines a protocol that its *clients*, namely graphical 
programs such as web browsers and photo editors, can use to communicate with the display server. Just like web servers, a display server has multiple clients that it can simultaniously serve. These
clients ask the server for key and mouse input and render their own window. When an applications
window has been updated, the client application will communicate the changes to the display server.
The display server takes care of input. Kernels are system resource managers and one of those system
resources are 
