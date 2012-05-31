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
;		shoot.asm
;;;

shootSingle:						 ;
	call	initShoot				 ;takes game values stored in in memory
	call	bigCoord				 ; outputs the trajectory of a single shot
	call	calcDamage				 ;
	call	initWind

	ld	a, 1
	ld	(oldX1), a
	ld	(oldY1), a
	ld	(oldX2), a
	ld	(oldY2), a

singleShotLoop:					;main loop for Single shot

	ld	a, (forceX)
	ld	hl, (shootX)
	call	addForce
	ld	(shootX), hl
	ld	a, (forceY)
	ld	hl, (shootY)
	call	addForce
	ld	(shootY), hl
	ld	a, (oldY2)		;clear old pixel
	cp	5
	jr	c, singleDontClear
	cp	64
	jr	nc, singleDontClear
	ld	l, a
	ld	a, (oldX2)
	call	getPixelMask
	cpl
	and	(HL)
	ld	(HL), A
singleDontClear:
	call	smallCoord
	ld	l, e			;end if pixel is off screen
	ld	a, d
	cp	96
	jp	nc, endSingleShot
	call	smallCoord		;end if next pixel is on
	ld	a, (oldY1)	;check to see if is same pixel or off the top (no test)
	cp	15
	jr	c, samePixel
	cp	64
	jr	nc, samePixel
	cp	e
	jr	nz, notSamePixel
	ld	a, (oldX1)
	cp	d
	jr	z, samePixel
notSamePixel:
	ld	a, d
	ld	l, e
	call	getPixelMask		;test pixel
	and	(hl)
	jp	nz, endSingleShot
samePixel:
	ld	a, (oldX1)		;save new pixel
	ld	(oldX2), a
	ld	a, (oldY1)
	ld	(oldY2), a
	call	smallCoord
	ld	a, d
	ld	(oldX1), a
	ld	a, e
	ld	(oldY1), a
	cp	5			;put new pixel
	jr	c, singleDontPut
	cp	64
	jr	nc, singleDontPut
	ld	a, d
	ld	l, e
	call	getPixelMask
	or	(hl)
	ld	(hl), a
singleDontPut:
	b_call( _GrBufCpy )	
	ld	hl, forceY		;update forces
	dec	(hl)
	ld	hl, windCounter2
	dec	(hl)
	call	z, addWindPower
	jp	singleShotLoop

endSingleShot:
	ld	a, (oldY1)
	ld	l, a
	ld	a, (oldX1)
	call	getPixelMask
	cpl
	and	(HL)
	ld	(HL), A
	b_call( _GrBufCpy )	

	call	putSingleExplosion
	call	getDmgEnemySingle
	call	getDmgSelfSingle

	ret



shootScatter:
	call	initShoot
	

	ret

shootMortar:
	call	initShoot
	call	bigCoord
	ld	a, 150
	ld	(gameDmg), a
	call	initWind

	ld	a, 1
	ld	(oldX1), a
	ld	(oldY1), a

mortarShotLoop:

	ld	a, (forceX)
	ld	hl, (shootX)
	call	addForce
	ld	(shootX), hl
	ld	a, (forceY)
	ld	hl, (shootY)
	call	addForce
	ld	(shootY), hl
	ld	a, (oldY1)		;clear old shot
	cp	5
	jr	c, mortarDontClear
	cp	64
	jr	nc, mortarDontClear
	ld	l, a
	ld	a, (oldX1)
	call	getPixel
	ld	de, $C000
	ld	b, a
mortarClearLoop:
	srl	d
	rr	e
	djnz	mortarClearLoop

	ld	a, d
	cpl
	and	(HL)
	ld	(HL), A
	inc	hl
	ld	a, e
	cpl
	and	(hl)
	ld	(hl), a
	ld	bc, 11
	add	hl, bc
	ld	a, d
	cpl
	and	(HL)
	ld	(HL), A
	inc	hl
	ld	a, e
	cpl
	and	(hl)
	ld	(hl), a
mortarDontClear:
	call	smallCoord
	ld	l, e			;end if shot is off screen
	ld	a, d
	cp	95
	jp	nc, endMortarShot
	call	smallCoord
	ld	a, e
	inc	a
	cp	5
	jr	c, mortarDontTest
	cp	64
	jr	nc, mortarDontTest
	ld	l, a
	ld	a, d
	inc	a
	call	getPixelMask		;test pixel
	and	(hl)
	jp	nz, endMortarShot
	call	smallCoord
	ld	a, d
	ld	l, e
	inc	l
	call	getPixelMask
	and	(hl)
	jp	nz, endMortarShot
