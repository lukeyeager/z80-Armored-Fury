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
;		upgrades.asm
;;;


upgradeMenu:
	ld	hl, AFflags
	bit	upgradeMsg, (hl)
	call	z, otm2

	ld	hl, menuCounter
	ld	(hl), 1
restartUpgradeMenu:
	call	putUpgradeScreen
upgradeKeyLoop:
	b_call( _GetCSC )	
	cp	skDel
	ret	z
	cp	skClear
	jp	z, mainMenuStart
	cp	skUp
	jr	z, upgradeMoveUp
	cp	skDown
	jr	z, upgradeMoveDown
	cp	sk2nd
	jp	z, upgradeKeySelect
	cp	skEnter
	jp	z, upgradeKeySelect
	cp	skMode
	jr	z, upgradeInfo
	cp	skComma
	jr	z, resetStats
	jr	upgradeKeyLoop

resetStats:
	call	resetMemory
	ld	hl, 1000
	ld	(money), hl
	jr	restartUpgradeMenu

upgradeMoveUp:
	call	upgradeEraseBullet
	ld	hl, menuCounter
	ld	a, (hl)
	cp	1
	jr	z, upgradeMoveBottom
	dec	(hl)
	jr	upgradeMoveEnd
upgradeMoveBottom:
	ld	(hl), 5
	jr	upgradeMoveEnd
upgradeMoveDown:
	call	upgradeEraseBullet
	ld	hl, menuCounter
	ld	a, (hl)
	cp	5
	jr	z, upgradeMoveTop
	inc	(hl)
	jr	upgradeMoveEnd
upgradeMoveTop:
	ld	(hl), 1
upgradeMoveEnd:
	call	upgradePutBullet
	jr	upgradeKeyLoop

upgradeInfo:
	ld	a, (menuCounter)
	cp	5
	jr	z, upgradeKeyLoop
	call	putMessageBox
	set	textWrite, (IY + sGrFlags)
	ld	a, (menuCounter)
	cp	2
	jr	z, upgradeScatterInfo
	cp	3
	jr	z, upgradeMortarInfo
	cp	4
	jp	z, upgradePierceInfo

	ld	ix, armorUpgradeSprite		;armor message box
	call	upgradePutSprite
	ld	hl, 18*256 + 31
	ld	(penCol), hl
	ld	hl, armorInfoTxt1
	b_call( _VPutS )	
	ld	hl, 25*256 + 31
	ld	(penCol), hl
	ld	hl, armorInfoTxt2
	b_call( _VPutS )	
	ld	hl, 32*256 + 18
	ld	(penCol), hl
	ld	hl, armorInfoTxt3
	b_call( _VPutS )	
	ld	hl, 40*256 + 48
	ld	(penCol), hl
	ld	hl, armorInfoTxt4
	b_call( _VPutS )	
	b_call( _GrBufCpy )	
	jp	upgradeInfoKeyLoop

upgradeScatterInfo:
	ld	ix, scatterUpgradeSprite	;scatter message box
	call	upgradePutSprite
	ld	hl, 18*256 + 31
	ld	(penCol), hl
	ld	hl, scatterInfoTxt1
	b_call( _VPutS )	
	ld	hl, 25*256 + 31
	ld	(penCol), hl
	ld	hl, scatterInfoTxt2
	b_call( _VPutS )	
	ld	hl, 32*256 + 18
	ld	(penCol), hl
	ld	hl, scatterInfoTxt3
	b_call( _VPutS )	
	ld	hl, 40*256 + 48
	ld	(penCol), hl
	ld	hl, scatterInfoTxt4
	b_call( _VPutS )	
	b_call( _GrBufCpy )	
	jr	upgradeInfoKeyLoop

