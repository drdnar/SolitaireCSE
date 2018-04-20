; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.

; This contains LCD routines not related to text.

.module	Lcd
;------ DrawFourColorSprite ----------------------------------------------------
DrawFourColorSprite:
; Draws a four-color 24x25 sprite.  This is designed only for drawing card body
; graphics; you'll need to modify it a lot to support arbitrary widths and
; heights.
; Inputs:
;  - HL: Left side
;  - D: Top
;  - BC: Pointer to data
; Output:
;  - Sprite drawn
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
;  - IX
;  - BC'
;  - DE'
;  - HL'
; struct sprite
; {
;	word palettePtr;
;	byte data[];
; }
	push	ix
	ld	ix, 0
	add	ix, sp
	push	bc	; ix - 1, ix - 2
	push	de	; ix - 3, ix - 4
	push	hl	; ix - 5, ix - 6
; Set cursor direction
	call	SetDirectionRight
; Set left window bound
	di
	ld	a, lrWinLeft
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ld	a, h
	out	(pLcdData), a
	ld	a, l
	out	(pLcdData), a
; Set initial cursor column
	ld	a, lrCol
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ld	a, h
	out	(pLcdData), a
	ld	a, l
	out	(pLcdData), a
; Set right window bound
	ld	de, 23
	add	hl, de
	ld	a, lrWinRight
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ld	a, h
	out	(pLcdData), a
	ld	a, l
	out	(pLcdData), a
; Set top window bound
	ld	a, lrWinTop
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	b, (ix - 3)
	ld	a, b
	out	(pLcdData), a
; Set initial cursor row
	ld	a, lrRow
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, b
	out	(pLcdData), a
; Set bottom window bound
	ld	a, lrWinBottom
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, colorScrnHeight - 1
	out	(pLcdData), a
; Prepare for data
	ld	a, lrGram
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ei
; Figure out how many rows to write
	ld	(ix - 4), 25
@:	; Figure out how many bytes to write per row
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	ld	(ix - 3), 6	; IX - 3: Bytes to write per row
; Fetch pointer to palette
	push	hl
	exx
	pop	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	b, 0
	exx
	inc	hl
	inc	hl
	; C: Byte being decoded
	; B: Byte decode loop counter
	; HL: Data pointer
	; DE': Pointer to color table
_4colorLoop:
	ld	d, (ix - 3)
	di
_4colorRowLoop:
	ld	c, (hl)
	ld	b, 4
@:	; Decode pixel
	ld	a, c
	and	3
	rr	c
	rr	c
	; Index palette
	exx
	ld	l, e
	ld	h, d
;	add	a, l
;	jr	nc, $ + 3
;	inc	h
;	ld	l, a
	ld	c, a
	add	hl, bc
	ld	a, (hl)
	exx
	; Output pixel
	out	(pLcdData), a
	out	(pLcdData), a
	; Loop control
	djnz	{-1@}
	dec	d
	inc	hl
	jr	nz, _4colorRowLoop
	dec	(ix - 4)
	ei
	jr	nz, _4colorLoop
	pop	hl
	pop	de
	pop	bc
	pop	ix
	jp	ResetScreen


;------ DrawRect ---------------------------------------------------------------
DrawRect:
; Draws a rectangle with a black outline.
; Inputs:
;  - HL: Left side
;  - D: Top
;  - E: Height
;  - B: Width
	push	ix
	ld	ix, 0
	add	ix, sp
	push	hl	; ix - 1, ix - 2
	push	de	; ix - 3, ix - 4
	push	bc	; ix - 5, ix - 6
	; Top line
;	ld	l, (ix - 2)
;	ld	h, (ix - 1)
;	ld	d, (ix - 3)
;	ld	b, (ix - 5)
	ld	c, colorBlack
	call	DrawHorizLine
	; Bottom line
	ld	a, (ix - 3)
	add	a, (ix - 4)
	dec	a
	ld	d, a
	ld	b, (ix - 5)
	call	DrawHorizLine
	; Left line
	ld	d, (ix - 3)
	inc	d
	ld	b, (ix - 4)
	dec	b
	dec	b
	call	DrawVertLine
	; Right line
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	ld	a, (ix - 5)
	dec	a
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	d, (ix - 3)
	inc	d
	ld	b, (ix - 4)
	dec	b
	dec	b
	call	DrawVertLine
	pop	bc
	pop	de
	pop	hl
	pop	ix
	ret


;------ InvertRect -------------------------------------------------------------
InvertRect:
; Inverts the colors in a given region.
; Inputs:
;  - HL: Left size
;  - D: Top
;  - E: Width
;  - B: Height
; Output:
;  - Region inverted
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
;  - LCD state; call SetCharRow and SetCharCol to fix
	di
	ld	c, b
	; lrWinTop
	ld	a, lrWinTop	; 7 cc
	out	(pLcdCmd), a
	out	(pLcdCmd), a		; 12 cc
	xor	a
	out	(pLcdData), a
	out	(pLcdData), a
	; lrWinBottom
	ld	a, lrWinBottom
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, colorScrnHeight-1
	out	(pLcdData), a
