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
;   library.asm
;;;

menuPutSprite:				;Adds bullet sprite in front of selected menu item
					;
	ld	d, 0			;	Takes: spot in plotSScreen (hl)
	ld	e, 12
	ld	a, (menuBulletOn + 0)
	ld	b, a
	ld	a, (hl)
	and	b
	ld	(hl), a
	add	hl, de
	ld	a, (menuBulletOn + 1)
	ld	b, a
	ld	a, (hl)
	and	b
	ld	(hl), a
	add	hl, de
	ld	a, (menuBulletOn + 2)
	ld	b, a
	ld	a, (hl)
	and	b
	ld	(hl), a
	b_call(_grBufCpy)
	ret

menuEraseSprite:			;Deletes bullet sprite in front of previously selected menu item
					;
	ld	d, 0			;	Takes: spot in plotSScreen (hl)
	ld	e, 12
	ld	a, (menuBulletOff + 0)
	ld	b, a
	ld	a, (hl)
	or	b
	ld	(hl), a
	add	hl, de
	ld	a, (menuBulletOff + 1)
	ld	b, a
	ld	a, (hl)
	or	b
	ld	(hl), a
	add	hl, de
	ld	a, (menuBulletOff + 2)
	ld	b, a
	ld	a, (hl)
	or	b
	ld	(hl), a
	b_call(_grBufCpy)
	ret

menuBulletOn:
	.db %10001111
	.db %10010111
	.db %10001111
menuBulletOff:
	.db %11111100
	.db %11110100
	.db %11111100



putMessageBox:				;Puts a blank white box in the middle of the screen for a message
					;
	ld	de, plotSScreen + 194	;	box is from 16,16 to 79,45
	ld	hl, plotSScreen + 566
	ld	a, $FF
	ld	b, 8
messageBoxLoop1:		;put top and bottom lines
	ld	(de), a
	ld	(hl), a
	inc	de
	inc	hl
	DJNZ	messageBoxLoop1

	ld	de, plotSScreen + 206
	ld	c, 30
messageBoxLoop2:
	ld	hl, messageBoxPic
	ld	b, 8
messageBoxLoop3:		;put blank space
	ld	a, (hl)
	ld	(de), a
	inc	de
	inc	hl
	DJNZ	messageBoxLoop3

	inc	de
	inc	de
	inc	de
	inc	de
	dec	c
	jr	nz, messageBoxLoop2

	b_call(_grBufCpy)
	ret

messageBoxPic: .db $80, $00, $00, $00, $00, $00, $00, $01


pauseLoop:
	b_call(_getCSC)
	cp	sk2nd
	ret	z
	cp	skEnter
	ret	z
	cp	skClear
	ret	z
	jr	pauseLoop


blackOutScreen:				;
	ld	hl, plotSScreen
	ld	de, plotSScreen + 1
	ld	bc, 767
	ld	a, 255
	ld	(hl), a
	LDIR
	b_call(_grBufCpy)
	ret

calculateRank:				;gets the rank of your tank and outputs to 'a'
	ld	a, (statPanzer)		;
	cp	2			;	23T + 2A + 2S + 4M + 10P = rank
	jr	z, calcPanzer
	ld	a, (statPanther)
	cp	2
	jr	z, calcPanther
	ld	a, 46
	ld	d, 6
	ld	e, 3
	jr	calcTiger
calcPanzer:
	ld	a, 0
	ld	d, 2
	ld	e, 1
	jr	calcTiger
calcPanther:
	ld	a, 23
	ld	d, 4
	ld	e, 2
calcTiger:
	ld	(rank), a
	ld	a, (statArmor)
	add	a, a		;2x
	ld	b, a
	ld	a, (rank)
	add	a, b
	ld	(rank), a
	ld	a, (statScatters)
	ld	b, d
	cp	b
	jr	c, calcNotMaxScatters
	ld	a, d
