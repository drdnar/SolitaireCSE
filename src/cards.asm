; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.


stacksTable:
	.dw	stack0
	.dw	stack1
	.dw	stack2
	.dw	stack3
	.dw	stack4
	.dw	stack5
	.dw	stack6
	.dw	stack7
	.dw	homeCell0
	.dw	homeCell1
	.dw	homeCell2
	.dw	homeCell3
	.dw	freeCell0
	.dw	freeCell1
	.dw	freeCell2
	.dw	freeCell3
	.dw	freeCell4
	.dw	freeCell5
	.dw	dealCell
	.dw	deckCell
	.dw	0

stack0		.equ	stacks
stack1		.equ	stack0 + 32
stack2		.equ	stack1 + 32
stack3		.equ	stack2 + 32
stack4		.equ	stack3 + 32
stack5		.equ	stack4 + 32
stack6		.equ	stack5 + 32
stack7		.equ	stack6 + 32
homeCell0	.equ	stack7 + 32
homeCellNo0	.equ	8
homeCell1	.equ	homeCell0 + 24
homeCellNo1	.equ	9
homeCell2	.equ	homeCell1 + 24
homeCellNo2	.equ	10
homeCell3	.equ	homeCell2 + 24
homeCellNo3	.equ	11
freeCell0	.equ	homeCell3 + 24
freeCellNo0	.equ	12
freeCell1	.equ	freeCell0 + 12
freeCellNo1	.equ	13
freeCell2	.equ	freeCell1 + 12
freeCellNo2	.equ	14
freeCell3	.equ	freeCell2 + 12
freeCellNo3	.equ	15
freeCell4	.equ	freeCell3 + 12
freeCellNo4	.equ	16
freeCell5	.equ	freeCell4 + 12
freeCellNo5	.equ	17
dealCell	.equ	freeCell5 + 12
dealCellNo	.equ	18
deckCell	.equ	dealCell + 12
deckCellNo	.equ	19
numberOfStacks	.equ	20

stackStatus	.equ	0
stackColumn	.equ	1
stackRow	.equ	3
stackMoveDown	.equ	4
stackMoveLeft	.equ	5
stackMoveRight	.equ	6
stackMoveUp	.equ	7
stackCards	.equ	8

stackActiveM	.equ	80h
stackActive	.equ	7
stackCountM	.equ	1Fh
stackHideHidden	.equ	6
stackHideHiddenM	.equ	40h
stackShowOnlyTop	.equ	5
stackShowOnlyTopM	.equ	20h

cardNotVisible	.equ	6
cardNotVisibleM	.equ	40h
notACard	.equ	63
cardTypeMask	.equ	63

cardWidth	.equ	26
cardHeight	.equ	39
cardHeaderHeight	.equ	13
cardBodyHeight		.equ	26


.module	Cards

;------ Abort Dialog Stubs -----------------------------------------------------
DoScreenRedraw:
	ld	a, (selectedGame)
	and	3
	jp	z, KlondikeInitalizeScreen
	jp	FreeCellInitalizeScreen

DoForfeit:
	ld	a, (selectedGame)
	and	3
	jp	z, KlondikeForfeit
	jp	FreeCellForfeit


;------ LoadStacks -------------------------------------------------------------
LoadStacks:
; Loads all stacks from some area of RAM.
; Input:
;  - HL: Source
; Output:
;  - Stacks loaded
;  - HL: Byte after last byte of stack data
; Destroys:
;  - AF
;  - BC
;  - HL
;  - IXl
	ld	ixl, 0
_lslp:	ex	de, hl
	ld	a, ixl
	ld	l, a
	call	DerefStack
	ex	de, hl
	ld	a, (hl)
	ldi
	cp	255
	jr	z, {@}
	and	stackCountM
	jr	z, {@}
	cp	24
	call	nc, Panic
	ex	de, hl
	ld	bc, 7
	add	hl, bc
	ex	de, hl
	ld	c, a
	ld	b, 0
	ldir
@:	inc	ixl
	ld	a, ixl
	cp	20
	jr	c, _lslp
	ret


;------ SaveStacks -------------------------------------------------------------
SaveStacks:
; Writes all stacks to some area of RAM.
; Input:
;  - DE: Destination
; Output:
;  - Stacks written
;  - DE: Byte after last byte of stack data
; Destroys:
;  - AF
;  - BC
;  - HL
;  - IXl
	ld	ixl, 0
_sslp:	ld	a, ixl
	ld	l, a
	call	DerefStack
	ld	a, (hl)
	ldi
	cp	255
	jr	z, {@}
	and	stackCountM
	jr	z, {@}
	cp	24
	call	nc, Panic
	ld	bc, 7
	add	hl, bc
	ld	c, a
	ld	b, 0
	ldir
@:	inc	ixl
	ld	a, ixl
	cp	20
	jr	c, _sslp
	ret


;------ Main GUI loop for generic Solitaire game -------------------------------
CardsPlayLoop:
;	ld	hl, 0
;	ld	d, 12
;	call	Locate
;	ld	a, (undoNextSlot)
;	call	DispA
;	ld	a, ' '
;	call	PutC
;	ld	a, (undosExtant)
;	call	DispA
;	ld	a, ' '
;	call	PutC

;	ld	a, (currentStack)
;	call	DispByte
;	ld	a, ','
;	call	PutC
;	ld	a, (currentDepth)
;	call	DispByte

;	ld	a, ':'
;	call	PutC
;	ld	a, (currentStack)
;	ld	l, a
;	push	hl
;	call	DerefStack
;	ld	a, (hl)
;	call	DispByte
;	ld	a, ' '
;	call	PutC
;	pop	hl
;	ld	a, (currentDepth)
;	call	GetCard
;	call	DispByte
;	ld	a, ' '
;	call	PutC
;	ld	a, (currentStack)
;	ld	l, a
;	call	CheckCard
;	call	DispByte
;	ld	a, ' '
;	call	PutC
;	ld	a, (currentStack)
;	ld	l, a
;	call	GetStackDepth
;	call	DispByte
;	ld	a, ' '
;	call	PutC

;	ld	a, ';'
;	call	PutC
;	ld	a, (selectedStack)
;	call	DispByte
;	ld	a, ','
;	call	PutC
;	ld	a, (selectedDepth)
;	call	DispByte
	
;	ld	d, 255
	
	call	HighlightCurrentCard
_cpKLoop:
	ei
	halt
	ld	a, (flags + mSettings)
	and	setApdNowM
	jp	nz, SaveAndQuit
