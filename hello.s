# ----------------------------------------------------------------------------------------
# Writes "Hello, World" to the console using only system calls. Runs on 64-bit Linux only.
# To assemble and run:
#
#     gcc -c hello.s && ld hello.o -o hello && ./hello
#
# ----------------------------------------------------------------------------------------
# GAS documentation: https://sourceware.org/binutils/docs/as/index.html

#-------------------------------
# define system call macros
# system call table: https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#x86_64-64_bit

.macro syscall0 num
        mov     $\num, %rax
        syscall
.endm

.macro syscall1 num, arg1
        mov     $\num, %rax
        mov     \arg1, %rdi
        syscall
.endm

.macro syscall2 num, arg1, arg2
        mov     $\num, %rax
        mov     \arg1, %rdi
        mov     \arg2, %rsi
        syscall
.endm

.macro syscall3 num, arg1, arg2, arg3
        mov     $\num, %rax
        mov     \arg1, %rdi
        mov     \arg2, %rsi
        mov     \arg3, %rdx
        syscall
.endm

#-------------------------------

.lcomm  buff, 32

        .global _start

        .text
_start:
        # write(1, message, 13)
        mov     $1, %rax                # system call 1 is write
        mov     $1, %rdi                # file handle 1 is stdout
        mov     $message, %rsi          # address of string to output
        mov     $13, %rdx               # number of bytes
        syscall                         # invoke operating system to do the write

        syscall3 1, $1, $message2, $14     # write(1, message2, 14) by macro

        # getc and putc
        syscall3 0, $0, $buff, $2     # read(0, buff, 2)
        syscall3 1, $1, $buff, $2     # write(1, buff, 2)

        # exit(0)
        mov     $60, %rax               # system call 60 is exit
        xor     %rdi, %rdi              # we want return code 0
        syscall                         # invoke operating system to exit
message:
        .ascii  "Hello, world\n"
message2:
        .ascii  "Hello, world2\n"
