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
;		single.asm
;;;

startSingleplay:
	ld	hl, AFflags
	bit	singleMsg, (hl)
	call	z, otm4

	ld	a, 1
	ld	(gameType), a

	b_call( _GrBufClr )	

	call	initGame
	call	getEnemyStats
	call	putTerrain
	call	dropTank
	call	dropEnemy




	call	putGameMenu
	b_call( _GrBufCpy )	
	jp	pauseLoop



;=======================================================================================================================;
;				Routines										;
;=======================================================================================================================;

getEnemyStats:
	ld	a, 100
	ld	(enemyHealth), a
	ld	(maxEnemyHealth), a
	ret




;=======================================================================================================================;
;				Data											;
;=======================================================================================================================;
