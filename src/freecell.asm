; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.

.module	FreeCell
; Sources:
;http://www.solitairelaboratory.com/mshuffle.txt
;http://www.solitairelaboratory.com/fcfaq.html
;http://rosettacode.org/wiki/Linear_congruential_generator
;http://rosettacode.org/wiki/Deal_cards_for_FreeCell


FreeCellRandomGame:
	di
	call	RandomSeed
	call	NextRandomInt
	im	2
	ei
	ld	a, l
	or	h
	jr	z, FreeCellRandomGame
	ld	de, 32001
	cpHlDe
	jr	nc, FreeCellRandomGame
	ld	de, (fcGameNumber)
	ld	(fcPreviousGame), de
	ld	(fcGameNumber), hl
	ret


StartFreeCell:
;------ Initialize new game ----------------------------------------------------
	im	2
	ld	hl, (fcGameNumber)
	ld	(rngState), hl
	ld	hl, 0
	ld	(rngState + 2), hl
	ld	(fcMoves), hl
; Erase data in stacks
	ld	hl, stacks
	ld	(hl), 255
	ld	de, stacks + 1
	ld	bc, 530
	ldir
; Load initial stacks
	ld	ix, _stacks
	call	InitalizeStacks
; for (i = 0; i < 52; i++)
; 	deck[i] = i;
; for (i = 0; i < 52; i++)
; {
; 	int q = rng.NextShort();
; 	j = q % cardsLeft;
; 	cards[(i % 8) + 1, i / 8] = deck[j];
; 	deck[j] = deck[--cardsLeft];
; }
; Create new deck
	ld	hl, deck + 51
	ld	b, 52
_ddl:	dec	b
	ld	(hl), b
	inc	b
	dec	hl
	djnz	_ddl
	ld	(hl), b
; Deal cards
	ld	a, 52
	ld	(guiTemp), a
	ld	(iy + asm_Flag3), 0
_dcl:
	; Random number		  q = rng.NextShort();
	call	NextRandomInt
	ld	a, (guiTemp)
	ld	c, a
	call	DivHLByC	; j = q % cardsLeft;
	; A = number
	push	af
	ld	a, (iy + asm_Flag3)
	and	7
	ld	l, a
	pop	af
	ld	ix, deck
	ld	d, 0
	ld	e, a
	add	ix, de		; deck[j]
	ld	a, (ix)
	call	PlaceCard	; cards[(i % 8) + 1, i / 8] = deck[j];
	ld	a, (guiTemp)
	dec	a
	ld	(guiTemp), a
	ld	hl, deck
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	ld	a, (hl)		; deck[--cardsLeft]
	ld	(ix), a
	inc	(iy + asm_Flag3)
	ld	a, (iy + asm_Flag3)
	cp	52
	jr	nz, _dcl
	; Undo
	ld	hl, 0
	ld	(undoNextSlot), hl


;------ Initalize game-play loop -----------------------------------------------
; Initialize cursor
	ld	a, 255
	ld	(selectedStack), a
	ld	l, 0
	call	GetTopCardNumber
	; L already equals zero
	ld	(currentDepth), a
	xor	a
	ld	(currentStack), a

FreeCellInitalizeScreen:
; Alter stacks to reflect chosen number of free cells
	ld	a, (fcFreeCells)
	; FC = 5
	ld	c, a
	cp	6
	jr	nc, {@}
	ld	a, 255
	ld	(freeCell5), a
	ld	a, homeCellNo1
	ld	(freeCell3 + 4), a
	ld	a, freeCellNo3
	ld	(homeCell1 + 7), a
	xor	a
	ld	(freeCell4 + 6), a
	; FC = 4
	ld	a, c
	cp	5
	jr	nc, {@}
	ld	a, 255
	ld	(freeCell4), a
	ld	a, homeCellNo0
	ld	(freeCell2 + 4), a
	ld	a, freeCellNo2
	ld	(homeCell0 + 7), a
	; FC = 3
	ld	a, c
	cp	4
	jr	nc, {@}
	ld	a, 255
	ld	(freeCell3), a
	ld	a, homeCellNo1
	ld	(freeCell1 + 4), a
	ld	a, freeCellNo1
	ld	(homeCell1 + 7), a
	xor	a
	ld	(freeCell2 + 6), a
	; FC = 2
	ld	a, c
	cp	3
	jr	nc, {@}
	ld	a, 255
	ld	(freeCell2), a
	ld	a, homeCellNo0
	ld	(freeCell0 + 4), a
	ld	a, freeCellNo0
	ld	(homeCell0 + 7), a
