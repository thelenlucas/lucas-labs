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
	ldr	r1, =int_a
	bl	scanf

	ldr r0, =format_int
	ldr r1, =int_a
	ldr r1, [r1]
	bl printf

	@ Triangle?
	cmp	r1, #1
	beq	triangle_calc

	@ If we didn't hit any of those conditions, we need to show error and try again
	@b	input_error

	b	exit

triangle_calc:
	LDR	r0, =triangle_str
	MOV r1, #99
	BL	printf

	BX	lr
	

.data
.balign	4
newline:	.asciz "\n"	@ Newline character
.balign	4
format_int:	.asciz "%d\n"	@ Generic formatter for integers
.balign 4	
format_char:	.asciz "%c\n"	@ Generic formatter for chars
.balign	4
overflow_message:	.asciz "Overflow reported!\n"
.balign 4
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
.balign 4
triangle_str:		.asciz	"Triangle Area: %d\n"
