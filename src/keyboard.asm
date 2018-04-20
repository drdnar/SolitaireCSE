; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.


.module	Keyboard


;------ GetKeyBlinky -----------------------------------------------------------
GetKeyBlinky:
; Gets a key while blinking a cursor.
; Input:
;  - Cursor location properly configured
; Output:
;  - 
	call	CursorOn
_gkbl:	halt
	call	GetCSC
	or	a
	jr	nz, _gkbd
	bit	kbdCurFlash, (iy + mKbdFlags)
	jr	z, _gkbl
	res	kbdCurFlash, (iy + mKbdFlags)
	call	ToggleCursor
	jr	_gkbl
_gkbd:	push	af
	call	ToggleCursorOff
	pop	af
	ret


;------ CursorOn ---------------------------------------------------------------
CursorOn:
; Resets the cursor timer.
; Inputs:
;  - None
; Outputs:
;  - Timer reset
; Destroys:
;  - F
	push	hl
	ld	hl, cursorPeriod
	ld	(cursorTimer), hl
	pop	hl
	res	kbdCurFlash, (iy + mKbdFlags)
	res	kbdCurOn, (iy + mKbdFlags)


;------ ToggleCursor -----------------------------------------------------------
ToggleCursor:
; Toggles the displayed cursor.
; Inputs:
;  - None
; Output:
;  - Cursor toggled
; Destroys:
;  - AF
;  - HL
	bit	kbdCurOn, (iy + mKbdFlags)
	jr	z, _tcon
	res	kbdCurOn, (iy + mKbdFlags)
ToggleCursorOff:
	ld	hl, (lcdCol)
	push	hl
	ld	a, chCurBlank
	call	PutC
	pop	hl
	ld	(lcdCol), hl
	jp	SetCharCol
_tcon:	set	kbdCurOn, (iy + mKbdFlags)
	ld	hl, (lcdCol)
	push	hl
	ld	a, chCurLine
	bit	kbdCurErr, (iy + mKbdFlags)
	jr	z, _tcopc
	ld	a, chCurHash
_tcopc:	call	PutC
	pop	hl
	ld	(lcdCol), hl
	jp	SetCharCol


;------ GetKey -----------------------------------------------------------------
GetKey:
; Waits for a keypress, and returns it.
; This may APD.
; Interrupts must be enabled.
; Inputs:
;  - None
; Output:
;  - Scan code in A
; Destroys:
;  - Nothing
	call	GetCSC
	or	a
	ret	nz
	ei
	halt
	jr	GetKey


;------ GetCSC -----------------------------------------------------------------
GetCSC:
; Returns the most recent keypress and removes it from the key queue.
; Inputs:
;  - None
; Output:
;  - Scan code in A
; Destroys:
;  - Nothing
	ld	a, (keyBuffer)
	push	af
	xor	a
	ld	(keyBuffer), a
	pop	af
	ret


;------ PeekCSC ----------------------------------------------------------------
PeekCSC:
; Returns the most recent keypress but leaves it in the key queue.
; This is a pretty dumb routine.
; Inputs:
;  - None
; Output:
;  - Scan code in A
; Destroys:
;  - Nothing
	ld	a, (keyBuffer)
	ret


;------ Scan Keyboard ----------------------------------------------------------
;	.dw	ScanKeyboardEnd - ScanKeyboardSource
ScanKeyboardSource:
;ScanKeyboard:
; Implements the core logic used for keyboard scanning, including timing for
; debouncing.
; You can call this manually if interrupts are disabled, but you will need to do
; so at about 50 Hz or the debouncing timing will be strange.
; Inputs:
;  - None
; Output:
;  - Documented effect (s)
; Destroys:
;  - AF
;  - BC
;  - HL
	call	RawGetCSC
