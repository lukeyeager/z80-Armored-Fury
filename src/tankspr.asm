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
; along with Armored Fury. If not, see <http://www.gnuorg/licenses/>.
;
;
;   tankspr.asm
;;;

dropTank:				;takes random # (0-9) in a
	ld	b, 12			;drops tank onto ground
	call	irandom
	add	a, 8
	ld	(gameX), a		;at start of each round
	ld	a, 40
	ld	(gameY), a
dropTankLoop:
	call	putTankTop
	call	putTankBase
	b_call( _GrBufCpy )	
	call	clearTank
	ld	hl, gameY
	inc	(hl)
	call	testTankRest
	cp	0
	jr	z, dropTankLoop

	call	putTankTop
	call	putTankBase
	b_call( _GrBufCpy )		
	ret

putTankTop:					;takes x and y in (gameX) and (gameY)
	ld	a, (gameTank)			;puts the appropriate tank top
	cp	1				;for both angle and tank type
	jr	z, putPantherTop
	cp	2
	jr	z, putTigerTop
	ld	hl, panzerSpr0
	jr	putPanzerTop
putPantherTop:
	ld	hl, pantherSpr0
	jr	putPanzerTop
putTigerTop:
	ld	hl, tigerSpr0
putPanzerTop:
	ld	a, (angleSpr)
	add	a, a
	add	a, a
	ld	d, 0
	ld	e, a
	add	hl, de
	push	hl
	pop	ix			;now ix is sprite index
	ld	a, (gameY)
	ld	l, a
	ld	a, (gameX)
	call	getPixel
	ld	d, a
	ld	e, 4
putTankTopLoop:
	ld	c, (ix)
	ld	b, d
	call	sprBitShift
	ld	b, a
	ld	a, c
	or	(hl)
	ld	(hl), a
	inc	hl
	ld	a, b
	or	(hl)
	ld	(hl), a
	ld	bc, 11
	add	hl, bc
	inc	ix
	dec	e
	jr	nz, putTankTopLoop

	ret


putTankBase:					;takes x and y in (gameX) and (gameY)
	ld	a, (gameTank)			;puts the appropriate tank base
	cp	1
	jr	z, putPantherBase
	cp	2
	jr	z, putTigerBase
	ld	ix, panzerSprBase
	jr	putPanzerBase
putPantherBase:
	ld	ix, pantherSprBase
	jr	putPanzerBase
putTigerBase:
	ld	ix, tigerSprBase
putPanzerBase:
	ld	a, (gameY)
	add	a, 4
	ld	l, a
	ld	a, (gameX)
	call	getPixel
	ld	b, a
	ld	(tempValue4), a		;save for later

	ld	a, (hl)			;save terrain for later
	ld	(sprBuf), a
	inc	hl
	ld	a, (hl)
	ld	(sprBuf + 1), a
	dec	hl

	ld	c, (ix)
	call	sprBitShift
	ld	e, a
	ld	a, c
	or	(hl)
	ld	(hl), a
	inc	hl
	ld	a, e
	or	(hl)
	ld	(hl), a
	ld	de, 11
	add	hl, de

	ld	a, (hl)			;save terrain for later
	ld	(sprBuf + 2), a
	inc	hl
	ld	a, (hl)
	ld	(sprBuf + 3), a
	dec	hl

	ld	a, (tempValue4)		;restore counter
	ld	b, a
	ld	c, (ix + 1)
	call	sprBitShift
	ld	b, a
	ld	a, c
	or	(hl)
	ld	(hl), a
	inc	hl
	ld	a, b
	or	(hl)
	ld	(hl), a

	ret

clearTank:				;takes x and y in (gameX) and (gameY)
	ld	a, (gameY)
	ld	l, a
	ld	a, (gameX)
	call	getPixel
	ld	b, a
	ld	c, $FE
	ld	a, 0
	call	sprBitShift
	CPL			;note: flips and switches a and c
	ld	d, a
	ld	a, c
	CPL
	ld	c, d
	ld	(tempValue2), a
	ld	b, 4
	ld	de, 11
