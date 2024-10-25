@ ------------------------------------------------------------
@ LAB Three: Vending Machine
@
@ AUTHOR: LUCAS THELEN
@
@ PURPOSE: Uses float calculations to vend products
@
@ COMPILE AND RUN: 
@ 1. as -o source.o source.s && gcc -o program source.o
@ 2. ./program
@
@ INSTRUCTIONS:
@ The secrete code to activate "Inventory Mode" is "I"
@
@ ------------------------------------------------------------

	.global main
	.global printf
	.global scanf
	.global getchar
	.arch armv6
	.fpu vfp

main:
    push {lr}  @ Save the link register

    @ Display welcome message
    ldr r0, =welcome
    bl printf

loop:
	@ Check if inventory is depleted
	ldr r1, =int_gum
	ldr r0, [r1]
	ldr r1, =int_peanuts
	ldr r1, [r1]
	add r0, r0, r1
	ldr r1, =int_crackers
	ldr r1, [r1]
	add r0, r0, r1
	ldr r1, =int_mnms
	ldr r1, [r1]
	add r0, r0, r1

	cmp r0, #0
	ble exit

    @ Display choices
    ldr r0, =choices
    bl printf

    @ Prompt for choice
    ldr r0, =enter_choice
    bl printf

    @ Get user's choice
    ldr r0, =format_char
    ldr r1, =in_char
    bl scanf

    @ Clear input buffer
    bl getchar

    @ Check the input
    ldr r1, =in_char
    ldrb r0, [r1]

    cmp r0, #'G'
    beq gum
    cmp r0, #'P'
    beq peanuts
    cmp r0, #'C'
    beq crackers
    cmp r0, #'M'
    beq mnms
    cmp r0, #'I'
    beq inventory
    
    @ Invalid choice
    ldr r0, =invalid_choice
    bl printf
    b loop

inventory:
	ldr r0, =inventory_message
	bl printf
    @ Print Inventory
	ldr r0, =gum_inventory
	ldr r1, =int_gum
	ldr r1, [r1]
	bl printf
	ldr r0, =peanuts_inventory
	ldr r1, =int_peanuts
	ldr r1, [r1]
	bl printf
	ldr r0, =crackers_inventory
	ldr r1, =int_crackers
	ldr r1, [r1]
	bl printf
	ldr r0, =mnms_inventory
	ldr r1, =int_mnms
	ldr r1, [r1]
	bl printf
	b loop

@ If the user selects gum
gum:
	@ If out of stock, skip
	ldr r0, =int_gum
	ldr r0, [r0]
	cmp r0, #0
	ble out_of_stock

	@ Print Price
	ldr r0, =choose_gum
	bl printf

	@ Go to payment subroutine - use d0 to store price required
	ldr r0, =gum_price
	vldr.64 d0, [r0]
	bl payment

	@ Subtract one from the inventory of gum
	ldr r0, =int_gum
	ldr r1, [r0]
	sub r1, r1, #1
	str r1, [r0]

	@ Loop
	b loop

@ If the user selects Peanuts
peanuts:
	@ If out of stock, skip
	ldr r0, =int_peanuts
	ldr r0, [r0]
	cmp r0, #0
	ble out_of_stock

	@ Print Price
	ldr r0, =choose_peanuts
	bl printf

	@ Go to payment subroutine - use d0 to store price required
	ldr r0, =peanuts_price
	vldr.64 d0, [r0]
	bl payment

	@ Subtract one from the inventory
	ldr r0, =int_peanuts
	ldr r1, [r0]
	sub r1, r1, #1
	str r1, [r0]

	@ Loop
	b loop

@ If the user selects Crackers
crackers:
	@ If out of stock, skip
	ldr r0, =int_crackers
	ldr r0, [r0]
	cmp r0, #0
	ble out_of_stock

	@ Print Price
	ldr r0, =choose_crackers
	bl printf

	@ Go to payment subroutine - use d0 to store price required
	ldr r0, =crackers_price
	vldr.64 d0, [r0]
	bl payment

	@ Subtract one from the inventory
	ldr r0, =int_crackers
	ldr r1, [r0]
	sub r1, r1, #1
	str r1, [r0]

	@ Loop
	b loop

@ If the user selects M&Ms
mnms:
	@ If out of stock, skip
	ldr r0, =int_mnms
	ldr r0, [r0]
	cmp r0, #0
	ble out_of_stock

	@ Print Price
	ldr r0, =choose_mnms
	bl printf

	@ Go to payment subroutine - use d0 to store price required
	ldr r0, =mnms_price
	vldr.64 d0, [r0]
	bl payment

	@ Subtract one from the inventory
	ldr r0, =int_mnms
	ldr r1, [r0]
	sub r1, r1, #1
	str r1, [r0]

	@ Loop
	b loop


