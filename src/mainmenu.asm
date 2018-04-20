; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.

.module	MainMenu
;====== Main Menu ==============================================================
StartGame:
	ld	hl, stacks
	ld	(hl), 255
	ld	de, stacks + 1
	ld	bc, 512
	ldir
	ld	hl, 0
	ld	(f1GuiCallback), hl
	ld	(f2GuiCallback), hl
	ld	a, (selectedGame)
	and	3
	jp	z, StartKlondike
	jp	StartFreeCell


;------ Title Screen -----------------------------------------------------------
MainMenu:

;	ld	hl, 0FF00h
;	ld	(textColors), hl
;	call	ResetScreen
;	jp	StartKlondike

	ld	hl, 0FF00h
	ld	(textColors), hl
	ld	d, colorGreen
	call	FillScrnFull
	call	ResetScreen
	
;	ld	hl, 250
;	ld	d, 0
;	call	Locate
;	ld	a, (saveVarMode)
;	call	DispByte
;	ld	a, (saveError)
;	call	DispByte
	
	
;	ld	hl, titleBanner
;	call	DrawBoxedText
	
	ld	hl, _about
	ld	(f1GuiCallback), hl
	ld	hl, _stats
	ld	(f2GuiCallback), hl
	
	; Load the options table into RAM
	ld	hl, _gii
	ld	de, guiRam
	ld	bc, gui_table_end - _gii
	ldir
	
	; Draw static GUI elements
	ld	ix, _guitb
	call	GuiDoDraw
	
	xor	a
	ld	(keyBuffer), a
;	call	GetKey
	
	; Draw game select elements
	ld	hl, 0
	ld	(guiFreeCellItem), hl
	ld	ix, guiStartButton
	call	GuiDoDraw
	
	; Set up current game
	ld	a, (selectedGame)
	and	3
	ld	(selectedGame), a
	jr	nz, _selectFreeCell
	call	_forceSetKlondikeActive
	jr	{@}
_selectFreeCell:
	call	_forceSetFreeCellActive
@:
	; Now enter GUI event loop
	ld	a, (selectedGame)
	ld	ix, guiKlondikeItem
	or	a
	jp	z, GuiEventLoop
	ld	ix, guiFreeCellItem
	jp	GuiEventLoop


;------ ------------------------------------------------------------------------
_setKlondikeActive:
	ld	a, (selectedGame)
	or	a
	ret	z
_forceSetKlondikeActive:
	push	ix
	; Set radio button option
	ld	ix, guiKlondikeItem
	call	GuiActionRadio
	; Link Klondike options into active GUI elements list
	ld	hl, guiKlondikeOptions
	ld	(guiFreeCellItem), hl
	ld	hl, guiDraw1RadioButton
	ld	(guiKlondikeBelowPtr), hl
	ld	(guiFreeCellBelowPtr), hl
	ld	hl, guiCumulativeRadioButton
	ld	(guiStartAbove), hl
	ld	(guiQuitAbove), hl
	
	; Draw Klondike options
	ld	ix, guiKlondikeOptions
	call	GuiDoDraw
	
	; Configure options to match RAM values
	ld	a, (kdDrawCount)
	cp	1
	push	af
	ld	ix, guiDraw1RadioButton
	call	z, GuiActionRadio
	pop	af
	ld	ix, guiDraw3RadioButton
	call	nz, GuiActionRadio
	
	ld	a, (kdTimed)
	or	a
	push	af
	ld	ix, guiNotTimedRadioButton
	call	z, GuiActionRadio
	pop	af
	ld	ix, guiTimedRadioButton
	call	nz, GuiActionRadio
	
	ld	a, (kdScoringMode)
	or	a
	push	af
	ld	ix, guiNormalRadioButton
	call	z, GuiActionRadio
	pop	af
	cp	1
	push	af
	ld	ix, guiVegasRadioButton
	call	z, GuiActionRadio
	pop	af
	cp	3
	ld	ix, guiCumulativeRadioButton
	call	z, GuiActionRadio
	
	pop	ix
	ret


