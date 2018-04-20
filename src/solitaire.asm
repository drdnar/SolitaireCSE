; Solitaire for the TI-84 Plus C SE
; Dr. D'nar
; drdnar@gmail.com
; Build using Brass (Ben Ryves Assembler) version 1.x

; TODO: 
;  - Make more moves release currently selected card
;  - Anti-battery drain: If same key repeats 255 times, APD
;  - Graphics for face cards
;  - Change graphics in FreeCell:
;     - FREECELL should have a box, no label for Home
;  - Automove in FreeCell doesn't correctly consider all free cells?

.nolist
.include "ti84pcse.inc"
.list

.include "equates.asm"

;.define	FREECELL_DEBUG
kdMaxSaveSlots	.equ	3	; 6 is the max or else you'll corrupt stuff


;====== Header =================================================================

;------ No Shell ---------------------------------------------------------------
.binarymode intel
.defpage	0, 16384, 4000h
.page	0
program_start:	
	; Master Field
	.db	80h, 0Fh, 0, 0, 0, 0
	; Name
;	.db	80h, 49h, "Solitaire"
	.db	80h, 40h + {2@} - {@}
@:	.db	"Solitair"
@:	; Disable TI splash screen.  Also, pointer to the jump table.
	.db	80h, 90h
	; Revision
	.db	80h, 21h, 1
	; Build
	.db	80h, 32h
	.db	BUILD >> 8
	.db	BUILD & 255
	; Pages
	.db	80h, 81h, 1
	; Signing Key ID
	.db	80h, 12h, 1, 15
	; Date stamp.  Nothing ever checks this, so you can put nothing in it.
	.db	03h, 22h, 09h, 00h
	; Date stamp signature.  Since nothing ever checks this, there's no
	; reason ever to update it.  Or even have data in it.
	.db	02h, 00
	; Final field
	.db	80h, 70h


;====== Initialization =========================================================
generic_stuff_start:
Restart:
; Memory
	di
	; TODO: If I move the ISR back into RAM, have it do instant aborts by
	; just PowerOffing back to the OS, instead of returning to the app?
;	in	a, (pMPgAHigh)
;	ld	h, a
;	in	a, (pMPgA)
;	ld	l, a
;	ld	(mBasePage), hl

	; This is important
	ld	a, cpu15MHz
	; OK, not really, but it helps a lot.
	out	(pCpuSpeed), a
	
	res	indicRun, (iy + shiftFlags)

;------ Appvar Check -----------------------------------------------------------
	; Erase stuff
	ld	hl, rngState
	ld	(hl), 0
	ld	de, rngState + 1
	ld	bc, end_of_game_vars - rngState - 1
	ldir
	
; Saving
	xor	a
	ld	(saveError), a
	ld	hl, appvarName
	rst	rMOV9TOOP1
	b_call(_ChkFindSym)
	jp	nc, _dontCreateAppVar
; Appvar not found
	call	_initalizeKnownGoodSettings
	; Create appvar
	ld	a, seLowRam
	ld	(saveError), a
	ld	hl, saveVarMode
	ld	(hl), 0
	ld	hl, saveStatsSize + 20
	b_call(_EnoughMem)
	jp	c, _appvarStuffDone
	ld	hl, saveVarMode
	inc	(hl)
	ld	hl, saveGameSize + 20
	b_call(_EnoughMem)
	jr	c, {@}
	xor	a
	ld	(saveError), a
	ld	hl, saveVarMode
	inc	(hl)
	ld	hl, saveUndoSize + 20
	b_call(_EnoughMem)
	jr	c, {@}
	ld	hl, saveVarMode
	inc	(hl)
@:	ld	hl, saveStatsSize	;ex	de, hl
	b_call(_CreateAppVar)
	ld	(saveAddress), de
	; Empty appvar so that it's clean if there's a panic
	ex	de, hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	push	hl
	ld	(hl), 0
	ld	e, l
	ld	d, h
	inc	de
	dec	bc
	ldir
	pop	de
	ld	hl, appvarHeader
	ld	bc, appvarHeader_end - appvarHeader
	ldir
	; Initialize appvar data
	ld	hl, first_saved_var
	ld	bc, end_of_game_vars - first_saved_var
	ldir
	; And done.
	jp	_appvarStuffDone

