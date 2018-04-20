; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.

; This file contains some miscellaneous data:
;  - Appvar stuff
;  - Dialogs
;  - Sprites not in the font file
;     - The font has the card backing graphic

appvarName:
	.db	AppVarObj, "Solitair"
appvarHeader:
	.db	"Solitaire", 0
	.dw	BUILD
appvarHeader_end:


statsDialog:
	.dw	MainMenu._statsCallback			; Post-draw callback
	.dw	MainMenu				; Button 1 callback
	.dw	MainMenu._about				; Button 2 callback
	.db	"SOLITAIRE STATS", 0			; Title text
	.db	"Klondike high score:", 0		; Line 1
	.db	"Klondike games won:", 0		; Line 2
	.db	"Klondike games forfeit:", 0		; Line 3
	.db	"FreeCell games won:", 0		; Line 4
	.db	"FreeCell games forfeit:", 0		; Line 5
	.db	"Previous game number:", 0		; Line 6
	.db	"", 0					; Line 7
	.db	"", 0					; Line 8
	.db	"OK", 0					; Button 1 text
	.db	"ABOUT", 0				; Button 2 text
aboutDialog:
	.dw	0					; Post-draw callback
	.dw	MainMenu				; Button 1 callback
	.dw	MainMenu._stats				; Button 2 callback
	.db	"ABOUT SOLITAIRE", 0			; Title text
	.db	"Written by Dr. D'nar.", 0		; Line 1
	.db	"", 0					; Line 2
	.db	"Optimization by Xeda.", 0		; Line 3
	.db	"", 0					; Line 4
	.db	"", 0					; Line 5
	.db	"", 0					; Line 6
	.db	"", 0					; Line 7
	.db	"", 0					; Line 8
	.db	"OK", 0					; Button 1 text
	.db	"STATS", 0				; Button 2 text
freeCellWinDialog:
	.dw	freeCellWinDrawback			; Post-draw callback
	.dw	StartFreeCell				; Button 1 callback
	.dw	MainMenu				; Button 2 callback
	.db	"YOU WIN", 0				; Title text
	.db	"Game:", 0				; Line 1
	.db	"Moves:", 0				; Line 2
	.db	"", 0					; Line 3
	.db	"", 0					; Line 4
	.db	"", 0					; Line 5
	.db	"", 0					; Line 6
	.db	"", 0					; Line 7
	.db	"", 0					; Line 8
	.db	"AGAIN", 0				; Button 1 text
	.db	"QUIT", 0				; Button 2 text
abortDialog:
	.dw	0					; Post-draw callback
	.dw	DoScreenRedraw				; Button 1 callback
	.dw	DoForfeit				; Button 2 callback
	.db	"FORFEIT GAME?", 0			; Title text
	.db	"Your progress will not be saved.", 0	; Line 1
	.db	"(Use MODE to save and quit.)", 0	; Line 2
	.db	"", 0					; Line 3
	.db	"", 0					; Line 4
	.db	"", 0					; Line 5
	.db	"", 0					; Line 6
	.db	"", 0					; Line 7
	.db	"", 0					; Line 8
	.db	"RESUME", 0				; Button 1 text
	.db	"FORFEIT", 0				; Button 2 texterr
klondikeWinDialog:
	.dw	klondikeWinDrawback			; Post-draw callback
	.dw	StartKlondike				; Button 1 callback
	.dw	MainMenu				; Button 2 callback
	.db	"YOU WIN", 0				; Title text
	.db	"Score:", 0				; Line 1
	.db	"High score:", 0			; Line 2
	.db	"Time:", 0				; Line 3
	.db	"Time bonus: ", 0			; Line 4
	.db	"Games won:", 0				; Line 5
	.db	"Games forfeit:", 0			; Line 6
	.db	"", 0					; Line 7
	.db	"", 0					; Line 8
	.db	"AGAIN", 0				; Button 1 text
	.db	"QUIT", 0				; Button 2 text
errLowRam:
	.dw	0					; Post-draw callback
	.dw	MainMenu				; Button 1 callback
	.dw	Quit					; Button 2 callback
	.db	"LOW RAM", 0				; Title text
	.db	"There is not enough free RAM for", 0	; Line 1
	.db	"the save appvar. Archive or delete", 0	; Line 2
	.db	"some variables.", 0			; Line 3
	.db	"", 0					; Line 4
	.db	"", 0					; Line 5
	.db	"", 0					; Line 6
	.db	"If you continue, the save feature", 0	; Line 7
	.db	"will not function.", 0			; Line 8
	.db	"OK", 0					; Button 1 text
	.db	"QUIT", 0				; Button 2 text
errVersion:
	.dw	0					; Post-draw callback
	.dw	MainMenu				; Button 1 callback
	.dw	Quit					; Button 2 callback
	.db	"VERSION MISMATCH", 0			; Title text
	.db	"The save appvar is not compatible", 0	; Line 1
	.db	"with this version of Solitaire.", 0	; Line 2
	.db	"Delete the appvar, or load the", 0	; Line 3
	.db	"matching version of Solitaire.", 0	; Line 4
	.db	"", 0					; Line 5
	.db	"", 0					; Line 6
	.db	"If you continue, the save feature", 0	; Line 7
	.db	"will not function.", 0			; Line 8
	.db	"OK", 0					; Button 1 text
	.db	"QUIT", 0				; Button 2 text