@:	im	2
; Initalize screen
	ld	d, colorGreen
;	ld	d, colorBlue
	call	FillScrnFull
	call	ResetScreen
	; Draw banner
	ld	hl, 9
	ld	de, 2 * 256 + 14
	ld	bc, 61 * 256 + colorWhite
	call	DrawOutlinedFilledRect
	ld	hl, 13
	ld	d, 3
	call	Locate
	ld	hl, freeCellBanner
	call	PutS
	; Draw Home box
	ld	hl, 4
	ld	d, 148
	ld	bc, 72 * 256 + colorBlack
	call	DrawHorizLine
	ld	hl, 4
	ld	d, 149
	ld	bc, 91 * 256 + colorBlack
	call	DrawVertLine
	ld	hl, 75
	ld	d, 149
	ld	bc, 91 * 256 + colorBlack
	call	DrawVertLine
	ld	hl, 22
	ld	de, 142 * 256 + 14
	ld	bc, 35 * 256 + colorWhite
	call	DrawOutlinedFilledRect
	ld	hl, 25
	ld	d, 143
	call	Locate
	ld	hl, freeCellHomeBanner
	call	PutS
	
	; Draw stacks
	ld	ix, _stacks
	call	DrawStacks

; Initialize UI callbacks
	ld	hl, _doSelection
	ld	(selectCardCallback), hl
	ld	hl, _doHomeCell
	ld	(selectCard2Callback), hl
	ld	hl, FreeCellInitalizeScreen
	ld	(f2Callback), hl
	ld	hl, 0
	ld	(f1Callback), hl
	ld	hl, _loadUndo
	ld	(f5Callback), hl
	ld	hl, 0
	ld	(cardTimerCallback), hl
	
; Stuff
	ld	a, (selectedGame)
	or	80h
	ld	(selectedGame), a
	ld	a, (flags + mKbdFlags)
	and	~kbdCurFlashM
	ld	(flags + mKbdFlags), a
	jp	CardsPlayLoop

FreeCellForfeit:
	ld	hl, (fcGamesQuit)
	inc	hl
	bit	7, h
	jr	nz, {@}
	ld	(fcGamesQuit), hl
@:	jp	MainMenu


;------ ------------------------------------------------------------------------
_doSelection:
	; Is there a currently selected stack?
	ld	a, (selectedStack)
	cp	255
	jr	nz, {@}
	; Nope. Select card if possible.
	ld	a, (currentStack)
	ld	l, a
	call	GetStackDepth
	call	nz, SelectCurrentCard
	jp	CardsPlayLoop
@:	; What is the type of the destination stack?
	ld	a, (currentStack)
	call	IsHomeCell
	jp	z, _moveToHomeCell
	call	IsFreeCell
	jp	z, _moveToFreeCell
	; We're moving to a main tableau stack
	ld	l, a
	call	GetTopCardNumber
	ld	b, a
	ld	a, (currentDepth)
	cp	b
	jp	nz, _ab1;_abortMove	; Cannot move to non-top card
	; Check source card
	ld	a, (selectedStack)
	ld	l, a
	call	GetTopCardNumber
	ld	b, a
	ld	a, (selectedDepth)
	cp	b
	jp	nz, _superMove
	ld	a, (currentStack)
	ld	l, a
	call	GetStackDepth
	jr	z, _acceptTablaeuMove
	; Check if cards can be stacked
	ld	a, (selectedStack)
	ld	l, a
	ld	a, (selectedDepth)
	call	GetCard
	ld	c, a
	ld	a, (currentStack)
	ld	l, a
	ld	a, (currentDepth)
	call	GetCard
	call	CompareColors
.ifndef	FREECELL_DEBUG
	jp	z, _ab3;_abortMove
