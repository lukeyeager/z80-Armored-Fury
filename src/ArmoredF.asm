;;;
;	Copyright 2010 Luke Yeager
;
;	This file is part of Armored Fury.
;
;	Armored Fury is free software: you can redistribute it and/or modify
;	it under the terms of the GNU General Public License as published by
;	the Free Software Foundation, either version 3 of the License, or
;	(at your option) any later version.
;
;	Armored Fury is distributed in the hope that it will be useful,
;	but WITHOUT ANY WARRANTY; without even the implied warranty of
;	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;	GNU General Public License for more details.
;
;	You should have received a copy of the GNU General Public License
;	along with Armored Fury. If not, see <http://www.gnuorg/licenses/>.
;
;
;		ARMOREDF.z80
;;;

.nolist

#include "tools/ti83plus.inc"
#include "tools/mirage.inc"
menuCounter	.equ	appBackUpScreen		;menus
rank		.equ	menuCounter + 1
tempValue1	.equ	rank + 2
tempValue2	.equ	tempValue1 + 1
tempValue3	.equ	tempValue2 + 1
tempValue4	.equ	tempValue3 + 1

tankSpeed	.equ	0			;tank stats
tankPower	.equ	1
tankScatter	.equ	2
tankMortar	.equ	3

tempFlags	.equ	tempValue4 + 1		;game flags (temp)
delayFlag	.equ	5
selfIsDead	.equ	6
enemyIsDead	.equ	7

openingMsg	.equ	0			;more game flags (permanent)
upgradeMsg	.equ	1
singleMsg	.equ	2
multiMsg	.equ	3
trainMsg	.equ	4


gameTank	.equ	tempFlags + 1		;game
gameAngle	.equ	gameTank + 1
angleSpr	.equ	gameAngle + 1
gamePower	.equ	angleSpr+ 1
maxHealth	.equ	gamePower + 1
gameHealth	.equ	maxHealth + 1
gameWind	.equ	gameHealth + 1
gameWeapon	.equ	gameWind + 1
gameScatters	.equ	gameWeapon + 1
gameMortars	.equ	gameScatters + 1
gameX		.equ	gameMortars + 1
gameY		.equ	gameX + 1
sprBuf		.equ	gameY + 1	;4 bytes
minMenuBuf	.equ	sprBuf + 4	;12 bytes
enemyX		.equ	minMenuBuf + 12
enemyY		.equ	enemyX + 1
forceX		.equ	enemyY + 1
forceY		.equ	forceX + 1
shootX		.equ	forceY + 1
shootY		.equ	shootX + 2
oldX1		.equ	shootY + 2
oldY1		.equ	oldX1 + 1
oldX2		.equ	oldY1 + 1
oldY2		.equ	oldX2 + 1
windCounter1	.equ	oldY2 + 1
windCounter2	.equ	windCounter1 + 1
windIncrement	.equ	windCounter2 + 1
enemyHealth	.equ	windIncrement + 1		;(50 bytes)
maxEnemyHealth	.equ	enemyHealth + 1
gameDmg		.equ	maxEnemyHealth + 1
gameType	.equ	gameDmg + 1

.list

	.org		$9d93			;Origin
	.db		 $BB,$6D			;Compiled AsmPrgm token
	ret				;Header Byte 1 -- So TIOS wont run
	.db	1			;Header Byte 2 -- Identifies as MirageOS prog

button:					;Program Picture - should be a 15x15 graphic
 .db $54,$CE,$01,$28,$55,$EC,$01,$28,$E5,$28,$B0,$08,$FF,$C0,$38,$30
 .db $20,$08,$7F,$C4,$C3,$B4,$C3,$5A,$C3,$56,$FF,$AA,$7F,$FC

desc:						;Description - zero terminated
				.db		 "Armored Fury (beta)",0		;Your title, whatever you want

begin:
	jp	mainMenuStart




;-------------------------------------Includes text from other files-----------------------

#include "src/mainmenu.asm"
#include "src/library.asm"
#include "src/single.asm"
#include "src/multi.asm"
#include "src/training.asm"
#include "src/tankspr.asm"
#include "src/shoot.asm"
#include "src/upgrades.asm"
#include "src/tankmenu.asm"
#include "src/options.asm"
#include "src/credits.asm"
#include "src/otm.asm"

.end
.end
