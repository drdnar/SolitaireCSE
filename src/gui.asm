; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.

.module	Gui

guiFlagInteractive	.equ	80h
guiFlagStatic		.equ	0
guiButton		.equ	1 + guiFlagInteractive
guiRadioButton		.equ	2 + guiFlagInteractive
guiNumberBox		.equ	3 + guiFlagInteractive


;------ ShowNumbers ------------------------------------------------------------
ShowNumbers:
; Shows a table of numbers
; Input:
;  - IX: Pointer to struct, first byte length, followed by pointers to 16-bit signed ints
; Output:
;  - Number drawn
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	ld	b, (ix)
	inc	ix
@:	ld	l, (ix + 0)
	ld	h, (ix + 1)
	ld	d, (ix + 2)
	call	Locate
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	push	bc
	call	DispDecimal
	pop	bc
	ld	de, 5
	add	ix, de
	djnz	{-1@}
	ret


;------ ShowModalDialog --------------------------------------------------------
ShowModalDialog:
; Shows a message box with two buttons.  This is a jump, not a call.
; Input:
;  - IX: Pointer to dialog struct.
; Output:
;  - Dialog shown
;  - Different callback depending on user button choice
; Destroys:
;  - This routine does not directly return to caller
;  - All
;	.dw	Post-draw callback
;	.dw	Button 1 callback
;	.dw	Button 2 callback
;	.db	Title text, 0
;	.db	Line 1, 0
;	.db	Line 2, 0
;	.db	Line 3, 0
;	.db	Line 4, 0
;	.db	Line 5, 0
;	.db	Line 6, 0
;	.db	Line 7, 0
;	.db	Line 8, 0
;	.db	Button 1 text, 0
;	.db	Button 2 text, 0
	; Draw boxes
	push	ix
		ld	ix, _dialog
		call	GuiDoDraw
	pop	hl
	; Draw title
	; This one stack entry will persist until after the button callbacks
	push	hl
		ld	de, 6
		add	hl, de
		push	hl
			ex	de, hl
			call	GetStrWidth
			sra	l
			ex	de, hl
			ld	hl, 161
			or	a
			sbc	hl, de
			ld	d, 54
			call	Locate
		pop	hl
		call	PutS
		; Draw lines of text
		ld	b, 8
		ld	c, 68
@:		push	hl
			ld	hl, 59
			ld	d, c
			call	Locate
			ld	a, c
			add	a, 12
			ld	c, a
		pop	hl
		call	PutS
		djnz	{-1@}
		; Draw button 1 text
		push	hl
			ex	de, hl
			call	GetStrWidth
			sra	l
			ex	de, hl
			ld	hl, 171
			or	a
			sbc	hl, de
			ld	d, 165
			call	Locate
		pop	hl
		call	PutS
		; Draw button 2 text
		push	hl
			ex	de, hl
			call	GetStrWidth
			sra	l
			ex	de, hl
			ld	hl, 234
			or	a
			sbc	hl, de
			ld	d, 165
			call	Locate
		pop	hl
		call	PutS
	pop	hl
	; Extra drawing callback
	push	hl
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	or	h
	jr	z, {@}
	ld	de, {@}
	push	de
	jp	(hl)
@:	; Enter UI loop
	ld	ix, _dialogButton1
	jp	GuiEventLoop
	
_button1Do:
	pop	af
	pop	ix
	ld	l, (ix + 2)
	ld	h, (ix + 3)
	jp	(hl)

_button2Do:
	pop	af
	pop	ix
	ld	l, (ix + 4)
	ld	h, (ix + 5)
	jp	(hl)
	

_dialog:
	.dw	_dialogBanner		; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	56			; Column
	.db	59			; Row
	.db	208			; Width
	.db	122			; Height
	.dw	GuiDrawFilledBox	; Draw callback
_dialogBanner:
	.dw	_dialogButton1		; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	102			; Column
	.db	53			; Row
	.db	117			; Width
	.db	14			; Height
	.dw	GuiDrawFilledBox	; Draw callback
