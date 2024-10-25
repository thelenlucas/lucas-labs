.syntax unified
.thumb
.global main
.global printf
.global scanf
.global getchar

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

gum:
    @ If out of stock, skip
    ldr r0, =int_gum
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_gum
    bl printf

    @ Go to payment subroutine - use r0 to store price required (in cents)
    ldr r0, =gum_price
    ldr r0, [r0]
    bl payment

    @ Subtract one from the inventory of gum
    ldr r0, =int_gum
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    @ Loop
    b loop

peanuts:
    @ If out of stock, skip
    ldr r0, =int_peanuts
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_peanuts
    bl printf

    @ Go to payment subroutine - use r0 to store price required (in cents)
    ldr r0, =peanuts_price
    ldr r0, [r0]
    bl payment

    @ Subtract one from the inventory
    ldr r0, =int_peanuts
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    @ Loop
    b loop

crackers:
    @ If out of stock, skip
    ldr r0, =int_crackers
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_crackers
    bl printf

    @ Go to payment subroutine - use r0 to store price required (in cents)
    ldr r0, =crackers_price
    ldr r0, [r0]
    bl payment

    @ Subtract one from the inventory
    ldr r0, =int_crackers
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    @ Loop
    b loop

mnms:
    @ If out of stock, skip
    ldr r0, =int_mnms
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_mnms
    bl printf

    @ Go to payment subroutine - use r0 to store price required (in cents)
    ldr r0, =mnms_price
    ldr r0, [r0]
    bl payment

    @ Subtract one from the inventory
    ldr r0, =int_mnms
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    @ Loop
    b loop

out_of_stock:
    @ Print out of stock message and loop back
    ldr r0, =oos_message
    bl printf
    b loop

payment:
    push {lr}
    mov r1, r0    @ r1 = amount left to pay (in cents)

payment_loop:
    @ Ask for value
    ldr r0, =money
    bl printf
    @ Get choice
    ldr r0, =format_char
    ldr r2, =in_char
    bl scanf
    bl getchar
    ldr r0, =in_char
    ldrb r0, [r0]

    @ Check and subtract right amount
    cmp r0, #'B'
    beq payment_dollar
    cmp r0, #'Q'
    beq payment_quarter
    cmp r0, #'D'
    beq payment_dime
    b bad_payment

payment_dollar:
    subs r1, r1, #100    @ Subtract $1.00 (100 cents)
    b payment_end_loop

payment_quarter:
    subs r1, r1, #25     @ Subtract $0.25 (25 cents)
    b payment_end_loop

payment_dime:
    subs r1, r1, #10     @ Subtract $0.10 (10 cents)
    b payment_end_loop

bad_payment:
    @ Give feedback and loop back
    ldr r0, =invalid_choice
    bl printf
    b payment_loop

payment_end_loop:
    @ Check if amount left <= 0
    cmp r1, #0
    ble payment_end

    @ Print amount left
    mov r2, r1    @ amount left in cents
    bl compute_dollars_cents    @ computes dollars in r3, cents in r4

    ldr r0, =left
    mov r1, r3    @ dollars
    mov r2, r4    @ cents
    bl printf

    b payment_loop

payment_end:
    @ Print item dispensed
    ldr r0, =success
    bl printf

    @ Calculate change (if any)
    mov r2, r1
    rsbs r2, r2, #0   @ r2 = -r1

    cmp r2, #0
    beq no_change

    @ Compute dollars and cents for change
    bl compute_dollars_cents    @ computes dollars in r3, cents in r4

    ldr r0, =change
    mov r1, r3    @ dollars
    mov r2, r4    @ cents
    bl printf

no_change:
    @ Link and return
    pop {lr}
    bx lr

compute_dollars_cents:
    push {lr}
    mov r3, #0    @ dollars = 0
    mov r4, r2    @ cents = amount (input in r2)

dollar_loop:
    cmp r4, #100
    blt end_compute_dollars_cents
    subs r4, r4, #100
    adds r3, r3, #1
    b dollar_loop

end_compute_dollars_cents:
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

.align 2
welcome: .asciz "Welcome to the vending machine!\n"
.align 2
choices: .asciz "\nPlease choose Gum (G), Peanuts (P), Cheese Crackers (C), or M&Ms (M)\n"
.align 2
enter_choice: .asciz "Enter your choice: "
.align 2
money: .asciz "Enter Dollar (B)ill, (Q)uarter, or (D)ime: "
.align 2
left: .asciz "$%d.%02d left to pay\n\n"
.align 2
success: .asciz "Here's your item!\n"
.align 2
change: .asciz "Change: $%d.%02d\n"
.align 2
depleted: .asciz "Stock depleted! Exiting...\n"

.align 2
choose_gum: .asciz "Gum is $0.50\n"
.align 2
gum_price: .word 50

.align 2
choose_peanuts: .asciz "Peanuts are $0.55\n"
.align 2
peanuts_price: .word 55

.align 2
choose_crackers: .asciz "Cheese Crackers are $0.65\n"
.align 2
crackers_price: .word 65

.align 2
choose_mnms: .asciz "M&Ms are $1.00\n"
.align 2
mnms_price: .word 100

.align 2
invalid_choice: .asciz "Invalid choice. Please try again.\n"
.align 2
oos_message: .asciz "Sorry! Out of stock. Please choose again.\n"
.align 2
inventory_message: .asciz "Inventory mode activated.\n"
.align 2
gum_inventory: .asciz "Gum: %d\n"
.align 2
peanuts_inventory: .asciz "Peanuts: %d\n"
.align 2
crackers_inventory: .asciz "Crackers: %d\n"
.align 2
mnms_inventory: .asciz "M&Ms: %d\n"

.align 2
format_char: .asciz " %c"
.align 2
in_char: .word 0

.align 2
int_gum: .word 2
.align 2
int_peanuts: .word 2
.align 2
int_crackers: .word 2
.align 2
int_mnms: .word 2