calcNotMaxScatters:
	add	a, a		;2x
	ld	b, a
	ld	a, (rank)
	add	a, b
	ld	(rank), a
	ld	a, (statMortars)
	ld	b, e
	cp	b
	jr	c, calcNotMaxMortars
	ld	a, e
calcNotMaxMortars:
	add	a, a		;4x
	add	a, a
	ld	b, a
	ld	a, (rank)
	add	a, b
	ld	(rank), a
	ld	a, (statPierce)
	cp	0
	jr	z, rankNotPierce
	ld	a, 10
rankNotPierce:
	ld	b, a
	ld	a, (rank)
	add	a, b
	ld	(rank), a
	ret


putGameMenu:						;clears the top section of the screen
	ld	hl, plotSScreen				; and puts all info needed for the in-
	ld	de, plotSScreen + 1			; game menu
	ld	bc, 12*24 - 1
	ld	(hl), 0
	LDIR

	ld	a, $20
	ld	c, $08
	ld	b, 19
	ld	hl, plotSScreen
	ld	de, 11
gameMenuLoop1:
	ld	(hl), a				;lines, sprites
	add	hl, de
	ld	(hl), c
	inc	hl
	djnz	gameMenuLoop1
	ld	hl, inGameMenuSprite1
	ld	de, plotSScreen + 228
	ld	bc, 12*4
	LDIR

	ld	hl, plotSScreen + 12
	ld	de, 12
	ld	a, $2F
	call	putGameTypeBox
	ld	a, $FF
	call	putGameTypeBox
	call	putGameTypeBox
	ld	a, $FC
	call	putGameTypeBox

	set	textWrite, (IY + sGrFlags)
	set	textInverse, (IY + textFlags)
	ld	a, (gameType)
	cp	1
	jr	z, putGameSingle
	cp	2
	jr	z, putGameMulti
	ld	hl, 1*256 + 5
	ld	(pencol), hl
	ld	hl, trainingTxt
	ld	a, (hl)
	b_call(_vPutMap)
	inc	hl
	call	trainingTextShift
	ld	a, (hl)
	b_call(_vPutMap)
	inc	hl
	call	trainingTextShift
	call	trainingTextShift
	b_call(_vPutS)
	ld	hl, plotSScreen + 49
	res	5, (hl)
	jr	endPutGameType

putGameSingle:
	ld	hl, 3*256 + 7
	ld	(pencol), hl
	ld	hl, singleTxt
	b_call(_vPutS)
	jr	endPutGameType
putGameMulti:

endPutGameType:
	res	textInverse, (IY + textFlags)

	ld	hl, 31				;text
	ld	(pencol), hl
	ld	hl, inGameMenuTxt1
	b_call(_vPutS)
	ld	hl, 12*256 + 8
	ld	(pencol), hl
	ld	hl, inGameMenuTxt3
	b_call(_vPutS)

	call	putAngle
	call	putPower
	call	putAngleArrows
	call	putPowerArrows
	call	putWeapon
	call	putWind
	ret

putGameTypeBox:
	push	hl
	ld	b, 11
	ld	(hl), a
	add	hl, de
	djnz	putGameTypeBox + 3
	pop	hl
	inc	hl
	ret

trainingTextShift:
	ld	a, (pencol)
	dec	a
	ld	(pencol), a
	ld	a, (penrow)
	inc	a
	ld	(penrow), a
	ret

putAngle:						;
	ld	a, (gameAngle)				;outputs the angle in the in-game menu
	ld	hl, 6*256 + 44				;
	cp	99
	call	z, putTempBlank
	ld	hl, 6*256 + 34
	ld	(penCol), hl
	ld	h, 0
	ld	l, a
	b_call(_setxxxxop2)
	b_call(_op2toop1)
	ld	a, 6
	b_call(_dispop1a)
	ret