_initalizeKnownGoodSettings:	; Initialize variables
	ld	a, klondikeGame
	ld	(selectedGame), a
	ld	a, 3
	ld	(kdDrawCount), a
	ld	a, 1
	ld	(kdTimed), a
	xor	a
	ld	(kdScoringMode), a
	ld	hl, 4
	ld	(fcFreeCells), hl
	ret
; Appvar found
_dontCreateAppVar:
	; Is appvar in RAM?
	ld	a, b
	or	a
	jr	z, _appvarInRam
	ex	de, hl
	inc	hl
	bit	7, h
	jr	z, {@}
	ld	hl, 4000h
	inc	b
@:	b_call(_LoadDEIndPaged)
	ex	de, hl
	ld	de, 10
	add	hl, de
	b_call(_EnoughMem)
	jr	nc, {@}
	; Not enough RAM to unarchive
	ld	a, seLowRam
	ld	(saveError), a
	xor	a
	ld	(saveVarMode), a
	call	_initalizeKnownGoodSettings
	jp	_appvarStuffDone
@:	; Unarchive variable
	b_call(_Arc_Unarc)
	; Fetch pointer to data
	ld	hl, appvarName
	rst	rMOV9TOOP1
	b_call(_ChkFindSym)
_appvarInRam:
	ld	(saveAddress), de
	; Verify that appvar is Solitaire appvar
	ld	a, (de)
	ld	b, a
	inc	de
	ld	a, (de)
	inc	de
	or	a
	jr	nz, {@}
	ld	a, b
	cp	20
	jr	c, {2@}
@:	ld	hl, appvarHeader
	call	CompareStrings
	jr	z, {2@}
	; Header mismatch
@:	ld	a, seAppvarInUse
	ld	(saveError), a
	xor	a
	ld	(saveVarMode), a
	jp	_appvarStuffDone
@:	; Verify that appvar version is suitable
	ex	de, hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, SAVE_EARLIEST_SUPPORTED_VERSION
	ex	de, hl
	cpHlDe
	jr	nc, {@}
	; Version mismatch
	ld	a, seVersion
	ld	(saveError), a
	xor	a
	ld	(saveVarMode), a
	call	_initalizeKnownGoodSettings
	jp	_appvarStuffDone
@:	xor	a
	ld	(saveError), a
	; Load stats
	ld	hl, (saveAddress)
	ld	de, appvarHeader_end - appvarHeader + 2
	add	hl, de
	ld	de, first_saved_var
	ld	bc, end_of_game_vars - first_saved_var
	ldir
	ld	a, 1
	ld	(saveVarMode), a
	; If game is in progress, load that
	ld	a, (selectedGame)
	and	80h
	jr	z, _dontLoadGame
	ld	de, deck
	ld	bc, 32
	ldir
	ld	a, (selectedGame)
	and	3
	ld	ix, FreeCell._stacks
	jr	nz, {@}
	ld	ix, Klondike._stacks
@:	push	hl
	call	InitalizeStacks
	pop	hl
	call	LoadStacks
	ld	a, 3
	ld	(saveVarMode), a
	ld	de, (saveAddress)
	inc	de
	ld	a, (de)
	or	a		; Screw it, we'll just figure out whether there's undo data based on size
	jr	z, {@}
	; Load undo stack
	ld	de, undoStack
	ld	bc, 768
	ldir
	jr	_appvarStuffDone
@:	; No undo data present, so make sure the game knows
	ld	hl, 0
	ld	(undoNextSlot), hl
	; Is there enough RAM to save an undo stack?
	ld	hl, 780
	b_call(_EnoughMem)
	jr	nc, _appvarStuffDone
	ld	hl, saveVarMode
	ld	(hl), 2
	; Don't report an error.  Just silently not save the undo stack.
	jr	_appvarStuffDone
_dontLoadGame:
	; Memory save mode
	ld	a, seLowRam
	ld	(saveError), a
