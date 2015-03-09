/* crt0.S -- startup file for oldland
 * 
 * Copyright (c) 2015 Jamie Iles
 *
 * The authors hereby grant permission to use, copy, modify, distribute,
 * and license this software and its documentation for any purpose, provided
 * that existing copyright notices are retained in all copies and that this
 * notice is included verbatim in any distributions. No written agreement,
 * license, or royalty fee is required for any of the authorized uses.
 * Modifications to this software may be copyrighted by their authors
 * and need not follow the licensing terms described here, provided that
 * the new terms are clearly indicated on the first page of each file where
 * they apply.
 */

	.globl	__start
	.weak	_start
	.text
	.type	__start,@function
__start:
_start:
	movhi	$sp, %hi(_stack)	/* set the top of stack */
	orlo	$sp, $sp, %lo(_stack)
	mov	$fp, 1

	mov	$r3, 0
	movhi	$r4, %hi(__bss_start__)
	orlo	$r4, $r4, %lo(__bss_start__)
	movhi	$r5, %hi(__bss_end__)
	orlo	$r5, $r5, %lo(__bss_end__)
_clear_bss:
	str8	$r3, [$r4, 0]
	cmp	$r4, $r5
	beq	1f
	add	$r4, $r4, 1
	b	_clear_bss
1:

	/* Call _init to invoke static constructors, etc.  */
	call	_init
	
	/* Call _fini at exit time for static destructors.  */
	movhi	$r0, %hi(_fini)
	orlo	$r0, $r0, %lo(_fini)
	call	atexit
	
	/* Set argc and argv.  These are populated by the simulator.  */
	mov	$r0, 0
	mov	$r1, 0
	
	call	main
	call	exit

.Lend:
	.size	__start,(.Lend-__start)
