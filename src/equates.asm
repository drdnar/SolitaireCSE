; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.

; This file contains offsets of memory locations and constants that replace
; ti83plus.inc or ti84pcse.inc .

#define equ	.equ

; This macro prints a value in hex
.deflong EchoByte(x)
	.if (x) < 10h
		.echo	"0"
	.elseif (x) < 20h
		.echo	"1"
	.elseif (x) < 30h
		.echo	"2"
	.elseif (x) < 40h
		.echo	"3"
	.elseif (x) < 50h
		.echo	"4"
	.elseif (x) < 60h
		.echo	"5"
	.elseif (x) < 70h
		.echo	"6"
	.elseif (x) < 80h
		.echo	"7"
	.elseif (x) < 90h
		.echo	"8"
	.elseif (x) < 0A0h
		.echo	"9"
	.elseif (x) < 0B0h
		.echo	"A"
	.elseif (x) < 0C0h
		.echo	"B"
	.elseif (x) < 0D0h
		.echo	"C"
	.elseif (x) < 0E0h
		.echo	"D"
	.elseif (x) < 0F0h
		.echo	"E"
	.elseif (x) < 100h
		.echo	"F"
	.else
		.echo	"?"
	.endif
	.if (x % 10h) == 0
		.echo "0"
	.elseif (x % 10h) == 1
		.echo "1"
	.elseif (x % 10h) == 2
		.echo "2"
	.elseif (x % 10h) == 3
		.echo "3"
	.elseif (x % 10h) == 4
		.echo "4"
	.elseif (x % 10h) == 5
		.echo "5"
	.elseif (x % 10h) == 6
		.echo "6"
	.elseif (x % 10h) == 7
		.echo "7"
	.elseif (x % 10h) == 8
		.echo "8"
	.elseif (x % 10h) == 9
		.echo "9"
	.elseif (x % 10h) == 10
		.echo "A"
	.elseif (x % 10h) == 11
		.echo "B"
	.elseif (x % 10h) == 12
		.echo "C"
	.elseif (x % 10h) == 13
		.echo "D"
	.elseif (x % 10h) == 14
		.echo "E"
	.elseif (x % 10h) == 15
		.echo "F"
	.else
		.echo "?"
	.endif
.enddeflong

