; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.

.module	Text

;------ PutS -------------------------------------------------------------------
PutS:
; Displays a string.  If the string contains control codes, those codes are
; parsed.
; Input:
;  - HL: String to show
; Output:
;  - String shown
;  - HL advanced to the byte after the null terminator.
; Destroys:
;  - AF
	ld	a, (hl)
	inc	hl
	or	a
	scf
	ret	z
;	cp	chNewLine
;	jr	z, putSNewLine
	
	push	hl
	push	de
	ld	hl, (lcdCol)
	; Just use a heuristic.
	; Otherwise, we'd be calling GetGlyphWidth twice per glyph.
	ld	de, colorScrnWidth - 6
	cpHlDe
	pop	de
	pop	hl
	ret	nc
	
	dec	hl
	ld	a, (hl)
	inc	hl
	call	PutC
	jr	PutS
;putSNewLine:
;	push	hl
;	call	ClearEOL
;	ld	a, (lcdRow)
;	add	a, charHeight
;	ld	(lcdRow), a
;	ld	hl, 0
;	ld	(lcdCol), hl
;	call	FixCursor
;	pop	hl
;	jr	PutS


.ifdef	NEVER
;------ PutSCentered -----------------------------------------------------------
PutSCentered:
; Displays a string, centering it.  However, if the string contains control
; codes, the result will be weird.
; Input:
;  - HL: String to show
;  - B: Line on which to show the string.
; Output:
;  - String shown
;  - HL advanced to the byte after the null terminator.
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	push	hl
	ex	de, hl
	ld	l, b
	ld	h, 0
	call	Locate
	call	GetStrWidth
	or	a
	ld	a, h
	rra
	ld	d, a
	ld	a, l
	rra
	ld	e, a
	ld	hl, colorScrnWidth / 2
	or	a
	sbc	hl, de
	setLcdRegHl(lrCol)
	pop	hl
	call	PutS
	ret
.endif


;------ Locate -----------------------------------------------------------------
Locate:
; Moves the cursor to a specific location.
; Named after a QuickBASIC command.
; Inputs:
;  - HL: Column
;  - D: Row
; Output:
;  - Cursor moved
; Destroys:
;  - Nothing
	push	af
	push	bc
	push	de
	push	hl
	ld	(lcdCol), hl
	ld	a, d
	ld	(lcdRow), a
	call	SetCharRow
	call	SetCharCol
	pop	hl
	pop	de
	pop	bc
	pop	af
	ret


;------ GetGlyphWidth ----------------------------------------------------------
GetGlyphWidth:
; GetGlyphWidth
; Returns the width of the given glyph
; Input:
;  - A: Codepoint
; Output:
;  - A: Width
; Destroys:
;  - Nothing
	push	hl
	ld	hl, fontWidthTable - ch1stPrintableChar
	add	a, l
	jr	nc, _ggw
	inc	h
_ggw:	ld	l, a
	ld	a, (hl)
	pop	hl
	ret


;------ GetStrWidth ------------------------------------------------------------
GetStrWidth:
; Computes the width, in pixels, of a string
; Input:
;  - DE: Pointer to string
; Output:
;  - HL: Width of string, in pixels
; Destroys:
;  - AF
;  - HL
	ld	hl, 0
_gswl:	ld	a, (de)
	inc	de
	or	a
	ret	z
	call	GetGlyphWidth
	add	a, l
	jr	nc, _gswa
	inc	h
_gswa:	ld	l, a
	jr	_gswl


;------ PutCSmall --------------------------------------------------------------
PutCSmall:
; Draws a small character to the screen.
; Inputs:
;  - HL: Column
;  - D: Row
;  - A: Glyph
; Output:
;  - Glyph drawn
; Destroys:
;  - LCD state; use locate or SetCharRow and SetCharCol to fix.
	call	Locate
	push	af
	di
	ld	a, lrWinBottom
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, (lcdRow)
	add	a, 7 - 1
	out	(pLcdData), a
	ei	
	pop	af
;	call	PutC
;	ret

	
;------ PutC -------------------------------------------------------------------
PutC:
; Draws a character to the screen.
; Input:
;  - A
; Output:
;  - Character drawn
; Destroys:
;  - Nothing
; Assumes:
;  - LCD window already set
;  - LCD write cursor already set
	push	af
	push	bc
	push	de
	push	hl
	
	; If APD while displaying something, the screen will get confused
	sub	ch1stPrintableChar
	ld	c, a
	
	; Update cursor
	add	a, ch1stPrintableChar
	call	GetGlyphWidth
	ld	hl, (lcdCol)
	add	a, l
	jr	nc, _ptca
	inc	h
