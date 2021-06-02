CC=gcc
CFLAGS=-O0
IF=filesystem.c commands.c
OF=filesystem

make: $(IF)
	$(CC) $(CFLAGS) $(IF) -o $(OF)


run: $(OF)
	./$(OF)
