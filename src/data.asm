; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.


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


;------ Sprites ----------------------------------------------------------------
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

fourColorPalette:
	.db	colorBlack
	.db	colorRed
	.db	colorYellow
	.db	colorWhite
cBk	.equ	0
cRd	.equ	1
cYw	.equ	2
cWh	.equ	3

.define	px(a, b, c, d)	a | (b << 2) | (c << 4) | (d << 6)

; struct sprite
; {
;	byte width;
;	byte height;
;	word palettePtr;
;	byte data[];
; }

;sprite1:
;	.db	24
;	.db	25
;	.dw	fourColorPalette
;	.db	px(cWh, cWh, cWh, cRd), px(cBk, cRd, cBk, cRd), &c.
