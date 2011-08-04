;-------------------------------------------------------;
;     A R M O R E D   F U R Y   f o r   T I - 8 3 +	;
;							;
;      Programmed by: Luke Yeager and Austin Hogan	;
;							;
;							;
;							;
;							;
;		     (Credits Code)			;
;-------------------------------------------------------;

credits:

	call	blackOutScreen
	set	textInverse, (IY + textFlags)
	ld	hl, 0*256 + 20
	ld	(penCol), hl
	ld	hl, creditsTxt1		;Programmed by
	b_call(_vPutS)
	ld	hl, 16*256 + 4
	ld	(penCol), hl
	ld	hl, creditsTxt3		;and
	b_call(_vPutS)
	ld	hl, 24*256 + 19
	ld	(penCol), hl
	ld	hl, creditsTxt5		;Graphical Design
	b_call(_vPuts)
	ld	hl, 32*256 + 77
	ld	(penCol), hl
	ld	hl, creditsTxt3		;and
	b_call(_vPutS)
	ld	hl, 48*256 + 26
	ld	(penCol), hl
	ld	hl, creditsTxt8		;Tank Intel
	b_call(_vPutS)

	set	FracDrawLFont, (IY + FontFlags) 
	ld	hl, 7*256 + 16
	ld	(penCol), hl
	ld	hl, creditsTxt2		;Luke Yeager
	b_call(_vPutS)
	ld	hl, 15*256 + 20
	ld	(penCol), hl
	ld	hl, creditsTxt4		;Austin Hogan
	b_call(_vPutS)
	ld	hl, 31*256 + 8
	ld	(penCol), hl
	ld	hl, creditsTxt6		;Will Garvin
	b_call(_vPutS)
	ld	hl, 39*256 + 6
	ld	(penCol), hl
	ld	hl, creditsTxt7		;Lucas Forsythe
	b_call(_vPuts)
	ld	hl, 55*256 + 12
	ld	(penCol), hl
	ld	hl, creditsTxt9		;Nolon Connor
	b_call(_vPuts)
	res	FracDrawLFont, (IY + FontFlags)
	res	textInverse, (IY + textFlags)

creditsLoop:
	b_call(_getCSC)
	cp	sk2nd
	jp	z, optionsMenu
	cp	skClear
	jp	z, optionsMenu
	cp	skDel
	ret	z
	jr	creditsLoop

creditsTxt1:	.db "-Programmed by-", 0
creditsTxt2:	.db "LUKE YEAGER", 0
creditsTxt3:	.db "and", 0
creditsTxt4:	.db "AUSTIN HOGAN", 0
creditsTxt5:	.db "-Graphical Design-", 0
creditsTxt6:	.db "WILL GARVIN", 0
creditsTxt7:	.db "LUCAS FORSYTHE", 0
creditsTxt8:	.db "-Tank Intel-", 0
creditsTxt9:	.db "NOLAN CONNOR", 0