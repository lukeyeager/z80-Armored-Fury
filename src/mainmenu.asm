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
;   mainmenu.asm
;;;

mainMenuStart:

	ld	hl, AFflags
	bit	openingMsg, (hl)
	call	z, otm1

	ld	hl, menuCounter
	ld	(hl), 1
	ld	hl, mainMenuPic
	ld	de, plotSScreen
	ld	bc, 64*12
	LDIR
	b_call( _GrBufCpy )	
mainMenuLoop:
	b_call( _GetCSC )	
	cp	sk2nd
	jr	z, mainMenuEnd
	cp	skEnter
	jr	z, mainMenuEnd
	cp	skUp
	jr	z, mainMenuMoveUp
	cp	skDown
	jr	z, mainMenuMoveDown
	cp	skClear
	ret	z
	cp	skDel
	ret	z
	jr	mainMenuLoop

mainMenuMoveUp:
	call	mainMenuEraseBullet
	ld	hl, menuCounter
	ld	a, (hl)
	cp	1
	jr	z, mainMenuMoveBottom
	dec	(hl)
	jr	mainMenuMoveEnd
mainMenuMoveBottom:
	ld	(hl), 5
	jr	mainMenuMoveEnd
mainMenuMoveDown:
	call	mainMenuEraseBullet
	ld	hl, menuCounter
	ld	a, (hl)
	cp	5
	jr	z, mainMenuMoveTop
	inc	(hl)
	jr	mainMenuMoveEnd
mainMenuMoveTop:
	ld	(hl), 1
mainMenuMoveEnd:
	call	mainMenuPutBullet
	jr	mainMenuLoop
mainMenuEnd:
	ld	a, (menuCounter)
	cp	1
	jp	z, startSingleplay
	cp	2
	jp	z, startMultiplay
	cp	3
	jp	z, startTraining
	cp	4
	jp	z, upgradeMenu
	jp	optionsMenu

mainMenuPutBullet:

	ld	de, plotSScreen + 216
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
	call	menuPutSprite
	ret

mainMenuEraseBullet:

	ld	de, plotSScreen + 216
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
	call	menuEraseSprite
	ret

mainMenuPic:
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$C0,$00
 .db $00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$BF,$FF,$FF,$FF,$FF,$FF
 .db $FF,$FE,$FF,$FF,$FF,$FF,$BC,$3F,$FF,$FF,$FF,$F8,$1F,$FE,$FF,$FF
 .db $FF,$FF,$B8,$1E,$F7,$BD,$EF,$70,$1D,$EE,$FF,$FF,$FF,$FF,$B9,$9C
 .db $63,$18,$C6,$33,$F8,$C6,$FF,$FF,$FF,$FF,$B3,$CE,$F7,$BD,$EF,$73
 .db $FD,$EE,$FF,$FF,$FF,$FF,$B3,$CD,$6B,$5A,$D6,$B3,$FA,$D6,$FF,$FF
 .db $FF,$FF,$B0,$0F,$FF,$FF,$FF,$F0,$7F,$FE,$FF,$FF,$FF,$FF,$A0,$07
 .db $FF,$FF,$FF,$F0,$7F,$FE,$FF,$FF,$FF,$FF,$A3,$C4,$5D,$98,$89,$F3
 .db $DA,$2A,$FF,$FF,$FF,$FF,$A7,$E5,$49,$6A,$9A,$F3,$DA,$AA,$FF,$FF
 .db $FF,$FF,$A7,$E4,$C1,$69,$BA,$F3,$DA,$76,$FF,$FF,$FF,$FF,$A7,$E5
 .db $55,$9A,$89,$F3,$E6,$B6,$FF,$FF,$FF,$FF,$BF,$FF,$FF,$FF,$FF,$FF
 .db $FF,$FE,$FF,$FF,$FF,$FF,$C0,$00,$00,$00,$00,$00,$00,$01,$FF,$FF
 .db $FF,$FF,$EA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$FF,$FF,$FF,$FF,$EA,$AA
 .db $AA,$AA,$AA,$AA,$AA,$AB,$FF,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00
 .db $00,$07,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$2F,$F9,$FE
 .db $7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$8E,$F9,$CD,$B3,$65,$6D,$7F,$FF
 .db $FF,$FF,$FF,$FF,$97,$6A,$AD,$55,$55,$54,$FF,$FC,$00,$00,$0F,$FF
 .db $8F,$AA,$CD,$33,$56,$CD,$FF,$FB,$FF,$FF,$FF,$FF,$FE,$6A,$ED,$97
 .db $66,$E5,$FF,$FA,$07,$00,$0F,$FF,$FF,$FF,$9F,$F7,$FD,$FF,$FF,$FB
 .db $83,$00,$09,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$99,$9F,$FC,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$99,$9F,$F4,$FF,$FE,$BE,$5B,$CF
 .db $FF,$FF,$FF,$FE,$9C,$CF,$F6,$7F,$FE,$2B,$4E,$6C,$AD,$AF,$FF,$FE
 .db $9C,$CF,$FB,$3F,$F6,$2B,$5A,$AA,$AA,$9F,$FF,$FE,$9E,$60,$35,$3F
 .db $FE,$AB,$5A,$6A,$D9,$BF,$FF,$FE,$9E,$60,$35,$9F,$FE,$A3,$6A,$EC
 .db $DC,$BF,$FF,$FE,$80,$33,$FA,$9F,$FF,$FF,$FE,$FF,$BF,$FF,$FF,$FE
 .db $80,$33,$F5,$9F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$9F,$99,$F5,$3F
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$9F,$99,$FB,$3F,$FE,$3F,$EF,$BF
 .db $FF,$FF,$FF,$FE,$9F,$CC,$F6,$7F,$FF,$6B,$39,$E7,$3F,$FF,$FF,$FE
 .db $9F,$CC,$F4,$FF,$F7,$66,$AA,$AA,$BF,$FF,$FF,$FE,$9F,$E6,$7C,$FF
 .db $FF,$6E,$AA,$AB,$3F,$FF,$FF,$FE,$9F,$E7,$39,$FF,$FF,$6F,$2A,$AB
 .db $BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$7F,$FF,$FF,$FF
 .db $DF,$BF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$BF,$7F,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$06,$0C,$1F,$FF,$FE,$BF,$FF,$FB
 .db $FF,$FF,$FF,$FF,$8F,$1E,$3F,$FF,$FE,$A7,$2B,$33,$67,$FF,$FF,$FF
 .db $AF,$5E,$BF,$FF,$F6,$AA,$A6,$AA,$AF,$FF,$FF,$FF,$FD,$F7,$FF,$FF
 .db $FE,$A7,$2E,$AA,$77,$FF,$FF,$FF,$FD,$F7,$FF,$FF,$FE,$2F,$AF,$33
 .db $27,$FF,$FF,$FF,$F0,$41,$FF,$FF,$FF,$EE,$7F,$FF,$FF,$FF,$FF,$FF
 .db $F8,$E3,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FA,$EB,$FF,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7E,$DF,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$A6,$7B,$33,$FF,$FF,$FF,$FF
 .db $FF,$FF,$FF,$FF,$F6,$AA,$D5,$57,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .db $FE,$A6,$D5,$5B,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$6F,$5B,$53
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF,$FF,$FF,$FF,$FF,$FF,$FF
 .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