mortarDontTest:
	call	smallCoord		;save old pixel
	ld	a, d
	ld	(oldX1), a
	ld	a, e
	ld	(oldY1), a
	cp	5			;put new shot
	jr	c, mortarDontPut
	cp	64
	jr	nc, mortarDontPut
	ld	a, d
	ld	l, e
	call	getPixel
	ld	de, $C000
	ld	b, a
mortarPutLoop:
	srl	d
	rr	e
	djnz	mortarPutLoop

	ld	a, d
	or	(HL)
	ld	(HL), A
	inc	hl
	ld	a, e
	or	(hl)
	ld	(hl), a
	ld	bc, 11
	add	hl, bc
	ld	a, d
	or	(HL)
	ld	(HL), A
	inc	hl
	ld	a, e
	or	(hl)
	ld	(hl), a

mortarDontPut:
	b_call( _GrBufCpy )	
	ld	hl, forceY		;update forces
	dec	(hl)
	ld	hl, windCounter2
	dec	(hl)
	call	z, addWindPower
	jp	mortarShotLoop

endMortarShot:
	ld	a, (oldY1)
	ld	l, a
	ld	a, (oldX1)
	call	getPixel
	ld	de, $C000
	ld	b, a
mortarClearFinal:
	srl	d
	rr	e
	djnz	mortarClearFinal

	ld	a, d
	cpl
	and	(HL)
	ld	(HL), A
	inc	hl
	ld	a, e
	cpl
	and	(hl)
	ld	(hl), a
	ld	bc, 11
	add	hl, bc
	ld	a, d
	cpl
	and	(HL)
	ld	(HL), A
	inc	hl
	ld	a, e
	cpl
	and	(hl)
	ld	(hl), a
	b_call( _GrBufCpy )	

	call	putSingleExplosion
	call	getDmgEnemySingle
	call	getDmgSelfSingle

	ret


	ret

;=======================================================================================================================;
;				Routines										;
;=======================================================================================================================;

initShoot:					;initializes the force
	ld	a, (gameAngle)			; in each direction from
	cp	90				; the angle and power
	jp	z, initAng90
	ld	b, a
	ld	a, 180
	sub	b
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )	
	b_call( _OP2ToOP1 )	
	set	trigDeg, (IY + trigFlags)
	b_call( _Cos )	
	b_call( _OP1ToOP3 )	
	ld	a, (gamePower)
	call	threeFourthsA
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )
	b_call( _OP3ToOP1 )	
	b_call( _FPMult )	
	call	convertFP
	ld	(forceX), a		;horizontal force
	ld	a, (gameAngle)
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )
	b_call( _OP2ToOP1 )	
	b_call( _Sin )	
	b_call( _OP1ToOP3 )	
	ld	a, (gamePower)
	call	threeFourthsA
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )	
	b_call( _OP3ToOP1 )	
	b_call( _FPMult )	
	call	convertFP
	ld	(forceY), a		;vertical force
	ret

initAng90:
	ld	a, (gamePower)
	call	threeFourthsA
	ld	(forceY), a
	ld	a, 0
	ld	(forceX), a
	ret
	

convertFP:					;
	ld	hl, OP1 + 1			;gets a number (0-99) from OP1 into A
	ld	a, (hl)				;
	inc	hl
	sub	$80
	cp	0
	jr	z, conv1Num
	cp	1
	jr	z, conv2Num
	ld	a, 0
	ret
conv1Num:
	ld	a, (hl)
	call	convGet1st4
	jr	endConvFP
conv2Num:
	ld	a, (hl)
	call	convGet1st4
	ld	b, a		;10x
	add	a, a
	add	a, a
	add	a, b
	add	a, a
	ld	b, a
	ld	a, (hl)
	and	15
	add	a, b
endConvFP:
	ld	hl, OP1
	bit	7, (hl)
	ret	z
	neg
	ret

convGet1st4:
	srl	a
	srl	a
	srl	a
	srl	a
	ret


bigCoord:					;enlarges gameX and
	ld	a, (gameX)			; gameY into shootX
	add	a, 2				; and shootY
	call	multBigCoord
	ld	(shootX), hl
	ld	a, (gameY)
	ld	b, a
	ld	a, 64
	sub	b
	call	multBigCoord
	ld	(shootY), hl
	ret

multBigCoord:
	ld	h, 0
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ret

