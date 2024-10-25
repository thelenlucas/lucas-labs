.thumb
.global main
.global printf
.global scanf
.global getchar

main:
    push {lr}

    @ Display welcome message
    ldr r0, =welcome_ptr
    ldr r0, [r0]
    bl printf

loop:
    @ Check if inventory is depleted
    ldr r1, =int_gum_ptr
    ldr r2, [r1]
    ldr r1, =int_peanuts_ptr
    ldr r3, [r1]
    adds r2, r2, r3
    ldr r1, =int_crackers_ptr
    ldr r3, [r1]
    adds r2, r2, r3
    ldr r1, =int_mnms_ptr
    ldr r3, [r1]
    adds r2, r2, r3

    cmp r2, #0
    ble exit

    @ Display choices
    ldr r0, =choices_ptr
    ldr r0, [r0]
    bl printf

    @ Prompt for choice
    ldr r0, =enter_choice_ptr
    ldr r0, [r0]
    bl printf

    @ Get user's choice
    ldr r0, =format_char_ptr
    ldr r0, [r0]
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
    ldr r0, =invalid_choice_ptr
    ldr r0, [r0]
    bl printf
    b loop

inventory:
    ldr r0, =inventory_message_ptr
    ldr r0, [r0]
    bl printf

    @ Print Inventory
    ldr r0, =gum_inventory_ptr
    ldr r0, [r0]
    ldr r1, =int_gum_ptr
    ldr r1, [r1]
    bl printf
    ldr r0, =peanuts_inventory_ptr
    ldr r0, [r0]
    ldr r1, =int_peanuts_ptr
    ldr r1, [r1]
    bl printf
    ldr r0, =crackers_inventory_ptr
    ldr r0, [r0]
    ldr r1, =int_crackers_ptr
    ldr r1, [r1]
    bl printf
    ldr r0, =mnms_inventory_ptr
    ldr r0, [r0]
    ldr r1, =int_mnms_ptr
    ldr r1, [r1]
    bl printf
    b loop

gum:
    @ If out of stock, skip
    ldr r0, =int_gum_ptr
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_gum_ptr
    ldr r0, [r0]
    bl printf

    @ Go to payment subroutine
    ldr r0, =gum_price_ptr
    ldr r0, [r0]
    bl payment

    @ Subtract one from the inventory of gum
    ldr r0, =int_gum_ptr
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    b loop

peanuts:
    @ If out of stock, skip
    ldr r0, =int_peanuts_ptr
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_peanuts_ptr
    ldr r0, [r0]
    bl printf

    @ Go to payment subroutine
    ldr r0, =peanuts_price_ptr
    ldr r0, [r0]
    bl payment

    @ Subtract one from the inventory
    ldr r0, =int_peanuts_ptr
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    b loop

crackers:
    @ If out of stock, skip
    ldr r0, =int_crackers_ptr
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_crackers_ptr
    ldr r0, [r0]
    bl printf

    @ Go to payment subroutine
    ldr r0, =crackers_price_ptr
    ldr r0, [r0]
    bl payment

    @ Subtract one from the inventory
    ldr r0, =int_crackers_ptr
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    b loop

mnms:
    @ If out of stock, skip
    ldr r0, =int_mnms_ptr
    ldr r0, [r0]
    cmp r0, #0
    ble out_of_stock

    @ Print Price
    ldr r0, =choose_mnms_ptr
    ldr r0, [r0]
    bl printf

    @ Go to payment subroutine
    ldr r0, =mnms_price_ptr
    ldr r0, [r0]
    bl payment

    @ Subtract one from the inventory
    ldr r0, =int_mnms_ptr
    ldr r1, [r0]
    subs r1, r1, #1
    str r1, [r0]

    b loop

out_of_stock:
    @ Print out of stock message and loop back
    ldr r0, =oos_message_ptr
    ldr r0, [r0]
    bl printf
    b loop

payment:
    push {lr}
    mov r1, r0    @ r1 = amount left to pay (in cents)

payment_loop:
    @ Ask for value
    ldr r0, =money_ptr
    ldr r0, [r0]
    bl printf
    @ Get choice
    ldr r0, =format_char_ptr
    ldr r0, [r0]
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
    ldr r0, =invalid_choice_ptr
    ldr r0, [r0]
    bl printf
    b payment_loop

