; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.


.module	Klondike
;====== Klondike ===============================================================


;------ StartGame --------------------------------------------------------------
StartKlondike:

;	ld	hl, rngState
;	ld	(hl), 1
;	inc	hl
;	ld	(hl), 0
;	inc	hl
;	ld	(hl), 0
;	inc	hl
;	ld	(hl), 0
	

;------ Initialize new game ----------------------------------------------------
	call	RandomSeed
	im	2
; Erase data in stacks
	ld	hl, stacks
	ld	(hl), 255
	ld	de, stacks + 1
	ld	bc, 530
	ldir
; Load initial stacks
	ld	ix, _stacks
	call	InitalizeStacks
	ld	a, cardNotVisibleM + notACard
	ld	(deckCell + 8), a
; Create new deck
	ld	hl, deck + 51
	ld	b, 52
_ddl:	dec	b
	ld	(hl), b
	inc	b
	dec	hl
	djnz	_ddl
	ld	(hl), b
; Shuffle deck
	ld	(iy + asm_Flag3), 52
_ddl2:	call	NextRandomInt
	ld	c, 52
	call	DivHLByC
	ld	hl, deck
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	push	hl
	call	NextRandomInt
	ld	c, 52
	call	DivHLByC
	ld	hl, deck
	add	a, l
	jr	nc, $ + 3
	inc	h
	ld	l, a
	pop	de
	ld	a, (de)
	ld	b, (hl)
	ex	de, hl
	ld	(hl), b
	ld	(de), a
	dec	(iy + asm_Flag3)
	jr	nz, _ddl2
; Deal cards
	ld	l, 7
	ld	ix, deck + 51
	ld	e, 52
_ddl3:	ld	b, l
_ddl4:	ld	a, (ix)
	ld	(ix), 255;notACard
	dec	ix
	or	cardNotVisibleM
	push	hl
	dec	l
	call	PlaceCard
	pop	hl
	djnz	_ddl4
	dec	l
	jr	nz, _ddl3
	; Initialize deck drawing information
	ld	hl, deck
	ld	(kdDeckLoc), hl
	ld	a, 10h
	ld	(kdDeckMode), a
; Show top card on each stack
	ld	b, 7
_ddl5:	ld	l, b
	dec	l
	call	CheckCard
	and	~cardNotVisibleM
	ld	(hl), a
	djnz	_ddl5
; Stats
	ld	hl, 0
	ld	(kdTime), hl
	ld	a, (kdScoringMode)
	or	a
	jr	z, _kdInitScoreNormal
	ld	hl, (kdScore)
	cp	3
	jr	z, {@}
	ld	hl, 0
@:	ld	de, -52
	add	hl, de
	ld	(kdScore), hl
	jr	{@}
_kdInitScoreNormal:
	ld	hl, 0
	ld	(kdScore), hl
@:	; Undo
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
	
KlondikeInitalizeScreen:
	im	2
; Initalize screen
	ld	d, colorGreen
;	ld	d, colorBlue
	call	FillScrnFull
	call	ResetScreen
; Draw text box
	ld	hl, 2
	ld	de, 2 * 256 + 41
	ld	bc, 104 * 256 + colorWhite
	call	DrawOutlinedFilledRect
	ld	hl, 5
	ld	d, 16
	ld	bc, 98 * 256 + colorBlack
	call	DrawHorizLine
	ld	hl, 27
	ld	d, 4
	call	Locate
	ld	hl, klondikeBanner
	call	PutS
	ld	hl, 5
	ld	d, 18
	call	Locate
	ld	hl, kdScoreText
	call	PutS
	ld	hl, 10
	ld	d, 227
	ld	bc, 35 * 256 + colorBlack
	call	DrawHorizLine
;	ld	hl, 11
;	ld	d, 228
;	ld	bc, 33 * 256 + colorBlack
;	call	DrawHorizLine
	ld	hl, 10
	ld	d, 228
	ld	bc, 12 * 256 + colorBlack
	call	DrawVertLine
	ld	hl, 44
	ld	d, 228
	ld	bc, 12 * 256 + colorBlack
	call	DrawVertLine
	ld	hl, 11
	ld	d, 228
	call	Locate
	ld	hl, kdDraw
	call	PutS
	ld	a, (kdTimed)
	or	a
	jr	z, _skda
	ld	hl, 5
	ld	d, 30
	call	Locate
	ld	hl, kdTimeText
	call	PutS
	
_redrawAllStacks:
_skda:	; Draw stacks
	ld	ix, _stacks
	call	DrawStacks