putPower:						;
	ld	a, (gamePower)				;outputs the power in the in-game menu
	ld	hl, 6*256 + 69				;
	cp	99
	call	z, putTempBlank
	ld	hl, 6*256 + 59
	ld	(penCol), hl
	ld	h, 0
	ld	l, a
	b_call(_setxxxxop2)
	b_call(_op2toop1)
	ld	a, 6
	b_call(_dispop1a)
	ret

putTempBlank:
	ld	(pencol), hl
	push	af
	ld	a, ' '
	b_call(_vPutMap)
	pop	af
	ret

putPowerArrows:
	ld	hl, plotSScreen + 103		;power arrows
	ld	de, 11
	set	7, (hl)
	add	hl, de
	set	0, (hl)
	inc	hl
	set	6, (hl)
	ld	hl, plotSScreen + 116
	set	0, (hl)
	inc	hl
	set	6, (hl)
	add	hl, de
	inc	hl
	set	7, (hl)
	ret

putAngleArrows:
	ld	hl, plotSScreen + 100		;angle arrows
	ld	de, 11
	set	7, (hl)
	add	hl, de
	set	0, (hl)
	inc	hl
	inc	hl
	add	hl, de
	set	7, (hl)
	
	ld	hl, plotSScreen + 101
	inc	de
	set	1, (hl)
	add	hl, de
	set	0, (hl)
	add	hl, de
	set	1, (hl)
	ret

putWeapon:						;
	ld	a, (gameWeapon)				;outputs current weapon on in-game menu
	ld	hl, 12*256 + 35				;
	ld	(pencol), hl
	cp	1
	jr	z, putWeaponScatter
	cp	2
	jr	z, putWeaponMortar

	ld	hl, inGameMenuTxt4
	jr	putWeaponTxt
putWeaponScatter:
	ld	hl, inGameMenuTxt5
	jr	putWeaponTxt
putWeaponMortar:
	ld	hl, inGameMenuTxt6
putWeaponTxt:
	set	textWrite, (IY + sGrFlags)
	b_call(_vPutS)
	res	textWrite, (IY + sGrFlags)
	ret

putWind:						;
	ld	a, (gameWind)				;outputs current wind (+ or -)
	ld	b, a					;
	add	a, a
	add	a, a
	add	a, b
	bit	7, a
	jr	z, putWindPos
	neg
putWindPos:

	ld	hl, 6*256 + 81
	ld	(pencol), hl
	b_call(_setXXOP1)
	ld	a, 2
	set	textWrite, (IY + sGrFlags)
	b_call(_dispOP1a)
	res	textWrite, (IY + sGrFlags)
	ld	a, (gameWind)
	cp	0
	ret	z
	bit	7, a
	jr	nz, putWindNeg

	ld	hl, plotSScreen + 107
	ld	de, 12
	set	6, (hl)
	add	hl, de
	set	5, (hl)
	add	hl, de
	set	6, (hl)
	ret

putWindNeg:
	ld	hl, plotSScreen + 105
	ld	de, 12
	set	0, (hl)
	add	hl, de
	set	1, (hl)
	add	hl, de
	set	0, (hl)
	ret

inGameMenuSprite1:
 .db $3F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$15,$55,$55,$55	;botom of menu thing
 .db $55,$55,$55,$55,$55,$55,$55,$50,$15,$55,$55,$55,$55,$55,$55,$55
 .db $55,$55,$55,$50,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E0

ingameMenuTxt1:	.db "Angle   Power   Wind", 0
inGameMenuTxt3:	.db "Weapon:", 0
inGameMenuTxt4:	.db "Shell       ", 0
inGameMenuTxt5:	.db "Scatter", 0
inGameMenuTxt6:	.db "Mortar   ", 0
blankTxt:	.db "   ", 0
trainingTxt:	.db "Training", 0
singleTxt:	.db "Single", 0



putTerrain:						;
	ld	b, 3					;puts terrain at bottom of game
	call	iRandom					;
	cp	0
	jr	z, terrainLevelOne
	cp	1
	jr	z, terrainLevelTwo
	cp	2
	jr	z, terrainLevelThree
	ret