errAppvarInUse:
	.dw	0					; Post-draw callback
	.dw	MainMenu				; Button 1 callback
	.dw	Quit					; Button 2 callback
	.db	"APPVAR IN USE", 0			; Title text
	.db	"An appvar named Solitair has been", 0	; Line 1
	.db	"created by another application.", 0	; Line 2
	.db	"Solitaire needs an appvar named", 0	; Line 3
	.db	"Solitair for the game save feature.", 0; Line 4
	.db	"Delete or rename the appvar.", 0	; Line 5
	.db	"", 0					; Line 6
	.db	"If you continue, the save feature", 0	; Line 7
	.db	"will not function.", 0			; Line 8
	.db	"OK", 0					; Button 1 text
	.db	"QUIT", 0				; Button 2 text


;====== Sprites ================================================================
sprites_start:
;.if	$ & 0FFh >= 0FFh
;	.db	0
;.endif
;.if	$ & 0FFh >= 0FEh
;	.db	0
;.endif
;.if	$ & 0FFh >= 0FDh
;	.db	0
;.endif
;.if	$ & 0FFh >= 0FCh
;	.db	0
;.endif


;suitClub	.equ	0
;suitDiamond	.equ	1
;suitHeart	.equ	2
;suitSpade	.equ	3
faceCardsSprites:
	.dw	spJackOfClubs		; J C
	.dw	spJackOfDiamonds	; J D
	.dw	spJackOfHearts		; J H
	.dw	spJackOfSpades		; J S
	.dw	spQueenOfClubs		; Q C
	.dw	spQueenOfDiamonds	; Q D
	.dw	spQueenOfHearts		; Q H
	.dw	spQueenOfSpades		; Q S
	.dw	spKingOfClubs		; K C
	.dw	spKingOfDiamonds	; K D
	.dw	spKingOfHearts		; K H
	.dw	spKingOfSpades		; K S

fourColorPalette:
	.db	colorBlack
	.db	colorRed
	.db	colorYellow
	.db	colorWhite
Bk	.equ	0
Rd	.equ	1
Yw	.equ	2
Wh	.equ	3

;altFourColorPalette:
;	.db	colorBlack
;	.db	colorRed
;	.db	colorDarkBlue
;	.db	colorWhite
;Bl	.equ	2

.define	px(a, b, c, d)	a | (b << 2) | (c << 4) | (d << 6)

; struct sprite
; {
;	word palettePtr;
;	byte data[];
; }
spJackOfClubs:
	.dw	fourColorPalette
 .db px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Rd,Bk),px(Rd,Bk,Rd,Bk),px(Rd,Bk,Rd,Bk),px(Rd,Bk,Bk,Wh)
 .db px(Yw,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Rd,Rd),px(Bk,Rd,Rd,Rd),px(Bk,Rd,Rd,Rd),px(Bk,Rd,Bk,Wh)
 .db px(Bk,Yw,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Bk,Wh)
 .db px(Yw,Yw,Yw,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Rd,Rd,Rd),px(Rd,Bk,Wh,Wh)
 .db px(Bk,Yw,Bk,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh)
 .db px(Yw,Yw,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Bk,Bk,Wh,Wh)
 .db px(Bk,Yw,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Yw,Yw,Bk,Wh)
 .db px(Yw,Yw,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Wh,Bk,Bk),px(Bk,Wh,Wh,Yw),px(Bk,Yw,Yw,Wh)
 .db px(Bk,Yw,Bk,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Wh,Bk),px(Bk,Wh,Wh,Yw),px(Yw,Yw,Bk,Wh)
 .db px(Yw,Yw,Bk,Wh),px(Bk,Bk,Bk,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Yw),px(Bk,Yw,Yw,Wh)
 .db px(Bk,Yw,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Yw),px(Yw,Yw,Bk,Wh)
 .db px(Yw,Yw,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Yw),px(Bk,Yw,Yw,Wh)
 .db px(Bk,Yw,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Yw,Yw,Bk,Wh)
 .db px(Yw,Yw,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Bk,Yw,Yw,Wh)
 .db px(Bk,Yw,Wh,Bk),px(Bk,Bk,Bk,Bk),px(Wh,Bk,Wh,Wh),px(Bk,Bk,Bk,Bk),px(Bk,Wh,Wh,Yw),px(Yw,Yw,Bk,Wh)
 .db px(Yw,Yw,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Bk,Yw,Yw,Wh)
 .db px(Bk,Yw,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Yw,Yw,Bk,Wh)
 .db px(Yw,Yw,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Rd),px(Bk,Bk,Bk,Bk),px(Bk,Rd,Bk,Wh),px(Bk,Yw,Yw,Wh)
 .db px(Bk,Yw,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Rd,Wh,Bk),px(Rd,Rd,Rd,Rd),px(Rd,Bk,Wh,Rd),px(Rd,Bk,Yw,Wh)
 .db px(Yw,Yw,Bk,Wh),px(Wh,Wh,Bk,Rd),px(Yw,Rd,Rd,Wh),px(Bk,Rd,Rd,Rd),px(Bk,Wh,Rd,Rd),px(Yw,Bk,Bk,Wh)
 .db px(Bk,Yw,Bk,Wh),px(Bk,Bk,Rd,Rd),px(Bk,Yw,Rd,Rd),px(Wh,Bk,Rd,Bk),px(Wh,Rd,Rd,Yw),px(Bk,Rd,Rd,Bk)
 .db px(Yw,Yw,Bk,Bk),px(Rd,Rd,Rd,Rd),px(Rd,Bk,Yw,Rd),px(Rd,Wh,Bk,Wh),px(Rd,Rd,Yw,Bk),px(Rd,Rd,Rd,Rd)
 .db px(Bk,Yw,Bk,Rd),px(Rd,Yw,Yw,Yw),px(Yw,Yw,Bk,Yw),px(Rd,Rd,Bk,Rd),px(Rd,Yw,Bk,Yw),px(Yw,Yw,Yw,Rd)
 .db px(Yw,Yw,Bk,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Rd,Bk),px(Yw,Rd,Bk,Rd),px(Yw,Bk,Rd,Rd),px(Rd,Rd,Rd,Rd)
 .db px(Bk,Yw,Bk,Rd),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Bk,Yw,Bk,Yw),px(Bk,Yw,Yw,Yw),px(Yw,Yw,Yw,Rd)
