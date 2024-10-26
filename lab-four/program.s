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
.global __aeabi_uidiv   @ Int division (unsigned)

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

@ Handles the mainvending_machine_main_loop of:
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
    beq vending_machine_out_of_stock

    @ Print choices
    ldr r0, =choices
    bl printf

    @ Get user input
    ldr r0, =format_char
    ldr r1, =in_char
    bl scanf
    bl getchar  @ Clear buffer
    ldr r1, =in_char
    ldrb r0, [r1]

    @ Check the input
    cmp r0, #'G'
    beq gum_handler
    cmp r0, #'P'
    beq peanuts_handler
    cmp r0, #'C'
    beq crackers_handler
    cmp r0, #'M'
    beq mnms_handler
    cmp r0, #'I'
    beq inventory_handler

    @ Invalid choice
    ldr r0, =invalid_choice
    bl printf
    b vending_machine_main_loop

.ltorg

gum_handler:
    @ If out of stock, skip
	ldr r0, =inv_gum
	ldr r0, [r0]
	cmp r0, #0
	ble out_of_stock_item

    @ Print price and start purchase function
    ldr r0, =gum_price
    bl printf

    mov r0, #50
    bl purchase_function

    @ Subtract from inventory
    ldr r0, =inv_gum
    ldr r0, [r0]
    sub r0, #1
    str r0, =inv_gum

    b vending_machine_main_loop

.ltorg

peanuts_handler:
    @ If out of stock, skip
	ldr r0, =inv_peanuts
	ldr r0, [r0]
	cmp r0, #0
	ble out_of_stock_item

    @ Print price and start purchase function
    ldr r0, =peanuts_price
    bl printf

    mov r0, #55
    bl purchase_function

    @ Subtract from inventory
    ldr r0, =inv_peanuts
    ldr r0, [r0]
    sub r0, #1
    str r0, =inv_peanuts

    b vending_machine_main_loop

.ltorg

crackers_handler:
    @ If out of stock, skip
	ldr r0, =inv_peanuts
	ldr r0, [r0]
	cmp r0, #0
	ble out_of_stock_item

    @ Print price and start purchase function
    ldr r0, =crackers_price
    bl printf

    mov r0, #65
    bl purchase_function

    @ Subtract from inventory
    ldr r0, =inv_crackers
    ldr r0, [r0]
    sub r0, #1
    str r0, =inv_crackers

    b vending_machine_main_loop

.ltorg

mnms_handler:
    @ If out of stock, skip
	ldr r0, =inv_mnms
	ldr r0, [r0]
	cmp r0, #0
	ble out_of_stock_item

    @ Print price and start purchase function
    ldr r0, =mnms_price
    bl printf

    mov r0, #100
    bl purchase_function

    @ Subtract from inventory
    ldr r0, =inv_mnms
    ldr r0, [r0]
    sub r0, #1
    str r0, =inv_mnms

    b vending_machine_main_loop

.ltorg

inventory_handler:
    b vending_machine_main_loop

.ltorg

out_of_stock_item:
    @ Inform and loop
    ldr r0, =out_of_individual_stock
    bl printf
    b vending_machine_main_loop

vending_machine_out_of_stock:
    ldr r0, =out_of_stock
    pop {pc}

.ltorg

@ Prints a dollar amount using the price in cents in r0
@ The caller function usually uses r6/7, so we'll save those
print_dollars:
    push {lr}
    push {r6, r7}
    mov r7, r0  @ Stick this for safekeeping

    @ Get dollar portion
    movs r1, #100
    bl __aeabi_uidiv    @ Divide
    mov r6, r0 @ Save because I'm parinoid

    @ No dollar amount we're handling should be above 2.00, so we don't need to bother with modulo thankfully
    sub r7, r6 @ Cents remainder
    @ Print
    ldr r0, =dollar_part_one
    mov r1, r6
    bl printf
    ldr r0, =dollar_part_two
    mov r1, r7
    bl printf

    @ Return
    pop {r6, r7}
    pop {pc}

.ltorg

@ Requests money until an amount in r0 is satisfied, then prints change
purchase_function:
    push {lr}

    mov r7, r0  @ Store
    mov r6, #0  @ Amount inserted
purchase_function_loop:
    push {r7} @ Save this
    @ Print amount inserted
    ldr r0, =money_in
    bl printf
    mov r0, r6
    bl print_dollars
    ldr r0, =newline
    bl printf

purchase_function_get_input:
    @ Display choices
    ldr r0, =bills_display
    bl printf
    @ Get choice
	ldr r0, =format_char
	ldr r1, =in_char
	bl scanf
	bl getchar
	ldr r0, =in_char
	ldrb r0, [r0]
	cmp r0, #'B'
	beq purchase_function_dollar
	cmp r0, #'Q'
	beq purchase_function_quarter
	cmp r0, #'D'
	beq purchase_function_dime
	b purchase_function_bad_payment

purchase_function_dollar:
	@ Add inserted amount
    add r6, #100
    b purchase_function_end_loop

purchase_function_quarter:
	add r6, #25
	b purchase_function_end_loop

purchase_function_dime:
    add r6, #10
	b purchase_function_end_loop

purchase_function_bad_payment:
	@ Give feedback and loop back
	ldr r0, =invalid_choice
	bl printf
	b purchase_function_get_input

purchase_function_end_loop:
    @ Check if we're done
    pop {r7}
    cmp r6, r7
    bgt purchase_function_done
    b purchase_function_loop

purchase_function_done:
    @ Get change
    sub r6, r7

    @ Print change
    ldr r0, =change
    bl printf
    mov r0, r6
    bl print_dollars
    ldr r0, =newline
    bl printf

    @ Return
    pop {pc}

@ Data section
.data

@ Strings
.balign 4   @ Variables are still 32-bit, only instructions are 16-bit
welcome:    .asciz "Welcome to the vending machine!\n"
.balign 4  
out_of_stock: .asciz "Sorry, vending machine out of stock! Exiting...\n"
.balign 4
choices: .asciz "\nPlease choose Gum (G), Peanuts (P), Cheese Crackers (C), or M&Ms (M): "
.balign 4
invalid_choice: .asciz "Sorry, invalid choice, please choose again."
.balign 4
out_of_individual_stock: .asciz "Sorry, out of that item. Please choose another."
.balign 4
dollar_part_one: .asciz "$%d."
.balign 4
dollar_part_two: .asciz "%02d"
.balign 4
newline: .asciz "\n"
.balign 4
gum_price: .asciz "Gum costs $0.55\n"
.balign 4
peanuts_price: .asciz "Peanuts are $0.55\n"
.balign 4
crackers_price: .asciz "Cheese Crackers are $0.65\n"
.balign 4
mnms_price: .asciz "M&Ms are $1.00\n"
.balign 4
money_in: .asciz "Inserted: "
.balign 4
bills_display: .asciz "Enter Dollar (B)ill, (Q)aurter, or (D)ime: "
.balign 4
change: .asciz "Change: "

@ Inventory
.balign 4
inv_gum: .word 2
.balign 4
inv_peanuts: .word 2
.balign 4
inv_crackers: .word 2
.balign 4
inv_mnms: .word 2

@ Input handling
.balign 4
format_char: .asciz " %c"
.balign 4
in_char: .word 0