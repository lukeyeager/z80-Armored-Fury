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
;		tankmenu.asm
;;;

tankMenu:

	ld	a, 2
	ld	(menuCounter), a
restartTankMenu:
	call	putTankMenu
tankMenuKeyLoop:
	b_call(_getCSC)
	cp	skDel
	ret	z
	cp	skClear
	jp	z, upgradeMenu
	cp	skUp
	call	z, tankMenuMoveUp
	cp	skDown
	call	z, tankMenuMoveDown
	cp	sk2nd
	jp	z, tankMenuSelect
	cp	skEnter
	jp	z, tankMenuSelect
	jr	tankMenuKeyLoop

tankMenuMoveUp:
	call	upgradeEraseBullet
	ld	hl, menuCounter
	ld	a, (hl)
	cp	2
	jr	z, tankMenuMoveBottom
	dec	(hl)
	jr	tankMenuMoveEnd
tankMenuMoveBottom:
	ld	(hl), 4
	jr	tankMenuMoveEnd
tankMenuMoveDown:
	call	upgradeEraseBullet
	ld	hl, menuCounter
	ld	a, (hl)
	cp	4
	jr	z, tankMenuMoveTop
	inc	(hl)
	jr	tankMenuMoveEnd
tankMenuMoveTop:
	ld	(hl), 2
tankMenuMoveEnd:
	jp	upgradePutBullet



tankMenuSelect:

	ld	a, (menuCounter)
	cp	3
	jr	z, tankSelectPanther
	cp	4
	jp	z, tankSelectTiger

	ld	a, (statPanzer)			;select panzer
	cp	2
	jp	z, tankMenuKeyLoop
	ld	a, 2
	ld	(statPanzer), a
	ld	a, (statTiger)
	cp	2
	jp	z, tankResetTiger
	jp	tankResetPanther
tankSelectPanther:				;select panther
	ld	a, (statPanther)
	cp	2
	jp	z, tankMenuKeyLoop
	cp	0
	jp	nz, tankMenuNotBuyPanther
	ld	hl, (money)
	ld	de, 200
	b_call(_cpHlDe)
	jp	c, tankMenuKeyLoop

	call	putMessageBox		;confirmation message
	ld	hl, 17*256 + 18
	ld	(penCol), hl
	ld	hl, confirmTxt1
	b_call(_vPutS)
	ld	hl, 24*256 + 18
	ld	(pencol), hl
	ld	a, 'a'
	b_call(_vPutMap)
	ld	a, 23
	ld	(pencol), a
	ld	hl, pantherTxt
	b_call(_vPutS)
	ld	hl, tankMenuTxt2
	b_call(_vPutS)
	ld	hl, 31*256 + 18
	ld	(pencol), hl
	ld	hl, confirmTxt2
	b_call(_vPutS)
	ld	hl, 200
	b_call(_setxxxxop2)
	b_call(_op2toop1)
	b_call(_dispop1a)
	ld	a, '?'
	b_call(_vPutMap)
	ld	hl, 40*256 + 18
	ld	(pencol), hl
	ld	hl, confirmTxt3
	b_call(_vPutS)
tankMenuBuyPantherKeyLoop:
	b_call(_getCSC)
	cp	sk2nd
	jr	z, tankSelectPantherConfirmed
	cp	skClear
	jp	z, restartTankMenu
	jr	tankMenuBuyPantherKeyLoop
tankSelectPantherConfirmed:

	ld	hl, (money)
	ld	de, 200
	SCF
	CCF
	SBC	hl, de
	ld	(money), hl
tankMenuNotBuyPanther:
	ld	a, 2
	ld	(statPanther), a
	ld	a, (statPanzer)
	cp	2
	jp	z, tankResetPanzer
	jp	tankResetTiger
tankSelectTiger:				;select tiger
	ld	a, (statTiger)
	cp	2
	jp	z, tankMenuKeyLoop
	cp	0
	jp	nz, tankMenuNotBuyTiger
	ld	hl, (money)
	ld	de, 500
	b_call(_cpHlDe)
	jp	c, tankMenuKeyLoop

	call	putMessageBox		;confirmation message
	ld	hl, 17*256 + 18
	ld	(penCol), hl
	ld	hl, confirmTxt1
	b_call(_vPutS)
	ld	hl, 24*256 + 18
	ld	(pencol), hl
	ld	a, 'a'
	b_call(_vPutMap)
	ld	a, 23
	ld	(pencol), a
	ld	hl, tigerTxt
	b_call(_vPutS)
	ld	hl, tankMenuTxt2
	b_call(_vPutS)
	ld	hl, 31*256 + 18
	ld	(pencol), hl
	ld	hl, confirmTxt2
	b_call(_vPutS)
	ld	hl, 500
	b_call(_setxxxxop2)
	b_call(_op2toop1)
	b_call(_dispop1a)
	ld	a, '?'
	b_call(_vPutMap)
	ld	hl, 40*256 + 18
	ld	(pencol), hl
	ld	hl, confirmTxt3
	b_call(_vPutS)
tankMenuBuyTigerKeyLoop:
	b_call(_getCSC)
	cp	sk2nd
	jr	z, tankSelectTigerConfirmed
	cp	skClear
	jp	z, restartTankMenu
	jr	tankMenuBuyTigerKeyLoop
tankSelectTigerConfirmed:

	ld	hl, (money)
	ld	de, 500
	SCF
	CCF
	SBC	hl, de
	ld	(money), hl