terrainLevelOne:
	ld	hl, terraindata1
	jr	terrainPlacement

terrainLevelTwo:
	ld	hl, terraindata2
	jr	terrainPlacement

terrainLevelThree:
	ld	hl, terraindata3
terrainPlacement:
	ld	de, PlotSScreen+648
	ld	bc, 10*12
	LDIR
	b_call(_GrBufCpy)
	ret

terraindata1:								;bowl
 .db $E0,$00,$00,$00,$00,$00,$00,$00
 .db $00,$00,$00,$07,$FE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F
 .db $FF,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$FE,$00,$00
 .db $00,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$E0,$00,$00,$00,$00,$00
 .db $00,$07,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF
 .db $FF,$FF,$FF,$F8,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$00,$03,$FF,$FF
 .db $F0,$00,$00,$07,$FF,$FF,$C0,$00,$7F,$FB,$FF,$FF,$FF,$FF,$FF,$FF
 .db $FF,$FF,$DF,$FE,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00

terraindata2:								;wavy
 .db $00,$00,$00,$00,$00,$00,$00,$00
 .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .db $00,$F0,$00,$00,$F0,$00,$00,$F0,$00,$00,$F0,$00,$07,$FE,$00,$07
 .db $FE,$00,$07,$FE,$00,$07,$FE,$00,$1F,$FF,$80,$1F,$FF,$80,$1F,$FF
 .db $80,$1F,$FF,$E0,$FF,$FF,$F0,$FF,$FF,$F0,$FF,$FF,$F0,$FF,$FF,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$03,$FF,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$C0,$00,$7F,$FB,$FF,$FF,$FF,$FF,$FF,$FF
 .db $FF,$FF,$DF,$FE,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00

terraindata3:								;two hills
 .db $00,$00,$07,$E0,$00,$00,$00,$00
 .db $07,$E0,$00,$00,$00,$00,$3F,$F8,$00,$00,$00,$00,$1F,$FC,$00,$00
 .db $00,$01,$FF,$FE,$00,$00,$00,$00,$7F,$FF,$80,$00,$00,$1F,$FF,$FF
 .db $80,$00,$00,$01,$FF,$FF,$F8,$00,$01,$FF,$FF,$FF,$F0,$00,$00,$0F
 .db $FF,$FF,$FF,$80,$FF,$FF,$FF,$FF,$FE,$00,$00,$7F,$FF,$FF,$FF,$FF
 .db $FF,$FF,$FF,$FF,$FF,$C0,$03,$FF,$FF,$FF,$FF,$FF,$00,$03,$FF,$FF
 .db $FF,$F8,$1F,$FF,$FF,$FF,$C0,$00,$7F,$FB,$FF,$FF,$FF,$FF,$FF,$FF
 .db $FF,$FF,$DF,$FE,$00,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00


teacherButton:
        ld      a, 1
        out     (3), a
        ei
        halt 
	ret

minMenu:					;minimizes the main game menu
	ld	a, 19
	ld	(tempValue1), a
minMenuLoop1:
	ld	a, (tempValue1)
	add	a, 3
	ld	hl, plotSScreen + 12
minMenuLoop2:
	ld	de, minMenuBuf
	ld	bc, 12
	push	hl
	LDIR
	pop	hl
	ld	de, 12
	SCF
	CCF
	SBC	hl, de
	ld	d, h
	ld	e, l
	ld	hl, minMenuBuf
	ld	bc, 12
	push	de
	LDIR
	pop	de
	ld	h, d
	ld	l, e
	ld	de, 24
	add	hl, de
	dec	a
	jr	nz, minMenuLoop2

	call	minMenuCalcBottom
	ld	a, 0
	ld	b, 12
minMenuLoop3:
	ld	(hl), a
	inc	hl
	djnz	minMenuLoop3
	b_call(_grBufCpy)
	ld	hl, tempValue1
	dec	(hl)
	jr	nz, minMenuLoop1
	ret