;	ld	a, deckCellNo
;	call	DrawStack
	
	
; Initialize UI callbacks
	ld	hl, _kdDoSelection
	ld	(selectCardCallback), hl
	ld	hl, _kdMoveCardToHomecell
	ld	(selectCard2Callback), hl
	ld	hl, KlondikeInitalizeScreen
	ld	(f2Callback), hl
	ld	hl, _kdDrawCards
	ld	(f1Callback), hl
	ld	hl, _loadUndo
	ld	(f5Callback), hl
	ld	hl, _kdTimerCallback
	ld	(cardTimerCallback), hl
	
; Stuff
	ld	hl, cursorPeriod
	ld	(cursorTimer), hl
	ld	a, (selectedGame)
	or	80h
	ld	(selectedGame), a
	ld	a, (flags + mKbdFlags)
	and	~kbdCurFlashM
	ld	(flags + mKbdFlags), a
	call	_kdInvalidateStats
	jp	CardsPlayLoop


; Forfeit handler
KlondikeForfeit:
	ld	hl, (kdGamesQuit)
	inc	hl
	bit	7, h
	jr	nz, {@}	; Saves one byte
	ld	(kdGamesQuit), hl
@:	jp	MainMenu


;------ Timer & Scoring Stuff --------------------------------------------------
_kdTimerCallback:
	; Check timer
	ld	a, (flags + mKbdFlags)
	bit	kbdCurFlash, a
	jr	z, {@}
	and	~kbdCurFlashM
	ld	(flags + mKbdFlags), a
	ld	hl, (kdTime)
	inc	hl
	ld	(kdTime), hl
	ld	a, (kdTimed)
	or	a
	jr	z, {@}
	call	_kdInvalidateStats
	ld	a, (kdScoringMode)
	or	a
	jr	nz, {@}
	ld	c, 20
	call	DivHLByC
	or	a
	jr	nz, {@}
	ld	hl, (kdScore)
	dec	hl
	dec	hl
	bit	7, h
	jr	z, $ + 2 + 3
	ld	hl, 0
	ld	(kdScore), hl
@:	; Update stats if necessary
	ld	a, (kdDirtyStats)
	or	a
	ret	z
	xor	a
	ld	(kdDirtyStats), a
	ld	hl, 45
	ld	d, 18
	call	Locate
	ld	hl, (kdScore)
	call	DispDecimal
	ld	a, chThickSpace
	call	PutC
	call	PutC
	ld	a, (kdTimed)
	or	a
	ret	z
	ld	hl, 36
	ld	d, 30
	call	Locate
_showTime:	; Do not add code after this; the win screen will break
	ld	hl, (kdTime)
	srl	h
	rr	l
	ld	c, 60
	call	DivHLByC
	push	af
	call	DispDecimal
	ld	a, ':'
	call	PutC
	pop	af
	ld	h, 0
	ld	l, a
	cp	10
	jr	nc, {@}
	ld	a, '0'
	call	PutC
@:	call	DispDecimal
	ret


_kdInvalidateStats:
	push	af
	ld	a, 1
	ld	(kdDirtyStats), a
	pop	af
	ret


;====== Klondike Movement Logic ================================================
_kdDoSelection:
	; Check if user is trying to draw another card from deck
	ld	a, (currentStack)
	cp	deckCellNo
	jp	z, _kdDrawCards
	; Check if card needs to be flipped
	ld	a, (currentStack)
	ld	l, a
	push	hl
	call	GetStackDepth
	pop	hl
	jr	z, {@}
	ld	a, (currentDepth)
	call	GetCard
	and	cardNotVisibleM
	jr	z, {@}
	or	a
	jp	nz, _kdFlipHiddenCard
@:	; Check if user has already selected a stack
	ld	a, (selectedStack)
	cp	255
	jr	nz, _kdValidateMove
	; Check if user is trying to select an empty stack
	ld	a, (currentStack)
	ld	l, a
	call	GetStackDepth
	jp	z, CardsPlayLoop
	call	SelectCurrentCard
	jp	CardsPlayLoop
	
_kdValidateMove:
	; Check if user is trying to draw another card from deck
