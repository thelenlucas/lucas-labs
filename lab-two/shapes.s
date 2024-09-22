.global main

main:
	ldr r0, =welcome
	bl printf
	b loop

loop:
	ldr	r0, =choices
	bl	printf

	@ Get user input
	ldr	r0, =format_int
	ldr	r1, =int_a
	bl	scanf

	@ Grab
	ldr	r0, =int_a
	ldr r0, [r0]

	@ Triangle
	cmp	r0, #1
	beq loop_triangle

	@ Square
	cmp	r0, #2
	beq loop_square

	@ Rectangle
	cmp	r0, #3
	beq loop_rect

	@ Trapizoid
	cmp	r0, #4
	beq loop_trap


loop_triangle:
	@ Get base
	LDR	r0, =base_string
	BL	printf
	LDR	r0, =format_int
	LDR	r1, =int_a
	BL	scanf

	@ Get height
	LDR	r0, =height_string
	BL	printf
	LDR	r0, =format_int
	LDR	r1, =int_b
	BL	scanf

	@ Pass base and height to triangle_area
	LDR	r0, =int_a
	LDR	r1, =int_b
	LDR	r0, [r0]
	LDR	r1, [r1]
	push {r0, r1}
	BL	triangle_area

	@ Print result
	POP {r1}
	LDR	r0, =print_area
	BL	printf

	B	loop_end

loop_square:
	@ Get side
	LDR	r0, =base_string
	BL	printf
	LDR	r0, =format_int
	LDR	r1, =int_a
	BL	scanf

	@ Hijack rectangle_area for square
	LDR	r0, =int_a
	LDR	r0, [r0]
	mov r1, r0
	push {r0, r1}
	BL	rectangle_area

	@ Print result
	POP {r1}
	LDR	r0, =print_area
	BL	printf

	B	loop_end

loop_rect:
	@ Get side
	LDR	r0, =base_string
	BL	printf
	LDR	r0, =format_int
	LDR	r1, =int_a
	BL	scanf

	@ Pass side to rectangle_area
	LDR	r0, =int_a
	LDR	r1, =int_a
	LDR	r0, [r0]
	LDR	r1, [r1]
	push {r0, r1}
	BL	rectangle_area

	@ Print result
	POP {r1}
	LDR	r0, =print_area
	BL	printf

	B	loop_end

loop_trap:
	@ Get base
	LDR	r0, =base_string
	BL	printf
	LDR	r0, =format_int
	LDR	r1, =int_a
	BL	scanf

	@ Get upper base
	LDR	r0, =upper_base_string
	BL	printf
	LDR	r0, =format_int
	LDR	r1, =int_b
	BL	scanf

	@ Get height
	LDR	r0, =height_string
	BL	printf
	LDR	r0, =format_int
	LDR	r1, =int_c
	BL	scanf

	@ Pass base, upper base, and height to trapizoid_area
	LDR	r0, =int_a
	LDR	r1, =int_b
	LDR	r2, =int_c
	LDR	r0, [r0]
	LDR	r1, [r1]
	LDR	r2, [r2]
	push {r0, r1, r2}
	BL	trapizoid_area

	@ Print result
	POP {r1}
	LDR	r0, =print_area
	BL	printf

	B	loop_end

loop_end:
	B	loop

@ Simple subroutine to print an overflow message
overflow:
	push {lr}
	ldr r0, =overflow_result
	bl printf
	pop {lr}
	bx lr

@ Input: base, height
@ Output: area
triangle_area:
	@ Inputs are on stack, pop them to r10 and r11
	pop {r10, r11}

	@ Preserve lr
	push {lr}

	@ Calculate area
	smull r0, r1, r10, r11
	
	@ Check for overflow,
	cmp r1, #0
	bne tri_calc_overflow

	b tri_calc_end

tri_calc_overflow:
	bl overflow
	b tri_calc_end

tri_calc_end:
	@ Divide by 2, using asr
	asr r0, r0, #1

	@ Get link back
	pop {lr}
	@ Push result to stack
	push {r0}
	bx lr

@ Rectangle area calculation
rectangle_area:
	@ Inputs are on stack, pop them to r10 and r11
	pop {r10, r11}

	@ Preserve lr
	push {lr}

	@ Calculate area
	smull r0, r1, r10, r11
	
	@ Check for overflow,
	cmp r1, #0
	bne rect_calc_overflow

	b rect_calc_end

rect_calc_overflow:
	bl overflow
	b rect_calc_end

rect_calc_end:
	@ Get link back
	pop {lr}
	@ Push result to stack
	push {r0}
	bx lr

@ Trapizoid area calculation, a bit more complex
@ Have to check for overflow both after add and multiply
@ Also has a third input, height, but otherwise similar
trapizoid_area:
	@ Inputs are on stack, pop them to r10, r11, r12
	pop {r10, r11, r12}

	@ Preserve lr
	push {lr}

	@ Calculate area
	@ First, add the bases
	add r0, r10, r11
	bvs trap_add_overflow
	b trap_mul

trap_add_overflow:
	bl overflow
	b trap_calc_end

trap_mul:
	smull r0, r1, r0, r12

	@ Check for overflow,
	cmp r1, #0
	bne trap_calc_overflow

	b trap_calc_end

trap_calc_overflow:
	bl overflow
	b trap_calc_end

trap_calc_end:
	@ Divide by 2, using asr
	asr r0, r0, #1

	@ Get link back
	pop {lr}
	@ Push result to stack
	push {r0}
	bx lr

exit:
	mov	r7, #1
	svc	0

.data
.balign 4
welcome: .asciz "Welcome!"
.balign 4
choices: .asciz "Please choose a shape:\nTriangle (1)\nSquare (2)\nRectangle (3)\nTrapizoid (4)\n"
.balign 4
base_string: .asciz "Please enter a base length: "
.balign 4
height_string: .asciz "Please enter a height length: "
.balign 4
upper_base_string: .asciz "Please enter the upper base length: "
overflow_result: .asciz "Overflow detected\n"
.balign 4
print_area: .asciz "The area is: %d!\n"

.balign 4
format_int: .asciz "%d" @ Generic integer format
.balign 4
print_int: .asciz "%d\n" @ Integer format

.balign 4
int_a: .word 0
.balign 4
int_b: .word 0
.balign 4
int_c: .word 0