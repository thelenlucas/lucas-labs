.global main

main:
	ldr	r0, =welcome
	bl	printf

	@ Get user input back
	ldr	r0, =format_int
	ldr	r1, =int_a
	bl	scanf

	@ Print user input

.data
.balign 4
welcome: .asciz "Welcome! Please choose a shape:\nTriangle (1)\nSquare (2)\nRectangle (3)\nTrapizoid (4)\n"

.balign 4
format_int: .asciz "%d" @ Generic integer format

.balign 4
int_a: .word 0