.else
	nop \ nop \ nop
.endif
	and	rankMask
	ld	b, a	; B = current card (card to be placed)
	ld	a, c	; A = selected card (card below candidate)
	and	rankMask
	add	a, 4
	cp	b
.ifndef	FREECELL_DEBUG
	jp	nz, _ab4;_abortMove
.else
	nop \ nop \ nop
.endif
_acceptTablaeuMove:
;****** UNDO POINT *************************************************************
	call	_storeUndo
	ld	a, (selectedStack)
	push	af
	call	UnselectCard
	pop	af
	ld	l, a
	call	RemoveCardRedraw
	push	af
	call	UnselectCard
	pop	bc
	ld	a, (currentStack)
	ld	l, a
	ld	c, a
	ld	a, b
	call	PlaceCard
	ld	a, c
	call	DrawStackAndEraseBelowIfNecessary
	ld	a, (currentStack)
;	call	IsHomeCell
;	push	af
;	ld	ix, _atmcb
;	call	z, TryToMoveCardsToHomeCell
;	pop	af
	ld	l, a
	call	GetTopCardNumber
	ld	(currentDepth), a
	ld	hl, fcMoves
	inc	(hl)
	jp	nz, _checkWin
	inc	hl
	inc	(hl)
@:	jp	_checkWin
_atmcb:	; Update moves count
	ld	hl, fcMoves
	inc	(hl)
	ret	nz
	inc	hl
	inc	(hl)
	ret


;------ ------------------------------------------------------------------------
_moveToFreeCell:
	ld	a, (currentStack)
	ld	l, a
	call	GetStackDepth
	jp	nz, _abortMove
	ld	a, (selectedStack)
	ld	l, a
	call	GetTopCardNumber
	ld	b, a
	ld	a, (selectedDepth)
	cp	b
	jp	nz, _abortMove
	jr	_acceptTablaeuMove


;------ ------------------------------------------------------------------------
_moveToHomeCell:
	ld	a, (selectedStack)
	ld	l, a
	call	GetTopCardNumber
	ld	b, a
	ld	a, (selectedDepth)
	cp	b
	jp	nz, _abortMove
	ld	a, (currentStack)
	ld	l, a
	call	GetStackDepth
	jr	z, {@}
	ld	a, (currentStack)
	ld	l, a
	ld	a, (currentDepth)
	call	GetCard
	add	a, 4
	ld	b, a
	ld	a, (selectedStack)
	ld	l, a
	ld	a, (selectedDepth)
	call	GetCard
	cp	b
	jp	nz, _abortMove
	jp	_acceptTablaeuMove
@:	ld	a, (selectedStack)
	ld	l, a
	ld	a, (selectedDepth)
	call	GetCard
	and	rankMask
	jp	z, _acceptTablaeuMove
	jp	_abortMove
	

;------ Alpha Key Handler ------------------------------------------------------
_doHomeCell:
	; Is there a currently selected stack?
;	ld	a, (selectedStack)
;	cp	255
;	call	nz, UnselectCard
	call	UnselectCard
	; Check if currentDepth is topmost card
	ld	a, (currentStack)
	ld	l, a
	call	GetStackDepth
	jp	z, _ab1;_abortMove
	dec	a
	ld	b, a
	ld	a, (currentDepth)
	cp	b
	jp	nz, _ab2;_abortMove
	; Check if current card is ace
	ld	a, (currentStack)
	ld	l, a
	ld	a, b
	call	GetCard
	ld	b, a
	and	rankMask
;	jr	z, _moveAce
	ld	ix, {@}
	call	TryToMoveToHomeCell
;_moveCardsToHomecell:
;	ld	ix, {@}
	call	nc, TryToMoveCardsToHomeCell
	jp	_checkWin
@:	; Shuffle variables for undo save
	ld	hl, (currentDepth)
	ld	(selectedDepth), hl
	ld	a, e
	ld	(currentStack), a
	ld	l, e
	call	GetTopCardNumber
	ld	(currentDepth), a
	call	_storeUndo
	ld	hl, (selectedDepth)
	ld	(currentDepth), hl
	ld	a, 255
	ld	(selectedStack), a
	; Update moves count
	ld	hl, fcMoves
	inc	(hl)
	ret	nz
	inc	hl
	inc	(hl)
	ret