;	ld	hl, saveVarMode
;	ld	(hl), 1
	ld	hl, (saveAddress)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	hl, saveGameSize
	or	a
	sbc	hl, de
	b_call(_EnoughMem)
	pop	de
	jr	c, _appvarStuffDone
	xor	a
	ld	(saveError), a
	ld	hl, saveVarMode
	inc	(hl)
	ld	hl, saveUndoSize
	or	a
	sbc	hl, de
	b_call(_EnoughMem)
	jr	c, _appvarStuffDone
	ld	hl, saveVarMode
	inc	(hl)

	
;------ Complete Initialization ------------------------------------------------
_appvarStuffDone:
	di
	
	; RAM-Resident Routines
;	ld	hl, ScanKeyboardSource
;	ld	de, ScanKeyboard
;	ld	bc, (ScanKeyboardSource - 2)
;	ldir
;	ld	hl, RawGetCSCSource
;	ld	de, RawGetCSC
;	ld	bc, (RawGetCSCSource - 2)
;	ldir
;	ld	hl, RealIsrSource
;	ld	de, RealIsr
;	ld	bc, (RealIsrSource - 2)
;	ldir
;	ld	hl, InstantQuitSource
;	ld	de, InstantQuit
;	ld	bc, (InstantQuitSource - 2)
;	ldir
	
	; Interrupts
	ld	bc, suspendDelay
	ld	(suspendTimer), bc
	call	SetUpInterrupts
	set	setApdEnabled, (iy + mSettings)
	res	setApdNow, (iy + mSettings)
	ei
	
	ld	hl, 0FF00h
	ld	(textColors), hl
	call	ResetScreen
	
	ld	a, (selectedGame)
	bit	7, a
	jr	z, {@}
	and	3
	jp	z, KlondikeInitalizeScreen
	jp	FreeCellInitalizeScreen

@:	call	FreeCellRandomGame
	
	; Show error message, if needed
	
;	ld	ix, errLowRam
;	ld	a, (saveVarMode)
;	or	a
;	jp	z, ShowModalDialog
	
	ld	a, (saveError)
	or	a
	jp	z, MainMenu
	ld	ix, errLowRam
	dec	a
	jp	z, ShowModalDialog
	ld	ix, errVersion
	dec	a
	jp	z, ShowModalDialog
	ld	ix, errAppvarInUse
	dec	a
	jp	z, ShowModalDialog
;	ld	hl, 300
;	ld	d, 0
;	call	Locate
;	ld	a, (saveError)
;	call	DispByte
	call	Panic

	
;====== Termination ============================================================
SaveAndQuit:
	ld	iy, flags
	ld	a, (saveVarMode)
	or	a
	jp	z, Quit
	cp	2
	jr	nc, {@}
	ld	a, (selectedGame)
	and	3
	ld	(selectedGame), a
@:	; Empty appvar
	ld	hl, (saveAddress)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	a, e
	or	d
	call	z, Panic
	di
	b_call(_DelMem)
	ei
	; . . . and allocate it back again
	ld	de, (saveAddress)
	inc	de
	inc	de
	ld	hl, saveStatsSize
	di
	b_call(_InsertMem)
	ei	; I'm dubious about whether this is safe. . . .
	ld	hl, (saveAddress)
	ld	(hl), saveStatsSize & 255
	inc	hl
	ld	(hl), saveStatsSize >> 8
	; Save appvar exists, so there must be sufficient space to save stats
	ld	de, (saveAddress)
	inc	de
	inc	de
	; Header
	ld	hl, appvarHeader
	ld	bc, appvarHeader_end - appvarHeader
	ldir
	; Stats
	ld	hl, first_saved_var
	ld	bc, end_of_game_vars - first_saved_var
	ldir
;	ld	(guiTemp), de
	; Should we save a game?
	ld	a, (saveVarMode)
	cp	2
	jp	c, Quit
; Is there a game in progress to save?
	ld	a, (selectedGame)
	bit	7, a
	jp	z, Quit
	; Allocate more memory
	push	de
	ld	hl, saveGameSize - saveStatsSize
	di
	b_call(_InsertMem)
	ei
	ld	hl, (saveAddress)
	ld	(hl), saveGameSize & 255
	inc	hl
	ld	(hl), saveGameSize >> 8
	pop	de
	; Save deck
	ld	hl, deck
	ld	bc, 32
	ldir
	; Save stacks
	call	SaveStacks
