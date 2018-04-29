; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.

; Solitaire for the TI-84 Plus C SE
; Dr. D'nar
; drdnar@gmail.com
; Build using Brass (Ben Ryves Assembler) version 1.x

; TODO:
;  - Make more moves release currently selected card
;  - Anti-battery drain: If same key repeats 255 times, APD
;     - (Because, you know, that would mean that something is laying on top of
;       the calculator.)
;  + Graphics for face cards
;  - Change graphics in FreeCell:
;     - FREECELL should have a box, no label for Home
;  - Can we instant abort by using PowerOff instead of paging back into the app?
;  - Pressing UP at top of stack should move to bottom
;  - DrawHiddenCardHeader can possibly be optimized; it seems it would be smaller
;    to make it a monochrome sprite
;  + DrawStack can probably be simplified by calling GetCardLocation
;     - This was a terrible idea.  It saved nine bytes.
;  - Could save up to 200 bytes net-total by Huffman compressing all text
;  - Could possibly save lots of space (200 bytes?) by RLE compressing face card graphics

; So here's an overview of how Solitaire works:
;  - The OS passes control to Solitaire
;  - Solitaire initializes itself
;     - It saves the current page for reference
;     - It checks for the presence of its save appvar
;        - If the appvar is absent, it creates it if enough RAM is available
;        - If the appvar is present, it checks if the appvar is a Solitaire appvar
;           - If it is, it loads the data in the appvar and saves a pointer to it
;        - It checks how much free RAM is available
;          and uses that information to decide what can be saved on termination:
;          Nothing, stats only, game without undo, or game with undo
;     - Once all that is done, the game will initialize interrupts
;       and change the screen mode to match Solitaire's needs
;  - If a game was loaded, it jumps into the correct game play loop
;  - If there was an error accessing the save appvar, it will present the error dialog
;  - Then control is passed to the main menu
;     - The main menu will clear the screen
;     - Some GUI structures will be loaded into RAM
;       so they can be mutated depending on user actions
;        - These structures contain callbacks for important actions
;           - Paint
;           - Enter control
;        - There are also pointers to physically nearby controls
;          so the arrow keys work
;        - Each item also has a pointer to the next item in the GUI list,
;          so items can be located in both RAM and flash
;     - The currently selected game's options are linked into the GUI list
;     - The GUI paint function is called
;        - The GUI paint function will walk the GUI list
;          and call the paint method for each item
;     - Then control is passed to the GUI event processing loop
;        - IX always holds a reference to the currently highlighted/active GUI control
;        - The GUI event loop highlights the current control
;        - It waits for keyboard input and uses the navigation vectors on
;          the current control to give focus to a new control
;        - When the ENTER key is pressed, control is passed to the item
;           - This is a jump, not a call; to return to the GUI event loop,
;             you JP back to GuiEventLoop
;           - When changing the selected game, the function will
;             change pointers in the GUI list
;              - It will also paint the correct options
;              - It then jumps into the radio button's normal callback
;           - For the radio buttons, the radio button callback walks the GUI list
;              - The radio button has a pointer to a RAM variable to change,
;                and a value to write
;              - Radio buttons have a group ID byte
;              - Every item in the same group is marked inactive, except the selected one
;     - Eventually, control is passed either to StartGame or SaveAndQuit
;  - StartGame will set bit 7 of selectedGame to show that a game is in progress,
;    and start the game
;  - SaveAndQuit saves all possible information
;     - SaveAndQuit is also called to save an in-progress game when you press MODE
;     - And it's the exact same function the saves an in-progress when upon APD
;     - SaveAndQuit uses the free RAM information discovered at initialization
;       to figure out what it can write
;     - It first empties the appvar
;     - Then incrementally adds memory to the appvar depending on what should be saved
;     - If saving is possible, SaveAndQuit will write all stats
;     - If a game is in-progress and there is sufficient RAM, it save the game
;     - Here's a mystery: Erase the Solitaire appvar, and run Solitaire
;       with less than 200 bytes of free RAM.  Start a game.  Quit using MODE.
;       Solitaire loads all stats fine, but somehow Solitaire knows no game was saved
;       and I have no clue how.  I'm sure I wrote code to handle that;
;       I just can't remember doing so, nor why it works.
;  - Eventually, a game is started
;     - The game will load the stack definitions into RAM
;        - These definitions contain flags for stack,
;          as well position and arrow key navigation information
;     - The game will generate a new game
;     - The game will clear the screen
;     - Control is passed to CardsPlayLoop for both Klondike and FreeCell
;        - This is a lot like GuiEventLoop
;        - Each stack has references to other stacks for arrow key movement
;        - One card is always highlighted by the cursor (currentStack/CurrentCard)
;     - There are callbacks for event keys
;        - These callbacks are where Klondike and FreeCell differ
;     - There's a timer callback, too, which Klondike uses
;  - FreeCell is simpler than Klondike
;     - There's a card under the cursor, and a selected card
;     - The movement routines logic isn't complicated
;        - But there are lots of special checks
;        - For example, movement to free cells is different than to home cells
;        - Also, supermove.  That keep giving me headaches.
;     - FreeCell's undo is better
;       - After every move, FreeCell stores the information necessary to undo the move
;       - This is just 3 bytes!  So a 768-byte buffer can store 256 undo steps!
;       - But there also has to be a count of the total number of undo steps present
;          - This counter is 8-bit, so it only goes from 0 to 255
;       - Undo is implemented as a circular buffer; if you do more than 255 moves,
;         the first move is overwritten, then the second, &c.
;  - Klondike has special needs FreeCell doesn't have
;     - It does special checks for whether you're clicking on the deck graphic
;     - The "waste" (cards from the deck) is a major headache
;        - I didn't feel like working out the logic to make it undoable
;     - The waste keeps card order, but may have empty cards in it
;     - Cards are returned to the waste to the same location they were before
;       unless a card was removed and played in the tableau or foundations
;     - The undo for Klondike sucks
;        - It just saves all variables and the waste
;          so that I don't have to do any thinking
;        - This takes about 128 bytes, so there's a maximum of
;          6 undos in a 768-byte buffer
;  - Both games check for the win condition by looking
;    at the number of cards in the foundations
; 
; Also be aware of:
;  - Custom interrupts drive the keyboard driver and provide timing
;     - The interrupt driver decrements the APD timer,
;       but GuiEventLoop and CardsPlayLoop are responsible for actually handling the APD event
;  - The screen driver requires some different settings than the OS
;     - Text is painted top-to-bottom, left-to-right; most people scan pixels
;       left-to-right, top-to-bottom
;        - I do this so that after a glyph is painted,
;          the cursor is in position for the next glyph
;        - Thus, the left/right LCD window bounds are normally 0/319
;          and cursor position is not explicitly set prior to drawing a glyph
;        - The top/bottom bounds are only ever set when you change line
;        - (In other people's routines, the LCD left/right bounds and cursor position
;          must be set prior to every single glyph!)
;     - All routines use "8-bit" color, in which the high and low bytes are the same
;        - (Recall that the LCD actually wants 16-bit color, packed as 5/6/5 RGB.)