upgradeMortarInfo:
	ld	ix, mortarUpgradeSprite		;mortar message box
	call	upgradePutSprite
	ld	hl, 18*256 + 31
	ld	(penCol), hl
	ld	hl, mortarInfoTxt1
	b_call( _VPutS )	
	ld	hl, 25*256 + 31
	ld	(penCol), hl
	ld	hl, mortarInfoTxt2
	b_call( _VPutS )	
	ld	hl, 32*256 + 18
	ld	(penCol), hl
	ld	hl, mortarInfoTxt3
	b_call( _VPutS )	
	ld	hl, 40*256 + 48
	ld	(penCol), hl
	ld	hl, mortarInfoTxt4
	b_call( _VPutS )	
	b_call( _GrBufCpy )	
	jr	upgradeInfoKeyLoop

upgradePierceInfo:
	ld	ix, pierceUpgradeSprite		;pierce message box
	call	upgradePutSprite
	ld	hl, 18*256 + 31
	ld	(penCol), hl
	ld	hl, pierceInfoTxt1
	b_call( _VPutS )	
	ld	hl, 25*256 + 31
	ld	(penCol), hl
	ld	hl, pierceInfoTxt2
	b_call( _VPutS )	
	ld	hl, 32*256 + 18
	ld	(penCol), hl
	ld	hl, pierceInfoTxt3
	b_call( _VPutS )	
	ld	hl, 40*256 + 44
	ld	(penCol), hl
	ld	hl, pierceInfoTxt4
	b_call( _VPutS )	
	b_call( _GrBufCpy )	

upgradeInfoKeyLoop:
	res	textWrite, (IY + sGrFlags)
	b_call( _GetCSC )	
	cp	skClear
	jp	z, restartUpgradeMenu
	cp	sk2nd
	jp	z, restartUpgradeMenu
	cp	skMode
	jp	z, restartUpgradeMenu
	cp	skDel
	ret	z
	jr	upgradeInfoKeyLoop

upgradeKeySelect:
	ld	a, (menuCounter)
	cp	5
	jp	z, tankMenu
	ld	hl, (money)			;
	ld	d, 0				;returns if all of item is bought
	cp	2				;or if there is not enough money
	jr	z, checkBoughtScatters		;
	cp	3
	jr	z, checkBoughtMortars
	cp	4
	jr	z, checkBoughtPierce

	ld	a, (statArmor)
	cp	10
	jp	z, upgradeKeyLoop
	ld	e, 20
	jr	endCheckBought
checkBoughtScatters:
	ld	a, (statScatters)
	cp	6
	jp	z, upgradeKeyLoop
	ld	e, 40
	jr	endCheckBought
checkBoughtMortars:
	ld	a, (statMortars)
	cp	3
	jp	z, upgradeKeyLoop
	ld	e, 60
	jr	endCheckBought
checkBoughtPierce:
	ld	a, (statPierce)
	cp	1
	jp	z, upgradeKeyLoop
	ld	e, 100
endCheckBought:
	b_call( _CpHLDE )	
	jp	c, upgradeKeyLoop

	call	putMessageBox

	ld	hl, 17*256 + 18		;generic text
	ld	(penCol), hl
	ld	hl, confirmTxt1
	b_call( _VPutS )	
	ld	hl, 31*256 + 18
	ld	(penCol), hl
	ld	hl, confirmTxt2
	b_call( _VPutS )	
	ld	hl, 40*256 + 18
	ld	(penCol), hl
	ld	hl, confirmTxt3
	b_call( _VPutS )	

	ld	hl, 24*256 + 18
	ld	(penCol), hl
	ld	a, (menuCounter)
	cp	2
	jr	z, upgradeSelectScatter
	cp	3
	jr	z, upgradeSelectMortar
	cp	4
	jr	z, upgradeSelectPierce
	ld	hl, selectArmorTxt	;specialized text
	b_call( _VPutS )	
	ld	a, 20
	jr	upgradeSelectEnd
upgradeSelectScatter:
	ld	hl, selectScatterTxt
	b_call( _VPutS )	
	ld	a, 40
	jr	upgradeSelectEnd
upgradeSelectMortar:
	ld	hl, selectMortarTxt
	b_call( _VPutS )	
	ld	a, 60
	jr	upgradeSelectEnd