spJackOfDiamonds:
	.dw	fourColorPalette
 .db px(Wh,Bk,Wh,Rd),px(Wh,Rd,Wh,Rd),px(Wh,Rd,Wh,Rd),px(Wh,Rd,Bk,Bk),px(Wh,Wh,Wh,Wh),px(Rd,Wh,Wh,Wh)
 .db px(Wh,Bk,Rd,Wh),px(Rd,Rd,Rd,Wh),px(Rd,Rd,Rd,Wh),px(Rd,Rd,Bk,Wh),px(Wh,Wh,Wh,Rd),px(Rd,Rd,Wh,Wh)
 .db px(Wh,Bk,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Bk,Wh),px(Wh,Wh,Rd,Rd),px(Rd,Rd,Rd,Wh)
 .db px(Wh,Wh,Bk,Rd),px(Rd,Rd,Rd,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Rd,Rd),px(Rd,Rd,Rd,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Rd),px(Rd,Rd,Wh,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Rd,Wh,Wh,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Yw,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Yw,Wh,Wh,Bk),px(Bk,Bk,Wh,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Yw,Wh,Wh,Bk),px(Bk,Wh,Wh,Bk),px(Bk,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Yw,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Rd,Bk,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Yw,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Yw,Wh,Wh,Wh),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Yw,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Yw,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Rd,Wh,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Yw,Wh,Wh,Bk),px(Bk,Bk,Bk,Bk),px(Wh,Wh,Bk,Wh),px(Wh,Bk,Rd,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Yw,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Bk,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Wh,Bk,Rd,Bk),px(Bk,Bk,Bk,Bk),px(Rd,Bk,Wh,Bk),px(Wh,Wh,Wh,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Wh,Yw,Bk,Rd),px(Rd,Wh,Bk,Rd),px(Rd,Rd,Rd,Rd),px(Bk,Wh,Rd,Rd),px(Bk,Wh,Wh,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Wh,Bk,Bk,Yw),px(Rd,Rd,Wh,Bk),px(Rd,Rd,Rd,Bk),px(Wh,Rd,Rd,Yw),px(Rd,Bk,Wh,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Bk,Rd,Rd,Bk),px(Yw,Rd,Rd,Wh),px(Bk,Rd,Bk,Wh),px(Rd,Rd,Yw,Bk),px(Rd,Rd,Bk,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Rd,Rd,Rd,Rd),px(Bk,Yw,Rd,Rd),px(Wh,Bk,Wh,Rd),px(Rd,Yw,Bk,Rd),px(Rd,Rd,Rd,Rd),px(Bk,Rd,Bk,Wh)
 .db px(Rd,Yw,Yw,Yw),px(Yw,Bk,Yw,Rd),px(Rd,Bk,Rd,Rd),px(Yw,Bk,Yw,Yw),px(Yw,Yw,Yw,Rd),px(Rd,Bk,Bk,Wh)
 .db px(Rd,Rd,Rd,Rd),px(Rd,Rd,Bk,Yw),px(Rd,Bk,Rd,Yw),px(Bk,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Bk,Bk,Wh)
 .db px(Rd,Yw,Yw,Yw),px(Yw,Yw,Yw,Bk),px(Yw,Bk,Yw,Bk),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Rd,Bk,Bk,Wh)
