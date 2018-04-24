; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.

.module	Utility


;====== Math Routines ==========================================================
;------ Milos Bazelides routines -----------------------------------------------
; These routines are by Milos "baze" Bazelides, baze_at_baze_au_com
; Retrived from http://baze.au.com/misc/z80bits.html 25 October 2008
#ifdef	NEVER
MultHByE:
; Standard optimized 8-bit multiply.
; Input: H = Multiplier, E = Multiplicand
; Output: HL = Product
	xor	a
	ld	l, a
	ld	d, a
	sla	h		; optimised 1st iteration
	jr	nc,$+3
	ld	l,e
	;
	ld	b, 7
multHbyEloop:
	add	hl,hl		; unroll 7 times
	jr	nc,$+3		; ...
	add	hl,de		; ...
	djnz	multHbyEloop
	ret
#endif


;------ DivHLByC ---------------------------------------------------------------
DivHLByC:
; 16-bit by 8-bit divide
; Inputs:
;  - HL: Dividend
;  - C: Divisor
; Outputs:
;  - HL: Quotient
;  - A: Remainder
; Destroys:
;  - B
	xor	a
	ld	b, 16
_dhlcl:
	add	hl,hl		; unroll 16 times
	rla			; ...
	cp	c		; ...
	jr	c,$+4		; ...
	sub	c		; ...
	inc	l		; ...
	djnz	_dhlcl
	ret


#ifdef	NEVER
;------ DivEHLByD --------------------------------------------------------------
DivEHLByD:
; 24-bit by 8-bit divide
; Inputs:
;  - EHL: Dividend
;  - D: Divisor
; Outputs:
;  - EHL: Quotient
;  - A: Remainder
; Destroys:
;  - B
	xor	a
	ld	b, 24
_dehld:	add	hl,hl		; unroll 24 times
	rl	e		; ...
	rla			; ...
	cp	d		; ...
	jr	c,$+4		; ...
	sub	d		; ...
	inc	l		; ...
	djnz	_dehld
	ret
#endif


;------ DivACByDE --------------------------------------------------------------
DivACByDE:
; 16-bit by 16-bit divide
; Inputs:
;  - A:C: Dividend
;  - DE: Divisor
; Outputs:
;  - A:C: Quotient
;  - HL: Remainder
; Destroys:
;  - AF
;  - BC
	ld	hl, 0
	ld	b, 16
@:	sll	c
	rla
	adc	hl, hl
	sbc	hl, de
	jr	nc, $ + 4
	add	hl, de
	dec	c
	djnz	{-1@}
	ret


;------ DispHL & DispByte ------------------------------------------------------
DispHL:
; Displays HL in hex.
; Input:
;  - HL
; Output:
;  - Word displayed
; Destroys:
;  - AF
	ld	a, h
	call	DispByte
	ld	a, l
DispByte:
; Display A in hex.
; Input:
;  - A: Byte
; Output:
;  - Byte displayed
; Destroys:
;  - AF
	push	af
	rra
	rra
	rra
	rra
	call	_dba
	pop	af
_dba:	or	0F0h
	daa
	add	a, 0A0h
	adc	a, 40h
	call	PutC
;	b_call(_PutC)
	ret


;------ DispDecimal ------------------------------------------------------------
DispDecimal:
; Displays HL in decimal.
; Input:
;  - HL
; Output:
;  - 16-bit number displayed in decimal
; Destroys:
;  - HL
;  - BC
;  - AF
	bit	7, h
	jr	z, {@}
	ld	a, h
	cpl
	ld	h, a
	ld	a, l
	cpl
	ld	l, a
	ld	bc, 1
	add	hl, bc
	ld	a, '-'
	call	PutC
@:	ld	bc, 10000
	cpHlBc
	jr	nc, _dd4
	ld	bc, 1000
	cpHlBc
	jr	nc, _dd3
	ld	bc, 100
	cpHlBc
	jr	nc, _dd2
	ld	bc, 10
	cpHlBc
	ld	b, 0FFh
	jr	nc, _dd1
	jr	_dd0	
_dd4	ld	bc, -10000
	call	_dda
_dd3	ld	bc, -1000
	call	_dda
_dd2	ld	bc, -100
	call	_dda
_dd1	ld	c, -10
	call	_dda
_dd0	ld	c,b
_dda:	ld	a,'0'-1
_ddb:	inc	a
	add	hl,bc
	jr	c, _ddb
	sbc	hl,bc
	call	PutC
	ret


