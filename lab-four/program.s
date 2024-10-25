    .global main
    .global printf
    .global scanf
    .global getchar
    .syntax unified       @ Use unified assembly syntax
    .arch armv6           @ Specify ARMv6 architecture
    .thumb                @ Enable Thumb instruction set

    .thumb_func           @ Indicate Thumb function
main:
    push {lr}             @ Save the link register

    @ Display welcome message
    ldr r0, =welcome
    bl printf

loop:
    @ Check if inventory is depleted
    ldr r1, =int_gum
    ldr r0, [r1]          @ r0 = int_gum
    ldr r1, =int_peanuts
    ldr r1, [r1]          @ r1 = int_peanuts
    add r0, r1            @ r0 = r0 + r1
    ldr r1, =int_crackers
    ldr r1, [r1]          @ r1 = int_crackers
    add r0, r1            @ r0 = r0 + r1
    ldr r1, =int_mnms
    ldr r1, [r1]          @ r1 = int_mnms
    add r0, r1            @ r0 = r0 + r1

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

    .thumb_func
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

    .thumb_func
gum:
    @ If out of stock, skip
    ldr r0, =int_gum
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_gum
    bl printf

    @ Go to payment subroutine - use r4 to store price required
    ldr r4, =gum_price
    ldr r4, [r4]
    bl payment

    @ Subtract one from the inventory of gum
    ldr r0, =int_gum
    ldr r1, [r0]
    subs r1, r1, #1        @ Use 'subs' to update flags
    str r1, [r0]

    @ Loop
    b loop

    .thumb_func
peanuts:
    @ If out of stock, skip
    ldr r0, =int_peanuts
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_peanuts
    bl printf

    @ Go to payment subroutine - use r4 to store price required
    ldr r4, =peanuts_price
    ldr r4, [r4]
    bl payment

    @ Subtract one from the inventory
    ldr r0, =int_peanuts
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    @ Loop
    b loop

    .thumb_func
crackers:
    @ If out of stock, skip
    ldr r0, =int_crackers
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_crackers
    bl printf

    @ Go to payment subroutine - use r4 to store price required
    ldr r4, =crackers_price
    ldr r4, [r4]
    bl payment

    @ Subtract one from the inventory
    ldr r0, =int_crackers
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    @ Loop
    b loop

    .thumb_func
mnms:
    @ If out of stock, skip
    ldr r0, =int_mnms
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_mnms
    bl printf

    @ Go to payment subroutine - use r4 to store price required
    ldr r4, =mnms_price
    ldr r4, [r4]
    bl payment

    @ Subtract one from the inventory
    ldr r0, =int_mnms
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    @ Loop
    b loop

    .thumb_func
out_of_stock:
    @ Print out of stock message and loop back
    ldr r0, =oos_message
    bl printf
    b loop

    .thumb_func
payment:
    push {lr}

    mov r5, r4          @ r5 holds the amount due in cents
    mov r6, #0          @ r6 will accumulate the total amount paid

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

    @ Check and add the right amount
    cmp r0, #'B'
    beq payment_dollar
    cmp r0, #'Q'
    beq payment_quarter
    cmp r0, #'D'
    beq payment_dime
    b bad_payment

payment_dollar:
	mov r5, #100
    add r6, r5    @ Add 100 cents for a dollar
    b payment_check

payment_quarter:
	mov r5, #25
    add r6, r5     @ Add 25 cents for a quarter
    b payment_check

payment_dime:
	mov r5, #10
    add r6, r5     @ Add 10 cents for a dime
    b payment_check

bad_payment:
    @ Invalid input
    ldr r0, =invalid_choice
    bl printf
    b payment_loop

payment_check:
    cmp r6, r5          @ Compare total paid with amount due
    blt payment_display_balance  @ If less, continue payment

    @ If equal or more, calculate change
    subs r7, r6, r5     @ r7 = total paid - amount due (change)
    b payment_finalize

payment_display_balance:
    @ Display amount left to pay
    subs r7, r5, r6     @ r7 = amount due - total paid
    ldr r0, =left_format
    mov r1, r7          @ Amount left in cents
    bl print_amount
    b payment_loop

payment_finalize:
    @ Dispense item
    ldr r0, =success
    bl printf

    @ If change is due, print it
    cmp r7, #0
    beq payment_done    @ No change due
    ldr r0, =change_format
    mov r1, r7          @ Change in cents
    bl print_amount

payment_done:
    pop {lr}
    bx lr

    .thumb_func
print_amount:
    @ Input: r1 = amount in cents
    @ Output: None (prints amount as dollars and cents)
    push {r0-r3, lr}
    mov r2, #100
    bl __aeabi_uidivmod   @ Unsigned division and modulus
    mov r2, r0           @ r2 = dollars
    mov r3, r1           @ r3 = cents
    bl printf
    pop {r0-r3, pc}

    .thumb_func
exit:
    @ Print message
    ldr r0, =depleted
    bl printf
    @ Exit the program
    mov r0, #0
    pop {lr}
    bx lr                 @ Return from main

    .data

    .balign 4
welcome: .asciz "Welcome to the vending machine!\n"
    .balign 4
choices: .asciz "\nPlease choose Gum (G), Peanuts (P), Cheese Crackers (C), or M&Ms (M)\n"
    .balign 4
enter_choice: .asciz "Enter your choice: "
    .balign 4
money: .asciz "Enter Dollar (B)ill, (Q)uarter, or (D)ime: "
    .balign 4
left_format: .asciz "$%d.%02d left to pay\n\n"
    .balign 4
success: .asciz "Here's your item!\n"
    .balign 4
change_format: .asciz "Change: $%d.%02d\n"
    .balign 4
depleted: .asciz "Stock depleted! Exiting...\n"

    .balign 4
choose_gum: .asciz "Gum is $0.50\n"
    .balign 4
gum_price: .word 50        @ Price in cents

    .balign 4
choose_peanuts: .asciz "Peanuts are $0.55\n"
    .balign 4
peanuts_price: .word 55    @ Price in cents

    .balign 4
choose_crackers: .asciz "Cheese Crackers are $0.65\n"
    .balign 4
crackers_price: .word 65   @ Price in cents

    .balign 4
choose_mnms: .asciz "M&Ms are $1.00\n"
    .balign 4
mnms_price: .word 100      @ Price in cents

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