; Loop registers:
;  - HL: Current column
;  - E: Columns left
;  - D: Start row
;  - C: Rows per loop
;  - B: Rows left
_invol:	; Cursor Row
	ld	a, lrRow
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, d
	out	(pLcdData), a
	; Cursor Column
	ld	a, lrCol
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ld	a, h
	out	(pLcdData), a
	ld	a, l
	out	(pLcdData), a
	ld	a, lrGram
	out	(pLcdCmd), a
	out	(pLcdCmd), a
_invl:	
	; Get pixel
	in	a, (pLcdData)
	in	a, (pLcdData)
	in	a, (pLcdData)
	in	a, (pLcdData)
	; Set pixel
	cpl
	out	(pLcdData), a
	out	(pLcdData), a
	djnz	_invl
	ei
	ld	b, c
	inc	hl
	dec	e
	di
	jr	nz, _invol
	ei
	ret


;------ DrawOutlinedFilledRect -------------------------------------------------
DrawOutlinedFilledRect:
; Draws a rectangle with a black outline and filled interior.
; Inputs:
;  - HL: Left side
;  - D: Top
;  - E: Height
;  - C: Fill color
;  - B: Width
	push	hl
	push	de
	push	bc
	call	DrawRect
	pop	bc
	pop	de
	pop	hl
	; Fill
	inc	hl
	inc	d
	dec	e
	dec	e
	dec	b
	dec	b


;------ DrawFilledRect ---------------------------------------------------------
DrawFilledRect:
; Draws a filled rectangle.
; Inputs:
;  - HL: Left side
;  - D: Top
;  - E: Height
;  - C: Color
;  - B: Width
; Output:
;  - Area filled
; Destroys:
;  - LCD state; call SetCharRow and SetCharCol to fix
	di
	; Column
	ld	a, lrCol
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ld	a, h
	out	(pLcdData), a
	ld	a, l
	out	(pLcdData), a
	; Top
	ld	a, lrWinTop
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, d
	out	(pLcdData), a
	; Cursor Row
	ld	a, lrRow
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, d
	out	(pLcdData), a
	; Bottom
	ld	a, lrWinBottom
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, d
	add	a, e
	dec	a
	out	(pLcdData), a
	; Data
	ld	a, lrGram
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ld	d, b
	ld	a, c
_frl:	ld	b, d
_frli:	out	(pLcdData), a
	out	(pLcdData), a
	djnz	_frli
	ei
	dec	e
	di
	jr	nz, _frl
	ei
	ret


;------ DrawHorizLine ----------------------------------------------------------
DrawHorizLine:
; Draws a horizontal line.
; Inputs:
;  - HL: Left side
;  - D: Row
;  - B: Length
;  - C: Color
; Output:
;  - Line draw
; Destroys:
;  - AF
;  - B
;  - LCD state; call SetCharRow and SetCharCol to fix	
	di
	; Top
	ld	a, lrWinTop
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, d
	out	(pLcdData), a
	; Cursor Row
	ld	a, lrRow
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, d
	out	(pLcdData), a
	; Bottom
	ld	a, lrWinBottom
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, d
	out	(pLcdData), a
	; Column
	ld	a, lrCol
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ld	a, h
	out	(pLcdData), a
	ld	a, l
	out	(pLcdData), a
	; Data
_dha:	ld	a, lrGram
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ld	a, c
_dhl:	out	(pLcdData), a
	out	(pLcdData), a
	djnz	_dhl
	ei
	ret


;------ DrawVertLine -----------------------------------------------------------
DrawVertLine:
; Draws a vertical line.
; Inputs:
;  - HL: Column
;  - D: Start row
;  - B: Length
;  - C: Color
; Output:
;  - Line draw
; Destroys:
;  - AF
;  - B
;  - LCD state; call SetCharRow and SetCharCol to fix	
	di
	; Top
	ld	a, lrWinTop
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, d
	out	(pLcdData), a
	; Cursor Row
	ld	a, lrRow
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, d
	out	(pLcdData), a
	; Bottom
	ld	a, lrWinBottom
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, colorScrnHeight - 1
	out	(pLcdData), a
	; Column
	ld	a, lrCol
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ld	a, h
	out	(pLcdData), a
	ld	a, l
	out	(pLcdData), a
	jr	_dha


;------ ClearSrcnFull ----------------------------------------------------------
; Fully erases the whole screen to black.
; Just uses FillScrnFull to do its dirty work.
ClrScrnFull:
	ld	d, 0