;	call	nz, Panic
	call	GetCSC
	or	a
	jr	nz, _cpkdo
	; Update timer and whatnot
	ld	hl, (cardTimerCallback)
	ld	a, l
	or	h
	jr	z, _cpKLoop
	ld	de, _cpKLoop
	push	de
	jp	(hl)
	jr	_cpKLoop
_cpkdo:	; Unhighlight selected card
	push	af
	call	HighlightCurrentCard
	pop	af
	cp	6
	jr	c, _cpMove
	cp	skEnter
	jr	z, _cpSelect
	cp	sk2nd
	jr	z, _cpSelect
	cp	skAlpha
	jr	z, _cpSelect2
	cp	skYEqu
	jr	z, _cpF1
	cp	skWindow
	jr	z, _cpF2
	cp	skGraph
	jr	z, _cpF5
	cp	skClear
	jp	z, _cpAbort;Quit
	cp	skMode
	jp	z, {@}
	cp	skGraphVar
	jr	nz, CardsPlayLoop
	ld	hl, saveVarMode
	ld	a, (hl)
	cp	3
	jr	nz, {@}
	dec	(hl)
@:	call	UnselectCard
	jp	SaveAndQuit
_cpSelect:
	ld	hl, (selectCardCallback)
	jp	(hl)
_cpSelect2:
	ld	hl, (selectCard2Callback)
;	ld	a, l
;	or	h
;	jp	z, CardsPlayLoop
	jp	(hl)
_cpF1:
	ld	hl, (f1Callback)
	ld	a, l
	or	h
	jp	z, CardsPlayLoop
	jp	(hl)
_cpF2:
	ld	hl, (f2Callback)
	jp	(hl)
_cpF5:
	ld	hl, (f5Callback)
;	ld	a, l
;	or	h
;	jp	z, CardsPlayLoop
	jp	(hl)
_cpAbort:
	call	UnselectCard
	ld	ix, abortDialog
	jp	ShowModalDialog
_cpMove:
	ld	hl, currentStack
	ld	l, (hl)
	call	DerefStack
	cp	skLeft
	jr	z, _cpMoveGo
	cp	skRight
	jr	z, _cpMoveGo
	bit	stackShowOnlyTop, (hl)
	jr	z, _cpMoveWithinStack
;	cp	skUp
;	jr	nz, _cpMoveGo
;	ld	b, a
;	ld	a, (currentDepth)
;	or	a
;	jr	nz, _cpMoveUp
;	ld	a, b
_cpMoveGo:
	dec	a
;	add	a, a
	add	a, 4	; Added value!
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	a, (hl)
	inc	a
	jp	z, CardsPlayLoop
	dec	a
	ld	(currentStack), a
	ld	l, a
	call	GetTopCardNumber
	ld	(currentDepth), a
	jp	CardsPlayLoop
_cpMoveWithinStack:
	ld	b, a
	ld	a, (currentStack)
	cp	dealCellNo
	ld	a, b
	jr	z, _cpMoveGo
;	push	af
;	ld	a, (currentStack)
;	ld	l, a
;	pop	af
;	call	DerefStack
;	bit	stackShowOnlyTop, (hl)
;	jr	nz, _cpMoveGo
	cp	skUp
	jr	z, _cpMoveUp
	ld	a, (hl)
	and	stackCountM
	jp	z, CardsPlayLoop
	ld	b, a
	ld	a, (currentDepth)
	inc	a
	cp	b
	jp	z, {@}
	ld	(currentDepth), a
	jp	CardsPlayLoop
	; Attempt to move to bottom-most card.
@:	ld	a, (hl)
	and	stackCountM
	call	z, Panic;jp	z, quit;CardsPlayLoop
	ld	b, a
	ld	c, 0
	ld	de, 8
	add	hl, de
@:	ld	a, (hl)
	and	cardNotVisibleM
	jr	z, {@}
	inc	hl
	inc	c
	djnz	{-1@}
	jp	CardsPlayLoop
@:	ld	a, c
	ld	(currentDepth), a
	jp	CardsPlayLoop
_cpMoveUp:
	ld	a, (currentDepth)
	ld	b, a
	or	a
	ld	a, skUp
	jr	z, _cpMoveGo
	ld	a, b
;	or	a
;	jp	z, CardsPlayLoop
	dec	a
	push	af
	; Fetch pointer to current card and check card below
	ld	hl, currentStack
	ld	l, (hl)
	call	GetCard
;	ld	b, a
;	ld	a, (currentStack)
;	ld	l, a
;	call	DerefStack
;	ld	a, b
;	add	a, 8
;	add	a, l
;	jr	nc, $ + 3
;	inc	h
;	ld	l, a
	pop	af
	bit	cardNotVisible, (hl)
	jp	nz, CardsPlayLoop
	ld	(currentDepth), a
	jp	CardsPlayLoop


;------ TryToMoveCardsToHomeCell -----------------------------------------------
TryToMoveCardsToHomeCell:
; Scans for any cards that can be moved to a home cell.
; Inputs:
;  - None
;  - IX: Callback to be invoked in move is accepted
; Output:
;  - Cards moved if possible, stuff redrawn
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	ld	hl, (currentDepth)
	push	hl
	ld	b, 7
	ld	a, (selectedGame)
	and	3
	jr	z, {@}
	inc	b
@:	ld	a, b
	dec	a
	ld	(currentStack), a
	ld	l, a
	call	GetTopCardNumber
	ld	(currentDepth), a
	push	bc
;	push	ix
	call	TryToMoveToHomeCell
.ifdef	NEVER
	pop	bc
	push	bc
	push	af
	push	bc
	ld	h, 0
	ld	a, b
	add	a, a
	add	a, a
	add	a, a
	ld	l, a
	ld	d, 30
	call	Locate
	ld	a, b
	add	a, '0'
	call	PutC
	call	GetKey
	pop	bc
	pop	af
.endif
;	pop	ix
	pop	bc
	djnz	{-1@}
	ld	a, (selectedGame)
	and	3
	jr	nz, _tmhfc
	ld	a, dealCellNo
	ld	(currentStack), a
	ld	l, a
	call	GetTopCardNumber
	ld	(currentDepth), a
;	ld	hl, 0
;	ld	d, 50
;	call	Locate
;	call	DispA
	call	TryToMoveToHomeCell
	jr	_tmhcr
_tmhfc:	ld	b, 4
@:	ld	a, b
	add	a, freeCellNo0 - 1
	ld	(currentStack), a
	ld	l, a
	call	GetTopCardNumber
	ld	(currentDepth), a
	push	bc
	call	TryToMoveToHomeCell
	pop	bc
	djnz	{-1@}