;	ld	a, (currentStack)
;	cp	deckCellNo
;	jp	z, _kdDrawCards
	; Check if user is trying to move card into deal cells
	ld	a, (currentStack)
	cp	dealCellNo
	jp	z, _kdAbortMove
	; Check if user is trying to move to a homecell
	ld	a, (currentStack)
	call	IsHomeCell
	jp	z, _kdMoveToHomeCell
	; User wants to move to tableau stack.
	; Is destination empty?
	ld	a, (currentStack)
	ld	l, a
	call	GetStackDepth
	jp	z, _kdMoveToEmpty
	dec	a
	ld	b, a
	; Check if destination is topmost
	ld	a, (currentDepth)
	cp	b
	jp	nz, _kdAbortMove
	; Compare source and destination
	ld	a, (selectedStack)
	ld	l, a
	ld	a, (selectedDepth)
	call	GetCard
	ld	c, a
	ld	a, (currentStack)
	ld	l, a
	ld	a, (currentDepth)
	call	GetCard
	call	CompareRanks
	jp	nz, _kdAbortMove
	call	CompareColors
	jp	z, _kdAbortMove
	jr	_kdMoveStack
_kdMoveToEmpty:
	; Check if source card is king
	ld	a, (selectedStack)
	ld	l, a
	ld	a, (selectedDepth)
	call	GetCard
	and	rankMask
	cp	rankK
	jp	nz, _kdAbortMove


;------ Move a Whole Stack of Cards --------------------------------------------
_kdMoveStack:
;****** UNDO POINT *************************************************************
	call	_storeUndo
	; Save source card data & unselect source card
	ld	a, (selectedStack)
	push	af
	call	UnselectCard
	pop	af
	ld	(selectedStack), a
	; Fetch pointer to source cards
	ld	l, a
	ld	a, (selectedDepth)
	push	hl
	call	GetCard
;	ld	(guiTemp), hl
	ex	de, hl
	pop	hl
	; Compute number of cards to move
	push	hl
	call	GetStackDepth
	pop	hl
	ld	b, a
	ld	a, (selectedDepth)
	sub	b
	neg
	call	z, Panic			; LDIR zero cards equals very bad
	ld	c, a
	; Update card count in source
	call	DerefStack
	ld	a, (hl)
	sub	c
	ld	(hl), a
	; Fetch pointer to destination
	ld	a, (currentStack)
	ld	l, a
	push	hl
	call	GetStackDepth
	pop	hl
	push	hl
	push	af
	call	CheckCard
	pop	af
	jr	z, {@}
	inc	hl
@:	; Update card count in destination
	ex	(sp), hl
	call	DerefStack
	ld	a, (hl)
	add	a, c
	ld	(hl), a
	pop	hl
	; ldir cards
	ex	de, hl
	ld	b, 0
	ldir
	; Redraw source
	ld	a, (selectedStack)
	call	DrawStackAndEraseBelowIfNecessary
	; Redraw destination
	ld	a, (currentStack)
	call	DrawStackAndEraseBelowIfNecessary
	; Delete last select card selection data
;	ld	a, (selectedStack)
;	cp	dealCellNo
	; Update score
	ld	hl, (kdScore)
	ld	a, (kdScoringMode)
	or	a
	jr	z, _kdMoveScoreNormal
	ld	a, (selectedStack)
	call	IsHomeCell
	jr	nz, _kdMoveScoreDone
	call	_kdInvalidateStats
	ld	de, -5
	add	hl, de
	jr	_kdMoveScoreDone
_kdMoveScoreNormal:
	ld	a, (selectedStack)
	cp	8
	jr	c, _kdMoveScoreDone
	call	_kdInvalidateStats
	ld	de, 5
	add	hl, de
	cp	dealCellNo
	jr	z, _kdMoveScoreDone
	call	IsHomeCell
	call	nz, Panic
	ld	de, -20
	add	hl, de
	bit	7, h
	jr	z, _kdMoveScoreDone
	ld	hl, 0
_kdMoveScoreDone:
	ld	(kdScore), hl
	; If deal cell is now empty, put a card there, iff possible.
	call	_kdCheckCardBelow
	ld	a, 255
	ld	(selectedStack), a
	; Move cursor to topmost card
	ld	a, (currentStack)
	ld	l, a
	call	GetTopCardNumber
	ld	(currentDepth), a
	; Blah
;	ld	hl, (guiTemp)
	jp	CardsPlayLoop	;_kdCheckWin


;------ Check if Card from Deck Should be Revealed -----------------------------
_kdCheckCardBelow:
;	ld	hl, 0
;	ld	d, 100
;	call	Locate
;	ld	a, r
;	call	DispByte
	call	_kdCheckDeckEmpty