spJackOfHearts:
	.dw	fourColorPalette
 .db px(Wh,Bk,Rd,Wh),px(Rd,Wh,Rd,Wh),px(Rd,Wh,Rd,Wh),px(Rd,Wh,Bk,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Rd,Rd),px(Wh,Rd,Rd,Rd),px(Wh,Rd,Rd,Rd),px(Wh,Rd,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Bk,Rd),px(Rd,Rd,Rd,Rd),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Rd,Wh),px(Rd,Wh,Wh,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Rd,Rd,Rd),px(Rd,Rd,Wh,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Yw,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Rd,Rd,Rd),px(Rd,Rd,Wh,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Yw,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Bk,Wh,Bk,Wh),px(Wh,Wh,Rd,Rd),px(Rd,Wh,Wh,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Yw,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Bk,Wh,Bk,Wh),px(Wh,Wh,Wh,Rd),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Yw,Bk,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Yw,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Yw,Wh,Bk,Wh),px(Wh,Wh,Bk,Bk),px(Wh,Wh,Bk,Bk),px(Wh,Wh,Yw,Bk),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Yw,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Bk,Yw,Yw),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Yw,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Bk,Yw,Yw),px(Bk,Bk,Bk,Wh)
 .db px(Wh,Bk,Yw,Yw),px(Yw,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Bk,Yw,Yw),px(Bk,Bk,Bk,Wh)
 .db px(Wh,Yw,Yw,Bk),px(Yw,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Yw,Yw),px(Bk,Wh,Bk,Wh)
 .db px(Yw,Bk,Yw,Yw),px(Yw,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Yw,Bk),px(Bk,Wh,Bk,Wh)
 .db px(Yw,Yw,Yw,Bk),px(Yw,Wh,Bk,Wh),px(Bk,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh)
 .db px(Yw,Bk,Yw,Yw),px(Yw,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh)
 .db px(Yw,Yw,Yw,Bk),px(Yw,Bk,Bk,Bk),px(Bk,Bk,Bk,Yw),px(Rd,Rd,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh)
 .db px(Yw,Bk,Yw,Yw),px(Yw,Rd,Rd,Rd),px(Rd,Rd,Rd,Bk),px(Yw,Rd,Rd,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh)
 .db px(Yw,Yw,Yw,Bk),px(Yw,Rd,Yw,Rd),px(Yw,Rd,Yw,Rd),px(Bk,Yw,Rd,Rd),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh)
 .db px(Yw,Yw,Yw,Rd),px(Rd,Rd,Yw,Rd),px(Yw,Rd,Yw,Rd),px(Yw,Bk,Yw,Rd),px(Rd,Wh,Bk,Wh),px(Wh,Wh,Bk,Wh)
 .db px(Rd,Rd,Rd,Rd),px(Rd,Bk,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Rd,Rd,Bk,Yw),px(Rd,Rd,Wh,Bk),px(Wh,Wh,Bk,Wh)
 .db px(Rd,Yw,Bk,Rd),px(Bk,Yw,Bk,Yw),px(Bk,Yw,Bk,Yw),px(Bk,Rd,Yw,Bk),px(Yw,Rd,Rd,Bk),px(Wh,Wh,Bk,Wh)
 .db px(Yw,Rd,Rd,Rd),px(Rd,Bk,Rd,Bk),px(Rd,Bk,Rd,Bk),px(Rd,Rd,Rd,Rd),px(Bk,Yw,Rd,Bk),px(Wh,Wh,Bk,Wh)
spJackOfSpades:
	.dw	fourColorPalette
 .db px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Bk,Rd),px(Bk,Rd,Bk,Rd),px(Bk,Rd,Bk,Rd),px(Bk,Rd,Bk,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Rd,Bk),px(Rd,Rd,Rd,Bk),px(Rd,Rd,Rd,Bk),px(Rd,Rd,Bk,Wh)
 .db px(Wh,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh),px(Wh,Bk,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Bk,Wh)
 .db px(Wh,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Rd,Rd,Rd,Rd),px(Rd,Bk,Wh,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Yw),px(Yw,Yw,Bk,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Bk,Yw,Yw,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Yw),px(Yw,Yw,Bk,Wh)
 .db px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Yw),px(Bk,Yw,Yw,Wh)
 .db px(Wh,Bk,Rd,Bk),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Yw),px(Yw,Yw,Bk,Wh)
 .db px(Bk,Yw,Yw,Yw),px(Bk,Wh,Wh,Wh),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Yw),px(Bk,Yw,Yw,Wh)
 .db px(Wh,Bk,Yw,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Yw,Yw,Bk,Wh)
 .db px(Bk,Yw,Bk,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Bk,Yw,Yw,Wh)
 .db px(Bk,Yw,Rd,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Yw,Yw,Bk,Wh)
 .db px(Bk,Yw,Bk,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Bk,Yw,Yw,Wh)
 .db px(Wh,Bk,Yw,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Yw,Yw,Bk,Yw)
 .db px(Bk,Yw,Bk,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Bk,Yw,Yw,Yw)
 .db px(Bk,Yw,Rd,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Yw),px(Yw,Yw,Bk,Yw)
 .db px(Bk,Yw,Bk,Yw),px(Bk,Wh,Wh,Wh),px(Bk,Rd,Wh,Rd),px(Rd,Bk,Bk,Bk),px(Bk,Bk,Bk,Yw),px(Bk,Yw,Yw,Yw)
 .db px(Wh,Bk,Yw,Bk),px(Wh,Wh,Wh,Bk),px(Rd,Wh,Rd,Wh),px(Rd,Wh,Rd,Wh),px(Rd,Wh,Rd,Yw),px(Yw,Yw,Bk,Yw)
 .db px(Bk,Yw,Bk,Yw),px(Bk,Wh,Bk,Rd),px(Yw,Rd,Wh,Rd),px(Rd,Bk,Rd,Rd),px(Wh,Rd,Rd,Bk),px(Rd,Yw,Yw,Yw)
 .db px(Bk,Yw,Rd,Yw),px(Bk,Bk,Rd,Yw),px(Wh,Rd,Rd,Rd),px(Bk,Wh,Bk,Rd),px(Rd,Rd,Bk,Wh),px(Bk,Rd,Wh,Rd)
 .db px(Bk,Rd,Bk,Rd),px(Bk,Rd,Yw,Wh),px(Bk,Rd,Wh,Rd),px(Rd,Bk,Rd,Rd),px(Wh,Rd,Rd,Bk),px(Rd,Rd,Wh,Rd)
 .db px(Bk,Yw,Rd,Yw),px(Bk,Yw,Wh,Bk),px(Rd,Wh,Rd,Wh),px(Rd,Wh,Rd,Wh),px(Rd,Wh,Rd,Wh),px(Rd,Wh,Rd,Wh)
 .db px(Bk,Yw,Bk,Yw),px(Bk,Wh,Bk,Rd),px(Rd,Rd,Wh,Rd),px(Rd,Bk,Rd,Rd),px(Wh,Rd,Rd,Bk),px(Rd,Rd,Wh,Rd)