_tmhcr:	pop	de
	ld	(currentDepth), de
	ld	l, d
	call	GetTopCardNumber
	cp	e
	ret	nc
	ld	(currentDepth), a
	ret


;------ TryToMoveToHomeCell ----------------------------------------------------
TryToMoveToHomeCell:
; If possible, moves a card from the cursor to a home cell, and redraws if
; the move was accepted.
; Inputs:
;  - currentStack, currentDepth: Card to move
;  - IX: Callback to be invoked in move is accepted
; Outputs:
;  - Card moved if possible
;  - C if illegal move
;  - NC if legal move
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
;	ld	hl, 0
;	ld	d, 12 * 3
;	call	Locate
;	ld	a, (guiTemp+1)
;	call	DispA
;	ld	a, ' '
;	call	PutC
;	ld	a, (currentDepth)
;	call	DispA
;	ld	a, ' '
;	call	PutC
;	ld	a, (currentStack)
;	ld	l, a
;	ld	a, (currentDepth)
;	call	GetCard
;	push	af
;	call	DispByte
;	pop	af
;	call	PrintCard
;	ld	a, '.'
;	call	PutC
;	ld	hl, 0
;	ld	d, 80
;	call	Locate
;	ld	a, '?'
;	call	PutC
	; Check if card is top card
	ld	a, (currentStack)
	ld	l, a
	call	GetStackDepth
	jr	z, _mthcErr0
	dec	a
	ld	b, a
	ld	a, (currentDepth)
	cp	b
	jr	nz, _mthcErr1
	; Check if card is ace
	ld	hl, currentStack
	ld	l, (hl)
	call	GetCard
	ld	c, a
	and	rankMask | 0F0h
	jr	nz, _mthcNotAce
	; Find free slot
	ld	e, homeCellNo0
	ld	l, e
	call	GetStackDepth
	jr	z, _mthcAccept
	inc	e
	ld	l, e
	call	GetStackDepth
	jr	z, _mthcAccept
	inc	e
	ld	l, e
	call	GetStackDepth
	jr	z, _mthcAccept
	inc	e
	ld	l, e
	call	GetStackDepth
	jr	nz, _mthcErr2
	jr	_mthcAccept
_mthcNotAce:
	; Find matching foundation
	ld	e, homeCellNo0 - 1
	ld	b, 4
@:	inc	e
	ld	l, e
	call	GetStackDepth
	jr	z, {@}
	ld	l, e
	call	CheckCard
	add	a, 4
	cp	c
	jr	z, _mthcAccept
@:	djnz	{-2@}
	jr	_mthcErr3
_mthcAccept:
	push	de
	ld	hl, _mthcb
	push	hl
	jp	(ix)
_mthcb:	pop	de
	; Move card
	ld	a, (currentStack)
	ld	l, a
	call	RemoveCard
;	ld	b, a
	ld	l, e
	call	PlaceCard
	ld	a, e
	call	DrawStackAndEraseBelowIfNecessary
	ld	a, (currentStack)
	call	DrawStackAndEraseBelowIfNecessary
	ld	a, (currentStack)
	ld	l, a
	call	GetTopCardNumber
	ld	(currentDepth), a
;	ld	a, '+'
;	ld	hl, 0
;	ld	d, 80
;	call	Locate
;	call	PutC
	or	a
	ret
_mthcErr0:
;	ld	a, '0'
;	jr	{@}
_mthcErr1:
;	ld	a, '1'
;	jr	{@}
_mthcErr2:
;	ld	a, '2'
;	jr	{@}
_mthcErr3:
;	ld	a, '3'
;@:	ld	hl, 0
;	ld	d, 80
;	call	Locate
;	call	PutC
_mthcErr:
	scf
	ret


;------ DrawStacks -------------------------------------------------------------
DrawStacks:
; Draws a list of stacks
; Input:
;  - IX: Pointer to list of stacks
; Output:
;  - Stacks drawn
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
;  - IX
	ld	b, (ix)
	inc	ix
@:	push	bc
	ld	a, (ix)
	inc	ix
	inc	ix
	inc	ix
	ld	l, a
	call	DerefStack
	ld	a, (hl)
	cp	255
	ld	a, (ix - 3)
	call	nz, DrawStack
	pop	bc
	djnz	{-1@}
	ret


;------ InitalizeStacks --------------------------------------------------------
InitalizeStacks:
; Draws a list of stacks
; Input:
;  - IX: Pointer to list of stacks
; Output:
;  - Stacks initialized
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
;  - IX
	ld	b, (ix)
	inc	ix
@:	push	bc
	ld	l, (ix)
	inc	ix
	call	DerefStack
	ex	de, hl
	ld	l, (ix)
	inc	ix
	ld	h, (ix)
	inc	ix
	ld	bc, 8
	ldir
	pop	bc
	djnz	{-1@}
	ret


;------ IsStackCell ------------------------------------------------------------
IsStackCell:
; Checks if the given stack is in the tableau.
; Input:
;  - A
; Output:
;  - Z if stack is in main tableau stack.
; Destroys:
;  - Nothing
	cp	7
	ret	nc	; 7 is a tableau stack; note that Z is also true here
	jr	_retz


;------ IsFreeCell -------------------------------------------------------------
IsFreeCell:
; Checks if the given stack is a freecell stack.
; Input:
;  - A
; Output:
;  - Z if freecell stack
; Destroys:
;  - Nothing
	cp	freeCellNo0
	ret	c
	cp	freeCellNo5
	ret	nc
_retz:	push	bc
	ld	b, a
	xor	a
	ld	a, b
	pop	bc
	ret


;------ IsHomeCell -------------------------------------------------------------
IsHomeCell:
; Checks if the given stack is a home stack.
; Input:
;  - A
; Output:
;  - Z if home stack
; Destroys:
;  - Nothing
	cp	homeCellNo0
	ret	z
	cp	homeCellNo1
	ret	z
	cp	homeCellNo2
	ret	z
	cp	homeCellNo3
	ret


;------ CanBeStacked -----------------------------------------------------------
CanBeStacked:
; Checks if one card can be stacked on the other, according to rank and color.
; Inputs:
;  - C: Candidate to stack on top
;  - A: Card on which to be placed
; Output:
;  - C if can be stacked
;  - NC if cannot be stacked
; Destroys:
;  - F
	push	af
	push	bc
	call	CompareColors
	jr	z, {@}
	and	rankMask
	ld	b, a
	ld	a, c
	and	rankMask
	add	a, 4
	cp	b
	jr	nz, {@}
	pop	bc
	pop	af
	scf
	ret
@:	pop	bc
	pop	af
	or	a
	ret