_dialogButton1:
	.dw	_dialogButton2	; Pointer to next entry
	.db	guiButton		; Flags & Type ID
	.dw	144			; Column
	.db	164			; Row
	.db	54			; Width
	.db	14			; Height
	.dw	GuiDrawButton		; Draw callback	
	.dw	_button1Do		; Enter key callback
	.dw	0			; Control below ptr
	.dw	_dialogButton2		; Control left ptr
	.dw	_dialogButton2		; Control right ptr
	.dw	0			; Control above ptr
	.db	0
_dialogButton2:
	.dw	0			; Pointer to next entry
	.db	guiButton		; Flags & Type ID
	.dw	207			; Column
	.db	164			; Row
	.db	54			; Width
	.db	14			; Height
	.dw	GuiDrawButton		; Draw callback	
	.dw	_button2Do		; Enter key callback
	.dw	0			; Control below ptr
	.dw	_dialogButton1		; Control left ptr
	.dw	_dialogButton1		; Control right ptr
	.dw	0			; Control above ptr
	.db	0


;====== Widget Library =========================================================


;------ GuiEventLoop -----------------------------------------------------------
GuiEventLoop:
; GUI event loop.  This is a jump, not a call.
; The correct way to exit this function is to have a button's ENTER callback not
; return.  The button must eat one stack entry to balance the stack, or else
; reset the stack manually.
; Input:
;  - IX: Pointer to entry.
; Output:
;  - Gooeyness.
; Destroys:
;  - This routine never returns, so . . . all?
	; Highlight active item
	call	_highlightItem
	set	cursorShowing, (iy + guiFlags)
_gelkl:	; Key loop
	ld	iy, flags
	ei
	halt
	;ld	a, (flags + mSettings)
	;and	setApdNowM
	bit	setApdNow, (iy + mSettings)
	jp	nz, SaveAndQuit
	bit	kbdCurFlash, (iy + mKbdFlags)
	jr	z, {@}
	call	_highlightItem
	ld	a, 1
	xor	(iy + guiFlags)
	ld	(iy + guiFlags), a
@:	call	GetCSC
	or	a
	jr	z, _gelkl
	ld	de, 12
	cp	5	; Is arrow key?
	jr	c, _gelm
	cp	skEnter
	jr	z, _gelact
	cp	sk2nd
	jr	z, _gelact
	cp	skYEqu
	jr	z, _f1
	cp	skWindow
	jr	z, _f2
	jr	_gelkl
; Movement subroutine
_gelm:	; Recall that skDown = 1, skLeft = 2, &c.
	; This converts the keycode into an offset and fetches the right pointer.
	add	a, a
	add	a, 10	; would be 12, but skDown == 1, times 2 = 2, so subtract that from offset
	push	ix
	pop	hl
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	; Fetch
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	; Is zero?
	or	h
	jr	z, _gelkl
	push	hl
	bit	cursorShowing, (iy + guiFlags)
	call	nz, _highlightItem
	pop	ix
	jr	GuiEventLoop
; Do action subroutine.
_gelact:; For various reasons, unhighlight control before sending it the event.
	bit	cursorShowing, (iy + guiFlags)
	call	nz, _highlightItem
	; Now send it the event.
	ld	hl, GuiEventLoop
	push	hl
	ld	l, (ix + 10)
	ld	h, (ix + 11)
	; If the callback field is zero, then it's not a valid callback.
	ld	a, l
	or	h
	ret	z	; Recall that the callback itself returns via ret.
	jp	(hl)
_f1:
	bit	cursorShowing, (iy + guiFlags)
	call	nz, _highlightItem
	ld	hl, GuiEventLoop
	push	hl
	ld	hl, (f1GuiCallback)
	ld	a, l
	or	h
	ret	z
	jp	(hl)
_f2:
	bit	cursorShowing, (iy + guiFlags)
	call	nz, _highlightItem
	ld	hl, GuiEventLoop
	push	hl
	ld	hl, (f2GuiCallback)
	ld	a, l
	or	h
	ret	z
	jp	(hl)
_highlightItem:
	res	kbdCurFlash, (iy + mKbdFlags)
	ld	hl, cursorPeriod
	ld	(cursorTimer), hl
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	ld	e, (ix + 6)
	ld	b, (ix + 7)
	jp	InvertRect


