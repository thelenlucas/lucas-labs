@ ------------------------------------------------------------
@ LAB Three: Vending Machine (Thumb Version)
@
@ AUTHOR: LUCAS THELEN
@
@ PURPOSE: In progress
@
@ CHANGES INTO THUMB:
@ 1. Memory management for literals is annoying. The .ltorg directive helps pool literals after functions that use them
@
@ COMPILE AND RUN: 
@ 1. as -mthumb -o source.o source.s && gcc -mthumb -o program source.o
@ 2. ./program
@ ------------------------------------------------------------

.global main
.global printf      @ Print directive
.global scanf       @ For grabbing input
.global getchar     @ Likewise
.thumb				@ Assemble in Thumb mode
.arch armv6			@ Specify ARMv6 architecture

.text				@ Code section

.thumb_func	@ Indicate that the following is a Thumb function, we won't leave so we don't need to re-identify
main:
    @ Save the link register (return address)
    push {lr}

    @ Load the address of the welcome message into r0 (first argument to printf)
    ldr r0, =welcome
    bl printf	@ Call printf

    bl vending_machine_main

    @ Set the return value to 0 (success)
    movs r0, #0
    @ Restore the link register and return from main
    pop {pc}	@ In Thumb mode, popping pc is valid for returning

.ltorg	@ Force the assembler to stick literals here, so they're still accessable later. This is why I hate thumb programming lol

@ Handles the main loop of:
@ 1. Check for empty machine
@ 2. Display Choices and prompt for user input
@ 3. Jump to appropriate handler function for food type
vending_machine_main:
    @ Save link
    push {lr}
vending_machine_main_loop:
    @ Load inventory
    mov r0, #0
    ldr r1, =inv_gum
    ldr r1, [r1]
    add r0, r1
    ldr r1, =inv_peanuts
    ldr r1, [r1]
    add r0, r1
    ldr r1, =inv_crackers
    ldr r1, [r1]
    add r0, r1
    ldr r1, =inv_mnms
    ldr r1, [r1]
    add r0, r1

    pop {pc}

@ Data section
.data
.balign 4   @ Variables are still 32-bit, only instructions are 16-bit
welcome:    .asciz "Welcome to the vending machine!\n"

.balign 4
inv_gum: .word 2
.balign 4
inv_peanuts: .word 2
.balign 4
inv_crackers: .word 2
.balign 4
inv_mnms: .word 2
