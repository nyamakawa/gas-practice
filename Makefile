CC:=gcc
CFLAGS:=-g

build:
	$(CC) $(CFLAGS) -c hello.s -o hello.o
link: build 
	ld hello.o -o hello 
all: link
	./hello