clearTankLoop:
	and	(hl)
	ld	(hl), a
	inc	hl
	ld	a, c
	and	(hl)
	ld	(hl), a
	ld	a, (tempValue2)
	add	hl, de
	DJNZ	clearTankLoop

	ld	a, (sprBuf)			;restore terrain
	ld	(hl), a
	inc	hl
	ld	a, (sprBuf + 1)
	ld	(hl), a
	ld	de, 11
	add	hl, de
	ld	a, (sprBuf + 2)
	ld	(hl), a
	inc	hl
	ld	a, (sprBuf + 3)
	ld	(hl), a
	ret

dropEnemy:
	ld	b, 12
	call	irandom
	add	a, 78			;a=x, c=y
	ld	(tempValue1), a
	ld	c, 50
dropEnemyLoop:
	ld	l, c
	ld	a, (tempValue1)
	call	testPixel
	inc	c
	cp	0
	jr	z, dropEnemyLoop
	ld	a, c
	sub	5
	ld	(enemyY), a
	ld	l, a
	ld	a, (tempValue1)
	sub	2
	ld	(enemyX), a
	call	getPixel
	ld	ix, targetSpr
	ld	d, a
	ld	e, 4
dropEnemyLoop2:
	ld	c, (ix)
	ld	b, d
	call	sprBitShift
	ld	b, a
	ld	a, c
	or	(hl)
	ld	(hl), a
	inc	hl
	ld	a, b
	or	(hl)
	ld	(hl), a
	ld	bc, 11
	add	hl, bc
	inc	ix
	dec	e
	jr	nz, dropEnemyLoop2
	b_call( _GrBufCpy )	
	ret

;=======================================================================================================================;
;				Routines										;
;=======================================================================================================================;

getPixel:				;takes x-location in a and y-location in l
	LD	 H, 0				;outputs in hl the place in plotSScreen
	LD	 D, H				;and a is # of times to SRL
	LD	 E, L
	ADD	HL, HL		;12x
	ADD	HL, DE
	ADD	HL, HL
	ADD	HL, HL

	LD	 E, A
	SRL	E			;e/8
	SRL	E
	SRL	E
	ADD	HL, DE

	LD	 DE, plotSScreen
	ADD	HL, DE

	AND	7
	RET

getPixelMask:
	call	getPixel
	ld	b, a
	ld	a, $80
pixelLoop:
	RRCA
	DJNZ	pixelLoop
	ret

testPixel:				;returns 0 or 1 in A
	call	getPixelMask
	and	(hl)
	cp	0
	ret	z
	ld	a, 1
	ret


testTankRest:				;tests to see if tank
	ld	a, (gameY)		;is at bottom of terrain
	add	a, 6
	ld	l, a
	ld	a, (gameX)
	add	a, 2
	call	testPixel
	ret


sprBitShift:				;shifts right B times
	ld	a, 0			; (overflow to A)
	cp	b
	ret	z
sprBitShiftLoop:
	SRL	c
	RRA
	DJNZ	sprBitShiftLoop
	ret

;=======================================================================================================================;
;				Data											;
;=======================================================================================================================;

panzerSprBase:		.db $F8,$70
panzerSpr0:	.db $00,$80,$60,$70
panzerSpr1:	.db $00,$40,$20,$70
panzerSpr2:	.db $00,$20,$20,$30
panzerSpr3:	.db $00,$20,$20,$60
panzerSpr4:	.db $00,$10,$20,$70
panzerSpr5:	.db $00,$08,$30,$70

pantherSprBase:		.db $FC,$78
pantherSpr0:	.db $00,$C0,$30,$78
pantherSpr1:	.db $40,$20,$30,$78
pantherSpr2:	.db $20,$20,$30,$78
pantherSpr3:	.db $10,$10,$30,$78
pantherSpr4:	.db $08,$10,$30,$78
pantherSpr5:	.db $00,$0C,$30,$78

tigerSprBase:		.db $FE,$7C
tigerSpr0:	.db $00,$C0,$38,$7C
tigerSpr1:	.db $40,$20,$38,$7C
tigerSpr2:	.db $20,$20,$38,$7C
tigerSpr3:	.db $08,$08,$38,$7C
tigerSpr4:	.db $04,$08,$38,$7C
tigerSpr5:	.db $00,$06,$38,$7C