spQueenOfClubs:
	.dw	fourColorPalette
 .db px(Wh,Wh,Wh,Rd),px(Yw,Yw,Yw,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Yw),px(Yw,Yw,Bk,Bk),px(Rd,Rd,Rd,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Yw,Yw),px(Yw,Bk,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Yw,Yw,Yw,Yw),px(Bk,Rd,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Yw,Yw,Yw,Bk),px(Rd,Wh,Bk,Wh),px(Bk,Wh,Bk,Wh),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Bk,Rd),px(Yw,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Rd,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Yw,Rd),px(Bk,Wh,Wh,Bk),px(Bk,Bk,Wh,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Rd,Rd),px(Bk,Wh,Wh,Bk),px(Bk,Wh,Wh,Bk),px(Bk,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Rd,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Bk,Bk),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Rd,Yw,Rd),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Yw,Rd,Rd),px(Bk,Wh,Wh,Wh),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Bk,Wh)
 .db px(Wh,Rd,Rd,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Rd,Yw,Rd),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Rd,Rd),px(Bk,Wh,Wh,Bk),px(Bk,Bk,Bk,Bk),px(Wh,Wh,Bk,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh)
 .db px(Wh,Rd,Rd,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Yw,Rd),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Rd,Bk),px(Rd,Rd,Yw,Rd),px(Bk,Bk,Bk,Rd),px(Yw,Rd,Rd,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Bk,Rd),px(Bk,Yw,Bk,Rd),px(Yw,Rd,Yw,Rd),px(Bk,Yw,Bk,Rd),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Rd,Rd),px(Rd,Bk,Rd,Yw),px(Bk,Rd,Bk,Yw),px(Rd,Bk,Rd,Rd),px(Rd,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Bk,Yw,Yw,Rd),px(Rd,Rd,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Rd,Rd,Yw),px(Yw,Yw,Bk,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Bk,Yw),px(Rd,Rd,Rd,Bk),px(Wh,Bk,Wh,Bk),px(Bk,Rd,Yw,Bk),px(Wh,Bk,Yw,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Rd,Rd,Wh,Bk),px(Yw,Rd,Bk,Bk),px(Yw,Bk,Yw,Bk),px(Rd,Yw,Bk,Rd),px(Rd,Rd,Bk,Yw),px(Bk,Wh,Wh,Wh)
 .db px(Rd,Rd,Rd,Bk),px(Yw,Rd,Rd,Bk),px(Yw,Bk,Yw,Bk),px(Bk,Yw,Wh,Rd),px(Wh,Rd,Wh,Yw),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Rd,Rd,Wh),px(Yw,Rd,Bk,Bk),px(Wh,Bk,Wh,Bk),px(Rd,Yw,Bk,Rd),px(Rd,Rd,Bk,Yw),px(Bk,Wh,Wh,Wh)
spQueenOfDiamonds:
	.dw	fourColorPalette
 .db px(Wh,Wh,Wh,Rd),px(Yw,Rd,Yw,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Yw),px(Yw,Yw,Bk,Bk),px(Rd,Rd,Rd,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Yw,Yw),px(Yw,Bk,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Yw,Yw,Yw,Yw),px(Bk,Rd,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Rd,Yw,Yw,Bk),px(Rd,Wh,Bk,Wh),px(Bk,Wh,Bk,Wh),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Bk,Rd),px(Yw,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Yw,Rd),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Rd,Yw),px(Bk,Wh,Wh,Bk),px(Bk,Bk,Wh,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Rd,Rd),px(Bk,Wh,Wh,Bk),px(Bk,Wh,Wh,Bk),px(Bk,Wh,Bk,Wh),px(Wh,Wh,Wh,Rd),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Yw,Rd),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Rd,Rd),px(Rd,Wh,Wh,Wh)
 .db px(Wh,Rd,Rd,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Rd,Rd,Rd),px(Rd,Rd,Wh,Wh)
 .db px(Wh,Yw,Rd,Rd),px(Bk,Wh,Wh,Wh),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Rd,Rd,Rd),px(Rd,Rd,Wh,Wh)
 .db px(Wh,Rd,Yw,Rd),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Rd,Rd),px(Rd,Wh,Wh,Wh)
 .db px(Wh,Rd,Rd,Yw),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Rd),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Rd,Rd),px(Bk,Wh,Wh,Bk),px(Bk,Bk,Bk,Bk),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Yw,Rd),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Rd,Yw),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Rd,Bk),px(Rd,Rd,Wh,Rd),px(Bk,Bk,Bk,Rd),px(Wh,Rd,Rd,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Rd,Bk,Rd),px(Bk,Wh,Rd,Rd),px(Wh,Rd,Wh,Rd),px(Rd,Wh,Bk,Rd),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Rd,Rd),px(Rd,Bk,Rd,Wh),px(Bk,Rd,Bk,Wh),px(Rd,Bk,Rd,Rd),px(Rd,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Bk,Yw,Yw,Rd),px(Rd,Rd,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Rd,Rd,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Yw,Yw,Yw),px(Rd,Rd,Rd,Bk),px(Wh,Bk,Wh,Bk),px(Bk,Rd,Bk,Yw),px(Bk,Yw,Bk,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Bk,Bk,Wh,Yw),px(Yw,Rd,Bk,Bk),px(Yw,Bk,Yw,Bk),px(Rd,Wh,Yw,Wh),px(Bk,Wh,Yw,Wh),px(Bk,Wh,Wh,Wh)
 .db px(Rd,Rd,Bk,Yw),px(Yw,Rd,Rd,Bk),px(Yw,Bk,Yw,Bk),px(Bk,Wh,Bk,Bk),px(Wh,Bk,Bk,Wh),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Rd,Bk,Wh),px(Yw,Rd,Bk,Bk),px(Wh,Bk,Wh,Bk),px(Rd,Wh,Yw,Wh),px(Bk,Wh,Yw,Wh),px(Bk,Wh,Wh,Wh)