;------ ------------------------------------------------------------------------
_setFreeCellActive:
	ld	a, (selectedGame)
	dec	a
	ret	z
_forceSetFreeCellActive:
	push	ix
	; Set radio button option
	ld	ix, guiFreeCellItem
	call	GuiActionRadio
	; Link FreeCell options into active GUI elements list
	ld	hl, guiFreeCellOptions
	ld	(guiFreeCellItem), hl
	ld	hl, guiGameNumberBox
	ld	(guiKlondikeBelowPtr), hl
	ld	(guiFreeCellBelowPtr), hl
	ld	hl, guiFreeCellsBox
	ld	(guiStartAbove), hl
	ld	(guiQuitAbove), hl
	; Draw FreeCell options
	ld	ix, guiFreeCellOptions
	call	GuiDoDraw
	; No need to configure options to match RAM values; GUI handles that
	pop	ix
	ret


FreeCellRandomButton:
	push	ix
	ld	ix, guiGameNumberBox
@:	call	NextRandomInt
	ld	a, l
	or	h
	jr	z, {-1@}
	ld	de, 32001
	cpHlDe
	jr	nc, {-1@}
	ex	de, hl
	ld	l, (ix + 20)
	ld	h, (ix + 21)
	ld	(hl), e
	inc	hl
	ld	(hl), d
	ld	l, (ix + 3)
	ld	h, (ix + 4)
	ld	d, (ix + 5)
	ld	b, (ix + 6)
	ld	e, (ix + 7)
	ld	c, colorWhite
	call	DrawFilledRect
	ld	hl, {@}
	push	hl
	ld	l, (ix + 8)
	ld	h, (ix + 9)
	jp	(hl)
@:	pop	ix
	ret


;------ ------------------------------------------------------------------------
_about:
	pop	af	; Do not return to caller
	ld	ix, aboutDialog
	jp	ShowModalDialog
	
_stats:
	pop	af	; Do not return to caller
	ld	ix, statsDialog
	jp	ShowModalDialog
_statsCallback:
	ld	ix, _infoTable
	jp	ShowNumbers
	
_infoTable:
	.db	6
	.dw	178
	.db	68
	.dw	kdHighScore
	.dw	179
	.db	80
	.dw	kdGamesWon
	.dw	197
	.db	92
	.dw	kdGamesQuit
	.dw	179
	.db	104
	.dw	fcGamesWon
	.dw	197
	.db	116
	.dw	fcGamesQuit
	.dw	197
	.db	128
	.dw	fcPreviousGame


;------ GUI Elements -----------------------------------------------------------
gui_table_start:
_guitb:	; Title banner
	.dw	_guisgb			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	127			; Column
	.db	2			; Row
	.db	64			; Width
	.db	14			; Height
	.dw	GuiDrawBanner		; Draw callback
	.db	chThinSpace, chThinSpace, "SOLITAIRE", chThinSpace, 0
_guisgb:; Select game box
	.dw	_guisgbn		; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	93			; Column
	.db	28			; Row
	.db	130			; Width
	.db	22			; Height
	.dw	GuiDrawFilledBox	; Draw callback
_guisgbn:; Select game banner
	.dw	_guiobx			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	118			; Column
	.db	22			; Row
	.db	81			; Width
	.db	14			; Height
	.dw	GuiDrawBanner		; Draw callback
	.db	chThinSpace, chThinSpace, "SELECT GAME", chThinSpace, 0
_guiobx:; Options box
	.dw	_guiobn			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	20			; Column
	.db	61			; Row
	.db	130			; Width
	.db	117			; Height
	.dw	GuiDrawFilledBox	; Draw callback