upgradeSelectPierce:
	ld	hl, selectPierceTxt
	b_call( _VPutS )	
	ld	a, 100
upgradeSelectEnd:

	ld	hl, 31*256 + 31		;price
	ld	(penCol), hl
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )	
	b_call( _OP2ToOP1 )	
	ld	a, 5
	b_call( _DispOP1A )	
	ld	a, '?'
	b_call( _VPutMap )	

upgradeConfirmKeyLoop:
	b_call( _GetCSC )	
	cp	sk2nd
	jr	z, upgradeBuyItem
	cp	skClear
	jp	z, restartUpgradeMenu
	jr	upgradeConfirmKeyLoop

upgradeBuyItem:
	ld	a, (menuCounter)	;spending $
	ld	b, 0			;and getting items
	cp	2
	jr	z, buyScatter
	cp	3
	jr	z, buyMortar
	cp	4
	jr	z, buyPierce

	ld	c, 20
	ld	hl, statArmor
	inc	(hl)
	jr	endBuyItem
buyScatter:
	ld	c, 40
	ld	hl, statScatters
	inc	(hl)
	jr	endBuyItem
buyMortar:
	ld	c, 60
	ld	hl, statMortars
	inc	(hl)
	jr	endBuyItem
buyPierce:
	ld	c, 100
	ld	hl, statPierce
	inc	(hl)
	jr	endBuyItem
endBuyItem:
	ld	hl, (money)
	SCF
	CCF
	SBC	HL, BC
	ld	(money), hl
	jp	restartUpgradeMenu
	

;=======================================================================================================================;
;				Routines										;
;=======================================================================================================================;

putUpgradeScreen:

	call	blackOutScreen
	ld	hl, plotSScreen + 180	;
	ld	de, 96			;initial menu bullets
	ld	b, 5			;
primaryUpgradeBulletsLoop:
	res	3, (hl)
	add	hl, de
	djnz	primaryUpgradeBulletsLoop
	b_call( _GrBufCpy )	
	call	upgradePutBullet

	set	textInverse, (IY + textFlags)
	set	fracDrawLFont, (IY + fontFlags)
	set	textWrite, (IY + sGrFlags)

	ld	hl, 1*256 + 24		;"UPGRADES"
	ld	(penCol), hl
	ld	hl, upgradesTxt1
	b_call( _VPutS )	

	res	fracDrawLFont, (IY + fontFlags)

	ld	hl, 12*256 + 7		;
	ld	(penCol), hl		;List Items
	ld	hl, upgradesTxt2	;
	b_call( _VPutS )	
	ld	hl, 20*256 + 7
	ld	(penCol), hl
	ld	hl, upgradesTxt3
	b_call( _VPutS )	
	ld	hl, 28*256 + 7
	ld	(penCol), hl
	ld	hl, upgradesTxt4
	b_call( _VPutS )	
	ld	hl, 36*256 + 7
	ld	(penCol), hl
	ld	hl, upgradesTxt5
	b_call( _VPutS )	
	ld	hl, 44*256 + 7
	ld	(penCol), hl
	ld	hl, upgradesTxt6
	b_call( _VPutS )	

	ld	a, (statArmor)		;armor		;
	ld	hl, 12*256 + 69				;variable stat sprites
	ld	(penCol), hl				;
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )	
	b_call( _OP2ToOP1 )	
	ld	a, 5
	b_call( _DispOP1A )	
	ld	a, (statScatters)	;scatters
	ld	hl, 20*256 + 73
	ld	(penCol), hl
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )	
	b_call( _OP2ToOP1 )	
	ld	a, 5
	b_call( _DispOP1A )	
	ld	a, (statPanzer)
	cp	2
	jr	z, capabilitiesPanzer
	ld	a, (statPanther)
	cp	2
	jr	z, capabilitiesPanther
	ld	a, (tigerStats + tankScatter)
	ld	b, a
	ld	a, (tigerStats + tankMortar)
	jr	capabilitiesTiger
