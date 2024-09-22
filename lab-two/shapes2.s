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

    @ Check for overflow flag in r8
    CMP     r8, #0
    BEQ     print_result_triangle

    @ Overflow occurred
    LDR     r0, =overflow_msg
    BL      printf
    B       continue_prompt

print_result_triangle:
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

    @ Check for overflow flag in r8
    CMP     r8, #0
    BEQ     print_result_rectangle

    @ Overflow occurred
    LDR     r0, =overflow_msg
    BL      printf
    B       continue_prompt

print_result_rectangle:
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

    @ Check for overflow flag in r8
    CMP     r8, #0
    BEQ     print_result_trapezoid

    @ Overflow occurred
    LDR     r0, =overflow_msg
    BL      printf
    B       continue_prompt

print_result_trapezoid:
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

    @ Check for overflow flag in r8
    CMP     r8, #0
    BEQ     print_result_square

    @ Overflow occurred
    LDR     r0, =overflow_msg
    BL      printf
    B       continue_prompt

print_result_square:
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
    POP     {r10, r11}
    UMULL   r0, r1, r10, r11
    MOV     r8, #0
    TST     r1, r1
    BNE     triangle_overflow
    MOV     r2, r0, LSR #1
    B       triangle_push_result

triangle_overflow:
    MOV     r8, #1
    MOV     r2, #0

triangle_push_result:
    PUSH    {r2}
    POP     {pc}

@ Rectangle area calculation
rectangle_area:
    PUSH    {lr}
    POP     {r10, r11}
    UMULL   r0, r1, r10, r11
    MOV     r8, #0
    TST     r1, r1
    BNE     rectangle_overflow
    MOV     r2, r0
    B       rectangle_push_result

rectangle_overflow:
    MOV     r8, #1
    MOV     r2, #0

rectangle_push_result:
    PUSH    {r2}
    POP     {pc}

@ Trapezoid area calculation
trapezoid_area:
    PUSH    {lr}
    POP     {r10, r11, r12}
    ADDS    r0, r10, r11
    BCC     no_add_overflow_trap
    MOV     r8, #1
    MOV     r2, #0
    B       trap_push_result

no_add_overflow_trap:
    UMULL   r0, r1, r0, r12
    TST     r1, r1
    BNE     trap_overflow
    MOV     r2, r0, LSR #1
    B       trap_push_result

trap_overflow:
    MOV     r8, #1
    MOV     r2, #0

trap_push_result:
    PUSH    {r2}
    POP     {pc}

@ Square area calculation
square_area:
    PUSH    {lr}
    POP     {r10}
    UMULL   r0, r1, r10, r10
    MOV     r8, #0
    TST     r1, r1
    BNE     square_overflow
    MOV     r2, r0
    B       square_push_result

square_overflow:
    MOV     r8, #1
    MOV     r2, #0

square_push_result:
    PUSH    {r2}
    POP     {pc}