;------ GuiFindItemType --------------------------------------------------------
GuiFindItemType:
; Finds the first item with a given type.
; Inputs:
;  - B: Type to search for
;  - IX: Pointer to first GUI item from which to start searching
; Outputs:
;  - IX: Pointer to found item, or zero if not found.
; Destroys:
;  - AF
;  - HL
	ld	a, b
	and	15
	ld	b, a
	ld	a, ixl
	or	ixh
	ret	z
	ld	a, (ix + 2)
	and	15
	cp	b
	ret	z
	ld	l, (ix + 0)
	ld	h, (ix + 1)
	push	hl
	pop	ix
	jr	GuiFindItemType


;------ GuiDoDraw --------------------------------------------------------------
GuiDoDraw:
; Draws all GUI objects.
; Input:
;  - IX: Pointer to first GUI item
; Output:
;  - Items drawn
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
;  - IX
	ld	a, ixl
	or	ixh
	ret	z
	push	ix
	ld	hl, _guiddret
	push	hl
	ld	l, (ix + 8)
	ld	h, (ix + 9)
	jp	(hl)
_guiddret:
	pop	ix
	ld	l, (ix + 0)
	ld	h, (ix + 1)
	push	hl
	pop	ix
	jr	GuiDoDraw


;------ GUI Action Callbacks ---------------------------------------------------
; Input:
;  - IX: Pointer to GUI active element
; Output:
;  - Actions
;  - IX: Pointer to active GUI element
; Destroys:
;  - Anything, but IX must point to valid GUI element.
GuiActionRadio:
	push	ix
	; Set memory value
	ld	l, (ix + 21)
	ld	h, (ix + 22)
	ld	a, (ix + 23)
	ld	(hl), a
	; Paint radio button, change glyph
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	inc	hl
	inc	hl
	ld	d, (ix + 5)
	call	Locate
	ld	a, chFilledBullet
	ld	(ix + 26), a
	call	PutC
	; Now search for other radio buttons in the same group
	ld	c, (ix + 20)
	ld	b, guiRadioButton
	push	ix
	pop	iy
	ld	ix, guiRam
	jr	_garl
_garln:	; Advance to next item
	ld	l, (ix + 0)
	ld	h, (ix + 1)
	push	hl
	pop	ix
_garl:	call	GuiFindItemType
	; Is this the last item?
	ld	a, ixl
	or	ixh
	jr	z, _garex
	; Is this the item we just set?
	ld	a, ixl
	cp	iyl
	jr	nz, _garla
	ld	a, ixh
	cp	iyh
	jr	z, _garln
_garla:	; Is this in the same group?
	ld	a, (ix + 20)
	cp	c
	jr	nz, _garln
	; Paint radio button, change glyph
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	inc	hl
	inc	hl
	ld	d, (ix + 5)
	call	Locate
	ld	a, chEmptyBullet
	ld	(ix + 26), a
	call	PutC
	jr	_garln
_garex:	ld	iy, flags
	pop	ix
	ret


;------ ------------------------------------------------------------------------
GuiActionNumberBox:
; This routine does not support negative numbers.
	ld	l, (ix + 20)
	ld	h, (ix + 21)
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	ld	(guiTemp), hl
	res	kbdCurErr, (iy + mKbdFlags)
	res	entryEmpty, (iy + guiFlags)
	; Loop
_ganbl:	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	ld	b, (ix + 6)
	ld	e, (ix + 7)
	ld	c, colorWhite
	call	DrawFilledRect
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	inc	hl
	inc	hl
	call	Locate
	ld	hl, (guiTemp)
	bit	entryEmpty, (iy + guiFlags)
	call	z, DispDecimal
	res	kbdCurErr, (iy + mKbdFlags)
	ld	hl, (guiTemp)
	ld	de, 10000
	cphlde
	jr	c, _ganbm