spQueenOfHearts:
	.dw	fourColorPalette
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Yw,Yw,Yw),px(Rd,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Rd,Rd,Rd),px(Bk,Bk,Yw,Yw),px(Yw,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Bk,Yw),px(Yw,Yw,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Bk,Wh),px(Bk,Wh,Rd,Bk),px(Yw,Yw,Yw,Yw)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Rd),px(Bk,Yw,Yw,Yw)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Yw),px(Rd,Bk,Yw,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Yw,Rd,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Wh,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Rd,Yw,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Wh,Bk),px(Bk,Wh,Wh,Bk),px(Rd,Rd,Yw,Wh)
 .db px(Wh,Wh,Wh,Rd),px(Wh,Rd,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Yw,Rd,Rd,Wh)
 .db px(Wh,Wh,Rd,Rd),px(Rd,Rd,Rd,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Yw,Rd,Wh)
 .db px(Wh,Wh,Rd,Rd),px(Rd,Rd,Rd,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Bk),px(Rd,Rd,Yw,Wh)
 .db px(Wh,Wh,Wh,Rd),px(Rd,Rd,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Yw,Rd,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Rd,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Yw,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Bk,Bk,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Rd,Rd,Yw,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Yw,Rd,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Rd,Yw,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Rd,Rd,Yw),px(Rd,Bk,Bk,Bk),px(Rd,Yw,Rd,Rd),px(Bk,Rd,Yw,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Bk,Yw,Bk),px(Rd,Yw,Rd,Yw),px(Rd,Bk,Yw,Bk),px(Rd,Bk,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Rd),px(Rd,Rd,Bk,Rd),px(Yw,Bk,Rd,Bk),px(Yw,Rd,Bk,Rd),px(Rd,Rd,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Bk,Yw,Yw),px(Yw,Rd,Rd,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Rd,Rd),px(Rd,Yw,Yw,Bk)
 .db px(Wh,Wh,Wh,Wh),px(Bk,Yw,Bk,Wh),px(Bk,Yw,Rd,Bk),px(Bk,Wh,Bk,Wh),px(Bk,Rd,Rd,Rd),px(Yw,Bk,Bk,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Yw,Bk,Rd,Rd),px(Rd,Bk,Yw,Rd),px(Bk,Yw,Bk,Yw),px(Bk,Bk,Rd,Yw),px(Bk,Wh,Rd,Rd)
 .db px(Wh,Wh,Wh,Bk),px(Yw,Wh,Rd,Wh),px(Rd,Wh,Yw,Bk),px(Bk,Yw,Bk,Yw),px(Bk,Rd,Rd,Yw),px(Bk,Rd,Rd,Rd)
 .db px(Wh,Wh,Wh,Bk),px(Yw,Bk,Rd,Rd),px(Rd,Bk,Yw,Rd),px(Bk,Wh,Bk,Wh),px(Bk,Bk,Rd,Yw),px(Wh,Rd,Rd,Wh)