; This macro prints a value in hex
.deflong EchoWord(x)
	.if (x) < 1000h
		.echo	"0"
	.elseif (x) < 2000h
		.echo	"1"
	.elseif (x) < 3000h
		.echo	"2"
	.elseif (x) < 4000h
		.echo	"3"
	.elseif (x) < 5000h
		.echo	"4"
	.elseif (x) < 6000h
		.echo	"5"
	.elseif (x) < 7000h
		.echo	"6"
	.elseif (x) < 8000h
		.echo	"7"
	.elseif (x) < 9000h
		.echo	"8"
	.elseif (x) < 0A000h
		.echo	"9"
	.elseif (x) < 0B000h
		.echo	"A"
	.elseif (x) < 0C000h
		.echo	"B"
	.elseif (x) < 0D000h
		.echo	"C"
	.elseif (x) < 0E000h
		.echo	"D"
	.elseif (x) < 0F000h
		.echo	"E"
	.elseif (x) < 10000h
		.echo	"F"
	.else
		.echo	"?"
	.endif
	.if ((x) % 1000h) < 100h
		.echo "0"
	.elseif ((x) % 1000h) < 200h
		.echo "1"
	.elseif ((x) % 1000h) < 300h
		.echo "2"
	.elseif ((x) % 1000h) < 400h
		.echo "3"
	.elseif ((x) % 1000h) < 500h
		.echo "4"
	.elseif ((x) % 1000h) < 600h
		.echo "5"
	.elseif ((x) % 1000h) < 700h
		.echo "6"
	.elseif ((x) % 1000h) < 800h
		.echo "7"
	.elseif ((x) % 1000h) < 900h
		.echo "8"
	.elseif ((x) % 1000h) < 0A00h
		.echo "9"
	.elseif ((x) % 1000h) < 0B00h
		.echo "A"
	.elseif ((x) % 1000h) < 0C00h
		.echo "B"
	.elseif ((x) % 1000h) < 0D00h
		.echo "C"
	.elseif ((x) % 1000h) < 0E00h
		.echo "D"
	.elseif ((x) % 1000h) < 0F00h
		.echo "E"
	.elseif ((x) % 1000h) < 10000h
		.echo "F"
	.else
		.echo "!"
	.endif
	.if ((x) % 100h) < 10h
		.echo "0"
	.elseif ((x) % 100h) < 20h
		.echo "1"
	.elseif ((x) % 100h) < 30h
		.echo "2"
	.elseif ((x) % 100h) < 40h
		.echo "3"
	.elseif ((x) % 100h) < 50h
		.echo "4"
	.elseif ((x) % 100h) < 60h
		.echo "5"
	.elseif ((x) % 100h) < 70h
		.echo "6"
	.elseif ((x) % 100h) < 80h
		.echo "7"
	.elseif ((x) % 100h) < 90h
		.echo "8"
	.elseif ((x) % 100h) < 0A0h
		.echo "9"
	.elseif ((x) % 100h) < 0B0h
		.echo "A"
	.elseif ((x) % 100h) < 0C0h
		.echo "B"
	.elseif ((x) % 100h) < 0D0h
		.echo "C"
	.elseif ((x) % 100h) < 0E0h
		.echo "D"
	.elseif ((x) % 100h) < 0F0h
		.echo "E"
	.elseif ((x) % 100h) < 1000h
		.echo "F"
	.else
		.echo "!"
	.endif
	.if ((x) % 10h) == 0
		.echo "0"
	.elseif ((x) % 10h) == 1
		.echo "1"
	.elseif ((x) % 10h) == 2
		.echo "2"
	.elseif ((x) % 10h) == 3
		.echo "3"
	.elseif ((x) % 10h) == 4
		.echo "4"
	.elseif ((x) % 10h) == 5
		.echo "5"
	.elseif ((x) % 10h) == 6
		.echo "6"
	.elseif ((x) % 10h) == 7
		.echo "7"
	.elseif ((x) % 10h) == 8
		.echo "8"
	.elseif ((x) % 10h) == 9
		.echo "9"
	.elseif ((x) % 10h) == 10
		.echo "A"
	.elseif ((x) % 10h) == 11
		.echo "B"
	.elseif ((x) % 10h) == 12
		.echo "C"
	.elseif ((x) % 10h) == 13
		.echo "D"
	.elseif ((x) % 10h) == 14
		.echo "E"
	.elseif ((x) % 10h) == 15
		.echo "F"
	.else
		.echo "?"
	.endif
.enddeflong

;------ Version ----------------------------------------------------------------
; This is quite a hack.
; It converts the build number constant into an ASCII string.
; If you've got a better way to do this, I'd love to hear it.
; Update: unknownln suggested using Brass's looping structure, so I'll keep that
; in mind for the future.
.include "build_number.asm"
.define VERSION_1a ((BUILD) % 10)
.define VERSION_2a ((BUILD) % 100)
.define VERSION_3a ((BUILD) % 1000)
.define VERSION_4a ((BUILD) % 10000)
.define VERSION_5a ((BUILD) % 100000)
.define VERSION_6a ((BUILD) % 1000000)
.define VERSION_6b (VERSION_6a - VERSION_5a)
.define VERSION_5b (VERSION_5a - VERSION_4a)
.define VERSION_4b (VERSION_4a - VERSION_3a)
.define VERSION_3b (VERSION_3a - VERSION_2a)
.define VERSION_2b (VERSION_2a - VERSION_1a)
.define VERSION_1b (VERSION_1a)
.define VERSION_1c (VERSION_1b)
.define VERSION_2c (VERSION_2b / 10)
.define VERSION_3c (VERSION_3b / 100)
.define VERSION_4c (VERSION_4b / 1000)
.define VERSION_5c (VERSION_5b / 10000)
.define VERSION_6c (VERSION_6b / 100000)
.if	BUILD < 10
	.define	VERSION		('0' + VERSION_1c)