minMenuCalcBottom:			;sets hl as current bottom of menu
	ld	h, 0
	ld	a, (tempValue1)
	add	a, 3
	ld	l, a
	ld	d, h
	ld	e, l
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl		;12x
	ld	de, plotSScreen
	add	hl, de
	ret

resetMemory:				;resets memory to game defaults
	ld	a, 2
	ld	(statPanzer), a
	ld	a, 0
	ld	b, 9
	ld	hl, statPanther
resetMemLoop:
	ld	(hl), a
	inc	hl
	djnz	resetMemLoop
	ld	hl, 500
	ld	(money), hl
	ret

initGame:					;sets the generic initial game values

	ld	a, (statPanzer)
	cp	2
	jr	z, trainingTankIsPanzer
	ld	a, (statPanther)
	cp	2
	jr	z, trainingTankIsPanther
	ld	a, 2
	jr	trainingTankIsTiger
trainingTankIsPanzer:
	ld	a, 0
	jr	trainingTankIsTiger
trainingTankIsPanther:
	ld	a, 1
trainingTankIsTiger:
	ld	(gameTank), a		;tank

	ld	a, 50
	ld	(gamePower), a		;power
	ld	a, 115
	ld	(gameAngle), a		;angle
	ld	a, 4
	ld	(angleSpr), a
	ld	a, 0			;weapons: 0-normal, 1-scatter, 2-mortar
	ld	(gameWeapon), a
	ld	(tempFlags), a		;flags


initPlayerHealth:				;initializes player's health
	ld	a, (gameTank)
	add	a, a			;maximum health = 10(2(tank) + 5 + armor)
	add	a, 5
	ld	b, a
	ld	a, (statArmor)
	add	a, b
	ld	b, a
	add	a, a
	add	a, a
	add	a, b
	add	a, a
	ld	(maxHealth), a
	ld	(gameHealth), a
	ret

putEnemyHealth:					;puts health bar for enemy
	ld	a, (enemyHealth)
	ld	h, 0
	ld	l, a
	b_call(_setXXXXOP2)		;bar length = 12(enemyHealth/maxEnemyHealth)
	b_call(_op2toOp1)
	ld	a, (maxEnemyHealth)
	ld	h, 0
	ld	l, a
	b_call(_setXXXXOP2)
	b_call(_fpDiv)
	ld	a, 12
	b_call(_setXXOP2)
	b_call(_fpMult)
	call	convertFP
	ld	hl, 0
	cp	0
	jr	z, skipPutEnemyHealth
	ld	b, a
putEnemyHealthLoop:
	SLL	l
	RL	h
	djnz	putEnemyHealthLoop
	SLA	l
	RL	h
skipPutEnemyHealth:
	ld	de, 49152
	add	hl, de
	ld	de, plotSScreen + 754
	ld	a, h
	ld	(de), a
	inc	de
	ld	a, l
	ld	(de), a
	b_call(_grBufCpy)
	ret

putSelfHealth:					;puts health bar for self
	ld	a, (gameHealth)
	ld	h, 0
	ld	l, a
	b_call(_setXXXXOP2)		;bar length = 12(gameHealth/maxHealth)
	b_call(_op2toOp1)
	ld	a, (maxHealth)
	ld	h, 0
	ld	l, a
	b_call(_setXXXXOP2)
	b_call(_fpDiv)
	ld	a, 12
	b_call(_setXXOP2)
	b_call(_fpMult)
	call	convertFP
	ld	hl, 0
	cp	0
	jr	z, skipPutSelfHealth
	ld	b, a
	set	7, h
putSelfHealthLoop:
	SRA	h
	RR	l
skipPutSelfHealth:
	djnz	putSelfHealthLoop
	res	7, h
	ld	de, 3
	add	hl, de
	ld	de, plotSScreen + 744
	ld	a, h
	ld	(de), a
	inc	de
	ld	a, l
	ld	(de), a
	b_call(_grBufCpy)
	ret



