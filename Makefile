CC:=gcc

build:
	$(CC) -c hello.s -o hello.o
link: build 
	ld hello.o -o hello 
all: link
	./hello