;------ CompareRanks -----------------------------------------------------------
CompareRanks:
; Checks if the rank of A is the rank of C plus one.
; Inputs:
;  - A
;  - C
; Outputs:
;  - Z if A's rank is C's rank plus one
;  - NZ if not
; Destroys:
;  - Nothing
	push	bc
	ld	b, a
	ld	a, c
	and	rankMask
	add	a, 4
	ld	c, a
	ld	a, b
	and	rankMask
	cp	c
	ld	a, b
	pop	bc
	ret


;------ CompareColors ----------------------------------------------------------
CompareColors:
; Checks if the colors of two cards are the same or different.
; Inputs:
;  - A
;  - C
; Outputs:
;  - NZ if different
;  - Z if same
; Destroys:
;  - Nothing
	; This may be a little bit faster, but it's bigger.
	; It also prevents saving all registers.
;	and	3		; 7	2
;	cp	suitClub	; 7	2
;	jr	z, _ccblack	; 7/12	2
;	cp	suitSpade	; 7	2
;	jr	z, _ccblack	; 7/12	2
;	; It's red
;	ld	b, a		; 4	1
;	and	3		; 7	2
;	cp	suitDiamond	; 7	2
;	ret	z		; 5/11	1
;	cp	suitHeart	; 7	2
;	ret			; 10	1
;_ccblack:
;	ld	b, a		; 4	1
;	and	3		; 7	2
;	cp	suitClub	; 7	2
;	ret	z		; 5/11	1
;	cp	suitSpade	; 7	2
;	ret			; 10	1
	; This is the only time I have ever used parity.
	; Recall that the IDs for club and spade are 00 and 11.  Therefore,
	; after masking out the rank, parity is even for club and spade.
	; Conversely, it is even for heart and diamond.
	push	bc
	ld	b, a
	and	suitMask	; 7	2
	ld	a, c		; 4	1
	jp	po, _ccpo	; 12	3
	and	suitMask	; 7	2
	jp	pe, _ccbad	; 12	3
	jr	_ccgd		; 12	2
_ccpo:
	and	suitMask	; 7	2
	jp	po, _ccbad	; 12	3
_ccgd:	xor	a		; 4	1
	inc	a		; 4	1
	ld	a, b
	pop	bc
	ret			; 10	1
_ccbad:
	xor	a		; 4	1
	ld	a, b
	pop	bc
	ret			; 10	1


;------ UnselectCard -----------------------------------------------------------
UnselectCard:
; If there is a currently selected card, this unselects it.
; Inputs:
;  - None
;  - (currentStack)
;  - (currentDepth)
;  - (selectedStack)
;  - (selectedDepth)
; Output:
;  - Card unhighlighted
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	ld	a, (selectedStack)
	inc	a
	ret	z
	dec	a
	ld	l, a
	ld	a, (selectedDepth)
	ld	h, a
	ld	a, 255
	ld	(selectedStack), a
	ld	a, h
	call	GetCardLocation
	ld	b, e
	ld	e, 26
	jp	InvertRect


;------ SelectCurrentCard ------------------------------------------------------
SelectCurrentCard:
; Sets the current card to be selected.
; Inputs:
;  - None
;  - (currentStack)
;  - (currentDepth)
;  - (selectedStack)
;  - (selectedDepth)
; Output:
;  - Card highlighted
;  - Card set as selected
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	ld	a, (selectedStack)
	inc	a
	call	nz, UnselectCard
	ld	a, 255
	ld	(selectedStack), a
	call	HighlightCurrentCard
	ld	a, (currentStack)
	ld	(selectedStack), a
	ld	a, (currentDepth)
	ld	(selectedDepth), a
	ret


;------ HighlightCurrentCard ---------------------------------------------------
HighlightCurrentCard:
; Highlights the card under the cursor, unless that card is also the currently
; selected card, in which case it is already already highlighted.
; Inputs:
;  - None
;  - (currentStack)
;  - (currentDepth)
;  - (selectedStack)
;  - (selectedDepth)
; Output:
;  - Card highlighted
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	ld	a, (currentStack)
	ld	l, a
	ld	a, (selectedStack)
	cp	l
	ld	a, (currentDepth)
	jr	nz, _cpha
	ld	b, a
	ld	a, (selectedDepth)
	cp	b
	ret	z
	ld	a, b
_cpha:	call	GetCardLocation
	ld	b, e
	ld	e, 26
	jp	InvertRect


;------ GetTopCardNumber -------------------------------------------------------
GetTopCardNumber:
; Returns the number of the top-most card on a stack.
; Input:
;  - L: Stack number
; Output:
;  - A: Depth
; Destroys:
;  - HL
	call	GetStackDepth
	ret	z
	dec	a
	ret


;------ GetStackDepth ----------------------------------------------------------
GetStackDepth:
; Returns the number of cards in a stack.
; Input:
;  - L: Stack number
; Output:
;  - A: Depth
;  - Z if empty
; Destroys:
;  - HL
	call	DerefStack
	ld	a, (hl)
	and	stackCountM
	ret


;------ PlaceCard --------------------------------------------------------------
PlaceCard:
; Places a card at the top of a stack.
; Inputs:
;  - L: Stack number
;  - A: Card to place
; Outputs:
;  - Card placed
;  - Stack is NOT redrawn
; Destroys:
;  - AF
;  - HL
	push	hl
	push	af
	call	CheckCard
	cp	notACard
	jr	nz, _pca
	dec	hl
_pca:	pop	af
	inc	hl
	ld	(hl), a
	pop	hl
	call	DerefStack
	inc	(hl)
	ret


;------ GetCard ----------------------------------------------------------------
GetCard:
; Returns the card at the given location.
; Inputs:
;  - L: Stack number
;  - A: Depth
; Outputs:
;  - A: Card
;  - HL: Pointer to card
; Destroys:
;  - Flags
	call	DerefStack
	push	de
	ld	de, 8
	add	hl, de
	ld	e, a
	add	hl, de
	pop	de
	ld	a, (hl)
	ret


;------ CheckCard --------------------------------------------------------------
CheckCard:
; Returns the value of the topmost card on a stack, or not-a-card if the stack
; is empty.  Also returns a pointer to the card.
; Input:
;  - L: Stack number
; Output:
;  - A: Card
;  - HL: Pointer to card
; Destroys:
;  - F
	call	DerefStack
	push	de
	ld	a, (hl)
	and	stackCountM
	jr	z, _ccempty
	ld	de, 7
	add	hl, de
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	a, (hl)
	pop	de
	ret
_ccempty:
	ld	a, notACard
	ld	de, 8
	add	hl, de
	pop	de
	ret