_guiobn:; Options banner
	.dw	_guicbx			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	57			; Column
	.db	55			; Row
	.db	55			; Width
	.db	14			; Height
	.dw	GuiDrawBanner		; Draw callback
	.db	chThinSpace, chThinSpace, "OPTIONS", chThinSpace, 0
_guicbx:; Controls box
	.dw	_guicbn			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	170			; Column
	.db	61			; Row
	.db	130			; Width
	.db	117			; Height
	.dw	GuiDrawFilledBox	; Draw callback
_guicbn:; Controls banner
	.dw	_guict1			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	202			; Column
	.db	55			; Row
	.db	63			; Width
	.db	14			; Height
	.dw	GuiDrawBanner		; Draw callback
	.db	chThinSpace, chThinSpace, "CONTROLS", chThinSpace, 0
_guict1:; Controls text 1
	.dw	_guict2			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	173			; Column
	.db	70			; Row
	.db	0			; Width
	.db	0			; Height
	.dw	GuiDrawText		; Draw callback
	.db	"Move: ", chArrowLeft, chArrowUp, chArrowDown, chArrowRight, 0
_guict2:; Controls text 2
	.dw	_guict3			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	173			; Column
	.db	82			; Row
	.db	0			; Width
	.db	0			; Height
	.dw	GuiDrawText		; Draw callback
	.db	"Select: 2ND", 0
_guict3:; Controls text 3
	.dw	_guict4			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	173			; Column
	.db	94			; Row
	.db	0			; Width
	.db	0			; Height
	.dw	GuiDrawText		; Draw callback
	.db	"Automove: ALPHA", 0
_guict4:; Controls text 4
	.dw	_guict5			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	173			; Column
	.db	106			; Row
	.db	0			; Width
	.db	0			; Height
	.dw	GuiDrawText		; Draw callback
	.db	"Draw: Y=", 0
_guict5:; Controls text 5
	.dw	_guict6			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	173			; Column
	.db	118			; Row
	.db	0			; Width
	.db	0			; Height
	.dw	GuiDrawText		; Draw callback
	.db	"Save & Quit: MODE", 0
_guict6:; Controls text 6
	.dw	_guict7			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	173			; Column
	.db	130			; Row
	.db	0			; Width
	.db	0			; Height
	.dw	GuiDrawText		; Draw callback
	.db	"Forfeit: CLEAR", 0
_guict7:; Controls text 7
	.dw	_guiabn			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	173			; Column
	.db	142			; Row
	.db	0			; Width
	.db	0			; Height
	.dw	GuiDrawText		; Draw callback
	.db	"Undo: GRAPH", 0
_guiabn:; About box
	.dw	_guiabx			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	170			; Column
	.db	191			; Row
	.db	130			; Width
	.db	34			; Height
	.dw	GuiDrawFilledBox	; Draw callback
_guiabx:; About banner
	.dw	_guiat1			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	213			; Column
	.db	185			; Row
	.db	41			; Width
	.db	14			; Height
	.dw	GuiDrawBanner		; Draw callback
	.db	chThinSpace, chThinSpace, "ABOUT", chThinSpace, 0
_guiat1:; About text 1
	.dw	_guiat2			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	173			; Column
	.db	200			; Row
	.db	0			; Width
	.db	0			; Height
	.dw	GuiDrawText		; Draw callback
	.db	"v", VERSION, " by Dr. D'nar", 0
_guiat2:; About text 2
	.dw	_guistbx		; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	173			; Column
	.db	212			; Row
	.db	0			; Width
	.db	0			; Height
	.dw	GuiDrawText		; Draw callback
	.db	"Y= for more info", 0
_guistbx:; Start box
	.dw	0			; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	20			; Column
	.db	191			; Row
	.db	130			; Width
	.db	34			; Height
	.dw	GuiDrawFilledBox	; Draw callback


guiRam_start:
_gii:

_guistbn:; Start button
guiStartButton	.equ	guiRam
	.dw	_guiqtbn -_gii+guiRam	; Pointer to next entry
	.db	guiButton		; Flags & Type ID
	.dw	37			; Column
	.db	201			; Row
	.db	40			; Width
	.db	14			; Height
	.dw	GuiDrawButton		; Draw callback	
	.dw	StartGame		; Enter key callback
	.dw	0			; Control below ptr
	.dw	guiQuitButton		; Control left ptr
	.dw	guiQuitButton		; Control right ptr
guiStartAbove	.equ	$ - _gii+guiRam
	.dw	0			; Control above ptr
	.db	chThinSpace, chThinSpace, "START", chThinSpace, 0
_guiqtbn:; Quit button
guiQuitButton	.equ	_guiqtbn -_gii+guiRam
	.dw	_guiki -_gii+guiRam	; Pointer to next entry
	.db	guiButton		; Flags & Type ID
	.dw	93			; Column
	.db	201			; Row
	.db	40			; Width
	.db	14			; Height
	.dw	GuiDrawButton		; Draw callback	
	.dw	SaveAndQuit		; Enter key callback
	.dw	0			; Control below ptr
	.dw	guiStartButton		; Control left ptr
	.dw	guiStartButton		; Control right ptr
guiQuitAbove	.equ	$ - _gii+guiRam
	.dw	0			; Control above ptr
	.db	"  QUIT", 0
_guiki:	; Klondike item
guiKlondikeItem	.equ	_guiki -_gii+guiRam
	.dw	_guiklr -_gii+guiRam	; Pointer to next entry
	.db	guiRadioButton		; Flags & Type ID
	.dw	94			; Column
	.db	37			; Row
	.db	61			; Width
	.db	12			; Height
	.dw	GuiDrawRadioButton	; Draw callback
	.dw	_setKlondikeActive	; Enter key callback
guiKlondikeBelowPtr	.equ	$ -_gii+guiRam
	.dw	0			; Control below ptr
	.dw	guiFreeCellItem		; Control left ptr
	.dw	guiFreeCellItem		; Control right ptr
	.dw	0			; Control above ptr
	.db	1			; Radio button group ID
	.dw	selectedGame		; Pointer to setting byte
	.db	klondikeGame		; Value to write
	.db	chThinSpace, chThinSpace, chEmptyBullet, " Klondike", 0
_guiklr:; FreeCell item
guiFreeCellItem	.equ	_guiklr -_gii+guiRam
	.dw	0			; Pointer to next entry
	.db	guiRadioButton		; Flags & Type ID
	.dw	160			; Column
	.db	37			; Row
	.db	62			; Width
	.db	12			; Height
	.dw	GuiDrawRadioButton	; Draw callback
	.dw	_setFreeCellActive	; Enter key callback
guiFreeCellBelowPtr	.equ	$ -_gii+guiRam
	.dw	0			; Control below ptr
	.dw	guiKlondikeItem		; Control left ptr
	.dw	guiKlondikeItem		; Control right ptr
	.dw	0			; Control above ptr
	.db	1			; Radio button group ID
	.dw	selectedGame		; Pointer to setting byte
	.db	freeCellGame		; Value to write
	.db	chThinSpace, chThinSpace, chEmptyBullet, " FreeCell", 0
_selectGameEnd:
guiOptionsRam	.equ	guiRam + _selectGameEnd - _gii

_guisoler:; Box to erase whatever was previously there
guiKlondikeOptions	.equ	_guisoler -_gii+guiRam
	.dw	_guisdrbx -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	23			; Column
	.db	69			; Row
	.db	121			; Width
	.db	105			; Height
	.dw	GuiDrawWhiteBox		; Draw callback
_guisdrbx:; Draw option box
	.dw	_guisdrbn -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	24			; Column
	.db	78			; Row
	.db	113			; Width
	.db	22			; Height
	.dw	GuiDrawBox		; Draw callback