out_of_stock:
	@ Print out of stock message and loop back
	ldr r0, =oos_message
	bl printf
	b loop

@ Handles loop for paying d0
payment:
	push {lr}
	
payment_loop:
	@ Ask for value
	ldr r0, =money
	bl printf
	@ Get choice
	ldr r0, =format_char
	ldr r1, =in_char
	bl scanf
	bl getchar
	ldr r0, =in_char
	ldrb r0, [r0]

sub_time:
	@ Check and subtract right amount
	cmp r0, #'B'
	beq payment_dollar
	cmp r0, #'Q'
	beq payment_quarter
	cmp r0, #'D'
	beq payment_dime
	b bad_payment

payment_dollar:
	@ Subtract amount
	ldr r0, =dollar
	vldr.64 d1, [r0]
	vsub.F64 d0, d0, d1
	b payment_end_loop

payment_quarter:
	@ Same as above
	ldr r0, =quarter
	vldr.64 d1, [r0]
	vsub.F64 d0, d0, d1
	b payment_end_loop

payment_dime:
	@ Likewise
	ldr r0, =dime
	vldr.64 d1, [r0]
	vsub.F64 d0, d0, d1
	b payment_end_loop

bad_payment:
	@ Give feedback and loop back
	ldr r0, =invalid_choice
	bl printf
	b payment_loop

payment_end_loop:
	@ Save the value in d2, because either printf or the compare screws things up
	vmov.f64 d2, d0
	@ See if the amount left is less than one cent (rounding errors, yayyy)
	ldr r0, =one_cent
	vldr.64 d1, [r0]
	vcmp.f64 d0, d1
	vmrs APSR_nzcv, FPSCR

	@ If we're negative, branch to end, otherwise continue
	BPL payment_loop_continue
	B payment_end

payment_loop_continue:
	@ Print amoutn left
	ldr r0, =left
	vmov r2, r3, d0
	bl printf
	@ Move value back
	vmov.f64 d0, d2
	b payment_loop

payment_end:
	@ Print item deposited
	ldr r0, =success
	bl printf

	@ Calculate change
	ldr r0, =zero_val
	vldr.64 d1, [r0]
	vsub.f64 d1, d1, d0
	vmov r2, r3, d1

	@ Print change
	ldr r0, =change
	bl printf

	@ Link and return
	pop {lr}
	bx lr

exit:
	@ Print message
	ldr r0, =depleted
	bl printf
    @ Exit the program
    mov r0, #0
    pop {lr}  @ Restore the link register
    bx lr     @ Return from main

.data

.balign 4
welcome: .asciz "Welcome to the vending machine!\n"
.balign 4
choices: .asciz "\nPlease choose Gum (G), Peanuts (P), Cheese Crackers (C), or M&Ms (M)\n"
.balign 4
enter_choice: .asciz "Enter your choice: "
.balign 4
money: .asciz "Enter Dollar (B)ill, (Q)aurter, or (D)ime: "
.balign 4
left: .asciz "$%.2f left to pay\n\n"
.balign 4
success: .asciz "Here's your item!\n"
.balign 4
change: .asciz "Change: $%.2f\n"
.balign 4
depleted: .asciz "Stock depleted! Exiting...\n"

.balign 4
zero_val: .double 0.0
.balign 4
one_cent: .double 0.01
.balign 4
dollar: .double 1.00
.balign 4
quarter: .double 0.25
.balign 4
dime: .double 0.10
.balign 4
current_balance: .double 0.00

.balign 4
choose_gum: .asciz "Gum is $0.50\n"
.balign 4
gum_price: .double 0.50

.balign 4
choose_peanuts: .asciz "Peanuts are $0.55\n"
.balign 4
peanuts_price: .double 0.55

.balign 4
choose_crackers: .asciz "Cheese Crackers are $0.65\n"
.balign 4
crackers_price: .double 0.65

.balign 4
choose_mnms: .asciz "M&Ms are $1.00\n"
.balign 4
mnms_price: .double 1.00

.balign 4
invalid_choice: .asciz "Invalid choice. Please try again.\n"
.balign 4
oos_message: .asciz "Sorry! Out of stock. Please choose again.\n"
.balign 4
inventory_message: .asciz "Inventory mode activated.\n"
.balign 4
gum_inventory: .asciz "Gum: %d\n"
.balign 4
peanuts_inventory: .asciz "Peanuts: %d\n"
.balign 4
crackers_inventory: .asciz "Crackers: %d\n"
.balign 4
mnms_inventory: .asciz "M&Ms: %d\n"

.balign 4
format_char: .asciz " %c"
.balign 4
in_char: .word 0

.balign 4
int_gum: .word 2
.balign 4
int_peanuts: .word 2
.balign 4
int_crackers: .word 2
.balign 4
int_mnms: .word 2