;------ RemoveCardRedraw -------------------------------------------------------
RemoveCardRedraw:
; Removes the topmost card from a given and redraws.
; Input:
;  - L: Stack number
; Output:
;  - A: Card fetched
;  - Stack is redrawn
; Destroys:
;  - BC
;  - DE
;  - HL
	push	hl
	call	RemoveCard
	pop	hl
	push	af
	ld	a, l
	call	DrawStackAndEraseBelowIfNecessary
	pop	af
	ret


;------ RemoveCard -------------------------------------------------------------
RemoveCard:
; Removes the topmost card from a given stack.
; Input:
;  - L: Stack number
; Output:
;  - A: Card fetched
;  - Stack is NOT redrawn
; Destroys:
;  - HL
	push	hl
	call	CheckCard
	ld	(hl), notACard
	cp	notACard
	pop	hl
	ret	z
	call	DerefStack
	dec	(hl)
	ret


;------ DerefStack -------------------------------------------------------------
DerefStack:
; Returns the location of a stack given its number.
; Input:
;  - L: Stack number
; Output:
;  - HL: Pointer
; Destroys:
;  - None
	push	de
	ld	h, 0
	add	hl, hl
	ld	de, stacksTable
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	pop	de
	ret


;------ GetCardLocation --------------------------------------------------------
GetCardLocation:
; Returns the location of a card given its stack and depth in stack.
; Inputs:
;  - L: Stack number
;  - A: Depth in stack
; Outputs:
;  - HL: Column
;  - D: Row
;  - E: Height
;  - Width = 26 pixels
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	push	ix
	ld	ix, 0
	add	ix, sp
	push	af	; ix - 1, ix - 2
	call	DerefStack
	bit	stackShowOnlyTop, (hl)
	jr	z, _gcl1
	; Show only top card
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	b, (hl)
	ex	de, hl
	ld	d, b
	ld	e, cardHeight
	jr	_gcl9
_gcl1:	; Card height
	ld	(ix - 2), 13 - 4
	ld	a, (hl)
	and	stackCountM
	jr	z, _gcl0
	bit	stackHideHidden, (hl)
	jr	nz, {@}
	cp	19
	jr	c, {@}
	cp	20
	call	nc, Panic
	dec	(ix - 2)
@:	; Compute card size
	ld	b, (ix - 1)
	ld	c, 13
	dec	a
	cp	b
	jr	nz, {@}
	ld	c, cardHeight
@:	; Fetch stack base location
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	push	de
	ld	a, (hl)
	; Iterate over stack
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	b	; Zero case. . . .
	dec	b
	jr	z, _gcl6
_gcl4:	inc	hl
	add	a, 4
	bit	cardNotVisible, (hl)
	jr	nz, _gcl5
	add	a, (ix - 2)
_gcl5:	djnz	_gcl4
_gcl6:	ld	d, a
	ld	e, c
	add	a, e
	jr	c, {@}
	cp	colorScrnHeight - 1
	jr	c, {2@}
@:	ld	a, colorScrnHeight
	sub	d
	ld	e, a
@:	pop	hl
_gcl9:	pop	af
	pop	ix
	ret

_gcl0:		
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	h, (hl)
	ex	de, hl
	ld	e, cardHeight
	jr	_gcl9


#ifdef	NEVER
;------ GetCardLocation --------------------------------------------------------
;GetCardLocation:
; Returns the location of a card given its stack and depth in stack.
; Inputs:
;  - L: Stack number
;  - A: Depth in stack
; Outputs:
;  - HL: Column
;  - D: Row
;  - E: Height
;  - Width = 26 pixels
;  - A: Information
;     - Card
;     - Card is top card
;     - Card is not visible
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	push	ix
	ld	ix, 0
	add	ix, sp
	push	af	; ix - 1, ix - 2
	; Get location of stack from stack number
	ld	h, 0
	add	hl, hl
	ld	de, stacksTable
	add	hl, de
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	ld	a, (hl)
	inc	hl
	bit	stackShowOnlyTop, a
	jr	z, _gcla
	; Show only top card
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	b, (hl)
	ld	a, (ix - 1)
	add	a, 5
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	a, (hl)
	ex	de, hl
	ld	d, b
	ld	e, cardHeight
	pop	ix
	pop	ix
	ret
_gcla:	ld	(ix - 2), 13 - 4	; => Height of each card
	; Is card shrinking an issue?
	bit	stackHideHidden, a
	jr	z, {@}
	and	stackCountM
;	or	a		; redundant. . . .
;	jr	z, _gclz	; Empty stack
	cp	19
	jr	c, {@}
	dec	(ix - 2)
@:	and	stackCountM
	jr	z, _gclz	; Empty stack
	cp	(ix - 1)
	ld	c, (ix - 2)	; C = height, temporarily
	jr	c, _gclc
	; A >= actual card count, so copy actual card count into and use that instead.
	ld	a, (ix - 1)
	; Also, set returned card height
	ld	c, cardHeight
_gclc:	ld	b, a
	; Fetch column of stack
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	push	de
	; Fetch row
	ld	d, (hl)
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	; Iterate over cards
	ld	e, c		; Now E = height, for remainder of function
	; If the requested card is card 0, don't iterate over 256 cards.
	ld	a, (hl)
	xor	a
	cp	b
	jr	z, _gcle
	ld	a, d
_gcld:	add	a, 4
	bit	cardNotVisible, (hl)
	inc	hl
	jr	nz, {@}
	add	a, (ix - 2)
@:	djnz	_gcld
	ld	d, a
_gcle:	pop	hl
_gclr:	pop	ix
	pop	ix
	ret

_gclz:
	jp	Quit

	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	h, (hl)
	ex	de, hl
	ld	e, cardHeight
	ld	a, notACard
	jr	_gclr
#endif


;------ DrawStackAndEraseBelowIfNecessary --------------------------------------
DrawStackAndEraseBelowIfNecessary:
; DOES WHAT IT SAYS
; Input:
;  - A: Stack number
; Output:
;  - Stack drawn
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	cp	dealCellNo
	jr	z, DrawStackEraseBelow
	call	IsStackCell
	jr	z, DrawStackEraseBelow
	jp	DrawStack


;------ DrawStackEraseBelow ----------------------------------------------------
DrawStackEraseBelow:
; Draws a complete stack, and erases the space below it.
; Input:
;  - A: Stack number
; Output:
;  - Stack drawn
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	push	af
	call	DrawStack
	pop	af
	ld	l, a
	push	hl
	call	GetTopCardNumber
	pop	hl
	push	hl
	call	GetCardLocation
	pop	hl
	ld	a, d
	cp	colorScrnHeight - cardHeight
	ret	nc


