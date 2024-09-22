.global main

main:
    ldr     r0, =welcome
    bl      printf
    b       loop

loop:
    ldr     r0, =choices
    bl      printf

    @ Get user input with validation
get_menu_choice:
    ldr     r0, =enter_choice
    bl      printf

    ldr     r0, =format_int
    ldr     r1, =int_a
    bl      scanf
    bl      check_input_validity
    cmp     r0, #0
    beq     get_menu_choice

    ldr     r0, =int_a
    ldr     r0, [r0]

    cmp     r0, #1
    beq     loop_triangle

    cmp     r0, #2
    beq     loop_square

    cmp     r0, #3
    beq     loop_rect

    cmp     r0, #4
    beq     loop_trap

    @ Invalid menu selection
    ldr     r0, =invalid_choice
    bl      printf
    b       loop

loop_triangle:
    @ Get base with validation
get_triangle_base:
    ldr     r0, =base_string
    bl      printf

    ldr     r0, =format_int
    ldr     r1, =int_a
    bl      scanf
    bl      check_input_validity
    cmp     r0, #0
    beq     get_triangle_base

    @ Check for positive integer
    ldr     r0, =int_a
    ldr     r0, [r0]
    cmp     r0, #1
    blt     invalid_dimension_triangle_base

    @ Get height with validation
get_triangle_height:
    ldr     r0, =height_string
    bl      printf

    ldr     r0, =format_int
    ldr     r1, =int_b
    bl      scanf
    bl      check_input_validity
    cmp     r0, #0
    beq     get_triangle_height

    @ Check for positive integer
    ldr     r0, =int_b
    ldr     r0, [r0]
    cmp     r0, #1
    blt     invalid_dimension_triangle_height

    @ Pass base and height to triangle_area
    ldr     r0, =int_a
    ldr     r1, =int_b
    ldr     r0, [r0]
    ldr     r1, [r1]
    push    {r0, r1}
    bl      triangle_area

    @ Print result
    pop     {r1}
    ldr     r0, =print_area
    bl      printf

    b       loop_end

invalid_dimension_triangle_base:
    ldr     r0, =invalid_dimension
    bl      printf
    b       get_triangle_base

invalid_dimension_triangle_height:
    ldr     r0, =invalid_dimension
    bl      printf
    b       get_triangle_height

loop_square:
    @ Get side with validation
get_square_side:
    ldr     r0, =side_string
    bl      printf

    ldr     r0, =format_int
    ldr     r1, =int_a
    bl      scanf
    bl      check_input_validity
    cmp     r0, #0
    beq     get_square_side

    @ Check for positive integer
    ldr     r0, =int_a
    ldr     r0, [r0]
    cmp     r0, #1
    blt     invalid_dimension_square_side

    @ Use rectangle_area for square
    mov     r1, r0
    push    {r0, r1}
    bl      rectangle_area

    @ Print result
    pop     {r1}
    ldr     r0, =print_area
    bl      printf

    b       loop_end

invalid_dimension_square_side:
    ldr     r0, =invalid_dimension
    bl      printf
    b       get_square_side

loop_rect:
    @ Get base with validation
get_rectangle_base:
    ldr     r0, =base_string
    bl      printf

    ldr     r0, =format_int
    ldr     r1, =int_a
    bl      scanf
    bl      check_input_validity
    cmp     r0, #0
    beq     get_rectangle_base

    @ Check for positive integer
    ldr     r0, =int_a
    ldr     r0, [r0]
    cmp     r0, #1
    blt     invalid_dimension_rectangle_base

    @ Get height with validation
get_rectangle_height:
    ldr     r0, =height_string
    bl      printf

    ldr     r0, =format_int
    ldr     r1, =int_b
    bl      scanf
    bl      check_input_validity
    cmp     r0, #0
    beq     get_rectangle_height

    @ Check for positive integer
    ldr     r0, =int_b
    ldr     r0, [r0]
    cmp     r0, #1
    blt     invalid_dimension_rectangle_height

    @ Pass base and height to rectangle_area
    ldr     r0, =int_a
    ldr     r1, =int_b
    ldr     r0, [r0]
    ldr     r1, [r1]
    push    {r0, r1}
    bl      rectangle_area

    @ Print result
    pop     {r1}
    ldr     r0, =print_area
    bl      printf

    b       loop_end

invalid_dimension_rectangle_base:
    ldr     r0, =invalid_dimension
    bl      printf
    b       get_rectangle_base

invalid_dimension_rectangle_height:
    ldr     r0, =invalid_dimension
    bl      printf
    b       get_rectangle_height

loop_trap:
    @ Get base with validation
get_trapezoid_base:
    ldr     r0, =base_string
    bl      printf

    ldr     r0, =format_int
    ldr     r1, =int_a
    bl      scanf
    bl      check_input_validity
    cmp     r0, #0
    beq     get_trapezoid_base

    @ Check for positive integer
    ldr     r0, =int_a
    ldr     r0, [r0]
    cmp     r0, #1
    blt     invalid_dimension_trapezoid_base

    @ Get upper base with validation
get_trapezoid_upper_base:
    ldr     r0, =upper_base_string
    bl      printf

    ldr     r0, =format_int
    ldr     r1, =int_b
    bl      scanf
    bl      check_input_validity
    cmp     r0, #0
    beq     get_trapezoid_upper_base

    @ Check for positive integer
    ldr     r0, =int_b
    ldr     r0, [r0]
    cmp     r0, #1
    blt     invalid_dimension_trapezoid_upper_base

    @ Get height with validation