_ganof:	set	kbdCurErr, (iy + mKbdFlags)
_ganbm:	call	GetKeyBlinky
	cp	skClear
	jr	z, _ganab
	cp	skLeft
	jr	z, _ganbs
	cp	skEnter
	jr	z, _gandone
	cp	sk2nd
	jr	z, _gandone
	ld	hl, numberTable
	call	MapTable
	jr	nz, _ganbm
	res	entryEmpty, (iy + guiFlags)
	ld	a, b
	ld	hl, (guiTemp)
	add	hl, hl
	jr	c, _ganof
	ld	e, l
	ld	d, h
	add	hl, hl
	jr	c, _ganof
	add	hl, hl
	jr	c, _ganof
	add	hl, de
	jr	c, _ganof
	add	a, l
	jr	nc, $ + 5
	inc	h
	jr	z, _ganof
	ld	l, a
	; This is somewhat weird.
	or	h
	jr	z, _ganbl
	ld	e, (ix + 24)
	ld	d, (ix + 25)
	dec	hl
	cpHlDe
	jr	nc, _ganof
	inc	hl
	ld	(guiTemp), hl
	jp	_ganbl

_ganbs:
	ld	hl, (guiTemp)
	ld	c, 10
	call	DivHLByC
	ld	(guiTemp), hl
	ld	a, l
	or	h
	jp	nz, _ganbl
	set	entryEmpty, (iy + guiFlags)
	jp	_ganbl

_gandone:
	ld	hl, (guiTemp)
	ld	e, (ix + 22)
	ld	d, (ix + 23)
	cpHlDe
	ex	de, hl
	jr	nc, _gandg
	ex	de, hl
_gandg:	ld	l, (ix + 20)
	ld	h, (ix + 21)
	ld	(hl), e
	inc	hl
	ld	(hl), d
_ganab:	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	ld	b, (ix + 6)
	ld	e, (ix + 7)
	ld	c, colorWhite
	call	DrawFilledRect
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	inc	hl
	inc	hl
	call	Locate
	ld	l, (ix + 20)
	ld	h, (ix + 21)
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	call	DispDecimal
	ret
	
numberTable:
	.db	10
	.db	sk7, 7
	.db	sk8, 8
	.db	sk9, 9
	.db	sk4, 4
	.db	sk5, 5
	.db	sk6, 6
	.db	sk1, 1
	.db	sk2, 2
	.db	sk3, 3
	.db	sk0, 0


;------ GUI Drawing Callbacks --------------------------------------------------
GuiDrawNumberBox:
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	inc	hl
	inc	hl
	call	Locate
	ld	l, (ix + 20)
	ld	h, (ix + 21)
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	call	DispDecimal
	ret


;------ ------------------------------------------------------------------------
GuiDrawBanner:
	; I could do this without IX, but it would be more confusing and I'm lazy.
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	ld	b, (ix + 6)
	ld	e, (ix + 7)
	ld	c, colorWhite
	call	DrawOutlinedFilledRect
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	inc	hl
	inc	d
	call	Locate
	push	ix
	pop	hl
	ld	de, 10
	add	hl, de
	jp	PutS


;------ ------------------------------------------------------------------------
GuiDrawButton:
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	ld	b, (ix + 6)
	ld	e, (ix + 7)
	ld	c, colorWhite
	call	DrawOutlinedFilledRect
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	inc	hl
	inc	d
	call	Locate
	push	ix
	pop	hl
	ld	de, 20
	add	hl, de
	jp	PutS


;------ ------------------------------------------------------------------------
GuiDrawFilledBox:
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	ld	b, (ix + 6)
	ld	e, (ix + 7)
	ld	c, colorWhite
	jp	DrawOutlinedFilledRect


;------ ------------------------------------------------------------------------
GuiDrawBox:
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	ld	b, (ix + 6)
	ld	e, (ix + 7)
	jp	DrawRect


;------ ------------------------------------------------------------------------
GuiDrawText:
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	call	Locate
	push	ix
	pop	hl
	ld	de, 10
	add	hl, de
	jp	PutS


;------ ------------------------------------------------------------------------
GuiDrawRadioButton:
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	call	Locate
	push	ix
	pop	hl
	ld	de, 24
	add	hl, de
	jp	PutS


;------ ------------------------------------------------------------------------
GuiDrawWhiteBox:
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	ld	b, (ix + 6)
	ld	e, (ix + 7)
	ld	c, colorWhite
	jp	DrawFilledRect


;------ ------------------------------------------------------------------------
GuiDrawHorizLine:
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	ld	b, (ix + 6)
	ld	c, colorBlack
	jp	DrawHorizLine


;------ ------------------------------------------------------------------------
.endmodule