_guisdrbn:; Draw option banner
	.dw	_guisdr1 -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	32			; Column
	.db	72			; Row
	.db	35			; Width
	.db	14			; Height
	.dw	GuiDrawBanner		; Draw callback
	.db	chThinSpace, chThinSpace, "DRAW", chThinSpace, 0
_guisdr1:; Draw 1 radio button
guiDraw1RadioButton	.equ	_guisdr1 -_gii+guiRam
	.dw	_guisdr3 -_gii+guiRam	; Pointer to next entry
	.db	guiRadioButton		; Flags & Type ID
	.dw	25			; Column
	.db	87			; Row
	.db	52			; Width
	.db	12			; Height
	.dw	GuiDrawRadioButton	; Draw callback
	.dw	GuiActionRadio		; Enter key callback
	.dw	guiNotTimedRadioButton	; Control below ptr
	.dw	guiDraw3RadioButton	; Control left ptr
	.dw	guiDraw3RadioButton	; Control right ptr
	.dw	guiKlondikeItem		; Control above ptr
	.db	2			; Radio button group ID
	.dw	kdDrawCount		; Pointer to setting byte
	.db	1			; Value to write
	.db	chThinSpace, chThinSpace, chEmptyBullet, " Draw 1", 0
_guisdr3:; Draw 3 radio button
guiDraw3RadioButton	.equ	_guisdr3 -_gii+guiRam
	.dw	_guitmbx -_gii+guiRam	; Pointer to next entry
	.db	guiRadioButton		; Flags & Type ID
	.dw	82			; Column
	.db	87			; Row
	.db	54			; Width
	.db	12			; Height
	.dw	GuiDrawRadioButton	; Draw callback
	.dw	GuiActionRadio		; Enter key callback
	.dw	guiTimedRadioButton	; Control below ptr
	.dw	guiDraw1RadioButton	; Control left ptr
	.dw	guiDraw1RadioButton	; Control right ptr
	.dw	guiKlondikeItem		; Control above ptr
	.db	2			; Radio button group ID
	.dw	kdDrawCount		; Pointer to setting byte
	.db	3			; Value to write
	.db	chThinSpace, chThinSpace, chEmptyBullet, " Draw 3", 0
_guitmbx:; Timed option box
	.dw	_guitmbn -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	24			; Column
	.db	109			; Row
	.db	70			; Width
	.db	22			; Height
	.dw	GuiDrawBox		; Draw callback
_guitmbn:; Timed option banner
	.dw	_guitmn -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	32			; Column
	.db	103			; Row
	.db	41			; Width
	.db	14			; Height
	.dw	GuiDrawBanner		; Draw callback
	.db	chThinSpace, chThinSpace, "TIMED", chThinSpace, 0
_guitmn:; Not timed
guiNotTimedRadioButton	.equ	_guitmn -_gii+guiRam
	.dw	_guitmy -_gii+guiRam	; Pointer to next entry
	.db	guiRadioButton		; Flags & Type ID
	.dw	25			; Column
	.db	118			; Row
	.db	28			; Width
	.db	12			; Height
	.dw	GuiDrawRadioButton	; Draw callback
	.dw	GuiActionRadio		; Enter key callback
	.dw	guiNormalRadioButton	; Control below ptr
	.dw	guiTimedRadioButton	; Control left ptr
	.dw	guiTimedRadioButton	; Control right ptr
	.dw	guiDraw1RadioButton	; Control above ptr
	.db	3			; Radio button group ID
	.dw	kdTimed			; Pointer to setting byte
	.db	0			; Value to write
	.db	chThinSpace, chThinSpace, chEmptyBullet, " No", 0