.nolist
.include "ti84pcse.inc"
.list

.include "equates.asm"

;.define	FREECELL_DEBUG
kdMaxSaveSlots	.equ	6;3	; 6 is the max or else you'll corrupt stuff


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
@:	; Disable TI splash screen.
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
	im	1
	in	a, (pMPgAHigh)
	ld	h, a
	in	a, (pMPgA)
	ld	l, a
	ld	(mBasePage), hl

	; Initialize vars, implicitly reset setApdNow and rearchiveSaveVar
.if	mSettings != saveVarFlags
	.error	"Adjust code that initializes mSettings and saveVarFlags.\n"
.endif
	ld	(iy + mSettings), setApdEnabledM

	; This is important
	ld	a, cpu15MHz
	; OK, not really, but it helps a lot.
	out	(pCpuSpeed), a
	
;	res	indicRun, (iy + shiftFlags)

;------ Appvar Check -----------------------------------------------------------
	; Erase stuff
	xor	a
	ld	hl, rngState
	ld	(hl), a
	ld	de, rngState + 1
	ld	bc, end_of_screen_var - rngState - 1
	ldir
	; Initialize variables
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
	; Saving
	;xor	a ; Recycled from above
	ld	(saveError), a
	ld	hl, appvarName
	rst	rMOV9TOOP1
	b_call(_ChkFindSym)
	jp	nc, _dontCreateAppVar
; Appvar not found
	; Create appvar
	ld	a, seLowRam
	ld	(saveError), a
	xor	a		;	ld	hl, saveVarMode
	ld	(saveVarMode), a;	ld	(hl), 0
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
;	ld	de, 10
;	add	hl, de
	b_call(_EnoughMem)
	jr	nc, {@}
	; Not enough RAM to unarchive
	ld	a, seLowRam
	ld	(saveError), a
	xor	a
	ld	(saveVarMode), a
	jp	_appvarStuffDone
@:	; Unarchive variable
	b_call(_Arc_Unarc)
	set	rearchiveSaveVar, (iy + saveVarFlags)
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
	
	; Interrupts
	ld	hl, suspendDelay
	ld	(suspendTimer), hl
	call	SetUpInterrupts
	; These are set higher up
;	set	setApdEnabled, (iy + mSettings)
;	res	setApdNow, (iy + mSettings)
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
	di
	ld	iy, flags
	set	updateSaveVar, (iy + saveVarFlags)
	jr	saveAndQuitCont

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
BuildWordLocaton	.equ	$ + 1
	ld	hl, BUILD
	call	DispDecimal
	ld	hl, 0
	ld	d, 12
	call	Locate
	ld	b, 4
@:	pop	hl
	call	DispHL
	ld	a, ' '
	call	PutC
	djnz	{-1@}
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
	res	updateSaveVar, (iy + saveVarFlags)