.ifdef	NEVER
_moveAce:
	; Current card is ace, move to first free homecell
	ld	e, homeCellNo0
	ld	l, e
	call	GetStackDepth
	jr	z, {@}
	inc	e
	ld	l, e
	call	GetStackDepth
	jr	z, {@}
	inc	e
	ld	l, e
	call	GetStackDepth
	jr	z, {@}
	inc	e
	ld	l, e
	call	GetStackDepth
	call	nz, Panic
@:	push	de
	call	SelectCurrentCard
	pop	de
	ld	a, e
	ld	(currentStack), a
	ld	l, e
	call	GetTopCardNumber
	ld	(currentDepth), a
	jp	_moveToHomeCell
.endif


;------ ------------------------------------------------------------------------
_superMove:
	; Do not allow supermove to or from home cells or free cells
	ld	a, (selectedStack)
	call	IsStackCell
	jp	nz, _er1
	ld	a, (currentStack)
	call	IsStackCell
	jp	nz, _er1
	; We already know the destination is the top, so don't check that.
	; Check if cards can be stacked
	ld	a, (selectedStack)
	ld	l, a
	ld	a, (selectedDepth)
	call	GetCard
	ld	c, a
	ld	a, (currentStack)
	ld	l, a
	ld	a, (currentDepth)
	call	GetCard
	call	CanBeStacked
.ifndef	FREECELL_DEBUG
	jp	nc, _er2
.else
	nop \ nop \ nop
.endif
;	call	CompareColors
;	.echo	"\n * SUPER MOVE ALLOWS ALL MOVES * \n\n"
;	jp	z, _er;_ab3;_abortMove
;	and	rankMask
;	ld	b, a	; B = current card (card to be placed)
;	ld	a, c	; A = selected card (card below candidate)
;	and	rankMask
;	add	a, 4
;	cp	b
;	jp	nz, _er;_ab4;_abortMove
	; Check if there are enough free cells
	ld	c, 0
	ld	a, (fcFreeCells)
	dec	a
	ld	b, a
@:	ld	a, b
	add	a, freeCellNo0
	ld	l, a
	call	GetStackDepth
	jr	nz, {@}
	inc	c
@:	djnz	{-2@}
	ld	l, freeCellNo0
	call	GetStackDepth
	jr	nz, {@}
	inc	c
@:	; Check each stack in tableau for emptyness
	ld	b, 7
@:	ld	l, b
	call	GetStackDepth
	jr	nz, {@}
	inc	c
@:	djnz	{-2@}
	ld	l, b
	call	GetStackDepth
	jr	nz, {@}
	inc	c
@:	; Compare number of free cells to number of cards to be moved
	ld	a, (selectedStack)
	ld	l, a
	call	GetStackDepth;GetTopCardNumber
	ld	hl, selectedDepth
	ld	l, (hl)
	sub	l
	call	z, Panic	; Cannot move zero cards. . . .
	inc	c	; 1 due to NC condition causing off-by-one
	inc	c	; 1 due to supermove being an n + 1 thing
	cp	c
	jp	nc, _er3
	; Now A = number of cards to move
	ld	b, a
	dec	b
	ld	(guiTemp), a	; Stash for later
	; Now check if stack to be moved is valid
	; This also takes care of the case where you try to move a stack onto itself
	ld	a, (selectedStack)
	ld	l, a
	ld	a, (selectedDepth)
	call	GetCard
@:	ld	a, (hl)
	inc	hl
	ld	c, (hl)
	call	CanBeStacked
.ifndef	FREECELL_DEBUG
	jp	nc, _er4
.else
	nop \ nop \ nop
.endif
	djnz	{-1@}
	; Graphical check
	ld	a, (selectedStack)
	push	af
	call	UnselectCard
	pop	af
	ld	(selectedStack), a
;****** UNDO POINT *************************************************************
	call	_storeUndo