;------ FillScrnFull -----------------------------------------------------------
FillScrnFull:
; Fills the entire screen with a specified 16-bit color.
; Selected colors:
; Component 5/6/5 is the color as the LCD controller sees it.  For consistency,
; the middle green channel is divided by two, so each channel is out of 31.
; Component 8/8/8 is each channel multiplied by 8 so it is out of 255, like on
; PCs.
; Hex   Component 5/6/5	Component 8/8/8	Color RGB	Color BGR
; 00	 0,    0,  0	  0,   0,   0	Black		Black
; 06	 0,   24,  6	  0, 192,  48	Green		Green
; 08	 1,    0,  8	  8,   0,  64	Navy Blue	Dark Maroon?
; 18	 3,    0, 24	 24,   0, 192	Blue		Red
; 1F	 3,   28, 31	 24, 224, 248	Baby Blue?	Gold/Yellow?
; 4A	 9,    9, 10
; 60	12,  1.5,  0	 96,  12,   0	Maroon?		Dark Blue?
; 33	 0,   12,  3	  0,  96,  24	Dark Green	Better Dark Green
; 6B	13, 13.5, 11	104, 108,  88	Gray 39%	Gray 39%
;;; 77	28, 31.5,  7	224, 252,  56	Lime Green	Teal
; 77	 0,   28,  7	  0, 224,  26			Green-screen Green
; B5	22, 22.5, 21	176, 180, 168	Gray 68%	Gray 68%
; D8	27,    3, 24	216,  24, 192	Magenta?	Blue-Magenta? 
; DB	27,   27, 30	216, 216, 240	Gray 88%	Gray 88%
; E0	28,  3.5,  0	224,  28,   0	Red		Blue
; FF	31,   31, 31	255, 255, 255	White		White
; 
; Input:
;  - D: Color to write, high and low bytes are the same
; Output:
;  - Screen filled with repeating byte
;  - Current LCD register set to lrGram
;  - Row & Col set to (0,0)
;  - Window set to (0,0)-(319,239)
; Destroys:
;  - A, BC
; Assumes:
;  - Only assumes that the LCD is more or less configured correctly.
; Execution Time:
;  - Base time is 129 ms
;  - Add 31 ms if ASIC-forced LCD delay is set to the minimum of 3 clock cycle
;  - Total minimum time is therefore 160 ms (or 6.2 frames/second)
	di
	ld	c, pLcdCmd	; 7 cc
	xor	a		
	;			; sigma = 11
	; Sync
	out	(pLcdCmd), a	; 11 cc
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	;			; sigma = 44
	; lrWinTop
	ld	b, lrWinTop	; 7 cc
	out	(pLcdCmd), a
	out	(c), b		; 12 cc
	out	(pLcdData), a
	out	(pLcdData), a
	;			; sigma = 52
	; lrWinBottom
	inc	b
	out	(pLcdCmd), a
	out	(c), b
	out	(pLcdData), a
	ld	a, colorScrnHeight-1
	out	(pLcdData), a
	xor	a
	;			; sigma = 60
	; lrWinLeft
	inc	b
	out	(pLcdCmd), a
	out	(c), b
	out	(pLcdData), a
	out	(pLcdData), a
	;			; sigma = 49
	; lrWinRight
	inc	b
	out	(pLcdCmd), a
	out	(c), b
	inc	a
	;ld	de, colorScrnWidth ; 10 cc
	out	(pLcdData), a
	ld	a, lcdLow((colorScrnWidth-1))
	out	(pLcdData), a
	xor	a
	;			; sigma = 64
	; lrRow
	ld	b, lrRow
	out	(pLcdCmd), a
	out	(c), b
	out	(pLcdData), a
	out	(pLcdData), a
	;			; sigma = 52
	; lrCol
	inc	b
	out	(pLcdCmd), a
	out	(c), b
	out	(pLcdData), a
	out	(pLcdData), a
	;			; sigma = 49
	; Now fill the screen
	ld	b, lrGram
	out	(pLcdCmd), a
	out	(c), b
	ld	c, 75
	ld	b, 0
	ld	a, d
	;			; sigma = 51
	; Total time for header:  sigma = 432
	; Plus 3 cycles added by ASIC per write: 30*3 = 90
	; So 522 cc total for initalization.
_fsfl:	out	(pLcdData), a
	out	(pLcdData), a
	out	(pLcdData), a
	out	(pLcdData), a
	out	(pLcdData), a
	out	(pLcdData), a
	out	(pLcdData), a
	out	(pLcdData), a
	djnz	_fsfl		; 13/8 cc
	; 11*8*256+13*255+8 = 25851 cc
	dec	c
	jr	nz, _fsfl		; 12/7 cc
	; (25851+4)*75+12*74+7 = 1940020
	ei
	ret			; 10 cc
	; 1940462 = ca. 129 ms
	; Plus 3 cycles per write: 3*2*320*240 = 460800.
	; So, including delays, 2401352 clock cycles + 77 more for save/restore interrupts
	; Which is about 160 ms or 6.2 frames/second.


;------ ------------------------------------------------------------------------
.endmodule