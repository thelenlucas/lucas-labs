    .data
welcome_msg:    .asciz "Welcome to the Area Calculator Program!\n"
instruction_msg: .asciz "\nChoose a shape to calculate the area:\n1. Triangle\n2. Rectangle\n3. Trapezoid\n4. Square\n"
enter_choice_msg: .asciz "Enter your choice (1-4): "
invalid_choice_msg: .asciz "Invalid choice. Please enter a number between 1 and 4.\n"
enter_base_msg: .asciz "Enter the base: "
enter_height_msg: .asciz "Enter the height: "
enter_length_msg: .asciz "Enter the length: "
enter_width_msg: .asciz "Enter the width: "
enter_base1_msg: .asciz "Enter base1: "
enter_base2_msg: .asciz "Enter base2: "
enter_side_msg: .asciz "Enter the side length: "
result_msg: .asciz "The area is: %d\n"
overflow_msg: .asciz "Overflow error: The result does not fit into 32-bit unsigned integer.\n"
continue_msg: .asciz "Do you want to perform another calculation? (y/n): "
invalid_input_msg: .asciz "Invalid input. Please enter a positive integer.\n"
scanf_format: .asciz "%d"
scanf_format_char: .asciz " %c"

    .text
    .global main
    .extern printf
    .extern scanf
    .extern __aeabi_uidiv
    .extern exit

main:
    PUSH    {lr}          @ Save the link register
    @ Print welcome message
    LDR     r0, =welcome_msg
    BL      printf

main_loop:
    @ Print instruction message
    LDR     r0, =instruction_msg
    BL      printf

get_choice:
    @ Prompt for choice
    LDR     r0, =enter_choice_msg
    BL      printf

    @ Read user input
    SUB     sp, sp, #4      @ Allocate 4 bytes on stack
    MOV     r1, sp          @ Pointer to allocated space
    LDR     r0, =scanf_format
    BL      scanf
    CMP     r0, #1
    BNE     invalid_choice_input

    LDR     r4, [sp]        @ Load user's choice into r4
    ADD     sp, sp, #4      @ Clean up stack

    @ Check if choice is between 1 and 4
    CMP     r4, #1
    BLT     invalid_choice
    CMP     r4, #4
    BGT     invalid_choice

    B       process_choice

invalid_choice_input:
    @ Invalid input (non-integer)
    LDR     r0, =invalid_choice_msg
    BL      printf
    ADD     sp, sp, #4      @ Clean up stack
    B       get_choice

invalid_choice:
    @ Invalid choice (not between 1 and 4)
    LDR     r0, =invalid_choice_msg
    BL      printf
    B       get_choice

process_choice:
    CMP     r4, #1
    BEQ     triangle_case
    CMP     r4, #2
    BEQ     rectangle_case
    CMP     r4, #3
    BEQ     trapezoid_case
    CMP     r4, #4
    BEQ     square_case
    @ Should not reach here
    B       invalid_choice

@ Triangle case
triangle_case:
    @ Prompt for base
    MOV     r5, #0
get_base:
    LDR     r0, =enter_base_msg
    BL      printf
    SUB     sp, sp, #4
    MOV     r1, sp
    LDR     r0, =scanf_format
    BL      scanf
    CMP     r0, #1
    BNE     invalid_input_base
    LDR     r5, [sp]
    ADD     sp, sp, #4
    CMP     r5, #1
    BLT     invalid_input_base

    @ Prompt for height
    MOV     r6, #0
get_height:
    LDR     r0, =enter_height_msg
    BL      printf
    SUB     sp, sp, #4
    MOV     r1, sp
    LDR     r0, =scanf_format
    BL      scanf
    CMP     r0, #1
    BNE     invalid_input_height
    LDR     r6, [sp]
    ADD     sp, sp, #4
    CMP     r6, #1
    BLT     invalid_input_height

    @ Push operands onto stack
    PUSH    {r5, r6}

    @ Call triangle_area function
    BL      triangle_area

    @ Result is on top of stack
    POP     {r7}            @ Pop result into r7

    @ Print the result
    LDR     r0, =result_msg
    MOV     r1, r7
    BL      printf
    B       continue_prompt

