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
;		training.asm
;;;

startTraining:
	ld	hl, AFflags
	bit	trainMsg, (hl)
	call	z, otm3

	ld	a, 0
	ld	(gameType), a

	b_call( _GrBufClr )	

	call	initGame
	ld	a, 200
	ld	(maxEnemyHealth), a
	ld	(enemyHealth), a
	call	putTerrain
	call	dropTank
	call	dropEnemy

restartTraining:
	ld	b, 10			;wind is from -5 to 5
	call	irandom
	sub	5
	ld	(gameWind), a
	call	putGameMenu
	b_call( _GrBufCpy )	
trainingKeyLoop:
	ld	hl, tempFlags
	set	delayFlag, (hl)
	b_call( _GetCSC )	
	cp	skDown			;down
	jp	z, trainingDecPower
	cp	skLeft			;left
	jp	z, trainingDecAngle
	cp	skRight			;right
	jp	z, trainingIncAngle
	cp	skUp			;up
	jp	z, trainingIncPower
	cp	skEnter			;Enter
	jp	z, trainingShoot
	cp	skClear			;Clear
	jp	z, mainMenuStart
	cp	sk2nd			;2nd
	jp	z, trainingMoveLeft
	cp	skMode			;Mode
	jp	z, trainingMoveRight
	cp	skAlpha			;Alpha
	jp	z, trainingChangeWeapon
	cp	skDel
	jr	nz, trainingKeyLoop
	call	teacherButton
	jr	trainingKeyLoop

trainingIncAngle:
	ld	a, (gameAngle)
	cp	135
	jr	z, endTrainingIncAngle
	inc	a
	ld	(gameAngle), a
	cp	60
	call	z, trainingIncAngleChange
	cp	75
	call	z, trainingIncAngleChange
	cp	90
	call	z, trainingIncAngleChange
	cp	105
	call	z, trainingIncAngleChange
	cp	120
	call	z, trainingIncAngleChange
	call	putAngle
	ld	hl, tempFlags
	bit	delayFlag, (hl)
	call	nz, delayLoop
	ld	a, $FE
	out	(1), a
	NOP
	NOP
	in	a, (1)
	cp	$FB
	jr	z, trainingIncAngle
endTrainingIncAngle:
	set	textWrite, (IY + sGrFlags)
	call	putAngle
	res	textWrite, (IY + sGrFlags)
	call	putAngleArrows
	b_call( _GrBufCpy )	
	jp	trainingKeyLoop
trainingIncAngleChange:
	ld	hl, angleSpr
	inc	(hl)
	push	af
	call	clearTank
	call	putTankTop
	call	putTankBase
	b_call( _GrBufCpy )	
	pop	af
	ret

trainingDecAngle:
	ld	a, (gameAngle)
	cp	45
	jr	z, endTrainingDecAngle
	dec	a
	ld	(gameAngle), a
	cp	59
	call	z, trainingDecAngleChange
	cp	74
	call	z, trainingDecAngleChange
	cp	89
	call	z, trainingDecAngleChange
	cp	104
	call	z, trainingDecAngleChange
	cp	119
	call	z, trainingDecAngleChange
	call	putAngle
	ld	hl, tempFlags
	bit	delayFlag, (hl)
	call	nz, delayLoop
	ld	a, $FE
	out	(1), a
	NOP
	NOP
	in	a, (1)
	cp	$FD
	jr	z, trainingDecAngle
endTrainingDecAngle:
	set	textWrite, (IY + sGrFlags)
	ld	hl, 6*256 + 42
	ld	(penCol), hl
	ld	hl, blankTxt
	b_call( _VPutS )	
	call	putAngle
	res	textWrite, (IY + sGrFlags)
	call	putAngleArrows
	b_call( _GrBufCpy )	
	jp	trainingKeyLoop
trainingDecAngleChange:
	ld	hl, angleSpr
	dec	(hl)
	push	af
	call	clearTank
	call	putTankTop
	call	putTankBase
	b_call( _GrBufCpy )	
	pop	af
	ret

trainingIncPower:
	ld	a, (gameTank)
	ld	b, a
	add	a, a	;10x
	add	a, a
	add	a, b
	add	a, a
	ld	b, a
	ld	a, 80
	add	a, b
	ld	c, a

trainingIncPowerRst:
	ld	a, (gamePower)
	cp	c
	jr	z, endTrainingIncPower
	inc	a
	ld	(gamePower), a
	push	bc
	call	putPower
	pop	bc
	ld	hl, tempFlags
	bit	delayFlag, (hl)
	call	nz, delayLoop
	ld	a, $FE
	out	(1), a
	NOP
	NOP
	in	a, (1)
	cp	$F7
	jr	z, trainingIncPowerRst