;------ EraseBelowStack --------------------------------------------------------
EraseBelowStack:
; Erases the space below a stack.
; Input:
;  - L: Stack number
; Output:
;  - Green drawn
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	push	hl
	call	GetTopCardNumber
	pop	hl
	call	GetCardLocation
	ld	a, e
	cp	colorScrnHeight - cardBodyHeight
	ret	nc
	add	a, d
	ld	d, a
	ld	a, colorScrnHeight
	sub	d
	ld	e, a
	ld	b, 26
	ld	c, colorGreen
	jp	DrawFilledRect


;------ DrawStack --------------------------------------------------------------
DrawStack:
; Draws a complete stack.
; Input:
;  - A: Stack number
; Output:
;  - Stack drawn
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	push	ix
	ld	ix, 0
	add	ix, sp
	; Get location of stack from stack number
	add	a, a
	ld	hl, stacksTable
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	; Process stack header
	push	af	; ix - 1, ix - 2
	ld	a, (hl)
	and	stackCountM
	or	a
;	jr	z, _dsext	; Stack is empty, so nothing to draw
	jp	z, _dsempt	; Stack is empty, so nothing to draw
	ld	(ix - 2), a	; => Number of cards left to process
	ld	(ix - 1), 13	; => Height of each card
	; Show only top card if required
	ld	a, (hl)
	bit	stackShowOnlyTop, a
	jr	z, _dscd
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	b, (hl)
	ld	a, (ix - 2)
	add	a, 4
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	a, (hl)
	ex	de, hl
	ld	e, b
	ld	(ix - 2), 1
	jr	_dsla
_dscd:	; If there are a lot of cards, shrink each card
	bit	stackHideHidden, a
	jr	nz, _dsc
	and	stackCountM
	cp	19
	jr	c, _dsc
	cp	20
	call	nc, Panic
	dec	(ix - 1)
_dsc:	; Fetch location of stack
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	a, (hl)
	inc	hl
	ex	de, hl
	; Skip navigation vectors
	inc	de
	inc	de
	inc	de
	inc	de
	ld	c, e
	ld	b, d
	ld	e, a
_dsl:	; Card drawing loop
	ld	a, (bc)
	inc	bc
	bit	cardNotVisible, a
	jr	z, _dsla
	; Draw a hidden card
	ld	a, (ix - 2)
	cp	1
	jr	z, _dslc
	push	hl
	push	de
	push	bc
	call	DrawHiddenCardHeader
	pop	bc
	pop	de
	pop	hl
	ld	a, e
	add	a, 4
	ld	e, a
	jr	_dslb
_dsla:	; Draw a regular card
	and	3Fh
	ld	d, a
	push	hl
	push	de
	push	bc
	call	DrawCardHeader
	pop	bc
	pop	de
	pop	hl
	ld	a, e
	add	a, (ix - 1)
	ld	e, a
_dslb:	; Go down, do next card
	dec	(ix - 2)
	jr	nz, _dsl
	call	DrawCardBody
	
_dsext:	pop	af
	pop	ix
	ret

_dslc:	; Draw the card back instead
	ld	d, e
	call	Locate
	di
	ld	a, lrWinBottom
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, (lcdRow)
	add	a, 38
	out	(pLcdData), a
	ei	
	ld	a, chBackGraphic
	call	PutC
	jr	_dsext

_dsempt: ; Stack is empty; draw a placeholder box instead.
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	a, (hl)
	ex	de, hl
	ld	d, a
	ld	e, cardHeight
	ld	b, cardWidth
	ld	c, colorGreen
	call	DrawOutlinedFilledRect
	jr	_dsext


;------ DrawCardFull -----------------------------------------------------------
DrawCardFull:
; Draws both card header and body.
; Inputs:
;  - HL: Column
;  - E: Row
;  - D: Card
; Output:
;  - Card drawn
; Destroys:
;  - HL
;  - DE
;  - BC
;  - AF
	push	hl
	push	de
	call	DrawCardHeader
	pop	de
	pop	hl
	ld	a, e
	add	a, 13
	ld	e, a


;------ DrawCardBody -----------------------------------------------------------
DrawCardBody:
; Draws the body graphic and outline of a card, or at least draws some lines if
; the card can't fit on screen.
; Inputs:
;  - HL: Column
;  - E: Row
;  - D: Card
; Output:
;  - Graphic drawn
; Destroys:
;  - HL
;  - DE
;  - BC
;  - AF
	; You might complain that stack frames are slow, but I'm feeling lazy and
	; card games aren't exactly a high-performance task.
	; Check if card is drawable
;	ld	a, e
;	cp	240 - cardBodyHeight
;	ret	nc
	push	ix
	ld	ix, 0
	add	ix, sp
	push	hl	; ix - 1, ix - 2
	push	de	; ix - 3, ix - 4
	; Draw left line
	ld	d, e
	ld	b, cardBodyHeight - 1
	ld	a, (ix - 4)
	cp	colorScrnHeight - cardBodyHeight
	jr	c, {@}
	ld	a, colorScrnHeight
	sub	(ix - 4)
	ld	b, a
@:	ld	c, colorBlack
	call	DrawVertLine
	; Draw right line
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	ld	a, cardWidth - 1
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	d, (ix - 4)
	ld	b, cardBodyHeight - 1
	ld	a, (ix - 4)
	cp	colorScrnHeight - cardBodyHeight
	jr	c, {@}
	ld	a, colorScrnHeight
	sub	(ix - 4)
	ld	b, a
@:;	ld	c, colorBlack
	call	DrawVertLine
	; Draw bottom line
	ld	a, (ix - 4)
	add	a, cardBodyHeight - 1
	ld	d, a
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	ld	b, CardWidth
;	ld	c, colorBlack
	ld	a, (ix - 4)
	cp	colorScrnHeight - cardBodyHeight
	call	c, DrawHorizLine
	; Draw card graphic
	ld	a, (ix - 3)
	cp	36
	jr	nz, _dcbnotclubs
	; Ten of clubs gets a special graphic
	; NOTE: This can never be bottom-most card if the stack is super-deep
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	inc	hl
	ld	d, (ix - 4)
	call	Locate
	di
	ld	a, lrWinBottom
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	xor	a
	out	(pLcdData), a
	ld	a, (lcdRow)
	add	a, 24
	out	(pLcdData), a
	ei	
	ld	a, chClubsGraphic
	call	PutC
;	jr	_dcbdone
	jp	_dcbdone
_dcbnotclubs:
	; Background
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	inc	hl
	ld	d, (ix - 4)
	ld	e, cardBodyHeight - 1
	ld	bc, colorWhite + (256 * (cardWidth - 2))
	ld	a, (ix - 4)
	cp	colorScrnHeight - cardBodyHeight
	jr	c, {@}
	ld	a, colorScrnHeight
	sub	(ix - 4)
	ld	e, a