.elseif	BUILD < 100
	.define	VERSION		('0' + VERSION_2c), ('0' + VERSION_1c)
.elseif	BUILD < 1000
	.define	VERSION		('0' + VERSION_3c), ('0' + VERSION_2c), ('0' + VERSION_1c)
.elseif	BUILD < 10000
	.define	VERSION		('0' + VERSION_4c), ('0' + VERSION_3c), ('0' + VERSION_2c), ('0' + VERSION_1c)
.elseif	BUILD < 100000
	.define	VERSION		('0' + VERSION_5c), ('0' + VERSION_4c), ('0' + VERSION_3c), ('0' + VERSION_2c), ('0' + VERSION_1c)
.else
	.define	VERSION		('0' + VERSION_6c), ('0' + VERSION_5c), ('0' + VERSION_4c), ('0' + VERSION_3c), ('0' + VERSION_2c), ('0' + VERSION_1c)
.endif


;------ Macros -----------------------------------------------------------------

; Reads the value of an LCD register into HL
.deflong getLcdRegHl(regnum)
	ld a, regnum
	out (pLcdCmd), a
	out (pLcdCmd), a
	in a, (pLcdData)
	ld h, a
	in a, (pLcdData)
	ld l, a
.enddeflong

; Sets the value of an LCD register using HL
.deflong setLcdRegHl(regnum)
	ld a, regnum
	out (pLcdCmd), a
	out (pLcdCmd), a
	ld a, h
	out (pLcdData), a
	ld a, l
	out (pLcdData), a
.enddeflong

; Sets the value of an LCD register
; Both fixed constants and 8-bit registers (other than A) can be used
.deflong setLcdReg(regnum, highbyte, lowbyte)
	ld a, regnum
	out (pLcdCmd), a
	out (pLcdCmd), a
	ld a, highbyte
	out (pLcdData), a
	ld a, lowbyte
	out (pLcdData), a
.enddeflong

; Sets the value of an LCD register
; The value must be a fixed constant
.deflong setLcdDReg(regnum, double)
	ld a, regnum
	out (pLcdCmd), a
	out (pLcdCmd), a
	ld a, lcdHigh(double)
	out (pLcdData), a
	ld a, lcdLow(double)
	out (pLcdData), a
.enddeflong

; Standard optimized in-line routine
.deflong cpHlDe
	or	a
	sbc	hl, de
	add	hl, de
.enddeflong

; Standard optimized in-line routine
.deflong cpHlBc
	or	a
	sbc	hl, bc
	add	hl, bc
.enddeflong


;------ Structs ----------------------------------------------------------------
; 32-bit page/address pointer


;------ Main Memory Layout Settings --------------------------------------------
; Scrap memory usage:
;  - plotSScreen: Used for interrupts
;  - textShadow: Used for main variables
;  - statVars: Used for stacks
;  - saveSScreen: Used for GUI RAM
;  - saveSScreen: Planned for undo stack
;  - appData: Used for storing deck
;plotSScreen	equ	987Ch
;saveSScreen	equ	8798h
;textShadow	equ	08560h	; 260 bytes
;cmdShadow	equ	09BAAh ; Also expanded, but don't use this unless you want some crazy clean-up code
;statVars		equ	8C1Ch	; scrap 531 (clear b_call(_DelRes))
;appData	equ	8000h
stacks		.equ	statVars
guiRam		.equ	saveSScreen
deck		.equ	appData
undoStack	.equ	saveSScreen

start_of_static_vars	.equ	textShadow
; 9A01 is not free! It's the last byte of the IVT.
IvtLocation	.equ	99h ; vector table at 9900h
IsrLocation	.equ	98h ; ISR at 9898h


;------ ISR Resident Routines --------------------------------------------------
FixPage		.equ	987Ch	; Max 28 bytes
RawGetCSC	.equ	98A0h	; Max 96 bytes
RealIsr		.equ	9A01h	; Max 239 bytes
ScanKeyboard	.equ	9AF0h	; Max 140 bytes
;9B7C
;9A01 379 bytes