;	ret	nz
	ld	a, (kdDeckMode)
	or	a
	ret	z
	ld	l, dealCellNo
	call	GetStackDepth
	ret	nz
	ld	hl, (kdDeckLoc)
;	ld	a, l
;	cp	deck & 255
;	ret	z
@:	dec	hl
	ld	a, l
	cp	(deck - 1) & 255
	ret	z
	ld	a, h
	cp	80h
	call	c, Panic
	ld	a, (hl)
	cp	255
	ret	z
	cp	notACard
	jr	z, {-1@}
	ld	(hl), notACard
	ld	(kdDeckLoc), hl
	ld	l, dealCellNo
	call	PlaceCard
;****** UNDO POINT *************************************************************
	ld	a, dealCellNo
	jp	DrawStackAndEraseBelowIfNecessary


;------ Illegal Move Handler ---------------------------------------------------
_kdAbortMove:
	; Case not handled.
	call	UnselectCard
	jp	CardsPlayLoop
	
	
;------ Move Ace to Homecell ---------------------------------------------------
;_kdMoveToHomeCell:
;	ld	a, (selectedStack)
;	ld	(currentStack), a
;	ld	a, (selectedDepth)
;	ld	(currentDepth), a
;	call	UnselectCard
_kdMoveCardToHomecell:
	call	UnselectCard
	xor	a
	ld	(guiTemp), a
	; Check if user is trying to draw another card from deck
	ld	a, (currentStack)
	cp	deckCellNo
	jp	z, CardsPlayLoop
;	ld	l, a
;	call	CheckCard
;	and	cardFlagsMask
;	jp	nz, _kdDoSelection
	ld	ix, _homecellStatsUpdate
	call	TryToMoveToHomeCell
;_moveCardsToHomecell:
;	ld	ix, _homecellStatsUpdate
	call	nc, TryToMoveCardsToHomeCell
	call	_kdCheckCardBelow
	jp	_kdCheckWin
_homecellStatsUpdate:
	; Store undo if necessary
	ld	a, (guiTemp)
	or	a
;****** UNDO POINT *************************************************************
	call	z, _storeUndo
	inc	a	; This can't be called more than 50-ish times, so no overflow
	ld	(guiTemp), a
	; Update score
	ld	hl, (kdScore)
	ld	a, (currentStack)
	call	IsHomeCell
	jr	z, {@}
	ld	a, (kdScoringMode)
	ld	de, 5	; Notice how this adds 5 or 10 depending on scoring mode
	add	hl, de
	or	a
	jr	nz, {@}
	add	hl, de
@:	ld	(kdScore), hl
	jp	_kdInvalidateStats


;------ Move Ace to Homecell ---------------------------------------------------
_kdMoveToHomeCell:
	xor	a
	ld	(guiTemp), a
	; Check if card selected is top card
	ld	a, (selectedStack)
	ld	l, a
	call	GetTopCardNumber
	ld	b, a
	ld	a, (selectedDepth)
	cp	b
	jp	nz, _kdAbortMove
	; Check if destination cell is empty
	ld	a, (currentStack)
	ld	l, a
	call	GetStackDepth
	jr	nz, _kdmhcne
	; Stack is empty, so check if source is ace
	ld	a, (selectedStack)
	ld	l, a
	ld	a, (selectedDepth)
	call	GetCard
	and	rankMask
	jp	nz, _kdAbortMove
	; Accept move
	jp	_kdMoveCard
_kdmhcne: ; Stack is not empty; check card below
;	ld	a, (selectedStack)
;	ld	l, a
;	call	CheckCard
;	ld	b, a
	ld	a, (selectedStack) ; Is card ace?
	ld	l, a
	call	CheckCard
	and	rankMask
	jp	z, _kdAbortMove
;	; Check if right card
;	add	a, 4
;	cp	b
;	jp	nz, _kdAbortMove
;	ld	a, (selectedStack)
;	ld	l, a
	ld	a, (selectedStack)
	ld	(currentStack), a
	ld	a, (selectedDepth)
	ld	(currentDepth), a
	call	UnselectCard
	ld	ix, _homecellStatsUpdate
	call	TryToMoveToHomeCell
	call	_kdCheckCardBelow
	jp	_kdCheckWin
_kdMoveCard:
;****** UNDO POINT *************************************************************
	call	_storeUndo
	; Update score
	ld	hl, (kdScore)
	ld	a, (selectedStack)
	call	IsHomeCell
	jr	z, {@}
	ld	a, (kdScoringMode)
	ld	de, 5
	add	hl, de
	or	a
	jr	nz, {@}
	add	hl, de