_ptca:	ld	l, a
	ld	(lcdCol), hl
	
; Fetch bitmap
	; Add A*2 to (currentFontBitmaps)
	ld	l, c
	ld	h, 0
	add	hl, hl
	ld	de, fontDataTable
	add	hl, de
	
	; Load ptr
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	
; Tell it we want to write pixels
	di
	ld	a, lrGram
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ei
; Load colors
	ld	de, (textColors)
	ld	a, (flags + textFlags)
	bit	textInverse, a
	jr	z, _ptcb
	ld	a, d
	ld	d, e
	ld	e, a
_ptcb:
; Let's optimize with loop unrolling!
; Main output loop
; A = bitmap being processed
; B = bit/byte loop counter
; C = port 11h
; D = backcolor
; E = forecolor
; HL = ptr
	ld	de, (TextColors)
	ld	c, pLcdData
	ld	b, (hl)
	inc	hl
putCMainOutputLoop:
	ld	a, (hl)
	inc	hl
	di
putCMainResetBit0:
	rrca
	jr	c, putCMainSetBit0
	out	(c), d
	out	(c), d
	rrca
	jr	c, putCMainSetBit1
putCMainResetBit1:
	out	(c), d
	out	(c), d
	rrca
	jr	c, putCMainSetBit2
putCMainResetBit2:
	out	(c), d
	out	(c), d
	rrca
	jr	c, putCMainSetBit3
putCMainResetBit3:
	out	(c), d
	out	(c), d
	rrca
	jr	c, putCMainSetBit4
putCMainResetBit4:
	out	(c), d
	out	(c), d
	rrca
	jr	c, putCMainSetBit5
putCMainResetBit5:
	out	(c), d
	out	(c), d
	rrca
	jr	c, putCMainSetBit6
putCMainResetBit6:
	out	(c), d
	out	(c), d
	rrca
	jr	c, putCMainSetBit7
putCMainResetBit7:
	out	(c), d
	out	(c), d
	ei
	djnz	putCMainOutputLoop
	jr	putCRemainder
putCMainSetBit0:
	out	(c), e
	out	(c), e
	rrca
	jr	nc, putCMainResetBit1
putCMainSetBit1:
	out	(c), e
	out	(c), e
	rrca
	jr	nc, putCMainResetBit2
putCMainSetBit2:
	out	(c), e
	out	(c), e
	rrca
	jr	nc, putCMainResetBit3
putCMainSetBit3:
	out	(c), e
	out	(c), e
	rrca
	jr	nc, putCMainResetBit4
putCMainSetBit4:
	out	(c), e
	out	(c), e
	rrca
	jr	nc, putCMainResetBit5
putCMainSetBit5:
	out	(c), e
	out	(c), e
	rrca
	jr	nc, putCMainResetBit6
putCMainSetBit6:
	out	(c), e
	out	(c), e
	rrca
	jr	nc, putCMainResetBit7
putCMainSetBit7:
	out	(c), e
	out	(c), e
	ei
	djnz	putCMainOutputLoop
putCRemainder:
; And now for the last of the bitmap
; We're not unrolling this because I'm lazy and it would waste space.
; But mostly I'm lazy.
	ld	b, (hl)
	inc	hl
	ld	a, (hl)
	di
putCRemainderLoop:
	rrca
	jr	c, putCRemainderSet
	out	(c), d
	out	(c), d
	djnz	putCRemainderLoop
	jr	putCDone
putCRemainderSet:
	out	(c), e
	out	(c), e
	djnz	putCRemainderLoop
putCDone:
	ei
	pop	hl
	pop	de
	pop	bc
	pop	af
	ret


;------ ResetScreen ------------------------------------------------------------
ResetScreen:
; Initalizes the screen modes and text control variables.  This must be the
; first thing you call for text mode.
; Inputs:
;  - None
; Output:
;  - Everything ready for text mode
; Destroys:
;  - I dunno, assume everything.
	xor	a
	di
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ei
	call	SetDirectionDown
	call	SetLcdWindowColumnBounds
	ld	hl, 0
	call	Locate
	ret


