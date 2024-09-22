@ ------------------------------------------------------------
@ LAB ONE: Shape Calculator
@
@ AUTHOR: LUCAS THELEN
@
@ PURPOSE: Request user input to calculate the area of a chosen shape
@
@ COMPILE AND RUN: 
@ `as -o shapes.o shapes && gcc -o program shapes.o`
@ ./program
@ ------------------------------------------------------------

.global main

main:
	@ Entry point of the program
	@ Display welcome message
	ldr	r0, =welcome		@ Load address of welcome string into r0
	bl	printf			@ Call printf to display the welcome message
	b	loop			@ Branch to the main loop

loop:
	@ Main program loop where the user is prompted for input
	ldr	r0, =choices		@ Load address of choices string into r0
	bl	printf			@ Display the choices to the user

	@ Get user's menu choice with input validation
get_menu_choice:
	ldr	r0, =enter_choice	@ Load address of enter_choice string into r0
	bl	printf			@ Prompt the user to enter their choice

	ldr	r0, =format_int		@ Load format string for integer input into r0
	ldr	r1, =int_a		@ Load address of int_a variable into r1
	bl	scanf			@ Read user input and store it at int_a
	bl	check_input_validity	@ Validate the input
	cmp	r0, #0			@ Compare return value of validation to 0
	beq	get_menu_choice		@ If invalid, prompt again

	ldr	r0, =int_a		@ Load address of int_a into r0
	ldr	r0, [r0]		@ Load the user's choice into r0

	@ Check which shape the user selected and branch accordingly
	cmp	r0, #1
	beq	loop_triangle		@ If choice is 1, go to triangle calculation

	cmp	r0, #2
	beq	loop_square		@ If choice is 2, go to square calculation

	cmp	r0, #3
	beq	loop_rect		@ If choice is 3, go to rectangle calculation

	cmp	r0, #4
	beq	loop_trap		@ If choice is 4, go to trapezoid calculation

	@ If the choice is invalid, display an error message and loop again
	ldr	r0, =invalid_choice	@ Load address of invalid_choice string
	bl	printf			@ Display invalid choice message
	b	loop			@ Go back to the main loop

loop_triangle:
	@ Triangle area calculation
	@ Get base length with validation
get_triangle_base:
	ldr	r0, =base_string	@ Prompt for base length
	bl	printf

	ldr	r0, =format_int		@ Format string for integer input
	ldr	r1, =int_a		@ Address to store base length
	bl	scanf
	bl	check_input_validity	@ Validate input
	cmp	r0, #0
	beq	get_triangle_base	@ If invalid, prompt again

	@ Check if the base length is a positive integer
	ldr	r0, =int_a
	ldr	r0, [r0]		@ Load base length into r0
	cmp	r0, #1
	blt	invalid_dimension_triangle_base	@ If less than 1, invalid

	@ Get height length with validation
get_triangle_height:
	ldr	r0, =height_string	@ Prompt for height length
	bl	printf

	ldr	r0, =format_int
	ldr	r1, =int_b		@ Address to store height length
	bl	scanf
	bl	check_input_validity
	cmp	r0, #0
	beq	get_triangle_height	@ If invalid, prompt again

	@ Check if the height length is a positive integer
	ldr	r0, =int_b
	ldr	r0, [r0]		@ Load height length into r0
	cmp	r0, #1
	blt	invalid_dimension_triangle_height	@ If less than 1, invalid

	@ Prepare to call triangle_area subroutine
	ldr	r0, =int_a
	ldr	r1, =int_b
	ldr	r2, [r0]		@ Load base length into r2
	ldr	r3, [r1]		@ Load height length into r3
	push	{r2, r3}		@ Push base and height onto the stack
	bl	triangle_area		@ Call the triangle_area subroutine

	@ Retrieve and display the calculated area
	pop	{r1}			@ Pop the result (area) into r1
	ldr	r0, =print_area		@ Load the format string for area display
	bl	printf			@ Display the area

	b	loop_end		@ Go to end of loop to ask if user wants to continue

invalid_dimension_triangle_base:
	@ Handle invalid base length input
	ldr	r0, =invalid_dimension	@ Load invalid dimension message
	bl	printf			@ Display error message
	b	get_triangle_base	@ Prompt for base length again

invalid_dimension_triangle_height:
	@ Handle invalid height length input
	ldr	r0, =invalid_dimension
	bl	printf
	b	get_triangle_height	@ Prompt for height length again

loop_square:
	@ Square area calculation
	@ Get side length with validation
get_square_side:
	ldr	r0, =side_string	@ Prompt for side length
	bl	printf

	ldr	r0, =format_int
	ldr	r1, =int_a		@ Address to store side length
	bl	scanf
	bl	check_input_validity
	cmp	r0, #0
	beq	get_square_side		@ If invalid, prompt again

	@ Check if the side length is a positive integer
	ldr	r0, =int_a
	ldr	r2, [r0]		@ Load side length into r2
	cmp	r2, #1
	blt	invalid_dimension_square_side	@ If less than 1, invalid

	@ Use rectangle_area subroutine for square (since area = side * side)
	mov	r3, r2			@ Copy side length into r3
	push	{r2, r3}		@ Push side and side onto the stack
	bl	rectangle_area		@ Call rectangle_area subroutine

	@ Retrieve and display the calculated area
	pop	{r1}			@ Pop the result (area) into r1
	ldr	r0, =print_area
	bl	printf

	b	loop_end

