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
#
# AMD64 Linux Kernel Conventions:
# https://www.ucw.cz/~hubicka/papers/abi/node33.html
#
#  1. User-level applications use as integer registers for passing the sequence %rdi, %rsi, %rdx, %rcx, %r8 and %r9. The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9.
#  2. A system-call is done via the syscall instruction. The kernel destroys registers %rcx and %r11.
#  3. The number of the syscall has to be passed in register %rax.
#  4. System-calls are limited to six arguments, no argument is passed directly on the stack.
#  5. Returning from the syscall, register %rax contains the result of the system-call. A value in the range between -4095 and -1 indicates an error, it is -errno.
#  6. Only values of class INTEGER or class MEMORY are passed to the kernel.

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
        call hello
        call getc
        call putc

        jmp exit

hello:
        syscall3 1, $1, $message2, $14     # write(1, message2, 14) by macro
        ret
getc:
        syscall3 0, $0, $buff, $2     # read(0, buff, 2)
        ret
putc:
        syscall3 1, $1, $buff, $2     # write(1, buff, 2)
        ret

exit:
        mov     $60, %rax               # system call 60 is exit
        xor     %rdi, %rdi              # we want return code 0
        syscall                         # invoke operating system to exit
message:
        .ascii  "Hello, world\n"
message2:
        .ascii  "Hello, world2\n"