;------ Character Constants ----------------------------------------------------
chQuotes	.equ	22h
chNewLine	.equ	01h
ch1stPrintableChar	.equ	0Ah
chBackGraphic	.equ	0Ah
chClubsGraphic	.equ	0Bh
chSmallClub	.equ	0Ch
chSmallDiamond	.equ	0Dh
chSmallHeart	.equ	0Eh
chSmallSpade	.equ	0Fh
chCurBlank	.equ	10h
chThickSpace	.equ	10h
chCurLine	.equ	11h
chCurBlack	.equ	12h
chCurHash	.equ	13h
chAlpha		.equ	14h
chBeta		.equ	15h
chEmptyBullet	.equ	16h
chFilledBullet	.equ	17h
chArrowUp	.equ	18h
chArrowDown	.equ	19h
chArrowLeft	.equ	1Ah
chArrowRight	.equ	1Bh
chClub		.equ	1Ch
chDiamond	.equ	1Dh
chHeart		.equ	1Eh
chSpade		.equ	1Fh
chThinSpace	.equ	7Fh


;------ Screen & Text ----------------------------------------------------------
colorScrnHeight = 240
colorScrnWidth = 320
minBacklightLevel = 32
defaultBrightness = 10h
charHeight = 12
charWidth = 10


;------ Settings ---------------------------------------------------------------
; Timers
; Sets how many half-seconds elapse until APD
suspendDelay	.equ	2 * 60 * 3
; Sets the frequency at which the keyboard is scanned
kbdScanDivisor		.equ	10	; The below values are multiples of 10.24 ms
; A key must be held this long to be accepted
minKeyHoldTime		.equ	3	; 
; A key must remain up for this long before it is registered as being released
keyBlockTime		.equ	1	; 
; This controls how long the wait until a held key starts repeating
keyFirstRepeatWaitTime	.equ	20	; 
; This controls how often a held key repeats
keyRepeatWaitTime	.equ	10	; 
; This controls how long to wait between toggling the cursor
cursorPeriod		.equ	200h


;------ Flags ------------------------------------------------------------------
; These are used by the text input routines
saveVarFlags		.equ	asm_Flag1
updateSaveVar		.equ	0
updateSaveVarM		.equ	1
rearchiveSaveVar	.equ	1
rearchiveSaveVarM	.equ	2
mKbdFlags		.equ	asm_Flag1
; Set to display error cursor
kbdCurErr		.equ	2
; Set to show cursor
kbdCurAble		.equ	3
kbdCurOn		.equ	4
; True if the cursor timer has counted down to zero since the last time this was reset
kbdCurFlash		.equ	5
kbdCurFlashM		.equ	20h

mSettings		.equ	asm_Flag1
; Set if the system's APD timer has expired, so an APD is needed now
setApdNow		.equ	6
setApdNowM		.equ	40h
; Set if APD should be enabled
setApdEnabled		.equ	7
setApdEnabledM		.equ	80h

; Flags used by GUI routines
guiFlags		.equ	asm_Flag2
cursorShowing		.equ	0
cursorShowingM		.equ	1
entryEmpty		.equ	1

; Unused flags:
;asm_Flag3		equ 23h	;ASM CODING
;xapFlag0		equ 2Eh	;external app flags, do not use 0,(iy+2Eh) (used by mouse routines)
;xapFlag1		equ 2Fh
;xapFlag2		equ 30h
;xapFlag3		equ 31h


;------ Cards ------------------------------------------------------------------
; These equates come from MS cards.dll, which is used in MS Solitaire and MS
; FreeCell.  These need to be same so that FreeCell generates the MS 32000.
cardBlack	.equ	0
cardRed		.equ	1

suitClub	.equ	0
suitDiamond	.equ	1
suitHeart	.equ	2
suitSpade	.equ	3
suitMask	.equ	3

rankAce		.equ	0
rankJack	.equ	10
rankQueen	.equ	11
rankKing	.equ	12
rankMask	.equ	3Ch

cardFlagsMask	.equ	0C0h