@:	ld	(kdScore), hl
	call	_kdInvalidateStats
	; Move
	ld	a, (selectedStack)
	push	af
	call	UnselectCard	; Doesn't affect selectedDepth
	pop	af
	ld	l, a
	ld	a, (selectedDepth)
	call	RemoveCardRedraw
	ld	hl, currentStack
	ld	l, (hl)
	call	PlaceCard
	ld	a, (currentStack)
	call	DrawStackAndEraseBelowIfNecessary
	call	_kdCheckCardBelow
	ld	a, (currentStack)
	ld	l, a
	call	GetTopCardNumber
	ld	(currentDepth), a
	call	_kdCheckCardBelow
	jp	_kdCheckWin
;	jp	_moveCardsToHomecell;_kdCheckWin


.ifdef	NEVER
;------ Alpha-key Handler ------------------------------------------------------
_kdMoveCardToHomecell:
;	call	UnselectCard
	; Check if user is trying to draw another card from deck
	ld	a, (currentStack)
	cp	deckCellNo
	jp	z, CardsPlayLoop
	; Check if currentDepth is topmost card
	ld	a, (currentStack)
	ld	l, a
	call	GetStackDepth
	jp	z, _kdAbortMove;	call	z, abort;	jp	z, _kdAbortMove
	dec	a
	ld	b, a
	ld	a, (currentDepth)
	cp	b
	jp	nz, _kdAbortMove;	call	nz, abort;	jp	nz, _kdAbortMove
	; Check if current card is ace
	ld	a, (currentStack)
	ld	l, a
	ld	a, b
	call	GetCard
	bit	cardNotVisible, a
	jp	nz, _kdDoSelection
	ld	b, a
	and	rankMask
	jr	z, _kdMoveAce
	; Current card is not ace, so scan each homecell's top card to see if
	; its number plus four equals the current card's number
	dec	b
	dec	b
	dec	b
	dec	b
	ld	e, homeCellNo0
	ld	l, e
	call	CheckCard
	cp	b
	jr	z, {@}
	inc	e
	ld	l, e
	call	CheckCard
	cp	b
	jr	z, {@}
	inc	e
	ld	l, e
	call	CheckCard
	cp	b
	jr	z, {@}
	inc	e
	ld	l, e
	call	CheckCard
	cp	b
	jp	nz, _kdAbortMove;	call	nz, abort;	jp	nz, _kdAbortMove
@:	push	de
	call	SelectCurrentCard
	pop	de
	ld	a, e
	ld	(currentStack), a
	ld	l, e
	call	GetTopCardNumber
	ld	(currentDepth), a
	jp	_kdMoveToHomeCell
_kdMoveAce:
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
	jp	_kdMoveToHomeCell
.endif
	

;------ Handle Hidden Card -----------------------------------------------------
_kdFlipHiddenCard:
;****** UNDO POINT *************************************************************
	call	_storeUndo
	ld	a, (currentStack)
	ld	l, a
	ld	a, (currentDepth)
	call	GetCard
	res	cardNotVisible, (hl)
	ld	a, (currentStack)
	call	DrawStack
	; Update score
	ld	a, (kdScoringMode)
	or	a
	jp	nz, CardsPlayLoop
	ld	hl, (kdScore)
	ld	de, 5
	add	hl, de
	ld	(kdScore), hl
	call	_kdInvalidateStats
	jp	CardsPlayLoop
	
	
;------ Draw Cards -------------------------------------------------------------
_kdDrawCards:
; Stage 0: No drawn cards on tableau
; Stage 1: Cards drawn on tableau
; Stage 2: Cards drawn on tableau, but no more cards can be drawn
; So, stage 0, then stage 1 or 2, then stage 2
; Stage 0: kdDeckLoc points to deck and kdDeckLocNext points to deck,
;          signaling no cards to be placed into deck
; Stage 1: kdDeckLoc and kdDeckLoc different, signaling cards to be replaced to deck
; Stage 2: kdDeckLocNext points to an FF byte, signaling no more cards in deck
; In stage 0, skip replacing dealt cards, since there are none
;    If stage 0 cannot find any cards to deal, then 
; In stage 1, replace dealt cards, then draw new ones if possible,
;    possibly signaling advance to stage 2
; In stage 2, replace remaining cards, and signal advance to stage 0
;	ld	hl, 0
;	ld	d, 12
;	call	Locate
;	ld	hl, (kdDeckLoc)
;	call	DispHL
;	ld	a, ' '
;	call	PutC
;	ld	a, (kdDeckMode)
;	call	DispByte
	ld	a, (kdDeckMode)
	cp	3
	jp	z, CardsPlayLoop