endTrainingIncPower:
	set	textWrite, (IY + sGrFlags)
	call	putPower
	res	textWrite, (IY + sGrFlags)
	call	putPowerArrows
	b_call( _GrBufCpy )	
	jp	trainingKeyLoop

trainingDecPower:
	ld	a, (gamePower)
	cp	10
	jr	z, endTrainingIncPower
	dec	a
	ld	(gamePower), a
	call	putPower
	ld	hl, tempFlags
	bit	delayFlag, (hl)
	call	nz, delayLoop
	ld	a, $FE
	out	(1), a
	NOP
	NOP
	in	a, (1)
	cp	$FE
	jr	z, trainingDecPower
endTrainingDecPower:
	set	textWrite, (IY + sGrFlags)
	ld	hl, 6*256 + 67
	ld	(penCol), hl
	ld	hl, blankTxt
	b_call( _VPutS )	
	call	putPower
	res	textWrite, (IY + sGrFlags)
	call	putPowerArrows
	b_call( _GrBufCpy )	
	jp	trainingKeyLoop

trainingMoveLeft:					;moves tank to the left
	ld	a, (gameX)
	cp	0
	jp	z, trainingKeyLoop
	call	clearTank
	ld	hl, gameX
	dec	(hl)
	call	testTankRest
	cp	0
	jr	z, trainingMoveLeftNotBlank

	ld	hl, gameY
	dec	(hl)
	call	testTankRest
	cp	1
	jr	z, endTrainingMoveLeft
	ld	hl, gameY
	inc	(hl)
	jr	endTrainingMoveLeft
trainingMoveLeftNotBlank:
	ld	hl, gameY
	inc	(hl)
endTrainingMoveLeft:
	call	putTankTop
	call	putTankBase
	b_call( _GrBufCpy )	
	jp	trainingKeyLoop


trainingMoveRight:					;moves tank to the right
	ld	a, (gameX)
	cp	40
	jp	z, trainingKeyLoop
	call	clearTank
	ld	hl, gameX
	inc	(hl)
	call	testTankRest
	cp	0
	jr	z, trainingMoveRightNotBlank

	ld	hl, gameY
	dec	(hl)
	call	testTankRest
	cp	1
	jr	z, endTrainingMoveRight
	ld	hl, gameY
	inc	(hl)
	jr	endTrainingMoveRight
trainingMoveRightNotBlank:
	ld	hl, gameY
	inc	(hl)
endTrainingMoveRight:
	call	putTankTop
	call	putTankBase
	b_call( _GrBufCpy )	
	jp	trainingKeyLoop

trainingChangeWeapon:
	ld	a, (gameWeapon)
	cp	2
	jr	nz, changeWeaponNotTop
	ld	a, 255
changeWeaponNotTop:
	inc	a
	ld	(gameWeapon), a
	call	putWeapon
	b_call( _GrBufCpy )	
	jp	trainingKeyLoop

trainingShoot:
	call	minMenu
	ld	a, (gameWeapon)
	cp	0
	call	z, shootSingle
	ld	a, (gameWeapon)
	cp	1
	call	z, shootScatter
	ld	a, (gameWeapon)
	cp	2
	call	z, (shootMortar)
	ld	hl, tempFlags
	bit	selfIsDead, (hl)
	jr	nz, endTraining
	bit	enemyIsDead, (hl)
	jr	nz, endTraining
	call	putSelfHealth
	call	putEnemyHealth
	jp	restartTraining

endTraining:
	call	putMessageBox
	ld	hl, tempFlags
	bit	selfIsDead, (hl)
	jp	nz, mainMenuStart
	ld	hl, 21*256 + 21
	ld	(penCol), hl
	ld	hl, congratsTxt
	b_call( _VPutS )	
	ld	hl, 31*256 + 23
	ld	(penCol), hl
	ld	hl, endTrainingTxt
	b_call( _VPutS )	
	call	pauseLoop
	jp	mainMenuStart




;=======================================================================================================================;
;				Routines										;
;=======================================================================================================================;


delayLoop:
	ld	b, 20
delayLoopLoop:
	halt
	halt
	djnz	delayLoopLoop
	ld	hl, tempFlags
	res	delayFlag, (hl)
	ret


;=======================================================================================================================;
;				Data											;
;=======================================================================================================================;

startTrainingTxt1:	.db "Play with wind?", 0
startTrainingTxt2:	.db "2nd - Yes", 0
startTrainingTxt3:	.db "Mode - No", 0

congratsTxt:	.db "Congratulations!", 0
endTrainingTxt:	.db "Training Passed", 0

targetSpr:	.db $F0,$78,$CC,$78