_supermoveForceMove:
	; Fetch pointer to destination
	ld	a, (currentStack)
	ld	l, a
	push	hl
	call	GetStackDepth
	pop	hl
	push	af
	call	CheckCard
	pop	af
	jr	z, {@}
	inc	hl
@:	ex	de, hl
	; Fetch pointer to source
	ld	a, (selectedStack)
	ld	l, a
	ld	a, (selectedDepth)
	call	GetCard
	; Now copy cards
	ld	a, (guiTemp)
	ld	c, a
	ld	b, 0
	ldir
	; Update card count in destination
	ld	a, (guiTemp)
	ld	c, a
	ld	a, (currentStack)
	ld	l, a
	call	DerefStack
	ld	a, (hl)
	add	a, c
	call	c, Panic
	ld	(hl), a
	; Now, update card count in source
	ld	a, (selectedStack)
	ld	l, a
	call	DerefStack
	ld	a, (hl)
	ld	b, a
	sub	c
	call	c, Panic
	ld	(hl), a
	; Redraw source
	ld	a, (selectedStack)
	call	DrawStackAndEraseBelowIfNecessary
	; Redraw destination
	ld	a, (currentStack)
	call	DrawStackAndEraseBelowIfNecessary
	; Update move count
	ld	hl, fcMoves
	inc	(hl)
	jr	nz, {@}
	inc	hl
	inc	(hl)
@:	; Important
	ld	a, 255
	ld	(selectedStack), a
	jp	CardsPlayLoop


#ifdef	NEVER
;------ ------------------------------------------------------------------------
_getFreeCellCount:
; Returns the number of free cells.
; Inputs:
;  - None
; Output:
;  - C: Count
; Destroys:
;  - HL
;  - B
;  - A
	ld	c, 0
	ld	l, homeCellNo0
	call	GetStackDepth
	jr	nz, {@}
	inc	c
@:	ld	l, homeCellNo1
	call	GetStackDepth
	jr	nz, {@}
	inc	c
@:	ld	l, homeCellNo2
	call	GetStackDepth
	jr	nz, {@}
	inc	c
@:	ld	l, homeCellNo3
	call	GetStackDepth
	jr	nz, {@}
	inc	c
@:	ld	b, 7
@:	ld	l, b
	call	GetStackDepth
	jr	nz, {@}
	inc	c
@:	djnz	{-2@}
	ld	l, b
	call	GetStackDepth
	ret	nz
	inc	c
	ret
#endif


;------ Save Undo Stack Entry --------------------------------------------------
;fcMaxUndoSlots	.equ	255
; The undo struct indicates not how you got there, but how to go back.
; So the source entry in the undo struct is the destination is the current
; destination
; 0:	source
; 1:	card count
; 2:	destination
_storeUndo:
	push	af
	push	bc
	push	de
	push	hl
	; Store undo state
	ld	a, (undoNextSlot)
	ld	l, a
	ld	h, 0
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	ld	de, undoStack
	add	hl, de
	ld	a, (currentStack)
	ld	(hl), a
	inc	hl
	ex	de, hl
	ld	a, (selectedStack)
	ld	l, a
	call	GetTopCardNumber
	ld	hl, selectedDepth
	ld	b, (hl)
	ex	de, hl
	sub	b
;	inc	a	; Because selected card is included
	ld	(hl), a
	inc	hl
	ld	a, (selectedStack)
	ld	(hl), a
	; Update next slot counter
;	ld	a, (undoNextSlot)
;	inc	a
;	cp	fcMaxUndoSlots
;	jr	c, {@}
;	xor	a
;@:	ld	(undoNextSlot), a
	ld	hl, undoNextSlot
	inc	(hl)
	; Update number of actual undo entries present
	ld	a, (undosExtant)
;	cp	fcMaxUndoSlots
;	jr	nc, {@}
	inc	a
	jr	z, {@}
	ld	(undosExtant), a
@:	pop	hl
	pop	de
	pop	bc
	pop	af
	ret
	

;------ Load Undo State --------------------------------------------------------
_loadUndo:
	call	UnselectCard
	; Is undo possible?
	ld	a, (undosExtant)
	or	a
	jp	z, CardsPlayLoop
	; Fetch pointer to save slot