spQueenOfSpades:
	.dw	fourColorPalette
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Yw,Rd,Yw),px(Rd,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Rd,Rd,Rd),px(Bk,Bk,Yw,Yw),px(Yw,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Bk,Yw),px(Yw,Yw,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Bk,Wh),px(Bk,Wh,Rd,Bk),px(Yw,Yw,Yw,Yw)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Rd),px(Bk,Yw,Yw,Rd)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Yw),px(Rd,Bk,Yw,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Yw,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Wh,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Yw,Rd,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Wh,Bk),px(Bk,Wh,Wh,Bk),px(Rd,Rd,Yw,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Bk,Bk,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Yw,Rd,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Yw,Rd,Rd,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Bk),px(Rd,Rd,Yw,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Bk,Bk,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Yw,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Yw,Rd,Rd,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Bk,Bk,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Bk,Bk,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Rd,Rd,Yw,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Yw,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Yw,Rd,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Rd,Rd,Wh),px(Rd,Bk,Bk,Bk),px(Rd,Wh,Rd,Rd),px(Bk,Rd,Yw,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Bk,Wh,Rd),px(Rd,Wh,Rd,Wh),px(Rd,Rd,Wh,Bk),px(Rd,Bk,Rd,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Rd),px(Rd,Rd,Bk,Rd),px(Wh,Bk,Rd,Bk),px(Wh,Rd,Bk,Rd),px(Rd,Rd,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Rd,Rd,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Rd,Rd),px(Rd,Yw,Yw,Bk)
 .db px(Wh,Wh,Wh,Wh),px(Bk,Bk,Yw,Bk),px(Yw,Bk,Rd,Bk),px(Bk,Wh,Bk,Wh),px(Bk,Rd,Rd,Rd),px(Yw,Yw,Yw,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Wh,Yw,Wh,Bk),px(Wh,Yw,Wh,Rd),px(Bk,Yw,Bk,Yw),px(Bk,Bk,Rd,Yw),px(Yw,Wh,Bk,Bk)
 .db px(Wh,Wh,Wh,Bk),px(Wh,Bk,Bk,Wh),px(Bk,Bk,Wh,Bk),px(Bk,Yw,Bk,Yw),px(Bk,Rd,Rd,Yw),px(Yw,Bk,Rd,Rd)
 .db px(Wh,Wh,Wh,Bk),px(Wh,Yw,Wh,Bk),px(Wh,Yw,Wh,Rd),px(Bk,Wh,Bk,Wh),px(Bk,Bk,Rd,Yw),px(Wh,Bk,Rd,Wh)
spKingOfClubs:
	.dw	fourColorPalette
 .db px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Yw,Rd),px(Yw,Rd,Yw,Rd),px(Yw,Rd,Yw,Rd),px(Yw,Bk,Bk,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Bk,Bk,Wh)
 .db px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Yw,Yw,Yw),px(Yw,Bk,Wh,Wh)
 .db px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Rd,Rd,Rd),px(Rd,Bk,Wh,Wh)
 .db px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh)
 .db px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Bk,Bk,Wh,Wh)
 .db px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Wh,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Wh,Bk),px(Bk,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Bk,Bk,Rd),px(Bk,Bk,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh),px(Bk,Bk,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Bk,Bk,Bk,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Bk,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Bk,Yw,Bk,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Bk,Yw),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Bk,Bk,Bk),px(Bk,Bk,Wh,Bk),px(Rd,Wh,Yw,Bk),px(Rd,Bk,Bk,Bk),px(Rd,Bk,Yw,Wh),px(Rd,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Yw),px(Rd,Rd,Rd,Yw),px(Bk,Rd,Rd,Rd),px(Bk,Yw,Rd,Rd),px(Rd,Yw,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Bk,Bk,Rd,Rd),px(Rd,Wh,Rd,Rd),px(Yw,Bk,Rd,Bk),px(Yw,Rd,Rd,Wh),px(Rd,Rd,Rd,Bk)
 .db px(Wh,Wh,Wh,Bk),px(Rd,Rd,Rd,Wh),px(Rd,Rd,Rd,Wh),px(Rd,Yw,Bk,Yw),px(Rd,Wh,Rd,Rd),px(Rd,Wh,Rd,Yw)
 .db px(Wh,Wh,Bk,Yw),px(Rd,Wh,Rd,Rd),px(Rd,Wh,Rd,Rd),px(Yw,Yw,Rd,Yw),px(Yw,Rd,Rd,Wh),px(Rd,Rd,Rd,Yw)
 .db px(Wh,Wh,Bk,Yw),px(Rd,Rd,Rd,Wh),px(Rd,Rd,Rd,Bk),px(Bk,Bk,Rd,Bk),px(Bk,Bk,Rd,Rd),px(Rd,Wh,Rd,Yw)
 .db px(Wh,Wh,Bk,Yw),px(Rd,Wh,Rd,Rd),px(Rd,Wh,Rd,Rd),px(Yw,Yw,Rd,Yw),px(Yw,Rd,Rd,Wh),px(Rd,Rd,Rd,Yw)
spKingOfDiamonds:
	.dw	fourColorPalette
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Rd,Yw),px(Rd,Yw,Rd,Yw),px(Rd,Yw,Rd,Yw),px(Rd,Bk,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Bk,Bk,Wh)
 .db px(Wh,Wh,Wh,Rd),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Bk,Wh,Wh)
 .db px(Wh,Wh,Rd,Rd),px(Rd,Wh,Wh,Wh),px(Wh,Wh,Bk,Bk),px(Bk,Bk,Bk,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Bk,Wh,Wh)
 .db px(Wh,Rd,Rd,Rd),px(Rd,Rd,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh)
 .db px(Wh,Rd,Rd,Rd),px(Rd,Rd,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh),px(Bk,Bk,Wh,Wh)
 .db px(Wh,Wh,Rd,Rd),px(Rd,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Rd),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Bk,Bk,Yw,Wh),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Yw,Bk,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Bk,Bk,Bk),px(Wh,Yw,Bk,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Bk,Bk,Bk),px(Wh,Yw,Bk,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Yw,Bk,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Bk,Bk,Yw,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Bk),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Wh,Bk,Wh),px(Bk,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Yw,Yw,Yw),px(Yw,Bk,Yw,Bk),px(Yw,Bk,Yw,Bk),px(Yw,Bk,Wh,Wh)
 .db px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Yw,Yw,Rd,Rd),px(Rd,Yw,Rd,Yw),px(Rd,Yw,Rd,Yw),px(Rd,Yw,Bk,Wh)
 .db px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Yw,Bk)
 .db px(Wh,Bk,Wh,Wh),px(Wh,Bk,Yw,Rd),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Rd,Rd)
 .db px(Wh,Bk,Wh,Wh),px(Bk,Rd,Rd,Rd),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Rd,Rd)
 .db px(Wh,Wh,Wh,Wh),px(Bk,Yw,Rd,Rd),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Rd,Rd)
 .db px(Wh,Wh,Wh,Wh),px(Bk,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Rd,Rd)