tankMenuNotBuyTiger:
	ld	a, 2
	ld	(statTiger), a
	ld	a, (statPanther)
	cp	2
	jr	z, tankResetPanther

tankResetPanzer:
	ld	a, 1
	ld	(statPanzer), a
	jp	restartTankMenu
tankResetPanther:
	ld	a, 1
	ld	(statPanther), a
	jp	restartTankMenu
tankResetTiger:
	ld	a, 1
	ld	(statTiger), a
	jp	restartTankMenu

;=======================================================================================================================;
;				Routines										;
;=======================================================================================================================;

putTankMenu:
	call	blackOutScreen

	set	TextInverse, (IY + TextFlags)
	set	FracDrawLFont, (IY + FontFlags)
	set	textwrite, (IY + sGrFlags)

	ld	hl, 1*256 + 33			;TANKS
	ld	(pencol), hl
	ld	hl, tankMenuTxt
	b_call(_vPutS)

	res	FracDrawLFont, (IY + FontFlags)

	ld	hl, PlotSScreen + 276		;bullet sprites
	ld	de, 96
	ld	b, 3
primaryTankBulletsLoop:
	res	3, (hl)
	add	hl, de
	djnz	primaryTankBulletsLoop
	call	upgradePutBullet

	ld	hl, 20*256 + 7			;list items
	ld	(pencol), hl
	ld	hl, PanzerTxt
	b_call(_vPutS)
	ld	hl, 28*256 + 7
	ld	(pencol), hl
	ld	hl, PantherTxt
	b_call(_vPutS)
	ld	hl, 36*256 + 7
	ld	(pencol), hl
	ld	hl, tigerTxt
	b_call(_vPutS)

	ld	hl, plotSScreen + 672		;money
	call	putMoneySprite
	ld	hl, 56*256 + 9
	ld	(pencol), hl
	ld	hl, (money)
	b_call(_setxxxxop2)
	b_call(_op2toop1)
	ld	a, 5
	b_call(_dispop1a)
	call	calculateRank			;ranking
	ld	hl, 56*256 + 43
	ld	(pencol), hl
	ld	a, (rank)
	ld	h, 0
	ld	l, a
	b_call(_setxxxxop2)
	b_call(_op2toop1)
	ld	a, 5
	b_call(_dispop1a)
	ld	a, (statPanzer)			;tank
	cp	2
	jr	z, tankMenuPanzer
	ld	a, (statPanther)
	cp	2
	jr	z, tankMenuPanther
	ld	hl, TigerTxt
	jr	tankMenuTiger
tankMenuPanzer:
	ld	hl, PanzerTxt
	jr	tankMenuTiger
tankMenuPanther:
	ld	hl, PantherTxt
tankMenuTiger:
	b_call(_vPutS)

	ld	hl, 20*256 + 67			;panzer status
	ld	(pencol), hl
	ld	a, (statPanzer)
	cp	2
	jr	z, statusPanzerCurrent
	ld	hl, boughtTxt
	jr	endStatusPanzer
statusPanzerCurrent:
	ld	hl, currentTxt
endStatusPanzer:
	b_call(_vPutS)

	ld	hl, 28*256 + 67			;panther status
	ld	(pencol), hl
	ld	a, (statPanther)
	cp	2
	jr	z, statusPantherCurrent
	cp	1
	jr	z, statusPantherBought
	ld	de, plotSScreen + 344
	ld	hl, 200
	call	tanksPutPrice
	jr	endStatusPanther
statusPantherCurrent:
	ld	hl, currentTxt
	b_call(_vPutS)
	jr	endStatusPanther
statusPantherBought:
	ld	hl, boughtTxt
	b_call(_vPutS)
endStatusPanther:

	ld	hl, 36*256 + 67			;tiger status
	ld	(pencol), hl
	ld	a, (statTiger)
	cp	2
	jr	z, statusTigerCurrent
	cp	1
	jr	z, statusTigerBought
	ld	de, plotSScreen + 440
	ld	hl, 500
	call	tanksPutPrice
	jr	endStatusTiger
statusTigerCurrent:
	ld	hl, currentTxt
	b_call(_vPutS)
	jr	endStatusTiger
statusTigerBought:
	ld	hl, boughtTxt
	b_call(_vPutS)
endStatusTiger:

	b_call(_grBufCpy)
	res	TextInverse, (IY + TextFlags)
	res	textwrite, (IY + sGrFlags)
	ret

tanksPutPrice:
	ld	a, (pencol)
	add	a, 6
	ld	(pencol), a
	push	de
	b_call(_setxxxxop2)
	b_call(_op2toop1)
	ld	a, 5
	b_call(_dispop1a)
	pop	hl
	call	putMoneySprite
	ret
	

;=======================================================================================================================;
;				Data											;
;=======================================================================================================================;

tankMenuTxt:	.db "TANKS", 0
tankMenuTxt2:	.db " tank", 0
boughtTxt:	.db "Bought", 0
currentTxt:	.db "Current", 0
tankMsgTxt1:	.db "Tank:", 0
tankMsgTxt2:	.db "Power:", 0
tankMsgTxt3:	.db "Scatters:", 0
tankMsgTxt4:	.db "Mortars:", 0
tankMsgTxt5:	.db "Price:", 0

;=======================================================================================================================;
;				Tank Stats (used by many files to get abilities of each tank)				;
;=======================================================================================================================;

;			speed	power	scatter	mortar	

panzerStats:	.db	6,	3,	2,	1
pantherStats:	.db	5,	4,	4,	2
tigerStats:	.db	4,	5,	6,	3