;****** UNDO POINT *************************************************************
	call	_storeUndo
	cp	10h
	jr	z, {@}
	or	a
	jr	nz, {@}
	ld	hl, (kdScore)
	ld	de, -100
	add	hl, de
	bit	7, h
	jr	z, $ + 2 + 3
	ld	hl, 0
	ld	(kdScore), hl
	call	_kdInvalidateStats
@:	and	0Fh
	ld	(kdDeckMode), a
	; Check if a card in the deal stack is selected
	ld	a, (selectedStack)
	cp	dealCellNo
	jr	nz, {@}
	call	UnselectCard
@:	ld	a, (kdDeckMode)
	or	a
	jr	z, _kdDoDrawCards
	; Replace cards
	ld	l, dealCellNo
	xor	a
	call	DerefStack
	ld	de, (kdDeckLoc)
	ld	a, (hl)
	and	stackCountM
	jr	z, {2@}
	ld	b, a
	ld	(hl), 0
	ld	de, 8
	add	hl, de
	ld	de, (kdDeckLoc)
@:	ld	a, (hl)
	ld	(hl), notACard
	inc	hl
	ld	(de), a
	inc	de
	djnz	{-1@}
@:	ld	(kdDeckLoc), de
_kdDoDrawCards:
	ld	a, (kdDeckMode)
	cp	2
	jr	nz, {@}
	ld	a, (kdScoringMode)
	or	a
	call	nz, Panic
	; THINGY
	ld	hl, deck
	ld	(kdDeckLoc), hl
	xor	a
	ld	(kdDeckMode), a
	jr	_kdDrawingDone2
@:	ld	de, (kdDeckLoc)
	ld	a, (kdDrawCount)
	ld	b, a
_kdDrawLoop:
	ld	a, (de)
	cp	notACard
	jr	nz, {@}
	inc	de
	jr	_kdDrawLoop
@:	cp	255
	jr	z, _kdDrawNoMore
	ld	l, dealCellNo
	call	PlaceCard
	ld	a, notACard
	ld	(de), a
	inc	de
	djnz	_kdDrawLoop
@:	ld	a, (de)
	cp	255
	jr	z, _kdDrawNoMore
	cp	notACard
	jr	nz, _kdDrawingDone
	inc	de
	jr	{-1@}
_kdDrawNoMore:
	ld	a, (kdScoringMode)
	or	a
	ld	a, 2
	jr	z, {@}
	inc	a
@:	ld	(kdDeckMode), a
	jr	_kdDrawingDone2
_kdDrawingDone:
	ld	a, 1
	ld	(kdDeckMode), a
_kdDrawingDone2:
	; Repaint cards
	ld	a, dealCellNo
	call	DrawStackAndEraseBelowIfNecessary
;	ld	hl, 0
;	ld	d, 24
;	call	Locate
;	ld	hl, (kdDeckLoc)
;	call	DispHL
;	ld	a, ' '
;	call	PutC
;	ld	a, (kdDeckMode)
;	call	DispByte
	call	_kdCheckDeckEmpty
	; Check if current stack is deal stack
	ld	a, (currentStack)
	cp	dealCellNo
	jp	nz, CardsPlayLoop
	ld	l, a
	call	GetTopCardNumber
	ld	(currentDepth), a
	jp	CardsPlayLoop


;------ Deck graphic control ---------------------------------------------------
_kdCheckDeckEmpty:
;	ld	hl, 0
;	ld	d, 24
;	call	Locate
	ld	l, dealCellNo
	call	GetStackDepth
	ld	c, a
	ld	hl, deck
	ld	b, 30
@:	ld	a, (hl)
	inc	hl
	cp	notACard
	jr	z, {@}
	cp	255
	jr	z, {2@}
	inc	c
@:	djnz	{-2@}
@:	ld	a, c
;	push	af
;	call	DispByte
;	pop	af
	or	a
	ret	nz
	; 15 182
	ld	a, 3
	ld	(kdDeckMode), a
	ld	l, deckCellNo
	call	DerefStack
	res	0, (hl)
	ld	de, 8
	add	hl, de
	ld	(hl), notACard
	ld	a, deckCellNo
	jp	DrawStack