spKingOfHearts:
	.dw	fourColorPalette
 .db px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Rd,Rd,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Bk,Yw,Rd),px(Yw,Rd,Yw,Rd),px(Yw,Rd,Yw,Rd),px(Yw,Bk,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Bk,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Rd,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Yw,Yw,Yw),px(Yw,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Bk),px(Bk,Bk,Bk,Bk),px(Bk,Rd,Rd,Rd),px(Rd,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Bk,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Bk,Wh,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Rd,Wh),px(Rd,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Wh,Bk),px(Bk,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Rd,Rd,Rd),px(Rd,Rd,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Rd,Rd,Rd),px(Rd,Rd,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Wh,Rd,Rd),px(Rd,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Rd),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh),px(Bk,Bk,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Bk,Wh,Bk,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Bk,Bk),px(Wh,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Bk,Rd,Bk,Bk),px(Bk,Yw,Bk,Rd),px(Rd,Rd,Bk,Yw),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Rd,Rd,Rd,Bk),px(Yw,Yw,Yw,Bk),px(Rd,Bk,Rd,Yw),px(Rd,Bk,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Rd),px(Bk,Wh,Rd,Rd),px(Bk,Yw,Bk,Bk),px(Bk,Rd,Rd,Yw),px(Rd,Yw,Bk,Wh)
spKingOfSpades:
	.dw	fourColorPalette
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Bk),px(Rd,Yw,Rd,Yw),px(Rd,Yw,Rd,Yw),px(Rd,Yw,Rd,Bk),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Wh,Wh,Bk,Bk),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Yw),px(Yw,Yw,Yw,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Bk,Bk),px(Bk,Bk,Wh,Bk),px(Rd,Rd,Rd,Rd),px(Bk,Bk,Bk,Bk),px(Bk,Bk,Bk,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Bk,Bk),px(Bk,Bk,Wh,Bk),px(Bk,Bk,Bk,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Bk,Bk,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Bk,Bk,Bk,Wh),px(Bk,Bk,Bk,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Bk,Bk),px(Bk,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Bk,Bk,Wh,Wh),px(Bk,Bk,Wh,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Wh,Bk,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Wh,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Wh,Wh),px(Bk,Bk,Bk,Bk),px(Bk,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh),px(Wh,Wh,Wh,Wh),px(Wh,Wh,Bk,Wh),px(Bk,Wh,Wh,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Wh,Bk,Wh,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Wh,Bk,Wh),px(Bk,Bk,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Wh,Wh,Bk),px(Wh,Bk,Bk,Bk),px(Wh,Bk,Wh,Bk),px(Wh,Bk,Bk,Bk),px(Wh,Wh,Wh,Wh)
 .db px(Wh,Bk,Wh,Bk),px(Wh,Wh,Wh,Wh),px(Bk,Yw,Bk,Rd),px(Rd,Rd,Rd,Rd),px(Rd,Rd,Bk,Yw),px(Bk,Wh,Wh,Wh)
 .db px(Bk,Bk,Bk,Bk),px(Bk,Wh,Wh,Bk),px(Rd,Bk,Yw,Bk),px(Rd,Wh,Wh,Wh),px(Rd,Bk,Yw,Bk),px(Rd,Bk,Wh,Wh)
 .db px(Wh,Wh,Bk,Wh),px(Wh,Wh,Bk,Yw),px(Rd,Rd,Rd,Yw),px(Bk,Rd,Rd,Rd),px(Bk,Yw,Rd,Rd),px(Rd,Yw,Bk,Wh)
 .db px(Wh,Wh,Bk,Wh),px(Bk,Bk,Rd,Rd),px(Rd,Bk,Rd,Rd),px(Yw,Bk,Rd,Bk),px(Yw,Rd,Rd,Bk),px(Rd,Rd,Rd,Bk)
 .db px(Wh,Wh,Wh,Bk),px(Rd,Rd,Rd,Bk),px(Rd,Rd,Rd,Bk),px(Rd,Yw,Bk,Yw),px(Rd,Bk,Rd,Rd),px(Rd,Bk,Rd,Yw)
 .db px(Wh,Wh,Bk,Yw),px(Rd,Bk,Rd,Rd),px(Rd,Bk,Rd,Rd),px(Yw,Yw,Rd,Yw),px(Yw,Rd,Rd,Bk),px(Rd,Rd,Rd,Yw)
 .db px(Wh,Wh,Bk,Yw),px(Rd,Rd,Rd,Bk),px(Rd,Rd,Rd,Bk),px(Bk,Bk,Rd,Bk),px(Bk,Bk,Rd,Rd),px(Rd,Bk,Rd,Yw)
 .db px(Wh,Wh,Bk,Yw),px(Rd,Bk,Rd,Rd),px(Rd,Bk,Rd,Rd),px(Yw,Yw,Rd,Yw),px(Yw,Rd,Rd,Bk),px(Rd,Rd,Rd,Yw)
