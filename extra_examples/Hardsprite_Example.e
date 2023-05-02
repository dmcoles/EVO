/*

  $VER: HardSprite Example 1 - (C)Copyright Amiga Foundation Classes

  Written By: Andrea Galimberti

  This code is Public Domain



*/

MODULE 'AFC/hardsprite',
       'AFC/explain_exception',
       'intuition/screens'



PROC main() HANDLE
  DEF scr=NIL:PTR TO screen
  DEF vp, spr:PTR TO hardsprite
  DEF x,y,dx,dy

  NEW spr.hardsprite(2)  -> allocate sprite number 2 (IF available)

  spr.image(15,[$0180,$0000,
                $03C0,$0000,
                $07E0,$0000,
                $0FF0,$0000,
                $1FF8,$0180,
                $3FFC,$03C0,
                $7FFE,$07E0,
                $FFFF,$0FF0,
                $7FFE,$07E0,
                $3FFC,$03C0,
                $1FF8,$0180,
                $0FF0,$0000,
                $07E0,$0000,
                $03C0,$0000,
                $0180,$0000]:INT) -> the LIST must be OF INT type


  scr:=OpenScreenTagList(NIL,[SA_TOP,0,
                              SA_LEFT,0,
                              SA_WIDTH,320,
                              SA_HEIGHT,256,
                              SA_DEPTH,5,
                              SA_TITLE,'Sprite Test',
                              NIL,NIL]
                        )
  IF scr=NIL THEN Raise("scr")
  vp:=scr.viewport

  x:=36; y:=0
  dx:=1; dy:=1

  spr.changeImage(vp)
  spr.move(vp,x,y)
  REPEAT
    x:=x+dx; y:=y+dy
    IF (x=304) OR (x=0) THEN dx:=-dx
    IF (y=240) OR (y=0) THEN dy:=-dy
    spr.move(vp,x,y)
    WaitTOF()
  UNTIL Mouse()

EXCEPT DO
  END spr
  IF scr THEN CloseScreen(scr)
  explain_exception()
ENDPROC

