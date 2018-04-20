; This program is free software. It comes without any warranty, to
; the extent permitted by applicable law. You can redistribute it
; and/or modify it under the terms of the Do What The Fuck You Want
; To Public License, Version 2, as published by Sam Hocevar. See
; http://sam.zoy.org/wtfpl/COPYING for more details.

.module	Interrupts


;------ ApdOn ------------------------------------------------------------------
;ApdOn:
; ApdOn
; Enables the APD function.
; Inputs:
;  - None
; Outputs:
;  - None
; Destroys:
;  - AF
;	set	setApdEnabled, (iy + mSettings)
;	ret


;------ ApdOff -----------------------------------------------------------------
;ApdOff:
; ApdOff
; Disables the APD function.
; Inputs:
;  - None
; Outputs:
;  - None
; Destroys:
;  - AF
;	res	setApdEnabled, (iy + mSettings)
;	ret


;------ SetUpInterrupts --------------------------------------------------------
SetUpInterrupts:
; Sets up the IM 2 interrupt system, but does not enable interrupts.
; Inputs:
;  - None
; Output:
;  - Interrupts set up
; Destroys:
;  - Assume all
	di
	xor	a
	out	(pIntMask), a
	out	(pCrstlTmr1Freq), a
	out	(pCrstlTmr2Freq), a
	out	(pCrstlTmr3Freq), a
	out	(pLnkAstSeEnable), a
	; And kill USB
;	out	(57h), a
;	out	(5Bh), a
;	out	(4Ch), a
;	ld	a, 2
;	out	(54h), a
	; Custom Interrupts
;	ld	hl, IvtLocation*256
;	ld	de, IvtLocation*256+1
;	ld	bc, 256
;	ld	a, IvtLocation
;	ld	i, a
;	ld	a, IsrLocation
;	ld	(hl), a
;	ldir
;	ld	hl, InterruptServiceRoutine
;	ld	de, IsrLocation*256+IsrLocation
;	ld	bc, 3
;	ldir
	ld	a, InterruptVectorTable / 256
	ld	i, a
	; Enable only wanted interrupts
	;ld	a, tmrFreq0 | memMapMode0 | battVoltage0
	xor	a	; Above expression evaulates to 0
	out	(pAsicMiscCfg), a
	ld	a, intTmr2 | intOnKey | intDisableLowPowerMode
	out	(pIntMask), a
	im	2
	ret
;InterruptServiceRoutine:
;	jp	RealIsr


;------ Interrupt Service Routine ----------------------------------------------
;	.dw	RealIsrEnd - RealIsrSource
;RealIsrSource:
RealIsr:
	; PC valid check
	ex	(sp), hl
	push	af
	ld	a, h
	cp	80h
	call	nc, Panic
	cp	40h
	call	c, Panic
	pop	af
	ex	(sp), hl
	
	push	af
	push	hl
	; Stack overflow check
	ld	hl, 0
	add	hl, sp
	ld	a, h
	cp	250
	jr	nc, {@}
	pop	hl
	pop	af
	pop	ix	; Attempt to fetch PC into IX
	ld	iy, 0
	add	iy, sp
	ld	sp, 0FFF0h
	call	Panic
@:	; Check interrupt source
	in	a, (pIntId)
	rra
;	jp	c, InstantQuit;intHOnKey
	jr	nc, {@}
	; On key
	ld	a, intOnKey ^ 255
	out	(pIntAck), a
	pop	hl
	pop	af
	jp	Panic
@:	rra
	jp	c, Quit	;call	c, Panic;	jp	c, InstantQuit
	rra
	jr	c, _intHPapd
	rra
	rra
	jp	c, Quit	;call	c, Panic;	jp	c, InstantQuit
;	rra
;	jr	c, intHCrystal
;	rra
;	jr	c, intHHCrystal
	; Wait, there should be no other active interrupt sources.
;	xor	a
;	out	(pIntAck), a
	;call	RebootMicrOS
;intHLink:
;intHCrystal:
;intHApd: ; WTF, didn't we disable this interrupt?
	jp	Quit	;call	Panic;	jp	InstantQuit

_intHPapd:
;	push	hl
	; ACK the interrupt
	ld	a, intTmr2 ^ 255
	;xor	a
	out	(pIntAck), a
	; General fast timer.  This is useful for timing routines.
	ld	hl, (genFastTimer)
	inc	hl
_i1:	ld	(genFastTimer), hl
	ld	a, h
	cp	4
	jr	c, _i2
	ld	hl, 0
	jr	_i1	; Saves one byte.
_i2:	; Check the cursor timer.  This timer is always running.
	ld	hl, (cursorTimer)
	dec	hl
	ld	(cursorTimer), hl
	ld	a, h
	or	l
	jr	nz, _i3
	ld	hl, cursorPeriod
	ld	(cursorTimer), hl
	ld	a, (flags + mKbdFlags)
	or	kbdCurFlashM
	ld	(flags + mKbdFlags), a
	; Check if we're sleepy
	ld	a, (flags + mSettings)
	and	setApdEnabledM
	jr	z, _i3
	ld	hl, (suspendTimer)
	dec	hl
	ld	(suspendTimer), hl
	ld	a, l
	or	h
	jr	nz, _i3
	ld	hl, suspendDelay
	ld	(suspendTimer), hl
	ld	a, (flags + mSettings)
	bit	setApdNow, a
	set	setApdNow, a
	ld	(flags + mSettings), a
;	jp	nz, InstantQuit
	jp	nz, Quit	;	call	nz, Panic
_i3:	; Check if it's time to scan the keyboard
	ld	a, (kbdScanTimer)
	dec	a
	ld	(kbdScanTimer), a
	jr	nz, _noscn
	ld	a, kbdScanDivisor
	ld	(kbdScanTimer), a
	push	bc
	call	ScanKeyboard
	pop	bc
_noscn:	pop	hl
	pop	af
	ei
	ret
;RealIsrEnd:


;------ InstantQuit ------------------------------------------------------------
;	.dw	InstantQuitEnd - InstantQuitSource
;InstantQuitSource:
;	ld	hl, (mBasePage)
;	ld	a, h
;	out	(pMPgAHigh), a
;	ld	a, l
;	out	(pMPgA), a
;	jp	Quit
;InstantQuitEnd:


;------ ------------------------------------------------------------------------
.endmodule