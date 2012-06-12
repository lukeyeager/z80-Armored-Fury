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
;		ArmoredF.asm
;;;

.nolist

#define VERSION "0.1.1"

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
aliceIsDead	.equ	6
bobIsDead	.equ	7

openingMsg	.equ	0			;more game flags (permanent)
upgradeMsg	.equ	1
singleMsg	.equ	2
multiMsg	.equ	3
trainMsg	.equ	4

aliceTank	.equ	tempFlags + 1		; which tank is being used
bobTank		.equ	aliceTank + 1

gameAngle	.equ	bobTank + 1		; in-game options
angleSpr	.equ	gameAngle + 1	; which angle is being displayed graphically
gamePower	.equ	angleSpr + 1
gameWeapon	.equ	gamePower + 1

gameScatters	.equ	gameWeapon + 1		; in-game quantities
gameMortars		.equ	gameScatters + 1

aliceMaxHealth	.equ	gameMortars + 1		; health
bobMaxHealth	.equ	aliceMaxHealth + 1
aliceHealth		.equ	bobMaxHealth + 1
bobHealth		.equ	aliceHealth + 1

gameWind		.equ	bobHealth + 1		; wind
windCounter1	.equ	gameWind + 1
windCounter2	.equ	windCounter1 + 1
windIncrement	.equ	windCounter2 + 1

alicePosX	.equ	windIncrement + 1		; tank locations
alicePosY	.equ	alicePosX + 1
bobPosX		.equ	alicePosY + 1
bobPosY		.equ	bobPosX + 1

shotVelX		.equ	bobPosY + 1	; speed of the shot
shotVelY		.equ	shotVelX + 1	
shotPosX		.equ	shotVelY + 1	; location of the shot
shotPosY		.equ	shotPosX + 2
shotOld1x		.equ	shotPosY + 2	; keep old shot location to clear later
shotOld1y		.equ	shotOld1x + 1
shotOld2x		.equ	shotOld1y + 1
shotOld2y		.equ	shotOld2x + 1

sprBuf		.equ	shotOld2y + 1	;4 bytes
minMenuBuf	.equ	sprBuf + 4		 ;12 bytes

gameDmg		.equ	minMenuBuf + 12
gameType	.equ	gameDmg + 1

.list

	.org	$9d93		;Origin
	.db		$BB,$6D		;Compiled AsmPrgm token
	ret					;Header Byte 1 -- So TIOS wont run
	.db	1				;Header Byte 2 -- Identifies as MirageOS prog

button:					;Program Picture - should be a 15x15 graphic
 .db $54,$CE,$01,$28,$55,$EC,$01,$28,$E5,$28,$B0,$08,$FF,$C0,$38,$30
 .db $20,$08,$7F,$C4,$C3,$B4,$C3,$5A,$C3,$56,$FF,$AA,$7F,$FC

desc:					;Description - zero terminated
	.db		 "Armored Fury ", VERSION, 0		;Your title, whatever you want

begin:

	jp	mainMenuStart

	
; Include text from other files...

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