invalid_dimension_square_side:
	@ Handle invalid side length input
	ldr	r0, =invalid_dimension
	bl	printf
	b	get_square_side		@ Prompt for side length again

loop_rect:
	@ Rectangle area calculation
	@ Get base length with validation
get_rectangle_base:
	ldr	r0, =base_string	@ Prompt for base length
	bl	printf

	ldr	r0, =format_int
	ldr	r1, =int_a		@ Address to store base length
	bl	scanf
	bl	check_input_validity
	cmp	r0, #0
	beq	get_rectangle_base	@ If invalid, prompt again

	@ Check if the base length is a positive integer
	ldr	r0, =int_a
	ldr	r2, [r0]		@ Load base length into r2
	cmp	r2, #1
	blt	invalid_dimension_rectangle_base

	@ Get height length with validation
get_rectangle_height:
	ldr	r0, =height_string	@ Prompt for height length
	bl	printf

	ldr	r0, =format_int
	ldr	r1, =int_b		@ Address to store height length
	bl	scanf
	bl	check_input_validity
	cmp	r0, #0
	beq	get_rectangle_height	@ If invalid, prompt again

	@ Check if the height length is a positive integer
	ldr	r0, =int_b
	ldr	r3, [r0]		@ Load height length into r3
	cmp	r3, #1
	blt	invalid_dimension_rectangle_height

	@ Call rectangle_area subroutine
	push	{r2, r3}		@ Push base and height onto the stack
	bl	rectangle_area

	@ Retrieve and display the calculated area
	pop	{r1}			@ Pop the result (area) into r1
	ldr	r0, =print_area
	bl	printf

	b	loop_end

invalid_dimension_rectangle_base:
	@ Handle invalid base length input
	ldr	r0, =invalid_dimension
	bl	printf
	b	get_rectangle_base	@ Prompt for base length again

invalid_dimension_rectangle_height:
	@ Handle invalid height length input
	ldr	r0, =invalid_dimension
	bl	printf
	b	get_rectangle_height	@ Prompt for height length again

loop_trap:
	@ Trapezoid area calculation
	@ Get base length with validation
get_trapezoid_base:
	ldr	r0, =base_string	@ Prompt for base length
	bl	printf

	ldr	r0, =format_int
	ldr	r1, =int_a		@ Address to store base length
	bl	scanf
	bl	check_input_validity
	cmp	r0, #0
	beq	get_trapezoid_base	@ If invalid, prompt again

	@ Check if the base length is a positive integer
	ldr	r0, =int_a
	ldr	r2, [r0]		@ Load base length into r2
	cmp	r2, #1
	blt	invalid_dimension_trapezoid_base

	@ Get upper base length with validation
get_trapezoid_upper_base:
	ldr	r0, =upper_base_string	@ Prompt for upper base length
	bl	printf

	ldr	r0, =format_int
	ldr	r1, =int_b		@ Address to store upper base length
	bl	scanf
	bl	check_input_validity
	cmp	r0, #0
	beq	get_trapezoid_upper_base	@ If invalid, prompt again

	@ Check if the upper base length is a positive integer
	ldr	r0, =int_b
	ldr	r3, [r0]		@ Load upper base length into r3
	cmp	r3, #1
	blt	invalid_dimension_trapezoid_upper_base

	@ Get height length with validation
get_trapezoid_height:
	ldr	r0, =height_string	@ Prompt for height length
	bl	printf

	ldr	r0, =format_int
	ldr	r1, =int_c		@ Address to store height length
	bl	scanf
	bl	check_input_validity
	cmp	r0, #0
	beq	get_trapezoid_height	@ If invalid, prompt again

	@ Check if the height length is a positive integer
	ldr	r0, =int_c
	ldr	r4, [r0]		@ Load height length into r4
	cmp	r4, #1
	blt	invalid_dimension_trapezoid_height

	@ Call trapezoid_area subroutine
	push	{r2, r3, r4}		@ Push base, upper base, and height onto the stack
	bl	trapezoid_area

	@ Retrieve and display the calculated area
	pop	{r1}			@ Pop the result (area) into r1
	ldr	r0, =print_area
	bl	printf

	b	loop_end

invalid_dimension_trapezoid_base:
	@ Handle invalid base length input
	ldr	r0, =invalid_dimension
	bl	printf
	b	get_trapezoid_base	@ Prompt for base length again

invalid_dimension_trapezoid_upper_base:
	@ Handle invalid upper base length input
	ldr	r0, =invalid_dimension
	bl	printf
	b	get_trapezoid_upper_base	@ Prompt for upper base length again