capabilitiesPanzer:
	ld	a, (panzerStats + tankScatter)
	ld	b, a
	ld	a, (panzerStats + tankMortar)
	jr	capabilitiesTiger
capabilitiesPanther:
	ld	a, (pantherStats + tankScatter)
	ld	b, a
	ld	a, (pantherStats + tankMortar)
capabilitiesTiger:
	ld	(tempValue1), a
	ld	hl, 20*256 + 81
	ld	(penCol), hl
	ld	h, 0
	ld	l, b
	b_call( _SetXXXXOP2 )	
	b_call( _OP2ToOP1 )	
	ld	a, 5
	b_call( _DispOP1A )		
	ld	a, (statMortars)	;mortars
	ld	hl, 28*256 + 73
	ld	(penCol), hl
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )	
	b_call( _OP2ToOP1 )	
	ld	a, 5
	b_call( _DispOP1A )	
	ld	a, (tempValue1)
	ld	hl, 28*256 + 81
	ld	(penCol), hl
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )	
	b_call( _OP2ToOP1 )	
	ld	a, 5
	b_call( _DispOP1A )	
	ld	a, (statPierce)		;armor piercing
	ld	hl, 36*256 + 74
	ld	(penCol), hl
	cp	1
	jr	z, menuIsPierce
	ld	hl, upgradesTxt10
	jr	menuNotPierce
menuIsPierce:
	ld	hl, upgradesTxt9
menuNotPierce:
	b_call( _VPutS )	
	call	calculateRank		;ranking
	ld	hl, 56*256 + 43
	ld	(penCol), hl
	ld	a, (rank)
	ld	h, 0
	ld	l, a
	b_call( _SetXXXXOP2 )	
	b_call( _OP2ToOP1 )	
	ld	a, 5
	b_call( _DispOP1A )	
	ld	a, (statPanzer)		;tank
	cp	2
	jr	z, menuPanzer
	ld	a, (statPanther)
	cp	2
	jr	z, menuPanther
	ld	hl, tigerTxt
	jr	menuTiger
menuPanzer:
	ld	hl, panzerTxt
	jr	menuTiger
menuPanther:
	ld	hl, pantherTxt
menuTiger:
	b_call( _VPutS )	


	ld	hl, 12*256 + 77				;
	ld	(penCol), hl				;fixed stat sprites
	ld	hl, upgradesTxt7			;
	b_call( _VPutS )	
	ld	hl, 20*256 + 77
	ld	(penCol), hl
	ld	hl, upgradesTxt8
	b_call( _VPutS )	
	ld	hl, 28*256 + 77
	ld	(penCol), hl
	ld	hl, upgradesTxt8
	b_call( _VPutS )	

	ld	hl, plotSScreen + 672			;
	call	putMoneySprite				;money
	ld	hl, 56*256 + 9				;
	ld	(penCol), hl
	ld	hl, (money)
	b_call( _SetXXXXOP2 )	
	b_call( _OP2ToOP1 )	
	ld	a, 5
	b_call( _DispOP1A )	

	res	textInverse, (IY + textFlags)
	res	textWrite, (iy+sGrFlags)

	b_call( _GrBufCpy )	
	ret

upgradePutBullet:

	ld	de, plotSScreen + 72
	ld	a, (menuCounter)
	ld	h, 0
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl			;
	add	hl, hl			; get spot to put sprite
	add	hl, hl			;
	ld	b, h
	ld	c, l
	add	hl, hl
	add	hl, bc
	ex	de, hl
	add	hl, de
	jp	menuPutSprite

upgradeEraseBullet:

	ld	de, plotSScreen + 72
	ld	a, (menuCounter)
	ld	h, 0
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl			;
	add	hl, hl			; get spot to put sprite
	add	hl, hl			;
	ld	b, h
	ld	c, l
	add	hl, hl
	add	hl, bc
	ex	de, hl
	add	hl, de
	jp	menuEraseSprite