get_trapezoid_height:
    ldr     r0, =height_string
    bl      printf

    ldr     r0, =format_int
    ldr     r1, =int_c
    bl      scanf
    bl      check_input_validity
    cmp     r0, #0
    beq     get_trapezoid_height

    @ Check for positive integer
    ldr     r0, =int_c
    ldr     r0, [r0]
    cmp     r0, #1
    blt     invalid_dimension_trapezoid_height

    @ Pass bases and height to trapezoid_area
    ldr     r0, =int_a
    ldr     r1, =int_b
    ldr     r2, =int_c
    ldr     r0, [r0]
    ldr     r1, [r1]
    ldr     r2, [r2]
    push    {r0, r1, r2}
    bl      trapezoid_area

    @ Print result
    pop     {r1}
    ldr     r0, =print_area
    bl      printf

    b       loop_end

invalid_dimension_trapezoid_base:
    ldr     r0, =invalid_dimension
    bl      printf
    b       get_trapezoid_base

invalid_dimension_trapezoid_upper_base:
    ldr     r0, =invalid_dimension
    bl      printf
    b       get_trapezoid_upper_base

invalid_dimension_trapezoid_height:
    ldr     r0, =invalid_dimension
    bl      printf
    b       get_trapezoid_height

loop_end:
    @ Ask user to continue or quit
    ldr     r0, =continue_prompt
    bl      printf

    ldr     r0, =format_char
    ldr     r1, =char_input
    bl      scanf

	ldr     r0, =char_input
    ldrb    r0, [r0]
    cmp     r0, #'Y'
    beq     loop
    cmp     r0, #'y'
    beq     loop
    cmp     r0, #'N'
    beq     exit
    cmp     r0, #'n'
    beq     exit

    @ Invalid input, ask again
    ldr     r0, =invalid_choice
    bl      printf
    b       loop_end

exit:
    mov     r7, #1
    svc     0

@ Subroutine to check input validity
@ Returns r0 = 1 if valid, 0 if invalid
check_input_validity:
    cmp     r0, #1          @ scanf should return 1 for successful read
    beq     valid_input
    ldr     r0, =invalid_input
    bl      printf
    mov     r0, #0
    bx      lr

valid_input:
    mov     r0, #1
    bx      lr

@ Subroutine to print an overflow message
overflow:
    push    {lr}
    ldr     r0, =overflow_result
    bl      printf
    pop     {lr}
    bx      lr

@ Input: base, height
@ Output: area
triangle_area:
    @ Inputs are on stack, pop them to r10 and r11
    pop     {r10, r11}

    @ Preserve lr
    push    {lr}

    @ Calculate area
    smull   r0, r1, r10, r11

    @ Check for overflow
    cmp     r1, #0
    bne     tri_calc_overflow

    b       tri_calc_end

tri_calc_overflow:
    bl      overflow
    b       tri_calc_end

tri_calc_end:
    @ Divide by 2 using asr
    asr     r0, r0, #1

    @ Restore lr
    pop     {lr}
    @ Push result to stack
    push    {r0}
    bx      lr

@ Rectangle area calculation
rectangle_area:
    @ Inputs are on stack, pop them to r10 and r11
    pop     {r10, r11}

    @ Preserve lr
    push    {lr}

    @ Calculate area
    smull   r0, r1, r10, r11

    @ Check for overflow
    cmp     r1, #0
    bne     rect_calc_overflow

    b       rect_calc_end

rect_calc_overflow:
    bl      overflow
    b       rect_calc_end

rect_calc_end:
    @ Restore lr
    pop     {lr}
    @ Push result to stack
    push    {r0}
    bx      lr

@ Trapezoid area calculation
@ Inputs: base1, base2, height
trapezoid_area:
    @ Inputs are on stack, pop them to r10, r11, r12
    pop     {r10, r11, r12}

    @ Preserve lr
    push    {lr}

    @ Add the bases
    add     r0, r10, r11
    bvs     trap_add_overflow
    b       trap_mul

trap_add_overflow:
    bl      overflow
    b       trap_calc_end

trap_mul:
    smull   r0, r1, r0, r12

    @ Check for overflow
    cmp     r1, #0
    bne     trap_calc_overflow

    b       trap_calc_end

trap_calc_overflow:
    bl      overflow
    b       trap_calc_end

trap_calc_end:
    @ Divide by 2 using asr
    asr     r0, r0, #1

    @ Restore lr
    pop     {lr}
    @ Push result to stack
    push    {r0}
    bx      lr

.data
.balign 4
welcome:
    .asciz "Welcome!\n"

.balign 4
choices:
    .asciz "Please choose a shape:\nTriangle (1)\nSquare (2)\nRectangle (3)\nTrapezoid (4)\n"

.balign 4
enter_choice:
    .asciz "Enter your choice: "

.balign 4
base_string:
    .asciz "Please enter the base length: "

.balign 4
height_string:
    .asciz "Please enter the height length: "

.balign 4
upper_base_string:
    .asciz "Please enter the upper base length: "

.balign 4
side_string:
    .asciz "Please enter the side length: "

.balign 4
overflow_result:
    .asciz "Overflow detected.\n"

.balign 4
print_area:
    .asciz "The area is: %d!\n"

.balign 4
invalid_input:
    .asciz "Invalid input. Please enter a valid integer.\n"

.balign 4
invalid_dimension:
    .asciz "Invalid input. Please enter a positive integer.\n"

.balign 4
invalid_choice:
    .asciz "Invalid choice. Please try again.\n"

.balign 4
continue_prompt:
    .asciz "Do you want to perform another calculation? (Y/N): "

.balign 4
format_int:
    .asciz "%d"

.balign 4
format_char:
    .asciz " %c"

.balign 4
int_a:
    .word 0

.balign 4
int_b:
    .word 0

.balign 4
int_c:
    .word 0

.balign 4
char_input:
    .byte 0
