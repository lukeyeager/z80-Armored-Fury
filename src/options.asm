;;;
; Copyright 2010 Luke Yeager
;
; This file is part of Armored Fury.
;
; Armored Fury is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; Armored Fury is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with Armored Fury. If not, see <http://www.gnu.org/licenses/>.
;
;
;   options.asm
;;;

optionsMenu:

	ld	a, 3
	ld	(menuCounter), a
	call	putOptionsMenu

optionsMenuKeyLoop:
	b_call(_getCSC)
	cp	skDel
	ret	z
	cp	skClear
	jp	z, mainMenuStart
	cp	skUp
	call	z, optionsMenuMoveUp
	cp	skDown
	call	z, optionsMenuMoveDown
	cp	skLeft
	call	z, contrastDown
	cp	skRight
	call	z, contrastUp
	cp	sk2nd
	jp	z, optionsMenuSelect
	cp	skEnter
	jp	z, optionsMenuSelect
	jr	optionsMenuKeyLoop

contrastUp:
	ld	a, (menuCounter)
	cp	4
	ret	nz
	ld	a, (contrast)
	cp	39
	ret	z
	inc	a
	jr	putContrast
contrastDown:
	ld	a, (menuCounter)
	cp	4
	ret	nz
	ld	a, (contrast)
	cp	0
	ret	z
	dec	a

putContrast:
	
	ld	(contrast), a
	add	a, $18 + $C0
	out	($10), a
	ret

optionsMenuSelect:
	ld	a, (menuCounter)
	cp	4
	jp	z, optionsMenuKeyLoop
	cp	3
	jp	z, credits
	jp	resetMemory



;=======================================================================================================================;
;				Routines										;
;=======================================================================================================================;

putOptionsMenu:
	call	blackOutScreen

	ld	de, plotSScreen
	ld	hl, mainMenuPic
	ld	bc, 19*12
	LDIR
	
	set	TextInverse, (IY + TextFlags)
	set	textwrite, (IY + sGrFlags)

	ld	hl, 22*256 + 60
	ld	(pencol), hl
	ld	hl, optionsMenuTxt1
	ld	b, 7
putOptionsMenuLoop:
	ld	a, (hl)
	b_call(_vPutMap)
	inc	hl
	ld	a, (penrow)
	add	a, 5
	ld	(penrow), a
	djnz	putOptionsMenuLoop

	ld	hl, PlotSScreen + 468		;bullet sprites
	ld	de, 96
	ld	b, 2
primaryOptionsBulletsLoop:
	res	3, (hl)
	add	hl, de
	djnz	primaryOptionsBulletsLoop
	call	upgradePutBullet

	ld	hl, 28*256 + 7			;list items
	ld	(pencol), hl
	ld	hl, optionsMenuTxt2
	b_call(_vPutS)
	ld	hl, 36*256 + 7
	ld	(pencol), hl
	ld	hl, optionsMenuTxt3
	b_call(_vPutS)
	ld	hl, 44*256 + 7
	ld	(pencol), hl
	ld	hl, optionsMenuTxt4
	b_call(_vPutS)

	ld	hl, plotSScreen + 460		;contrast arrows
	ld	de, 11
	res	1, (hl)
	inc	hl
	res	6, (hl)
	add	hl, de
	res	2, (hl)
	inc	hl
	res	5, (hl)
	add	hl, de
	res	1, (hl)
	inc	hl
	res	6, (hl)
	add	hl, de

	res	TextInverse, (IY + TextFlags)
	res	textwrite, (IY + sGrFlags)
	b_call(_grBufCpy)
	ret

optionsMenuMoveUp:
	call	upgradeEraseBullet
	ld	hl, menuCounter
	ld	a, (hl)
	cp	3
	jr	z, optionsMenuMoveBottom
	dec	(hl)
	jr	optionsMenuMoveEnd
optionsMenuMoveBottom:
	ld	(hl), 5
	jr	optionsMenuMoveEnd
optionsMenuMoveDown:
	call	upgradeEraseBullet
	ld	hl, menuCounter
	ld	a, (hl)
	cp	5
	jr	z, optionsMenuMoveTop
	inc	(hl)
	jr	optionsMenuMoveEnd
optionsMenuMoveTop:
	ld	(hl), 3
optionsMenuMoveEnd:
	jp	upgradePutBullet


;=======================================================================================================================;
;				Data Declarations									;
;=======================================================================================================================;

optionsMenuTxt1:	.db "OPTIONS", 0
optionsMenuTxt2:	.db "Credits", 0
optionsMenuTxt3:	.db "Contrast", 0
optionsMenuTxt4:	.db "Reset Game", 0