;	ld	a, (undoNextSlot)
;	sub	1
;	jr	nc, {@}
;	ld	a, fcMaxUndoSlots - 1
;@:	ld	(undoNextSlot), a
	ld	hl, undoNextSlot
	dec	(hl)
	ld	a, (hl)	; slower but smaller
	ld	h, 0
	ld	l, a
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	ld	de, undoStack
	add	hl, de
	; Fetch undo information
	ld	a, (hl)
	inc	hl
	ld	(selectedStack), a
	ex	de, hl
	ld	l, a
	call	GetTopCardNumber
	ex	de, hl
	ld	b, (hl)
	inc	hl
	sub	b
	ld	(selectedDepth), a
	ld	a, b
	inc	a
	ld	(guiTemp), a
	ld	a, (hl)
	ld	(currentStack), a
	ld	l, a
	call	GetTopCardNumber
	ld	(currentDepth), a
	; Update number of existing undos
	ld	hl, undosExtant
	dec	(hl)
	jp	_supermoveForceMove


;------ Check for Win Condition ------------------------------------------------
_checkWin:
	ld	l, homeCellNo0
	call	GetStackDepth
	cp	13
	jp	c, CardsPlayLoop
	ld	l, homeCellNo1
	call	GetStackDepth
	cp	13
	jp	c, CardsPlayLoop
	ld	l, homeCellNo2
	call	GetStackDepth
	cp	13
	jp	c, CardsPlayLoop
	ld	l, homeCellNo3
	call	GetStackDepth
	cp	13
	jp	c, CardsPlayLoop
	ld	a, (selectedGame)
	and	3
	ld	(selectedGame), a
	ld	hl, (kdGamesWon)
	inc	hl
	bit	7, h
	jr	nz, {@}
	ld	(fcGamesWon), hl
@:	ld	ix, freeCellWinDialog
	jp	ShowModalDialog
freeCellWinDrawback:
	ld	ix, {@}
	call	ShowNumbers
	jp	FreeCellRandomGame
@:	.db	2
	.dw	96
	.db	68
	.dw	fcGameNumber
	.dw	96
	.db	80
	.dw	fcMoves


;------ Illegal Move Handler ---------------------------------------------------
_er1:
_er2:
_er3:
_er4:
_ab4:
;	ld	a, 4
;	jr	_abort
_ab3:
;	ld	a, 3
;	jr	_abort
_ab2:
;	ld	a, 2
;	jr	_abort
_ab1:
;	ld	a, 1
;	jr	_abort
_abort:
;	ld	hl, 0
;	ld	d, 0
;	call	Locate
;	call	DispByte
_abortMove:
	call	UnselectCard
	jp	CardsPlayLoop


;------ ------------------------------------------------------------------------
;====== Data ===================================================================
freeCellBanner:
	.db	"FREECELL", 0
freeCellHomeBanner:
	.db	"Home", 0
_stacks:
	.db	18
	.db	0
	.dw	fcs0
	.db	1
	.dw	fcs1
	.db	2
	.dw	fcs2
	.db	3
	.dw	fcs3
	.db	4
	.dw	fcs4
	.db	5
	.dw	fcs5
	.db	6
	.dw	fcs6
	.db	7
	.dw	fcs7
	.db	freeCellNo0
	.dw	fcfc0
	.db	freeCellNo1
	.dw	fcfc1
	.db	freeCellNo2
	.dw	fcfc2
	.db	freeCellNo3
	.dw	fcfc3
	.db	freeCellNo4
	.dw	fcfc4
	.db	freeCellNo5
	.dw	fcfc5
	.db	homeCellNo0
	.dw	fchc0
	.db	homeCellNo1
	.dw	fchc1
	.db	homeCellNo2
	.dw	fchc2
	.db	homeCellNo3
	.dw	fchc3
fcs0:	; Stack 0
;	.db	stackHideHiddenM	; Stack depth + flags
	.db	0			; Stack depth + flags
	.dw	80			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	freeCellNo1			; Stack left
	.db	1			; Stack right
	.db	255			; Stack above