.ifdef	NEVER
;------ ClearEOL ---------------------------------------------------------------
ClearEOL:
; Clears the rest of the line of text.
; Does not reset the cursor or anything
; Inputs:
;  - (lcdCol)
; Output:
;  - Line cleared
; Destroys:
;  - HL
;  - DE
;  - BC
;  - AF
	di
	ld	a, lrGram
	out	(pLcdCmd), a
	out	(pLcdCmd), a
clearLoop:
	ld	hl, (lcdCol)
	ei
	ld	de, colorScrnWidth;-1
	cpHlDe
	ret	nc
	inc	hl
	ld	(lcdCol), hl
	di
	ld	a, (textBackColor)
	ld	b, 14
_cll:	out	(pLcdData), a
	out	(pLcdData), a
	djnz	_cll
	jr	clearLoop
.endif


;------ FixCursor --------------------------------------------------------------
FixCursor:
; Fixes up the LCD read/write cursor
; Inputs:
;  - None
; Output:
;  - LCD window set
; Destroys:
;  - AF
	push	bc
	push	de
	push	hl
	call	SetCharCol
	call	SetCharRow
	pop	hl
	pop	de
	pop	bc
	ret


;------ SetCharRow -------------------------------------------------------------
SetCharRow:
; Sets the LCD window top and bottom for the current row of text.
; Inputs:
;  - None
; Output:
;  - LCD window set
; Destroys:
;  - AF
;  - C
	di
	ld	a, lrWinTop
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, (lcdRow)
	out	(pLcdData), a
;	out	(pLcdData), a
	ld	c, a
	ld	a, lrRow
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, c
;	out	(pLcdData), a
	out	(pLcdData), a
	ld	a, lrWinBottom
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, c			; ld	a, (fontHeight)
	add	a, charHeight - 1	; add	a, c
;	dec	a
	out	(pLcdData), a
;	out	(pLcdData), a
	ei
	ret


;------ SetCharCol -------------------------------------------------------------
SetCharCol:
; Sets the LCD write cursor column to match currentCol
; Input:
;  - None
; Output:
;  - LCD window set
; Destroys:
;  - AF
;  - HL
	di
	ld	a, lrCol
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	; Set column
	ld	hl, (lcdCol)
	ld	a, h
	out	(pLcdData), a
	ld	a, l
	out	(pLcdData), a
	ei
	ret


;------ SetLcdWindowColumnBounds -----------------------------------------------
; Sets the LCD window left/right bounds.
; These should be 0 and 319.
; Input:
;  - None
; Output:
;  - LCD left/right bounds reset
; Destroys:
;  - AF
; Assumes:
;  - Assumes that you want to be text mode.
; Execution Time:
;  - 134 cc not including inital CALL
SetLcdWindowColumnBounds:
	di
	xor	a
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	ld	a, lrWinLeft
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	out	(pLcdData), a
	out	(pLcdCmd), a
	ld	a, lrWinRight
	out	(pLcdCmd), a
	ld	a, 1
	out	(pLcdData), a
	;ld	a, lcdLow(((charWidth * textCols) - 1))
	ld	a, 3Fh
	out	(pLcdData), a
	ld	a, lrWinBottom
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, colorScrnHeight
	out	(pLcdData), a
	ei
	ret	;134 cc


;------ SetDirectionRight ------------------------------------------------------
SetDirectionRight:
; Sets the cursor to move left after every pixel.  At the end of the row, it
; then moves down;
; Inputs:
;  - None
; Output:
;  - Mode changed
; Destroys:
;  - AF
;  - H
	di
	push	hl
	ld	a, lrEntryMode
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	in	a, (pLcdData)
	ld	h, a
	in	a, (pLcdData)
	; Ignore the result
	ld	a, h
	out	(pLcdData), a
	ld	a, lcdCurMoveHoriz | lcdRowInc | lcdColInc
	out	(pLcdData), a
	pop	hl
	ei
	ret


;------ SetDirectionDown -------------------------------------------------------
SetDirectionDown:
; Sets the cursor to move down after every pixel.  At the end of the column, it
; then moves right.
; Inputs:
;  - None
; Output:
;  - Mode changed
; Destroys:
;  - AF
;  - H
	di
	ld	a, lrEntryMode
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	in	a, (pLcdData)
	ld	h, a
	in	a, (pLcdData)
	; Ignore the result
	ld	a, h
	out	(pLcdData), a
	ld	a, lcdRowInc | lcdColInc
	out	(pLcdData), a
	ei
	ret


;------ ------------------------------------------------------------------------
.endmodule