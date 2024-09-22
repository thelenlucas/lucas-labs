@ -----------------------------------
@ Lab One:	Shapes' Area
@
@ Author:	Lucas Thelen
@
@ Usage:	Requests a shap type,
@		calculates it's area
@		and reports it's area
@		plus any found errors
@ 
@ Compile/Run:
@ `as -o program.o && gcc -o program program.o && ./a.program`
@ -----------------------------------

	.global main
	.text

main:
	@ Just used as an entry here

	b	loop

input_error:
	@ Error message
	ldr	r0, =bad_input_msg
	bl	printf
	b	loop

loop:
	@ Welcome Message
	ldr	r0, =welcome_message
	bl	printf
	
	@ Get the user's entry
	ldr	r0, =request_entry
	ldr	r1, =buffer
	bl	scanf

	@ Load it back into r1
	ldr	r1, =buffer
	ldrb	r1, [r1]

	@ Triangle?
	cmp	r1, #1
	beq	quad_calc

	@ If we didn't hit any of those conditions, we need to show error and try again
	b	input_error

	b	exit

triangle_calc:
	@ Get the base
	ldr	r0, =base_string
	ldr	r1, =int_a
	bl	scanf

	@ Get the height
	ldr	r0, =height_string
	ldr	r1, =int_b
	bl	scanf

	@ Load values
	ldr	r0, =int_a
	ldr	r0, [r0]
	ldr	r1, =int_b
	ldr	r1, [r1]

	@ Call function
	push	{r0, r1}
	bl	triangle_area
	pop	{r1}

	@ Goto loop end
	b	loop_end

rectangle_calc:
	b	loop_end

square_calc:
	b	loop_end

quad_calc:
	b	loop_end

loop_end:
	ldr	r0, =format_int
	b	printf
	b	loop

exit:
	@ Exit
	mov	r7, #1
	svc	#0

@ Reports an overflow
overflow_report:
	push	{lr}
	ldr	r0, =overflow_message
	bl	printf
	pop	{lr}
	bx	lr

@ Takes {base, height} as the top two integers on the stack
@ Returns {area, overflow} as the top of the stack
triangle_area:
	pop	{r10, r11}	@ Get the inputs
	@ I'm going to use r10,r11 for the inputs in general

	@ A(T) = T_b * T_h / 2	

	mul	r0, r10, r11
	
	bvs	triangle_overflow_report
	b	triangle_done

triangle_overflow_report:
	push	{lr}
	bl	overflow_report
	pop	{lr}

triangle_done:
	asr	r0, r0, #1	@ Hijack shift right to divide by two

	push	{r0}		@ Push onto the stack to return value

	bx	lr		@ Return to caller


@ Calculates the area of a rectangle
@ Input: Base, Height
@ Output: Area, overflow
rectangle_area:
	pop	{r10, r11}	@ Get inputs

	mul	r9, r10, r11	@ A = h * w

	bvs	rect_overflow
	b	rect_done

rect_overflow:
	push	{lr}
	bl	overflow_report
	pop	{lr}

rect_done:
	push	{r9}		@ Save value

	bx	lr		@ Return


@ Calculates the area of a trapezoid
@ Input:	Lower and upper length, height
@ Output:	Area
@ Overwrites:	r8, r9, r10, r11, r12
trapezoid_area:
	pop	{r10, r11, r12}	@ Inputs

	add	r9, r10, r11	@ a + b
	bvs	trap_add_over
	b	trap_mul

trap_add_over:
	push	{lr}
	bl	overflow_report
	pop	{lr}

trap_mul:
	asr	r9, #1		@ Div by 2
	mul	r8, r9, r12	@ (a+b)/2 * h
	bvs	trap_mul_over
	b	trap_done

trap_mul_over:
	push	{lr}
	bl	overflow_report
	pop	{lr}

trap_done:
	push	{r8}		@ Save return

	bx	lr		@ Return



	.data
.balign	4
newline:	.asciz "\n"	@ Newline character
.balign	4
format_int:	.asciz "%d\n"	@ Generic formatter for integers
.balign 4	
format_char:	.asciz "%c\n"	@ Generic formatter for chars
.balign	4
overflow_message:	.asciz "Overflow reported!\n"
.balign	
buffer:		.space	4	@ Buffer space
int_a:		.space	4
int_b:		.space	4
int_c:		.space	4

.balign	4
welcome_message:	.asciz "Welcome to the shape calculator!\nPlease enter your shape(1-4):`\n\n1: Triangle\n2: Rectangle\n3: Square\n4: Quadrilateral\n"
.balign 4
bad_input_msg:		.asciz "Invalid input. Please try again.\n"
.balign 4
request_entry:		.asciz "Entry: %d"	@ Also used to scan in the char
.balign 4
base_string:		.asciz	"Enter base of shape: %d"
.balign 4
height_string:		.asciz	"Enter height of shape: %d"