.ifdef	NEVER
;------ DispA ------------------------------------------------------------------
DispA:
; Displays A as a decimal, without zero-padding.
; Input:
;  - A
; Output:
;  - Number displayed at current cursor location.
; Destroys:
;  - C
	cp	10
	jr	c, _dda2
	cp	100
	jr	c, _dda0
	ld	c, 2
	sub	200
	jr	nc, _dda3
	dec	c
	add	a, 100
_dda3:	push	af
	ld	a, c
	call	_dda2
	pop	af
_dda0:	ld	c, -1
_dda1:	inc	c
	sub	10
	jr	nc, _dda1
	add	a, 10
	push	af
	ld	a, c
	call	_dda2
	pop	af
_dda2:	add	a, '0'
	jp	PutC
.endif


;====== Routines ===============================================================

#ifdef	NEVER
;------ ToHlButDontJumpToNull --------------------------------------------------
ToHlButDontJumpToNull:
; Does JP (HL), unless HL is null, in which case it returns to caller.
	ld	a, l
	or	h
	ret	z
	jp	(hl)
#endif


;------ CompareStrings ---------------------------------------------------------
CompareStrings:
; Checks if two null terminated strings are identical.
; Input:
;  - HL: String 1
;  - DE: String 2
;  - B: Maximum string length
; Output:
;  - NZ if strings unequal
;  - Z if strings are identical
;  - If string are identical, HL and DE point to byte after zero
; Destroys:
;  - A
;  - B
;  - DE
;  - HL
	ld	a, (de)
	cp	(hl)
	ret	nz
	inc	hl
	inc	de
	or	a
	ret	z
	djnz	CompareStrings
	xor	a
	inc	a
	ret


#ifdef	NEVER
;------ ClearMem ---------------------------------------------------------------
ClearMem:
; Clears a section of memory SLOW! :p
; Input:
;  - HL: Location to kill
;  - B: Number of bytes to kill
;  - A: What to clear it with
	ld	(hl), a
	inc	hl
	djnz	ClearMem
	ret
#endif


;------ GetStrIndexed ----------------------------------------------------------
GetStrIndexed:
; Given an index into a table of ZTSs, this finds the specified string
; Inputs:
;  - A: Index
;  - HL: Pointer to table
; Output:
;  - HL: Pointer to selected string
	or	a
	ret	z
	push	bc
	ld	b, a
	xor	a
_gsia:	cp	(hl)
	inc	hl
	jr	nz, _gsia
	djnz	_gsia
	pop	bc
	ret


#ifdef	NEVER
;------ MapJumpTable -----------------------------------------------------------
MapJumpTable:
; Branches from a jump table based on a key press.
; The table will look like this:
;	.db	compareValue1
;	.dw	jumpTarget1
;	.db	compareValue2
;	.dw	jumpTarget2
;	. . .
;	.db	0
; Inputs:
;  - A: Value to compare
;  - HL: Location of table
; Output:
;  - Branches based on output
;  - If branch is successful, top stack entry is eaten
;  - If no match is found, returns to caller
; Destroys:
;  - AF, B, HL
	ld	b, a
_mjtLoop:
	ld	a, (hl)
	inc	hl
	or	a
	ret	z
	cp	b
	jr	z, _mklb
	inc	hl
	inc	hl
	jr	_mjtLoop
_mklb:	pop	af
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	jp	(hl)
#endif


;------ MapTable ---------------------------------------------------------------
MapTable:
; Scans a table mapping an input in A to an output in B.
; Input:
;  - HL: Pointer to struct specifying entries in real table and table address.
; Outputs:
;  - B: Code
;  - NZ on failure
; Destroys:
;  - HL
	ld	b, (hl)
	inc	hl
_mtl:	cp	(hl)
	inc	hl
	jr	z, _mtd
	inc	hl
	djnz	_mtl
	inc	b
	ret
_mtd:	ld	b, (hl)
	cp	a
	ret


#ifdef	NEVER
;------ AnyKey -----------------------------------------------------------------
AnyKey:
; Waits until a key is pressed, then returns.  This routine, unlike GetKey, does
; not depend on the interrupt-based keyboard driver.
; Inputs:
;  - None
; Output:
;  - Waits until a key is pressed, then returns
; Destroys:
;  - AF
;  - BC
	ld	bc, 0
	ld	a, 0FFh
	out	(pKey), a
	djnz	$
	inc	a
	out	(pKey), a
	djnz	$
@:	in	a, (pKey)
	inc	a
	jr	z, {-1@}
	ld	a, 0FFh
	out	(pKey), a
@:	djnz	$
	dec	c
	jr	nz, {-1@}
	ret
#endif


;------ ------------------------------------------------------------------------
.endmodule