; Key repeat logic:
; Key must be held for at least minKeyHoldTime before press registers.
; Thereafter, the same key code will not be accepted after release for keyBlockTime.
; As long as the key is being held, reissue the keypress to keyBuffer every keyRepeatWaitTime.
	; Any code?
	or	a
	jr	nz, _dontReleaseKey
	ld	a, (lastKey)
	or	a
	ret	z
	; Otherwise, begin blocking timer
	ld	a, (lastKeyBlockTimer)
	dec	a
	ld	(lastKeyBlockTimer), a
	ret	nz
	; The timer has expired, so allow the key again
	ld	(lastKey), a	; already 0
	ret
_dontReleaseKey:
	ld	l, a	; Save code for a moment
	; Reset the blocking timer
	ld	a, keyBlockTime
	ld	(lastKeyBlockTimer), a
	; Is the registered key the same as the last key?
	; This also covers the 0 case.
	ld	a, (lastKey)
	cp	l
	jr	nz, _newKey	; If not, accept the new key
	; It's the same old key, so decrement the hold timer
	ld	a, (lastKeyHoldTimer)
	or	a
	jr	nz, _decHoldTimer
	; Wait, the key has already been accepted.
	; Check if we're already in repeat mode, or need to wait
	ld	a, (lastKeyFirstRepeatTimer)
	or	a
	jr	z, _ska	; Repeat mode
	dec	a
	ld	(lastKeyFirstRepeatTimer), a
	ret	;jr	noKeys
_ska:	; OK, so we're in repeat mode.  Now do the reapeat timer.
	ld	a, (lastKeyRepeatTimer)
	or	a
	jr	z, _acceptKeypress	; The key was previously accepted, AND it's now ready to be reissued.
	dec	a
	ld	(lastKeyRepeatTimer), a
	ret
_decHoldTimer:
	dec	a
	ld	(lastKeyHoldTimer), a
	jr	z, _acceptKeypress
	; This key isn't ripe yet, so ignore it for now.
	ret
_newKey:	; Save the key code
	ld	a, l
	ld	(lastKey), a
	; Reset timers
	ld	hl, keyBlockTime*256 + minKeyHoldTime
	ld	(lastKeyHoldTimer), hl
	ld	hl, keyRepeatWaitTime*256 + keyFirstRepeatWaitTime
	ld	(lastKeyFirstRepeatTimer), hl
	; Now RET, and leave decrementing the debouncing timers for the next
	; interrupt cycle
	ret
_acceptKeypress:
	; Reset timers
	ld	a, keyBlockTime
	ld	(lastKeyBlockTimer), a
	ld	a, keyRepeatWaitTime
	ld	(lastKeyRepeatTimer), a
	ld	hl, suspendDelay
	ld	(suspendTimer), hl
	; Now write the key to the buffer
	ld	a, (lastKey)
	ld	(keyBuffer), a
	ret
ScanKeyboardEnd:


;------ GetCSC -----------------------------------------------------------------
;	.dw	RawGetCSCEnd - RawGetCSCSource
RawGetCSCSource:
;RawGetCSC:
; Scans the keyboard matrix for any pressed key, returning the first it finds,
; or 0 if none.
; Inputs:
;  - None
; Output:
;  - Code in A, or 0 if none
; Destroys:
;  - BC
	ld	a, 0FFh
	out	(pKey), a
	pop	af
	push	af
	ld	bc, 07BFh
_gcsca:	; Matrix scan loop
	ld	a, c
	out	(pKey), a
	rrca
	ld	c, a
	pop	af	; Probably should waste at least 20 cycles here.
	push	af	
;	push	ix
;	pop	ix
	in	a, (pKey)
	cp	0ffh
	jr	nz, _gcscb	; Any key pressed?
	djnz	_gcsca
	; No keys pressed in any key group, so return 0.
	xor	a
	ret
_gcscb:	; Yay! Found a key, now form a scan code
	dec	b
	sla	b
	sla	b
	sla	b
	; Get which bit in A is reset
_gcscc:	rrca
	inc	b
	jr	c, _gcscc
	ld	a, b
	ret
RawGetCSCEnd:


;------ ------------------------------------------------------------------------
.endmodule