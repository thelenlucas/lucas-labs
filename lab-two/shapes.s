.global main

main:
	ldr	r0, =welcome
	bl	printf

	@ Get user input back
	ldr	r0, =format_int
	ldr	r1, =int_a
	bl	scanf

	@ Print user input
	ldr	r0, =print_int
	ldr	r1, =int_a
	ldr	r1, [r1]
	bl	printf

exit:
	mov	r7, #1
	svc	0

.data
.balign 4
welcome: .asciz "Welcome! Please choose a shape:\nTriangle (1)\nSquare (2)\nRectangle (3)\nTrapizoid (4)\n"

.balign 4
format_int: .asciz "%d" @ Generic integer format
.balign 4
print_int: .asciz "%d\n" @ Integer format

.balign 4
int_a: .word 0