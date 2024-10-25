    @ ------------------------------------------------------------
    @ LAB Three: Vending Machine (Thumb Version)
    @
    @ AUTHOR: LUCAS THELEN
    @
    @ PURPOSE: Prints a welcome message and exits.
    @
    @ COMPILE AND RUN: 
    @ 1. as -o source.o source.s && gcc -o program source.o
    @ 2. ./program
    @ ------------------------------------------------------------

    .global main
    .global printf
    .syntax unified        @ Use unified syntax for ARM/Thumb compatibility
    .thumb                 @ Assemble in Thumb mode
    .arch armv6            @ Specify ARMv6 architecture

    .text                  @ Code section

    .thumb_func            @ Indicate that the following is a Thumb function
    main:
        @ Save the link register (return address)
        push {lr}

        @ Load the address of the welcome message into r0 (first argument to printf)
        ldr r0, =welcome
        bl printf          @ Call printf

        @ Set the return value to 0 (success)
        movs r0, #0

        @ Restore the link register and return from main
        pop {pc}           @ In Thumb mode, popping pc is valid for returning

    @ Data section
    .data
    .balign 4              @ Align data to 4-byte boundary
    welcome:
        .asciz "Welcome to the vending machine!\n"