invalid_input_base:
    @ Invalid base input
    LDR     r0, =invalid_input_msg
    BL      printf
    ADD     sp, sp, #4
    B       get_base

invalid_input_height:
    @ Invalid height input
    LDR     r0, =invalid_input_msg
    BL      printf
    ADD     sp, sp, #4
    B       get_height

@ Rectangle case
rectangle_case:
    @ Prompt for length
    MOV     r5, #0
get_length:
    LDR     r0, =enter_length_msg
    BL      printf
    SUB     sp, sp, #4
    MOV     r1, sp
    LDR     r0, =scanf_format
    BL      scanf
    CMP     r0, #1
    BNE     invalid_input_length
    LDR     r5, [sp]
    ADD     sp, sp, #4
    CMP     r5, #1
    BLT     invalid_input_length

    @ Prompt for width
    MOV     r6, #0
get_width:
    LDR     r0, =enter_width_msg
    BL      printf
    SUB     sp, sp, #4
    MOV     r1, sp
    LDR     r0, =scanf_format
    BL      scanf
    CMP     r0, #1
    BNE     invalid_input_width
    LDR     r6, [sp]
    ADD     sp, sp, #4
    CMP     r6, #1
    BLT     invalid_input_width

    @ Push operands onto stack
    PUSH    {r5, r6}

    @ Call rectangle_area function
    BL      rectangle_area

    @ Result is on top of stack
    POP     {r7}            @ Pop result into r7

    @ Print the result
    LDR     r0, =result_msg
    MOV     r1, r7
    BL      printf
    B       continue_prompt

invalid_input_length:
    @ Invalid length input
    LDR     r0, =invalid_input_msg
    BL      printf
    ADD     sp, sp, #4
    B       get_length

invalid_input_width:
    @ Invalid width input
    LDR     r0, =invalid_input_msg
    BL      printf
    ADD     sp, sp, #4
    B       get_width

@ Trapezoid case
trapezoid_case:
    @ Prompt for base1
    MOV     r5, #0
get_base1:
    LDR     r0, =enter_base1_msg
    BL      printf
    SUB     sp, sp, #4
    MOV     r1, sp
    LDR     r0, =scanf_format
    BL      scanf
    CMP     r0, #1
    BNE     invalid_input_base1
    LDR     r5, [sp]
    ADD     sp, sp, #4
    CMP     r5, #1
    BLT     invalid_input_base1

    @ Prompt for base2
    MOV     r6, #0
get_base2:
    LDR     r0, =enter_base2_msg
    BL      printf
    SUB     sp, sp, #4
    MOV     r1, sp
    LDR     r0, =scanf_format
    BL      scanf
    CMP     r0, #1
    BNE     invalid_input_base2
    LDR     r6, [sp]
    ADD     sp, sp, #4
    CMP     r6, #1
    BLT     invalid_input_base2

    @ Prompt for height
    MOV     r7, #0
get_height_trap:
    LDR     r0, =enter_height_msg
    BL      printf
    SUB     sp, sp, #4
    MOV     r1, sp
    LDR     r0, =scanf_format
    BL      scanf
    CMP     r0, #1
    BNE     invalid_input_height_trap
    LDR     r7, [sp]
    ADD     sp, sp, #4
    CMP     r7, #1
    BLT     invalid_input_height_trap

    @ Push operands onto stack
    PUSH    {r5, r6, r7}

    @ Call trapezoid_area function
    BL      trapezoid_area

    @ Result is on top of stack
    POP     {r4}            @ Pop result into r4

    @ Print the result
    LDR     r0, =result_msg
    MOV     r1, r4
    BL      printf
    B       continue_prompt

invalid_input_base1:
    LDR     r0, =invalid_input_msg
    BL      printf
    ADD     sp, sp, #4
    B       get_base1

invalid_input_base2:
    LDR     r0, =invalid_input_msg
    BL      printf
    ADD     sp, sp, #4
    B       get_base2

invalid_input_height_trap:
    LDR     r0, =invalid_input_msg
    BL      printf
    ADD     sp, sp, #4
    B       get_height_trap