invalid_dimension_trapezoid_height:
	@ Handle invalid height length input
	ldr	r0, =invalid_dimension
	bl	printf
	b	get_trapezoid_height	@ Prompt for height length again

loop_end:
	@ Prompt user to perform another calculation or exit
	ldr	r0, =continue_prompt	@ Load continue prompt message
	bl	printf

	ldr	r0, =format_char	@ Format string for single character input
	ldr	r1, =char_input		@ Address to store user's response
	bl	scanf

	ldrb	r0, [char_input]	@ Load user's response into r0
	cmp	r0, #'Y'		@ Compare with 'Y'
	beq	loop			@ If 'Y', repeat loop
	cmp	r0, #'y'		@ Compare with 'y'
	beq	loop
	cmp	r0, #'N'		@ Compare with 'N'
	beq	exit			@ If 'N', exit program
	cmp	r0, #'n'		@ Compare with 'n'
	beq	exit

	@ If invalid input, display error and prompt again
	ldr	r0, =invalid_choice
	bl	printf
	b	loop_end		@ Prompt user again

exit:
	@ Exit the program gracefully
	mov	r7, #1			@ syscall number for exit
	svc	0			@ Make system call to exit

@ Subroutine to check input validity
@ Validates the result of scanf
@ Returns r0 = 1 if valid, 0 if invalid
check_input_validity:
	cmp	r0, #1			@ scanf should return 1 if successful
	beq	valid_input		@ If equal, input is valid
	ldr	r0, =invalid_input	@ Load invalid input message
	bl	printf			@ Display error message
	mov	r0, #0			@ Set return value to 0 (invalid)
	bx	lr			@ Return from subroutine

valid_input:
	mov	r0, #1			@ Set return value to 1 (valid)
	bx	lr			@ Return from subroutine

@ Subroutine to print an overflow message
overflow:
	push	{lr}			@ Save return address
	ldr	r0, =overflow_result	@ Load overflow message
	bl	printf			@ Display overflow message
	pop	{lr}			@ Restore return address
	bx	lr			@ Return from subroutine

@ Triangle area calculation subroutine
@ Inputs: base and height (popped from stack into r10 and r11)
@ Output: area (pushed onto stack)
triangle_area:
	pop	{r10, r11}		@ Pop base into r10 and height into r11

	push	{lr}			@ Save return address

	@ Calculate area = (base * height) / 2
	smull	r2, r3, r10, r11	@ Multiply base and height, result in r2 (low), r3 (high)

	@ Check for multiplication overflow
	cmp	r3, #0			@ If high part of result is not zero, overflow occurred
	bne	tri_calc_overflow

	@ No overflow, proceed to division
	b	tri_calc_end

tri_calc_overflow:
	bl	overflow		@ Call overflow subroutine
	b	tri_calc_end

tri_calc_end:
	asr	r2, r2, #1		@ Divide the result by 2 using arithmetic shift right
	pop	{lr}			@ Restore return address
	push	{r2}			@ Push the area result onto the stack
	bx	lr			@ Return from subroutine

@ Rectangle area calculation subroutine
@ Inputs: base and height (popped from stack into r10 and r11)
@ Output: area (pushed onto stack)
rectangle_area:
	pop	{r10, r11}		@ Pop base into r10 and height into r11

	push	{lr}			@ Save return address

	@ Calculate area = base * height
	smull	r2, r3, r10, r11	@ Multiply base and height

	@ Check for multiplication overflow
	cmp	r3, #0			@ If high part of result is not zero, overflow occurred
	bne	rect_calc_overflow

	b	rect_calc_end

rect_calc_overflow:
	bl	overflow		@ Call overflow subroutine
	b	rect_calc_end

rect_calc_end:
	pop	{lr}			@ Restore return address
	push	{r2}			@ Push the area result onto the stack
	bx	lr			@ Return from subroutine

@ Trapezoid area calculation subroutine
@ Inputs: base1, base2, and height (popped from stack into r10, r11, r12)
@ Output: area (pushed onto stack)
trapezoid_area:
	pop	{r10, r11, r12}		@ Pop base1 into r10, base2 into r11, height into r12

	push	{lr}			@ Save return address

	@ Calculate sum of bases
	add	r2, r10, r11		@ r2 = base1 + base2
	bvs	trap_add_overflow	@ If overflow occurs during addition, branch

	@ Multiply sum by height
trap_mul:
	smull	r4, r5, r2, r12		@ Multiply (base1 + base2) * height

	@ Check for multiplication overflow
	cmp	r5, #0			@ If high part of result is not zero, overflow occurred
	bne	trap_calc_overflow

	b	trap_calc_end

trap_add_overflow:
	bl	overflow		@ Call overflow subroutine
	b	trap_calc_end

trap_calc_overflow:
	bl	overflow
	b	trap_calc_end

trap_calc_end:
	asr	r4, r4, #1		@ Divide the result by 2
	pop	{lr}			@ Restore return address
	push	{r4}			@ Push the area result onto the stack
	bx	lr			@ Return from subroutine