; Save undo stack
	ld	a, (saveVarMode)
	cp	3
	jp	c, Quit
	; Allocate more memory
	push	de
	ld	hl, saveUndoSize - saveGameSize
	di
	b_call(_InsertMem)
	ei
	ld	hl, (saveAddress)
	ld	(hl), saveUndoSize & 255
	inc	hl
	ld	(hl), saveUndoSize >> 8
	pop	de
	ld	hl, undoStack
	ld	bc, 768
	ldir
	jp	Quit


;------ Panic routine ----------------------------------------------------------
errorText:	.db	"BUG CHECK: ", 0
Panic:
	di
	ex	(sp), iy
	push	ix
	push	hl
	push	de
	push	bc
	push	af
	push	iy
	call	SetUpInterrupts
	call	ResetScreen
	ld	hl, colorRed
	ld	(textColors), hl
	ld	hl, 0
	ld	d, 0
	call	Locate
	ld	hl, errorText
	call	PutS
	pop	hl
	call	DispHL
	ld	a, ' '
	call	PutC
	ld	hl, BUILD
	call	DispDecimal
	ld	hl, 0
	ld	d, 12
	call	Locate
	pop	hl
	call	DispHL
	ld	a, ' '
	call	PutC
	pop	hl
	call	DispHL
	ld	a, ' '
	call	PutC
	pop	hl
	call	DispHL
	ld	a, ' '
	call	PutC
	pop	hl
	call	DispHL
	ld	hl, 0
	ld	d, 24
	call	Locate
	pop	hl
	call	DispHL
	ld	a, ' '
	call	PutC
	pop	hl
	call	DispHL
	
	call	GetKey
	call	GetKey


;------ Actual code to return code to OS ---------------------------------------
; 31 March 2014 11:27:43 PM KermM: DrDnar: Set the LCD ports to full-window, bcall(_DrawStatusBar), clear out CmdShadow with spaces, fix the APD flags, homeup, then send kClear to _jforcecmd
Quit:
	di
	ld	iy, flags
	; Screen
	xor	a
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	out	(pLcdCmd), a
	setLcdDReg(lrWinLeft, 0)
	setLcdDReg(lrWinRight, lcdWidth)
	setLcdDReg(lrWinTop, 0)
	setLcdDReg(lrWinBottom, lcdHeight)
	setLcdDReg(lrEntryMode, lcdDispCtrlDefault)
	; Interrupts
	ld	a, 1011b
	out	(pIntMask), a
	im	1
	ei
	; More screen stuff
;	This doesn't need to be cleared because I don't touch it.
;	ld	hl, cmdShadow 
;	ld	de, cmdShadow + 1
;	ld	(hl), '@' ; space
;	ld	bc, 259
;	ldir
;	Actually, this doesn't need to be cleared.
;	ld	hl, textShadow
;	ld	de, textShadow+1
;	ld	(hl), '!'
;	ld	bc, 259
;	ldir
;	b_call(_DelRes)
	b_call(_DrawStatusBarInfo)
; Use these if you're a RAM program
;	b_call(_DrawStatusBar)
;	b_call(_maybe_ClrScrn)
;	b_call(_HomeUp)
;	set	indicRun, (iy + shiftFlags)
;	res	DonePrgm, (iy + DoneFlags)
;	set	appAutoScroll, (iy + appFlags)
;	res	OnInterrupt, (iy + OnFlags)
	ei
	halt	; flush any keys the user held down
	b_call(_GetCSC)
	ei
	halt
	b_call(_GetCSC)
 	res	appLockMenus, (iy + appFlags)
	bit	setApdNow, (iy + mSettings)
	jr	nz, quitPowerOff
	bjump(_JForceCmdNoChar)
quitPowerOff:
	bcall(_PowerOff)
generic_stuff_end:



;====== Includes ===============================================================

mainmenu_start:
#include "mainmenu.asm"
mainmenu_end:

klondike_start:
#include "klondike.asm"
klondike_end:

freecell_start:
#include "freecell.asm"
freecell_end:

cards_start:
#include "cards.asm"
cards_end:

utility_start:
#include "utility.asm"
utility_end:

interrupts_start:
#include "interrupts.asm"
interrupts_end:

keyboard_start:
#include "keyboard.asm"
keyboard_end:

lcd_start:
#include "lcd.asm"
lcd_end:

text_start:
#include "text.asm"
text_end:

gui_start:
#include "gui.asm"
gui_end:

data_start:
#include "data.asm"
data_end:

font_start:
#include "font.asm"
font_end:


;====== Embedded IVT & ISR =====================================================
interrupt_burn_start:
.fill	256 - ($ & 255), 255
InterruptVectorTable:
;.echo	(($ + 256) / 256), "\n"
ivt_fill_byte	.equ	(($ + 256) >> 8)
.fill	257, ivt_fill_byte
;.echo	($ - 1) / 256, "\n"
.fill	ivt_fill_byte - 1, 255
InterruptHandler:
	jp	RealIsr
;.echo	InterruptHandler, "\n"
interrupt_burn_end:

program_end:


;====== INFORMATION ============================================================
.ifdef	FREECELL_DEBUG
.echo	"\n\nWARNING: FREECELL ALLOWS ALL MOVES\n\n\n"
.endif
.echo	" * INFORMATION & STATISTICS * \n"
.echo	"Build number: ", BUILD, "\n"
.echo	"Last main address used: "
EchoWord(interrupt_burn_start)
.echo	"h\nSpace wasted between end of app and IVT: ", InterruptVectorTable - interrupt_burn_start, " bytes\n"
.echo	"IVT location: "
EchoWord(InterruptVectorTable)
.echo	"h\nIVT fill byte: "
EchoByte(ivt_fill_byte)
.echo	"h\nInterruptHandler: "
EchoWord(InterruptHandler)
.echo	"h\n"
.echo	"Main RAM vars: ", end_of_game_vars - start_of_static_vars, " bytes\n"
.echo	"Core saved vars size: ", end_of_game_vars - first_saved_var, " bytes\n"
.echo	" * SIZES * \n"
.echo	"Initalization & termination code size: ", generic_stuff_end - generic_stuff_start, " bytes\n"
.echo	"Main menu size: ", mainmenu_end - mainmenu_start, " bytes\n"
.echo	"Main menu GUI elemnts: ", gui_table_end - gui_table_start, " bytes\n"
.echo	"Main menu RAM GUI elements: ", gui_table_end - guiRam_start, " bytes\n"
.echo	"GUI library size: ", gui_end - gui_start, " bytes\n"
.echo	"Klondike game size: ", klondike_end - klondike_start, " bytes\n"
.echo	"FreeCell game size: ", freecell_end - freecell_start, " bytes\n"
.echo	"Cards library size: ", cards_end - cards_start, " bytes\n"
.echo	"Utility routines size: ", utility_end - utility_start, " bytes\n"
.echo	"Interrupt driver size: ", interrupts_end - interrupts_start, " bytes\n"
.echo	"Keyboard driver size: ", keyboard_end - keyboard_start, " bytes\n"
.echo	"LCD driver size: ", lcd_end - lcd_start, " bytes\n"
.echo	"Text driver size: ", text_end - text_start, " bytes\n"
;.echo	"LCD & text driver size: ", text_end - lcd_start, " bytes\n"
.echo	"Data size: ", data_end - data_start, " bytes\n"
.echo	"Font size: ", font_end - font_start, " bytes\n"
.echo	"IVT & ISR burned space: ", interrupt_burn_end - interrupt_burn_start, " bytes\n"
.echo	"Total program code & data: ", program_end - program_start, " bytes\n"
.echo	"Space remaining: ", 7FBBh - program_end, " bytes\n"
.ifdef	FREECELL_DEBUG
.echo	"\n\nWARNING: FREECELL ALLOWS ALL MOVES\n\n\n"
.endif
;.echo	" size: ", _end - _start, " bytes"
;.echo	"\n"