payment_end_loop:
    @ Check if amount left <= 0
    cmp r1, #0
    ble payment_end

    @ Print amount left
    mov r2, r1    @ amount left in cents
    bl compute_dollars_cents    @ computes dollars in r3, cents in r4

    ldr r0, =left_ptr
    ldr r0, [r0]
    mov r1, r3    @ dollars
    mov r2, r4    @ cents
    bl printf

    b payment_loop

payment_end:
    @ Print item dispensed
    ldr r0, =success_ptr
    ldr r0, [r0]
    bl printf

    @ Calculate change (if any)
    mov r2, r1
    rsbs r2, r1, #0   @ r2 = -r1

    cmp r2, #0
    beq no_change

    @ Compute dollars and cents for change
    bl compute_dollars_cents    @ computes dollars in r3, cents in r4

    ldr r0, =change_ptr
    ldr r0, [r0]
    mov r1, r3    @ dollars
    mov r2, r4    @ cents
    bl printf

no_change:
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
    ldr r0, =depleted_ptr
    ldr r0, [r0]
    bl printf
    mov r0, #0
    pop {lr}
    bx lr

.data

.align 2
welcome_ptr: .word welcome
welcome: .asciz "Welcome to the vending machine!\n"

.align 2
choices_ptr: .word choices
choices: .asciz "\nPlease choose Gum (G), Peanuts (P), Cheese Crackers (C), or M&Ms (M)\n"

.align 2
enter_choice_ptr: .word enter_choice
enter_choice: .asciz "Enter your choice: "

.align 2
money_ptr: .word money
money: .asciz "Enter Dollar (B)ill, (Q)uarter, or (D)ime: "

.align 2
left_ptr: .word left
left: .asciz "$%d.%02d left to pay\n\n"

.align 2
success_ptr: .word success
success: .asciz "Here's your item!\n"

.align 2
change_ptr: .word change
change: .asciz "Change: $%d.%02d\n"

.align 2
depleted_ptr: .word depleted
depleted: .asciz "Stock depleted! Exiting...\n"

.align 2
choose_gum_ptr: .word choose_gum
choose_gum: .asciz "Gum is $0.50\n"
.align 2
gum_price_ptr: .word gum_price
gum_price: .word 50

.align 2
choose_peanuts_ptr: .word choose_peanuts
choose_peanuts: .asciz "Peanuts are $0.55\n"
.align 2
peanuts_price_ptr: .word peanuts_price
peanuts_price: .word 55

.align 2
choose_crackers_ptr: .word choose_crackers
choose_crackers: .asciz "Cheese Crackers are $0.65\n"
.align 2
crackers_price_ptr: .word crackers_price
crackers_price: .word 65

.align 2
choose_mnms_ptr: .word choose_mnms
choose_mnms: .asciz "M&Ms are $1.00\n"
.align 2
mnms_price_ptr: .word mnms_price
mnms_price: .word 100

.align 2
invalid_choice_ptr: .word invalid_choice
invalid_choice: .asciz "Invalid choice. Please try again.\n"

.align 2
oos_message_ptr: .word oos_message
oos_message: .asciz "Sorry! Out of stock. Please choose again.\n"

.align 2
inventory_message_ptr: .word inventory_message
inventory_message: .asciz "Inventory mode activated.\n"

.align 2
gum_inventory_ptr: .word gum_inventory
gum_inventory: .asciz "Gum: %d\n"

.align 2
peanuts_inventory_ptr: .word peanuts_inventory
peanuts_inventory: .asciz "Peanuts: %d\n"

.align 2
crackers_inventory_ptr: .word crackers_inventory
crackers_inventory: .asciz "Crackers: %d\n"

.align 2
mnms_inventory_ptr: .word mnms_inventory
mnms_inventory: .asciz "M&Ms: %d\n"

.align 2
format_char_ptr: .word format_char
format_char: .asciz " %c"

.align 2
in_char: .space 1

.align 2
int_gum_ptr: .word int_gum
int_gum: .word 2

.align 2
int_peanuts_ptr: .word int_peanuts
int_peanuts: .word 2

.align 2
int_crackers_ptr: .word int_crackers
int_crackers: .word 2

.align 2
int_mnms_ptr: .word int_mnms
int_mnms: .word 2