_guitmy:; Timed
guiTimedRadioButton	.equ	_guitmy -_gii+guiRam
	.dw	_guiscbx -_gii+guiRam	; Pointer to next entry
	.db	guiRadioButton		; Flags & Type ID
	.dw	58			; Column
	.db	118			; Row
	.db	35			; Width
	.db	12			; Height
	.dw	GuiDrawRadioButton	; Draw callback
	.dw	GuiActionRadio		; Enter key callback
	.dw	guiVegasRadioButton	; Control below ptr
	.dw	guiNotTimedRadioButton	; Control left ptr
	.dw	guiNotTimedRadioButton	; Control right ptr
	.dw	guiDraw3RadioButton	; Control above ptr
	.db	3			; Radio button group ID
	.dw	kdTimed			; Pointer to setting byte
	.db	1			; Value to write
	.db	chThinSpace, chThinSpace, chEmptyBullet, " Yes", 0
_guiscbx:; Scoring option box
	.dw	_guiscbn -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	24			; Column
	.db	140			; Row
	.db	110			; Width
	.db	34			; Height
	.dw	GuiDrawBox		; Draw callback
_guiscbn:; Scoring option banner
	.dw	_guiscn -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	32			; Column
	.db	134			; Row
	.db	55			; Width
	.db	14			; Height
	.dw	GuiDrawBanner		; Draw callback
	.db	chThinSpace, chThinSpace, "SCORING", chThinSpace, 0
_guiscn:; Normal scoring
guiNormalRadioButton	.equ	_guiscn -_gii+guiRam
	.dw	_guiscv -_gii+guiRam	; Pointer to next entry
	.db	guiRadioButton		; Flags & Type ID
	.dw	25			; Column
	.db	149			; Row
	.db	54			; Width
	.db	12			; Height
	.dw	GuiDrawRadioButton	; Draw callback
	.dw	GuiActionRadio		; Enter key callback
	.dw	guiCumulativeRadioButton; Control below ptr
	.dw	guiVegasRadioButton	; Control left ptr
	.dw	guiVegasRadioButton	; Control right ptr
	.dw	guiNotTimedRadioButton	; Control above ptr
	.db	4			; Radio button group ID
	.dw	kdScoringMode		; Pointer to setting byte
	.db	0			; Value to write
	.db	chThinSpace, chThinSpace, chEmptyBullet, " Normal", 0
_guiscv:; Vegas scoring
guiVegasRadioButton	.equ	_guiscv -_gii+guiRam
	.dw	_guiscc -_gii+guiRam	; Pointer to next entry
	.db	guiRadioButton		; Flags & Type ID
	.dw	84			; Column
	.db	149			; Row
	.db	49			; Width
	.db	12			; Height
	.dw	GuiDrawRadioButton	; Draw callback
	.dw	GuiActionRadio		; Enter key callback
	.dw	guiCumulativeRadioButton; Control below ptr
	.dw	guiNormalRadioButton	; Control left ptr
	.dw	guiNormalRadioButton	; Control right ptr
	.dw	guiTimedRadioButton	; Control above ptr
	.db	4			; Radio button group ID
	.dw	kdScoringMode		; Pointer to setting byte
	.db	1			; Value to write
	.db	chThinSpace, chThinSpace, chEmptyBullet, " Vegas", 0
_guiscc:; Cumulative Vegas option
guiCumulativeRadioButton	.equ	_guiscc -_gii+guiRam
	.dw	0			; Pointer to next entry
	.db	guiRadioButton		; Flags & Type ID
	.dw	25			; Column
	.db	161			; Row
	.db	75			; Width
	.db	12			; Height
	.dw	GuiDrawRadioButton	; Draw callback
	.dw	GuiActionRadio		; Enter key callback
	.dw	guiStartButton		; Control below ptr
	.dw	0			; Control left ptr
	.dw	0			; Control right ptr
	.dw	guiNormalRadioButton	; Control above ptr
	.db	4			; Radio button group ID
	.dw	kdScoringMode		; Pointer to setting byte
	.db	3			; Value to write
	.db	chThinSpace, chThinSpace, chEmptyBullet, " Cumulative", 0