rankA		.equ	4 * 0
rank2		.equ	4 * 1
rank3		.equ	4 * 2
rank4		.equ	4 * 3
rank5		.equ	4 * 4
rank6		.equ	4 * 5
rank7		.equ	4 * 6
rank8		.equ	4 * 7
rank9		.equ	4 * 8
rank10		.equ	4 * 9
rankJ		.equ	4 * 10
rankQ		.equ	4 * 11
rankK		.equ	4 * 12

;------ Colors -----------------------------------------------------------------
colorBlack	.equ	00
colorGreen	.equ	04	; 06 for normal maximum saturation green
colorBrGreen	.equ	06
colorNavyBlue	.equ	08
colorDarkBlue	.equ	10h
colorBlue	.equ	18h
colorDarkGray	.equ	6Bh
colorGray	.equ	0B5h
colorRed	.equ	0E0h
colorYellow	.equ	0E7h
colorWhite	.equ	0FFh
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
; E7	28, 31.5,  7	224, 252,   0	Yellow
; FF	31,   31, 31	255, 255, 255	White		White


;------ Vars -------------------------------------------------------------------

;start_of_static_vars .equ saveSScreen
; General Variables
; start_of_static_vars is defined in the equates_bw or equates_pcse

; This is a function of the layout of the below variables.
SAVE_EARLIEST_SUPPORTED_VERSION	.equ	577