#ifdef	NEVER
abort:
	call	UnselectCard
	ld	hl, 0
	ld	d, 0
	call	Locate
	in	a, (45h)
	call	DispByte
	ld	a, ' '
	call	PutC
	pop	hl
	call	DispHL
	jp	CardsPlayLoop
#endif	
	

;------ Check for Win Condition ------------------------------------------------
_kdCheckWin:
;	jr	{@}
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
@:	ld	a, (selectedGame)
	and	3
	ld	(selectedGame), a
	; Time bonus
	ld	hl, 0
	ld	(selectedDepth), hl
	ld	a, (kdTimed)
	or	a
	jr	z, {@}
	ld	a, (kdScoringMode)
	or	a
	jr	nz, {@}
TIME_BONUS_BASE	.equ	60000
	ld	a, TIME_BONUS_BASE >> 8
	ld	c, TIME_BONUS_BASE & 255
	ld	de, (kdTime)
	ld	hl, 30 * 2
	cpHlDe
	jr	nc, {@}
	srl	d
	rr	e
;	srl	d
;	rr	e
	call	DivACByDE
	ld	hl, (kdScore)
	ld	e, c
	ld	d, a
	ld	(selectedDepth), de
	add	hl, de
	ld	(kdScore), hl
	; This makes sure the "Score" field under the KLONDIKE text matches the
	; score in the YOU WIN dialog.
@:	call	_kdTimerCallback
	ld	hl, (kdGamesWon)
	inc	hl
	bit	7, h
	jr	nz, {@}
	ld	(kdGamesWon), hl
@:	ld	ix, klondikeWinDialog
	jp	ShowModalDialog
klondikeWinDrawback:
	ld	hl, 91
	ld	d, 92
	call	Locate
	call	_showTime
	ld	ix, {@}
	call	ShowNumbers
	ld	de, (kdHighScore)
	ld	hl, (kdScore)
	cpHlDe
	ret	c
	ld	(kdHighScore), hl
	ret
@:	.db	5
	.dw	100
	.db	68
	.dw	kdScore
	.dw	127
	.db	80
	.dw	kdHighScore
	.dw	129
	.db	104
	.dw	selectedDepth
	.dw	129
	.db	116
	.dw	kdGamesWon
	.dw	147
	.db	128
	.dw	kdGamesQuit


;------ Store Undo State -------------------------------------------------------
; You could get away with only saving these variables:
;  - kdDeckLoc
;  - kdDeckMode
;  - kdScore
;  - kdTime
;  - currentDepth
;  - currentStack
_storeUndo:
	push	af
	push	bc
	push	de
	push	hl
	push	ix
	; Compute slot to save to
	ld	a, (undoNextSlot)
	ld	h, a
	ld	l, 0
	srl	h
	rr	l
	ld	de, undoStack
	add	hl, de
	ex	de, hl
	; Save vars
	ld	hl, kdDeckLoc
	ld	bc, 5
	ldir
	ld	hl, currentDepth
	ldi
	ldi
	; Save deck
	ld	hl, deck
	ld	bc, 32
	ldir
	; Save stacks
	call	SaveStacks
	; Update save slot counter
	ld	a, (undoNextSlot)
	inc	a
	cp	kdMaxSaveSlots
	jr	c, {@}
	xor	a
@:	ld	(undoNextSlot), a
	; Update active undo slot count
	ld	a, (undosExtant)
	inc	a
	cp	kdMaxSaveSlots + 1
	jr	nc, {@}
	ld	(undosExtant), a
@:	pop	ix
	pop	hl
	pop	de
	pop	bc
	pop	af
	ret 


;------ Load Undo State --------------------------------------------------------
_loadUndo:
	; Is undo possible?
	ld	a, (undosExtant)
	or	a
	jp	z, CardsPlayLoop
	; Fetch pointer to save slot
	ld	a, (undoNextSlot)
	sub	1
	jr	nc, {@}
	ld	a, kdMaxSaveSlots - 1
@:	ld	(undoNextSlot), a
	ld	h, a
	ld	l, 0
	srl	h
	rr	l
	ld	de, undoStack
	add	hl, de
	; Load vars
	ld	de, kdDeckLoc
	ld	bc, 5
	ldir
	ld	de, currentDepth
	ldi
	ldi
	; Load deck
	ld	de, deck
	ld	bc, 32
	ldir
	; Load stacks
	call	LoadStacks
	; Fix score
	ld	hl, (kdScore)
	dec	hl
	dec	hl
	ld	a, (kdScoringMode)
	or	a
	jr	nz, {@}
	bit	7, h
	jr	z, {@}
	sbc	hl, hl	; C already 0