fcs1:	; Stack 1
;	.db	stackHideHiddenM	; Stack depth + flags
	.db	0			; Stack depth + flags
	.dw	110			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	0			; Stack left
	.db	2			; Stack right
	.db	255			; Stack above
fcs2:	; Stack 2
;	.db	stackHideHiddenM	; Stack depth + flags
	.db	0			; Stack depth + flags
	.dw	140			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	1			; Stack left
	.db	3			; Stack right
	.db	255			; Stack above
fcs3:	; Stack 3
;	.db	stackHideHiddenM	; Stack depth + flags
	.db	0			; Stack depth + flags
	.dw	170			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	2			; Stack left
	.db	4			; Stack right
	.db	255			; Stack above
fcs4:	; Stack 4
;	.db	stackHideHiddenM	; Stack depth + flags
	.db	0			; Stack depth + flags
	.dw	200			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	3			; Stack left
	.db	5			; Stack right
	.db	255			; Stack above
fcs5:	; Stack 5
;	.db	stackHideHiddenM	; Stack depth + flags
	.db	0			; Stack depth + flags
	.dw	230			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	4			; Stack left
	.db	6			; Stack right
	.db	255			; Stack above
fcs6:	; Stack 6
;	.db	stackHideHiddenM	; Stack depth + flags
	.db	0			; Stack depth + flags
	.dw	260			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	5			; Stack left
	.db	7			; Stack right
	.db	255			; Stack above
fcs7:	; Stack 7
;	.db	stackHideHiddenM	; Stack depth + flags
	.db	0			; Stack depth + flags
	.dw	290			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	6			; Stack left
	.db	freeCellNo0		; Stack right
	.db	255			; Stack above

fcfc0:	; Free cell 0
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	9			; Column
	.db	17			; Row
	.db	freeCellNo2		; Stack below
	.db	7			; Stack left
	.db	freeCellNo1		; Stack right
	.db	homeCellNo2		; Stack above
fcfc1:	; Free cell 1
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	44			; Column
	.db	17			; Row
	.db	freeCellNo3		; Stack below
	.db	freeCellNo0		; Stack left
	.db	0			; Stack right
	.db	homeCellNo3		; Stack above
fcfc2:	; Free cell 2
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	9			; Column
	.db	59			; Row
	.db	freeCellNo4		; Stack below
	.db	7			; Stack left
	.db	freeCellNo3		; Stack right
	.db	freeCellNo0		; Stack above
fcfc3:	; Free cell 3
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	44			; Column
	.db	59			; Row
	.db	freeCellNo5		; Stack below
	.db	freeCellNo2		; Stack left
	.db	0			; Stack right
	.db	freeCellNo1		; Stack above
fcfc4:	; Free cell 4
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	9			; Column
	.db	101			; Row
	.db	homeCellNo0		; Stack below
	.db	7			; Stack left
	.db	freeCellNo5		; Stack right
	.db	freeCellNo2		; Stack above
fcfc5:	; Free cell 5
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	44			; Column
	.db	101			; Row
	.db	homeCellNo1		; Stack below
	.db	freeCellNo4		; Stack left
	.db	0			; Stack right
	.db	freeCellNo3		; Stack above

fchc0:	; Home cell 0
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	9			; Column
	.db	157			; Row
	.db	homeCellNo2		; Stack below
	.db	7			; Stack left
	.db	homeCellNo1		; Stack right
	.db	freeCellNo4		; Stack above
fchc1:	; Home cell 1
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	44			; Column
	.db	157			; Row
	.db	homeCellNo3		; Stack below
	.db	homeCellNo0		; Stack left
	.db	0			; Stack right
	.db	freeCellNo5		; Stack above
fchc2:	; Home cell 2
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	9			; Column
	.db	199			; Row
	.db	freeCellNo0		; Stack below
	.db	7			; Stack left
	.db	homeCellNo3		; Stack right
	.db	homeCellNo0		; Stack above
fchc3:	; Home cell 3
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	44			; Column
	.db	199			; Row
	.db	freeCellNo1		; Stack below
	.db	homeCellNo2		; Stack left
	.db	0			; Stack right
	.db	homeCellNo1		; Stack above


.endmodule