upgradePutSprite:
	ld	hl, plotSScreen + 230
	ld	de, 11
	ld	b, 9
upgradePutSpriteLoop:
	ld	c, (ix)
	SRL	c
	SRL	c
	SRL	c
	ld	a, (hl)
	or	c
	ld	(hl), a
	ld	c, (ix)
	SLA	c
	SLA	c
	SLA	c
	SLA	c
	SLA	c
	inc	hl
	ld	a, (hl)
	or	c
	ld	(hl), a
	add	hl, de
	inc	ix
	djnz	upgradePutSpriteLoop
	b_call( _GrBufCpy )	
	ret

putMoneySprite:					;puts money sprite at hl (spot in plotSScreen)
	ld	ix, moneyUpgradeSprite
	ld	de, 12
	ld	b, 7
putMoneySpriteLoop:
	ld	a, (ix)
	ld	(hl), a
	inc	ix
	add	hl, de
	djnz	putMoneySpriteLoop
	b_call( _GrBufCpy )	
	ret

;=======================================================================================================================;
;				Data Declarations									;
;=======================================================================================================================;

upgradesTxt1:	.db "UPGRADES", 0
upgradesTxt2:	.db "Armor", 0
upgradesTxt3:	.db "Scatters", 0
upgradesTxt4:	.db "Mortars", 0
upgradesTxt5:	.db "Armor Piercing", 0
upgradesTxt6:	.db "Change Tanks", 0
upgradesTxt7:	.db "/10", 0
upgradesTxt8:	.db "/", 0
upgradesTxt9:	.db "Yes", 0
upgradesTxt10:	.db "No", 0

armorUpgradeSprite:		.db $FE,$82,$92,$BA,$92,$82,$44,$44,$38
scatterUpgradeSprite:	.db $0C,$2C,$40,$46,$96,$A0,$DB,$E3,$C0
mortarUpgradeSprite:	.db $06,$0E,$04,$10,$00,$20,$00,$60,$60
pierceUpgradeSprite:	.db $00,$03,$07,$1A,$24,$44,$88,$50,$20
moneyUpgradeSprite:		.db $F7,$E1,$D7,$E3,$F5,$C3,$F7

armorInfoTxt1:	.db "Increase", 0
armorInfoTxt2:	.db "your tanks", 0
armorInfoTxt3:	.db "armor by 1.", 0
armorInfoTxt4:	.db "Price: 20", 0

scatterInfoTxt1:	.db "Fire three", 0
scatterInfoTxt2:	.db "normal shots", 0
scatterInfoTxt3:	.db "at once.", 0
scatterInfoTxt4:	.db "Price: 40", 0

mortarInfoTxt1:	.db "Lob one huge", 0
mortarInfoTxt2:	.db "shot to give big", 0
mortarInfoTxt3:	.db "damage.", 0
mortarInfoTxt4:	.db "Price: 60", 0

pierceInfoTxt1:	.db "Double", 0
pierceInfoTxt2:	.db "your guns", 0
pierceInfoTxt3:	.db "damage.", 0
pierceInfoTxt4:	.db "Price: 100", 0

confirmTxt1:	.db "Do you want to buy", 0
confirmTxt2:	.db "for ", 0
confirmTxt3:	.db "2nd-Yes   Clear-No", 0

selectArmorTxt:		.db "Armor", 0
selectScatterTxt:	.db "a Scatter shot", 0
selectMortarTxt:	.db "a Mortar shot", 0
selectPierceTxt:	.db "Armor Piercing", 0

panzerTxt:	.db "Panzer III", 0
pantherTxt:	.db "Panther", 0
tigerTxt:	.db "Tiger", 0

statPanzer:		.db 2
statPanther:	.db 0
statTiger:		.db 0
statArmor:		.db 0
statScatters:	.db 0
statMortars:	.db 0
statPierce:		.db 0
money:			.dw 500
AFflags:		.db 0