@:	;ld	a, (ix - 3)	; Only fill if not face card, which will draw BG as part of sprite
	;cp	rankJack	; No need to mask. . . 
	;call	c, DrawFilledRect
	call	DrawFilledRect
	; Symbols
	ld	a, (ix - 3)
	push	af
	and	3
	ld	b, colorRed
	cp	suitDiamond
	jr	z, _dbccolor
	cp	suitHeart
	jr	z, _dbccolor
	ld	b, colorBlack
_dbccolor:
	ld	a, b
	ld	(textForeColor), a
	pop	af
	srl	a
	and	7Eh
	cp	13 * 2
	call	nc, Panic
	;cp	TODO: Special graphics for face cards
;	cp	rankJack
;	jr	nc, _dcbface
	ld	hl, _dcbSuitsLocationsTable
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
_dcbsymloop:
	ld	a, (bc)
	inc	bc
	or	a
	jr	z, _dcbdone
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	d, (ix - 4)
	ld	a, (bc)
	inc	bc
	add	a, d
	ld	d, a
	add	a, 7
	jr	c, _dcbsymloop
	cp	colorScrnHeight
	jr	nc, _dcbsymloop
	ld	a, (ix - 3)
	and	3
	add	a, chSmallClub
	call	PutCSmall
	jr	_dcbsymloop
;_dcbface:
;	Remember when building sprite ptr table to subtract rankJack * 2 from equate
;	so you don't have to subtract
;	ld	a, (ix - 3)
;	add	a, a
;	ld	hl, faceCardsSpritesTable
;	add	a, l
;	jr	nc, $ + 3
;	inc	h
;	ld	l, a
;	ld	c, (hl)
;	inc	hl
;	ld	b, (hl)
;	ld	l, (ix - 2)
;	ld	h, (ix - 1)
;	ld	d, (ix - 4)
;	call	DrawFourColorSprite
_dcbdone:
	ld	a, colorBlack
	ld	(textForeColor), a
	pop	de
	pop	hl
	pop	ix
	ret

_dcbSuitsLocationsTable:
	.dw	_dcbRankA
	.dw	_dcbRank2
	.dw	_dcbRank3
	.dw	_dcbRank4
	.dw	_dcbRank5
	.dw	_dcbRank6
	.dw	_dcbRank7
	.dw	_dcbRank8
	.dw	_dcbRank9
	.dw	_dcbRank10
	.dw	_dcbRankA
	.dw	_dcbRankA
	.dw	_dcbRankA
_dcbRank9:
	.db	10, 1
	.db	10, 17
_dcbRank7:
	.db	2, 9
	.db	18, 9
_dcbRank5:
	.db	18, 1
	.db	2, 17
_dcbRank3:
	.db	2, 1
	.db	18, 17
_dcbRankA:
	.db	10, 9
	.db	0
_dcbRank2:
	.db	5, 9
	.db	15, 9
	.db	0
_dcbRank4:
	.db	5, 3
	.db	15, 14
	.db	5, 14
	.db	15, 3
	.db	0
_dcbRank6:
	.db	5, 1
	.db	15, 1
	.db	5, 9
	.db	15, 9
	.db	5, 17
	.db	15, 17
	.db	0
_dcbRank8:
	.db	2, 1
	.db	10, 3
	.db	18, 1
	.db	2, 9
	.db	18, 9
	.db	2, 17
	.db	10, 14
	.db	18, 17
	.db	0
_dcbRank10:
	.db	2, 1
	.db	14, 1
	.db	8, 5
	.db	20, 5
	.db	2, 9
	.db	14, 9
	.db	8, 13
	.db	20, 13
	.db	2, 17
	.db	14, 17
	.db	0


;------ DrawHiddenCardHeader ---------------------------------------------------
DrawHiddenCardHeader:
; Draws the header to a hidden card.
; Inputs:
;  - HL: Column
;  - E: Row
;  - D: You can put a card value here, but it won't be used.
; Output:
;  - Card drawn
; Destroys:
;  - HL
;  - DE
;  - BC
;  - AF
	push	ix
	ld	ix, 0
	add	ix, sp
	push	hl	; ix - 1, ix - 2
	push	de	; ix - 3, ix - 4
	; Draw top line
	ld	b, CardWidth
	ld	d, e
	ld	c, colorBlack
	call	DrawHorizLine
	; Draw left line
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	ld	d, (ix - 4)
	inc	d
	ld	b, 3
;	ld	c, colorBlack
	call	DrawVertLine
	; Draw right line
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	ld	a, cardWidth - 1
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	d, (ix - 4)
	inc	d
	ld	b, 3
;	ld	c, colorBlack
	call	DrawVertLine
	; Draw card text
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	inc	hl
	ld	d, (ix - 4)
	inc	d
	ld	e, 3
	ld	c, colorWhite
	ld	b, cardWidth - 2
	call	DrawFilledRect
	pop	de
	pop	hl
	pop	ix
	ret


;------ DrawCardHeader ---------------------------------------------------------
DrawCardHeader:
; Draws the header to a card.
; Inputs:
;  - HL: Column
;  - E: Row
;  - D: Card
; Output:
;  - Card drawn
; Destroys:
;  - HL
;  - DE
;  - BC
;  - AF
	push	ix
	ld	ix, 0
	add	ix, sp
	push	hl	; ix - 1, ix - 2
	push	de	; ix - 3, ix - 4
	; Draw top line
	ld	b, CardWidth
	ld	d, e
	ld	c, colorBlack
	call	DrawHorizLine
	; Draw left line
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	ld	d, (ix - 4)
	inc	d
	ld	b, cardHeaderHeight - 1
;	ld	c, colorBlack
	call	DrawVertLine
	; Draw right line
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	ld	a, cardWidth - 1
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	d, (ix - 4)
	inc	d
	ld	b, cardHeaderHeight - 1
;	ld	c, colorBlack
	call	DrawVertLine
	; Draw card text
	ld	l, (ix - 2)
	ld	h, (ix - 1)
	inc	hl
	ld	d, (ix - 4)
	inc	d
	call	Locate
	ld	a, (ix - 3)
	call	PrintCard
	pop	de
	pop	hl
	pop	ix
	ret


