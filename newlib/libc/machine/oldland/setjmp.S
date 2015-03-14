/*
 * setjmp buffer for oldland, stores $r0-$lr and the psr.
 */

.global setjmp
.type   setjmp,@function
setjmp:
	str32	$r0, [$r0, 0x00]
	str32	$r1, [$r0, 0x04]
	str32	$r2, [$r0, 0x08]
	str32	$r3, [$r0, 0x0c]
	str32	$r4, [$r0, 0x10]
	str32	$r5, [$r0, 0x14]
	str32	$r6, [$r0, 0x18]
	str32	$r7, [$r0, 0x1c]
	str32	$r8, [$r0, 0x20]
	str32	$r9, [$r0, 0x24]
	str32	$r10, [$r0, 0x28]
	str32	$r11, [$r0, 0x2c]
	str32	$r12, [$r0, 0x30]
	str32	$fp, [$r0, 0x34]
	str32	$sp, [$r0, 0x38]
	str32	$lr, [$r0, 0x3c]
	gpsr	$r1
	str32	$r1, [$r0, 0x40]
	mov	$r0, 0
	ret

.global longjmp
.type   longjmp,@function
longjmp:
	cmp	$r1, 0
	bne	1f
	mov	$r1, 1
1:
	ldr32	$r2, [$r0, 0x08]
	ldr32	$r3, [$r0, 0x0c]
	ldr32	$r4, [$r0, 0x10]
	ldr32	$r5, [$r0, 0x14]
	ldr32	$r6, [$r0, 0x18]
	ldr32	$r7, [$r0, 0x1c]
	ldr32	$r8, [$r0, 0x20]
	ldr32	$r9, [$r0, 0x24]
	ldr32	$r10, [$r0, 0x28]
	ldr32	$r11, [$r0, 0x2c]
	ldr32	$r12, [$r0, 0x30]
	ldr32	$fp, [$r0, 0x34]
	ldr32	$sp, [$r0, 0x38]
	ldr32	$lr, [$r0, 0x3c]
	/*
	 * We can clobber $r0..$r5 if we want as they are caller save
	 * registers.
	 */
	ldr32	$r2, [$r0, 0x40]
	spsr	$r2
	mov	$r0, $r1
	ret