@ Square case
square_case:
    @ Prompt for side length
    MOV     r5, #0
get_side:
    LDR     r0, =enter_side_msg
    BL      printf
    SUB     sp, sp, #4
    MOV     r1, sp
    LDR     r0, =scanf_format
    BL      scanf
    CMP     r0, #1
    BNE     invalid_input_side
    LDR     r5, [sp]
    ADD     sp, sp, #4
    CMP     r5, #1
    BLT     invalid_input_side

    @ Push operand onto stack
    PUSH    {r5}

    @ Call square_area function
    BL      square_area

    @ Result is on top of stack
    POP     {r6}            @ Pop result into r6

    @ Print the result
    LDR     r0, =result_msg
    MOV     r1, r6
    BL      printf
    B       continue_prompt

invalid_input_side:
    LDR     r0, =invalid_input_msg
    BL      printf
    ADD     sp, sp, #4
    B       get_side

continue_prompt:
    LDR     r0, =continue_msg
    BL      printf
    SUB     sp, sp, #4
    MOV     r1, sp
    LDR     r0, =scanf_format_char
    BL      scanf
    LDRB    r4, [sp]
    ADD     sp, sp, #4
    CMP     r4, #'y'
    BEQ     main_loop
    CMP     r4, #'Y'
    BEQ     main_loop
    B       program_exit

program_exit:
    MOV     r0, #0
    BL      exit

@ Triangle area calculation
triangle_area:
    PUSH    {lr}
    POP     {r10, r11}    @ Pop operands into r10 and r11
    @ Multiply base and height
    UMULL   r0, r1, r10, r11
    @ Check if high word (r1) is zero
    CMP     r1, #0
    BNE     triangle_overflow
    @ Divide by 2 using logical shift right
    MOV     r2, r0, LSR #1
    @ Push result onto stack
    PUSH    {r2}
    MOV     pc, lr

triangle_overflow:
    BL      overflow_handler
    B       triangle_area_exit

triangle_area_exit:
    MOV     pc, lr

@ Rectangle area calculation
rectangle_area:
    PUSH    {lr}
    POP     {r10, r11}    @ Pop operands into r10 and r11
    @ Multiply length and width
    UMULL   r0, r1, r10, r11
    @ Check if high word (r1) is zero
    CMP     r1, #0
    BNE     rectangle_overflow
    @ Push result onto stack
    PUSH    {r0}
    MOV     pc, lr

rectangle_overflow:
    BL      overflow_handler
    B       rectangle_area_exit

rectangle_area_exit:
    MOV     pc, lr

@ Trapezoid area calculation
trapezoid_area:
    PUSH    {lr}
    POP     {r10, r11, r12}   @ Pop operands into r10 (base1), r11 (base2), r12 (height)
    @ Add base1 and base2
    ADDS    r0, r10, r11      @ r0 = base1 + base2, set flags
    BVS     trapezoid_overflow
    @ Multiply (base1 + base2) * height
    UMULL   r0, r1, r0, r12
    @ Check if high word (r1) is zero
    CMP     r1, #0
    BNE     trapezoid_overflow
    @ Divide by 2
    MOV     r2, r0, LSR #1
    @ Push result onto stack
    PUSH    {r2}
    MOV     pc, lr

trapezoid_overflow:
    BL      overflow_handler
    B       trapezoid_area_exit

trapezoid_area_exit:
    MOV     pc, lr

@ Square area calculation
square_area:
    PUSH    {lr}
    POP     {r10}         @ Pop operand into r10
    @ Multiply side * side
    UMULL   r0, r1, r10, r10
    @ Check if high word (r1) is zero
    CMP     r1, #0
    BNE     square_overflow
    @ Push result onto stack
    PUSH    {r0}
    MOV     pc, lr

square_overflow:
    BL      overflow_handler
    B       square_area_exit

square_area_exit:
    MOV     pc, lr

@ Overflow handler
overflow_handler:
    LDR     r0, =overflow_msg
    BL      printf
    @ Push zero as result to maintain stack consistency
    MOV     r0, #0
    PUSH    {r0}
    MOV     pc, lr