_guifcer:; Box to erase whatever was previously there
guiFreeCellOptions	.equ	_guifcer -_gii+guiRam
	.dw	_guignbx -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	23			; Column
	.db	69			; Row
	.db	114			; Width
	.db	105			; Height
	.dw	GuiDrawWhiteBox		; Draw callback
_guignbx:; Game number box
	.dw	_guignbn -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	24			; Column
	.db	78			; Row
	.db	64			; Width
	.db	22			; Height
	.dw	GuiDrawBox		; Draw callback
_guignbn:; Game number banner
	.dw	_guignnb -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	32			; Column
	.db	72			; Row
	.db	48			; Width
	.db	14			; Height
	.dw	GuiDrawBanner		; Draw callback
	.db	chThinSpace, chThinSpace, "GAME #", chThinSpace, 0
_guignnb:; Game number entry box
guiGameNumberBox	.equ	_guignnb -_gii+guiRam
	.dw	_guirgbx -_gii+guiRam	; Pointer to next entry
	.db	guiNumberBox		; Flags & Type ID
	.dw	25			; Column
	.db	87			; Row
	.db	38			; Width
	.db	12			; Height
	.dw	GuiDrawNumberBox	; Draw callback
	.dw	GuiActionNumberBox	; Enter key callback
	.dw	guiFreeCellsBox		; Control below ptr
	.dw	_guirgbx -_gii+guiRam	; Control left ptr
	.dw	_guirgbx -_gii+guiRam	; Control right ptr
	.dw	guiFreeCellItem		; Control above ptr
	.dw	fcGameNumber		; Pointer to location to write number
	.dw	1			; Minimum value
	.dw	32000			; Maximum value
_guirgbx:; Random game box
	.dw	_guisfcbx -_gii+guiRam	; Pointer to next entry
	.db	guiButton		; Flags & Type ID
	.dw	92			; Column
	.db	82			; Row
	.db	52			; Width
	.db	14			; Height
	.dw	GuiDrawButton		; Draw callback	
	.dw	FreeCellRandomButton	; Enter key callback
	.dw	guiFreeCellsBox		; Control below ptr
	.dw	_guignnb -_gii+guiRam	; Control left ptr
	.dw	_guignnb -_gii+guiRam	; Control right ptr
	.dw	guiFreeCellItem		; Control above ptr
	.db	chThinSpace, chThinSpace, "Random!", chThinSpace, 0
_guisfcbx:; Free cells box
	.dw	_guifcbn -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	24			; Column
	.db	109			; Row
	.db	85			; Width
	.db	22			; Height
	.dw	GuiDrawBox		; Draw callback
_guifcbn:; Free cells banner
	.dw	_guifcnb -_gii+guiRam	; Pointer to next entry
	.db	guiFlagStatic		; Flags & Type ID
	.dw	32			; Column
	.db	103			; Row
	.db	69			; Width
	.db	14			; Height
	.dw	GuiDrawBanner		; Draw callback
	.db	chThinSpace, chThinSpace, "FREE CELLS", chThinSpace, 0
_guifcnb:; Free cells number entry box
guiFreeCellsBox	.equ	_guifcnb -_gii+guiRam
	.dw	0			; Pointer to next entry
	.db	guiNumberBox		; Flags & Type ID
	.dw	25			; Column
	.db	118			; Row
	.db	10			; Width
	.db	12			; Height
	.dw	GuiDrawNumberBox	; Draw callback
	.dw	GuiActionNumberBox	; Enter key callback
	.dw	guiStartButton		; Control below ptr
	.dw	0			; Control left ptr
	.dw	0			; Control right ptr
	.dw	guiGameNumberBox	; Control above ptr
	.dw	fcFreeCells		; Pointer to location to write number
	.dw	2			; Minimum value
	.dw	6			; Maximum value


gui_table_end:
.endmodule