; GAME STUFF
; Used when the ISR was in RAM, so Solitaire could be paged back in on-demand
mBasePage	.equ	start_of_static_vars
; 32-bit state of MS LCG PRNG
rngState	.equ	mBasePage + 2
; When Solitaire is running, this specifies what CAN be saved.
; In the save appvar, this specifies what IS saved.
; 0 = Saving unavailable, 1 = Stats only, 2 = In-progress game, 3 = Game + undo stack
saveVarMode	.equ	rngState + 4
saveDisabled	.equ	0
saveStatsOnly	.equ	1
saveGameOnly	.equ	2
saveFull	.equ	3
; Estimate of minimum free RAM for an appvar with stats only
saveStatsSize	.equ	83
; Estimate for saved-game
saveGameSize	.equ	183
; Estimate for saved-game with undo
saveUndoSize	.equ	(saveGameSize + 770)
; Used during start-up to remember any errors encountered with the save appvar.
saveError	.equ	saveVarMode + 1
seLowRam	.equ	1	; Cannot save due to low RAM
seVersion	.equ	2	; Cannot load due to incompatible version
seAppvarInUse	.equ	3	; Cannot access appvar because it's not a Solitaire appvar
; Pointer to appvar in RAM.  Garbage if saveError is not zero.
saveAddress	.equ	saveError + 1
; Remembers the current game mode selected/in-progress. 0 = Klondike, 1 = FreeCell
; Bit 7 is set if a game is in-progress; this is how SaveAndQuit knows what to do.
selectedGame	.equ	saveAddress + 2
klondikeGame	.equ	0
freeCellGame	.equ	1
; Number of cards to draw.  Don't set this to zero or more than four; it'll behave strangely.
kdDrawCount	.equ	selectedGame + 1
; Zero if timer disabled; non-zero if timer enabled
kdTimed		.equ	kdDrawCount + 1
; Selects the scoring mode. 0 = normal, 1 = Vegas, 3 = Vegas and cumulative
kdScoringMode	.equ	kdTimed + 1
; Pointer to location in deck to which cards in waste should be returned.
; (There aren't separate stacks.  Why should there be?)
kdDeckLoc	.equ	kdScoringMode + 2	; Don't reorder this and kdDeckMode and kdScore
; Controls the behavior of the deck.
; 0 = No cards drawn, due to being at the start of the deck
; 1 = Cards drawn and in middle of deck
; 2 = End of deck.  Next draw will move to 0, and not display any new cards
; 3 = Deck disabled.  Used if out of cards, and in Vegas mode.
kdDeckMode	.equ	kdDeckLoc + 2
; Current score.  Signed.
kdScore		.equ	kdDeckMode + 1
; Current time, in half-seconds.  Rotate right to get full seconds.
kdTime		.equ	kdScore + 2
; One-byte flag that is set to true if the score and time display needs to be changed.
; This get checked continuously.
kdDirtyStats	.equ	kdTime + 2
; A bunch of stats
kdHighScore	.equ	kdDirtyStats + 1
kdGamesQuit	.equ	kdHighScore + 2
kdGamesWon	.equ	kdGamesQuit + 2
; 16-bit initializer for PRNG.  Literally specifies the game number.
fcGameNumber	.equ	kdGamesWon + 2
; Previous game number.  Kept for user's benefit.
fcPreviousGame	.equ	fcGameNumber + 2
; Number of free cells.  You'll have to reorganize the U/I to support more than six.
fcFreeCells	.equ	fcPreviousGame + 2
; Moves count
fcMoves		.equ	fcFreeCells + 2
; Statistics
fcGamesQuit	.equ	fcMoves + 2
fcGamesWon	.equ	fcGamesQuit + 2
; This us primarily used by the GUI's number input routine for storing the number being entered.
; It's also used in Klondike and FreeCell as a temporary variable.
guiTemp		.equ	fcGamesWon + 2
; Function to execute when F1 is pressed, or null if none.
f1GuiCallback	.equ	guiTemp + 2
; Function to execute when F2 is pressed, or null if none.
f2GuiCallback	.equ	f1GuiCallback + 2
; 2nd/Enter key callback in game loop
selectCardCallback	.equ	f2GuiCallback + 2
; Alpha key callback in game loop
selectCard2Callback	.equ	selectCardCallback + 2
; F1 callback in game loop
f1Callback	.equ	selectCard2Callback + 2
; F2 callback in game loop
f2Callback	.equ	f1Callback + 2
; F4 callback in game loop
f4Callback	.equ	f2Callback + 2
; F5 callback in game loop
f5Callback	.equ	f4Callback + 2
; Callback to execute after every interrupt in game loop, or null if none
cardTimerCallback	.equ	f5Callback + 2
; Current depth in stack the cursor is on
currentDepth	.equ	cardTimerCallback + 2
; Cursor's current stack
currentStack	.equ	currentDepth + 1
; Same for the selected card
selectedDepth	.equ	currentStack + 1
selectedStack	.equ	selectedDepth + 1
; Slot number of NEXT slot into which undo data will be written
undoNextSlot	.equ	selectedStack + 1
; Number of undo slots that have data in them
undosExtant	.equ	undoNextSlot + 1
end_of_game_vars	.equ	undosExtant + 1
first_saved_var	.equ	selectedGame


; APD
; This is intended to be looped once a second.
genFastTimer	.equ	end_of_game_vars
; This holds the number of cursor flashes left until APD is triggered
suspendTimer	.equ	genFastTimer + 2
end_of_apd_vars	.equ	suspendTimer + 2

; KEYBOARD
; This controls when the keyboard is scanned
kbdScanTimer		.equ	end_of_apd_vars
; These variables are all used for debouncing
lastKey			.equ	kbdScanTimer + 1	; Normally 0
lastKeyHoldTimer	.equ	lastKey + 1		; Normally minKeyHoldTime
lastKeyBlockTimer	.equ	lastKeyHoldTimer + 1	; Normally keyBlockTime
lastKeyFirstRepeatTimer	.equ	lastKeyBlockTimer + 1	; Normally keyFirstRepeatWaitTime
lastKeyRepeatTimer	.equ	lastKeyFirstRepeatTimer + 1	; Normally keyRepeatWaitTime
; Last accepted keycode
keyBuffer		.equ	lastKeyRepeatTimer + 1	; Normally 0
; When this reaches zero, a flag is set, indicating the cursor should flash
cursorTimer		.equ	keyBuffer + 1
end_of_kbd_vars	.equ	cursorTimer + 2

; SCREEN
; Colors
textColors	.equ	end_of_kbd_vars
textForeColor	.equ	textColors
textBackColor	.equ	textForeColor + 1
; Current text cursor location
lcdRow		.equ	textBackColor + 1
lcdCol		.equ	lcdRow + 1
lcdNewLineCol	.equ	lcdCol + 2
end_of_screen_var	.equ	lcdNewLineCol + 2