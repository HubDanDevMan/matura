
;Binary color definitions
%define BLACK				0b0000
%define BLUE				0b0001
%define GREEN				0b0010
%define CYAN				0b0011
%define RED 				0b0100
%define MAGENTA				0b0101
%define BROWN				0b0110
%define LIGHT_GREY			0b0111
%define DARK_GREY			0b1000
%define LIGHT_BLUE			0b1001
%define LIGHT_GREEN			0b1010
%define LIGHT_CYAN			0b1011
%define LIGHT_RED			0b1100
%define LIGHT_MAGENTA		0b1101
%define YELLOW				0b1110
%define WHITE				0b1111








;This is a makro that draws squares withing given coordinates
;DrawSquare row,column,length,width,color
;To use the macro initiate video mode with vga
%macro DrawSquare 5
	mov ah, 0x0c
	mov cx, %1 				;value for start of row
	mov dx, %2				;value for start of column
	mov di, %3 				;value for length
	mov bx, %4 				;value for width
	mov al, %5 				;value for color
	call squareDrawLoopStart
%endmacro


main: 						;example of how to use
mov ah, 0
mov al, 0x12
int 0x10
DrawSquare 10, 10, 80, 200, BLUE
DrawSquare 90,10, 80, 100, RED
jmp end

squareDrawLoopStart:
	push bp 
	mov bp, sp 				;create new stack frame
	sub sp, 4
	
	mov [bp-2], cx			;stores start of row in stack
	mov [bp-4], dx 			;stores start of column in stack
	add bx, dx 				;adds start of row to length
	add di, cx				;adds start of column to width
	
squaredrawloop:
	cmp cx, di				;checks whether it has reached end of the row
	je	squaredraw2			;jumps to the column incrementer
	int 0x10				;prints pixel at current location
	inc cx					;increments cx by 1
	jmp squaredrawloop 		;restarts the loop
	
squaredraw2:
	mov cx, [bp-2]
	cmp dx, bx				;checks weather it has reached end of column
	je squareend			;exit for loop at end of square
	inc dx					;increments row by 1
	jmp squaredrawloop      ;returns back to the original loop
	
squareend:
	mov cx,[bp-2]			;returns original postitionto cx and dx
	mov dx,[bp-4]   		
	
	add sp, 4 				;destroy stack frame
	pop bp	
	ret

end:
END_PADDING