@:	ld	(kdScore), hl
	; Forbid keeping selected card, which shouldn't happen, but if it does,
	; causes graphical glitch
	ld	a, 255
	ld	(selectedStack), a
	; Update number of existing undos
	ld	hl, undosExtant
	dec	(hl)
	; Redraw everything
	jp	KlondikeInitalizeScreen


;====== Routines ===============================================================



;====== Data ===================================================================
klondikeBanner:
	.db	"KLONDIKE", 0
kdScoreText:
	.db	"Score:", 0
kdTimeText:
	.db	"Time:", 0
kdDraw:
	.db	chThinSpace, chThinSpace, "DRAW", chThinSpace, 0
_stacks:
	.db	13
	.db	0
	.dw	kds0
	.db	1
	.dw	kds1
	.db	2
	.dw	kds2
	.db	3
	.dw	kds3
	.db	4
	.dw	kds4
	.db	5
	.dw	kds5
	.db	6
	.dw	kds6
	.db	homeCellNo0
	.dw	kdhc0
	.db	homeCellNo1
	.dw	kdhc1
	.db	homeCellNo2
	.dw	kdhc2
	.db	homeCellNo3
	.dw	kdhc3
	.db	dealCellNo
	.dw	kddc
	.db	deckCellNo
	.dw	kdkc
kds0:	; Stack 0
	.db	stackHideHiddenM	; Stack depth + flags
	.dw	110			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	homeCellNo1		; Stack left
	.db	1			; Stack right
	.db	255			; Stack above
kds1:	; Stack 1
	.db	stackHideHiddenM	; Stack depth + flags
	.dw	140			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	0			; Stack left
	.db	2			; Stack right
	.db	255			; Stack above
kds2:	; Stack 2
	.db	stackHideHiddenM	; Stack depth + flags
	.dw	170			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	1			; Stack left
	.db	3			; Stack right
	.db	255			; Stack above
kds3:	; Stack 3
	.db	stackHideHiddenM	; Stack depth + flags
	.dw	200			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	2			; Stack left
	.db	4			; Stack right
	.db	255			; Stack above
kds4:	; Stack 4
	.db	stackHideHiddenM	; Stack depth + flags
	.dw	230			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	3			; Stack left
	.db	5			; Stack right
	.db	255			; Stack above
kds5:	; Stack 5
	.db	stackHideHiddenM	; Stack depth + flags
	.dw	260			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	4			; Stack left
	.db	6			; Stack right
	.db	255			; Stack above
kds6:	; Stack 6
	.db	stackHideHiddenM	; Stack depth + flags
	.dw	290			; Column
	.db	2			; Row
	.db	255			; Stack below
	.db	5			; Stack left
	.db	homeCellNo0		; Stack right
	.db	255			; Stack above
kdhc0:	; Home cell 0
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	15			; Column
	.db	59			; Row
	.db	homeCellNo2		; Stack below
	.db	6			; Stack left
	.db	homeCellNo1		; Stack right
	.db	deckCellNo		; Stack above
kdhc1:	; Home cell 1
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	61			; Column
	.db	59			; Row
	.db	homeCellNo3		; Stack below
	.db	homeCellNo0		; Stack left
	.db	0			; Stack right
	.db	dealCellNo		; Stack above
kdhc2:	; Home cell 2
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	15			; Column
	.db	108			; Row
	.db	deckCellNo		; Stack below
	.db	6			; Stack left
	.db	homeCellNo3		; Stack right
	.db	homeCellNo0		; Stack above
kdhc3:	; Home cell 3
	.db	stackShowOnlyTopM	; Stack depth + flags
	.dw	61			; Column
	.db	108			; Row
	.db	dealCellNo		; Stack below
	.db	homeCellNo2		; Stack left
	.db	0			; Stack right
	.db	homeCellNo1		; Stack above
kddc:	; Deal cell
	.db	0			; Stack depth + flags
	.dw	61			; Column
	.db	170			; Row
	.db	homeCellNo1		; Stack below
	.db	deckCellNo		; Stack left
	.db	0			; Stack right
	.db	homeCellNo3		; Stack above
kdkc:	; Deck cell
	.db	stackHideHiddenM + 1	; Stack depth + flags
	.dw	15			; Column
	.db	182			; Row
	.db	homeCellNo0		; Stack below
	.db	6			; Stack left
	.db	dealCellNo		; Stack right
	.db	homeCellNo2		; Stack above


;====== ========================================================================
.endmodule