smallCoord:					;gets shootX and shootY
	ld	hl, (shootX)			; back to pixel form and
	call	divSmallCoord			; outputs to DE
	ld	c, a
	ld	hl, (shootY)
	ex	de, hl
	ld	hl, 32*64
	SCF
	CCF
	SBC	hl, de
	call	divSmallCoord
	ld	d, c
	ld	e, a
	ret

divSmallCoord:
	ld	a, l
	ld	b, 4
divSmallCoordLoop:
	srl	h			;srl hl
	rra
	djnz	divSmallCoordLoop
	srl	h
	rra
	ret	nc			;rounding
	inc	a
	ret


addForce:
	ld	d, 0
	ld	e, a
	bit	7, a
	call	nz, ld_D_FF
	add	hl, de
	ret

ld_D_FF:
	ld	d, $FF
	ret

threeFourthsA:
	ld	b, a
	srl	a
	add	a, b
	srl	a
	ret


addWindPower:
	ld	a, (windCounter1)
	ld	(windCounter2), a
	ld	a, (windIncrement)
	ld	hl, forceX
	add	a, (hl)
	ld	(forceX), a
	ret

putSingleExplosion:
	ret


calcDamage:
	ld	a, (gameTank)
	add	a, 3
	ld	hl, statPierce
	bit	0, (hl)
	jr	z, calcDamageNotPierce
	add	a, a
calcDamageNotPierce:
	ld	b, a
	add	a, a
	add	a, a
	add	a, b
	add	a, a
	ld	(gameDmg), a
	ret


getDmgEnemySingle:				;calculates damage for a hit on the enemy with a single shot
	
	call	smallCoord
	ld	a, (enemyX)
	call	dmgCalcDiff

	cp	13
	ret	nc
	cp	8
	jr	c, enemySingleDirectHit
	call	partialHit
	jr	endDmgEnemySingle

enemySingleDirectHit:
	ld	a, (gameDmg)

endDmgEnemySingle:
	ld	hl, tempFlags
	res	enemyIsDead, (hl)
	ld	b, a
	ld	a, (enemyHealth)
	sub	b
	ld	(enemyHealth), a
	jr	z, endDmgEnemySingleScrewed
	ret	nc
endDmgEnemySingleScrewed:
	set	enemyIsDead, (hl)
	ret

getDmgSelfSingle:				;calculates damage for a hit on yourself with a single shot

	call	smallCoord
	ld	a, (gameX)
	call	dmgCalcDiff

	cp	13
	ret	nc
	cp	8
	jr	c, selfSingleDirectHit
	call	partialHit
	jr	endDmgSelfSingle

selfSingleDirectHit:
	ld	a, (gameDmg)

endDmgSelfSingle:
	ld	hl, tempFlags
	res	selfIsDead, (hl)
	ld	b, a
	ld	a, (gameHealth)
	sub	b
	ld	(gameHealth), a
	jr	z, endDmgSelfSingleScrewed
	ret	nc
endDmgSelfSingleScrewed:
	set	selfIsDead, (hl)
	ret


dmgCalcDiff:			;takes 'a' as tank's x value
	dec	a		;and 'd' as shot's x value
	ld	b, a		;output is 'a' as difference btwn shot and tank x-values
	ld	a, d
	sub	b
	ret	nc
	neg
	add	a, 6
	ret

partialHit:			;calculates how much damage
	ld	b, a		;a partial shot did to the tank
	ld	a, 13		;takes diff in 'a' and returns dmg in 'a'
	sub	b
	b_call( _SetXXOP1 )	
	ld	a, (gameDmg)
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )	
	b_call( _FPMult )	
	ld	a, 6
	b_call( _SetXXOP2 )	
	b_call( _FPDiv )	
	jp	convertFP

initWind:
	ld	a, (gameWind)
	cp	0
	jr	z, singleWindEnd
	bit	7, a
	jr	nz, singleWindNeg
	ld	b, a
	ld	a, 1
	ld	(windIncrement), a
	ld	a, 6
	sub	b
	add	a, a
	add	a, a
	inc	a
	jr	singleWindEnd
singleWindNeg:
	neg
	ld	b, a
	ld	a, 255
	ld	(windIncrement), a
	ld	a, 6
	sub	b
	add	a, a
	add	a, a
	inc	a
singleWindEnd:
	ld	(windCounter1), a
	ld	(windCounter2), a
	ret



;=======================================================================================================================;
;				Data											;
;=======================================================================================================================;