saveAndQuitCont:
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
	; Re-enable USB
;	ld	a, 50h
;	out	(57h), a
	im	1
	ei
.ifdef	NEVER
	; Re-enable USB
	; TODO: This doesn't reset port 54h (pUsbSuspendCtrl)
	;Hold the USB controller in reset
	xor	a
	out	(4Ch), a
	;Enable protocol interrupts
	ld	a, 1
	out	(5Bh), a
	ld	a, 0FFh
	out	(87h), a
	xor	a
	out	(92h), a
	ld	a, 0C0h
	out	(57h), a
	in	a, (87h)
	ld	a, 0Eh
	out 	(89h), a
	ld	a, 0FFh
	out	(8Bh), a
	;Release the controller reset
WaitForControllerReset:
	in	a, (4Ch)
	and	2	;bit	1, a
	jr	z, WaitForControllerReset
	ld	a, 8
	out	(4Ch), a
	xor	a
.endif
	; More screen stuff
;	This doesn't need to be cleared because I don't touch it.
;	ld	hl, cmdShadow 
;	ld	de, cmdShadow + 1
;	ld	(hl), '@' ; space
;	ld	bc, 259
;	ldir
;	Actually, this doesn't need to be cleared either.
;	ld	hl, textShadow
;	ld	de, textShadow+1
;	ld	(hl), '!'
;	ld	bc, 259
;	ldir
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
	bit	updateSaveVar, (iy + saveVarFlags)
	jp	z, noSave
	ld	a, (saveVarMode)
	or	a
	jp	z, noSave
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
	b_call(_DelMem)
	; . . . and allocate it back again
	ld	de, (saveAddress)
	inc	de
	inc	de
	ld	hl, saveStatsSize
	b_call(_InsertMem)
	; I'm dubious about whether this is safe. . . .
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
	jr	c, _saveDone
	; Is there a game in progress to save?
	ld	a, (selectedGame)
	bit	7, a
	jr	z, _saveDone
	; Allocate more memory
	push	de
	ld	hl, saveGameSize - saveStatsSize
	b_call(_InsertMem)
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
	jr	c, _saveDone
	; Allocate more memory
	push	de
	ld	hl, saveUndoSize - saveGameSize
	b_call(_InsertMem)
	ld	hl, (saveAddress)
	ld	(hl), saveUndoSize & 255
	inc	hl
	ld	(hl), saveUndoSize >> 8
	pop	de
	ld	hl, undoStack
	ld	bc, 768
	ldir
_saveDone:
	bit	rearchiveSaveVar, (iy + saveVarFlags)
	jr	z, noSave
	ld	hl, appvarName
	rst	rMOV9TOOP1
	b_call(_Arc_Unarc)
noSave:
	b_call(_DelRes)
	bit	setApdNow, (iy + mSettings)
	jr	nz, {@}
	bjump(_JForceCmdNoChar)
@:	bcall(_PowerOff)
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


program_end:


;====== INFORMATION ============================================================
.ifdef	FREECELL_DEBUG
.echo	"\n\nWARNING: FREECELL ALLOWS ALL MOVES\n\n\n"
.endif
.echo	" * INFORMATION & STATISTICS * \n"
.echo	"Build number: ", BUILD, "\n"
.echo	"Main RAM vars: ", end_of_game_vars - start_of_static_vars, " bytes\n"
.echo	"Core saved vars size: ", end_of_game_vars - first_saved_var, " bytes\n"
.echo	" * SIZES * \n"
.echo	"ScanKeyboard size: ", ScanKeyboardEnd - ScanKeyboardSource, " bytes\n"
.echo	"RawGetCSC size: ", RawGetCSCEnd - RawGetCSCSource, " bytes\n"
.echo	"RealIsr size: ", RealIsrEnd - RealIsrSource, " bytes\n"
.echo	"FixPage size: ", FixPageEnd - FixPageSource, " bytes\n"
.echo	"Initialization & termination code size: ", generic_stuff_end - generic_stuff_start, " bytes\n"
.echo	"Main menu size: ", mainmenu_end - mainmenu_start, " bytes\n"
.echo	" Main menu GUI elemnts: ", gui_table_end - gui_table_start, " bytes\n"
.echo	" Main menu RAM GUI elements: ", gui_table_end - guiRam_start, " bytes\n"
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
.echo	" Non-sprites data size: ", sprites_start - data_start, " bytes\n"
.echo	" Sprites data size: ", data_end - sprites_start, " bytes\n"
.echo	"Font size: ", font_end - font_start, " bytes\n"
.echo	"Total program code & data: ", program_end - program_start, " bytes\n"
.echo	"Space remaining: ", 7FBBh - program_end, " bytes\n"
.ifdef	FREECELL_DEBUG
.echo	"\n\nWARNING: FREECELL ALLOWS ALL MOVES\n\n\n"
.endif
;.echo	" size: ", _end - _start, " bytes"
;.echo	"\n"