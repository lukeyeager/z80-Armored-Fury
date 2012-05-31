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
;		otm.asm
;;;

otm1:				;opening message
	b_call( _ClrLCDFull )	
	b_call( _HomeUp )	
	ld	hl, otm1txt
	b_call( _PutS )	
	ld	hl, AFflags
	set	openingMsg, (hl)
	jp	pauseLoop

otm2:				;upgrade menu message
	b_call( _ClrLCDFull )	
	b_call( _HomeUp )	
	ld	hl, otm2txt
	b_call( _PutS )	
	ld	hl, AFflags
	set	upgradeMsg, (hl)
	jp	pauseLoop

otm3:				;training message
	b_call( _ClrLCDFull )	
	ld	hl, 26
	ld	(penCol), hl
	ld	hl, otm3txt1
	b_call( _VPutS )	
	ld	hl, 11*256 + 1
	ld	(penCol), hl
	ld	hl, otm3txt2
	b_call( _VPutS )	
	ld	hl, 18*256 + 1
	ld	(penCol), hl
	ld	hl, otm3txt3
	b_call( _VPutS )	
	ld	hl, 25*256 + 1
	ld	(penCol), hl
	ld	hl, otm3txt4
	b_call( _VPutS )	
	ld	hl, 34*256 + 3
	ld	(penCol), hl
	ld	hl, otm3txt5
	b_call( _VPutS )	
	ld	hl, 40*256 + 3
	ld	(penCol), hl
	ld	hl, otm3txt6
	b_call( _VPutS )	
	ld	hl, 46*256 + 3
	ld	(penCol), hl
	ld	hl, otm3txt7
	b_call( _VPutS )	
	ld	hl, 52*256 + 3
	ld	(penCol), hl
	ld	hl, otm3txt8
	b_call( _VPutS )	
	ld	hl, 58*256 + 3
	ld	(penCol), hl
	ld	hl, otm3txt9
	b_call( _VPutS )	

	ld	hl, AFflags
	set	trainMsg, (hl)
	jp	pauseLoop

otm4:				;singleplayer message
	b_call( _ClrLCDFull )	
	ld	hl, 21
	ld	(penCol), hl
	ld	hl, otm4txt1
	b_call( _VPutS )	
	ld	hl, 11*256 + 2
	ld	(penCol), hl
	ld	hl, otm4txt2
	b_call( _VPutS )	
	ld	hl, 18*256 + 2
	ld	(penCol), hl
	ld	hl, otm4txt3
	b_call( _VPutS )	
	ld	hl, 29*256 + 1
	ld	(penCol), hl
	ld	hl, otm4txt4
	b_call( _VPutS )	
	ld	hl, 37*256 + 2
	ld	(penCol), hl
	ld	hl, otm4txt5
	b_call( _VPutS )	
	ld	hl, 45*256 + 2
	ld	(penCol), hl
	ld	hl, otm4txt6
	b_call( _VPutS )	

	ld	hl, AFflags
	set	singleMsg, (hl)
	jp	pauseLoop


;=======================================================================================================================;
;				Data Declarations									;
;=======================================================================================================================;

otm1txt:
	.db "   Welcome To   "
	.db "                "
	.db "****************"
	.db "**ARMORED FURY**"
	.db "****************"
	.db "                "
	.db "Created by:     "
	.db "     Luke Yeager"

otm2txt:
	.db "  Upgrade Menu  "
	.db "                "
	.db "Buy upgrades for"
	.db "   your tanks   "
	.db "                "
	.db " 2nd - Buy Item "
	.db " Mode - Info    "
	.db " Clear - Quit", 0

otm3txt1:	.db "Training Mode", 0
otm3txt2:	.db "Use this mode to hone your", 0
otm3txt3:	.db "acurracy before playing", 0
otm3txt4:	.db "the real game.", 0
otm3txt5:	.db "2nd & Mode - Move Tank", 0
otm3txt6:	.db "Up & Down - Power", 0
otm3txt7:	.db "Right & Left - Angle", 0
otm3txt8:	.db "Alpha-Weapon   Enter-Shoot", 0
otm3txt9:	.db "Delete - Teacher Button", 0

otm4txt1:	.db "Singleplayer Mode", 0
otm4txt2:	.db "Win a match (3 rounds) to get", 0
otm4txt3:	.db "points to upgrade your tank.", 0
otm4txt4:	.db "Point System:", 0
otm4txt5:	.db "4 pts for a round win", 0
otm4txt6:	.db "3 pts for a match win", 0