;------ PrintCard --------------------------------------------------------------
PrintCard:
; Displays a card's rank and suit, in color, and the current cursor location
; Inputs:
;  - A: Card number
;  - LCD cursor already set up
; Output:
;  - Card shown
; Destroys:
;  - AF
;  - BC
;  - HL
	ld	b, a
	ld	a, (textForeColor)
	push	af
	ld	a, colorBlack
	ld	(textForeColor), a
	ld	a, chThinSpace
	call	PutC
	ld	a, b
	srl	a
	srl	a
	ld	hl, _PrintCardRanks
	call	GetStrIndexed
	call	PutS
	ld	a, b
	and	3
	ld	c, colorBlack
	cp	suitClub
	jr	z, _dcb
	cp	suitSpade
	jr	z, _dcb
	ld	c, colorRed
_dcb:	ld	a, c
	ld	(textForeColor), a
	ld	a, b
	and	3
	add	a, chClub
	call	PutC
	pop	af
	ld	(textForeColor), a
	ret

_PrintCardRanks:
	.db	chThickSpace, "A", 0
	.db	chThickSpace, "2", 0
	.db	chThickSpace, "3", 0
	.db	chThickSpace, "4", 0
	.db	chThickSpace, "5", 0
	.db	chThickSpace, "6", 0
	.db	chThickSpace, "7", 0
	.db	chThickSpace, "8", 0
	.db	chThickSpace, "9", 0
	.db	"10", 0
	.db	chThickSpace, "J", 0
	.db	chThinSpace, chThinSpace, chThinSpace, chThinSpace, chThinSpace, chThinSpace, "Q", 0
	.db	chThickSpace, "K", 0


.endmodule
;------ RandomSeed -------------------------------------------------------------
RandomSeed:
; Randomizer
; This alters the random number seed based on the current seed,
; the R register, the I register, and the current RTC time.
; This is to prevent the same numbers from being generated every time
; after a RAM reset.
	di
	b_call(_maybe_Random)
	b_call(_OP1ToOP6)
	b_call(_GetAbsSeconds)
	b_call(_CkOP1FP0)
	jr	z, _s1
	b_call(_OP6ToOP2)
	b_call(_FPMult)
	jr	z, _s2
_s1:	b_call(_OP6ToOP1)
_s2:	ld	a, r
	ld	l, a
	ld	a, i
	ld	h, a
	or	l
	jr	z, _s3
	b_call(_SetXXXXOP2)
	b_call(_FPMult)
_s3:	ld	hl, OP1+1
	ld	ix, rngState
	call	_crazy
	ld	(ix), a
	call	_crazy
	ld	(ix + 1), a
	call	_crazy
	ld	(ix + 2), a
	call	_crazy
	ld	(ix + 3), a
	ei
	ret

_crazy:	ld	a, r
	ld	c, a
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	b, 8
_cloop:	rl	d
	rra
	djnz	_cloop
	xor	e
	add	a, c
	ret


.module	Cards
_rngStart:
;------ NextRandomInt ----------------------------------------------------------
NextRandomInt:
; Returns the next random int used by MS PRNG.
; Input:
;  - rngState
; Output:
;  - HL: Random number 0-32767
; Destroys:
;  - BC
;  - BC'
;  - DE
;  - DE'
; Preserves:
;  - A
;  - A'

; This optimized routine courtesy of Xeda112358
; 2131 t-states worst case, 60 bytes
; 1609 t-states best case
; avg= 1870
	xor	a
	ld	de, (rngState + 2)
	ld	h, a
	ld	l, a
	ld	bc, $FF40
	exx
	ld	b, 18
	ld	de, (rngState)
	ld	h, a
	ld	l, a
	ld	a, $D0
@:	add	hl, hl
	exx
	adc	hl, hl
	sla	c
	rl	b
	rla
	jr	nc, $ + 7
	exx
	add	hl, de
	exx
	adc	hl, de
	exx
	djnz	{-1@}
	ld	bc, 9EC3h
	add	hl, bc
	ld	(rngState), hl
	exx
	ld	bc, 26h
	adc	hl, bc
	res	7, h
	ld	(rngState + 2), hl
	ret

#ifdef	NEVER
; state_n+1 = 214013 * state_n + 2531011 (mod 2^31)
; Random number is state_n+1 >> 16
; HL = temp
; DE = accumulator
; BC = input * n
; Multiply constant is 214013
; Num.	0000 0000  0000 0011  0100 0011  1111 1101
; Bit	3322 2222  2222 1111  1111 11
; ''	1098 7654  3210 9876  5432 1098  7654 3210
; Factor                  16   1     52  1631 84 1
; ''	                  35   6     15  2426
; ''	                  15   3     26  8
; ''                      03   8
; ''	                  76   4
; ''	                  2
; Addition constant is 2531011 = 269EC3h
	; Fetch rngState into HL & HL'
	; Set up DE & BC
	ld	hl, (rngState + 2)
	ld	e, l
	ld	d, h
	ld	c, l
	ld	b, h
	exx
	ld	hl, (rngState)
	ld	e, l
	ld	d, h
	ld	c, l
	ld	b, h
	; Do multiply
	; The above code also did bit 0
	call	_Do0Bit
	call	_Do1Bit
	call	_Do1Bit
	call	_Do1Bit
	call	_Do1Bit
	call	_Do1Bit
	call	_Do1Bit
	call	_Do1Bit
	call	_Do1Bit
	call	_Do0Bit
	call	_Do0Bit
	call	_Do0Bit
	call	_Do0Bit
	call	_Do1Bit
	call	_Do0Bit
	call	_Do1Bit
	call	_Do1Bit
	; Remaining bits are zero and do not need explicit computation.
	; Now add 2531011
	ld	hl, 9EC3h
	add	hl, de
	ld	(rngState), hl
	exx
	ld	hl, 26h
	adc	hl, de
	res	7, h
	ld	(rngState + 2), hl
	ret

_Do0Bit:
	; Multiply BC by 2
	sla	c
	rl	b
	ld	l, c
	ld	h, b
	exx
	rl	c
	rl	b
	ld	l, c
	ld	h, b
	exx
;	ld	l, c
;	ld	h, b
;	add	hl, hl
;	ld	c, l
;	ld	b, h
;	exx
;	ld	l, c
;	ld	h, b
;	adc	hl, hl
;	ld	c, l
;	ld	b, h
;	exx
	ret

_Do1Bit:
	; Do BC = BC * 2
	call	_Do0Bit
	; Then DE = DE + BC (_Do0Bit leaves BC in HL)
	add	hl, de
	ld	e, l
	ld	d, h
	exx
	adc	hl, de
	ld	e, l
	ld	d, h
	exx
	ret
#endif
_rngEnd:
;.echo	"RNG Size: ", _rngEnd - _rngStart, "bytes\n"


;------ ------------------------------------------------------------------------
.endmodule