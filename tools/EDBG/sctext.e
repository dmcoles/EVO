-> implementation of textscrollerwindow class, subclass of scrollwin

OPT MODULE

MODULE 'class/sc'
MODULE 'intuition/intuition', 'intuition/screens','exec/memory',
       'graphics/rastport', 'graphics/gfxbase', 'graphics/text','graphics/gfx'

EXPORT OBJECT scrolltext OF scrollwin PRIVATE
  font:PTR TO textfont
  lines, cols
  tlist:PTR TO LONG
  bpoints:PTR TO CHAR
  ox,oy,oxs,oys
  current,ocurrent,curvis
ENDOBJECT

PROC settext(textlist,bpointlist,width) OF scrolltext
  self.lines:=ListLen(textlist)
  self.cols:=width
  self.tlist:=textlist
  self.bpoints:=bpointlist
  self.current:=-1
  self.ocurrent:=-1
  self.curvis:=FALSE
ENDPROC

PROC refreshwindow() OF scrolltext
  self.ox:=0
  self.oy:=0
  self.oxs:=0
  self.oys:=0
  SUPER self.refreshwindow()
ENDPROC

PROC getactive() OF scrolltext IS self.current

PROC active(cur,dorefresh=TRUE) OF scrolltext
  self.current:=cur
  IF dorefresh THEN IF (cur<self.oy) OR (self.oy+self.oys<=cur) THEN self.settop(cur-(self.oys/2)) ELSE SUPER self.refreshwindow()
ENDPROC

PROC bpoint(n) OF scrolltext
  DEF l:PTR TO CHAR
  DEF i
  IF self.bpoints<>NIL
    l:=self.bpoints
    RETURN l[n]
  ENDIF
ENDPROC FALSE

PROC extra_refresh(x,y,xs,ys,xoff,yoff,win:PTR TO window) OF scrolltext
  DEF fx,fy,a,b,yc,base,s,r:PTR TO rastport,ny,nys,bot,de=TRUE,xo2,bp
  DEF ai:areainfo
  DEF tp:tmpras
  DEF sz
  DEF buf
  DEF pi[25]:ARRAY OF INT
  
  r:=stdrast:=win.rport
  fx:=self.font.xsize
  fy:=self.font.ysize
  SetFont(r,self.font)
  base:=self.font.baseline
  bot:=win.height-win.borderbottom-1
  r.mask:=1

  IF self.bpoints
    xo2:=fx
  ELSE
    xo2:=0
  ENDIF

  IF ((a:=self.ocurrent)>=0) AND self.curvis
    a:=a-self.oy*fy+yoff
    ClipBlit(r,xoff+xo2,a,r,xoff+xo2,a,xs*fx-xo2,fy,$50)
    self.curvis:=FALSE
  ENDIF
  ny:=y; nys:=ys
  IF (self.ox=x) AND (self.oxs=xs) AND (self.oys=ys)
    IF (a:=self.oy-y)<>0
      IF ys>Abs(a)					-> only max half display
        IF a>0						-> scroll up
          ClipBlit(r,xoff,yoff,r,xoff,a*fy+yoff,xs*fx,(b:=ys-a)*fy,$C0)
          ys:=a
          bot:=a*fy+yoff-1
        ELSE						-> scroll down
          a:=Abs(a)
          ClipBlit(r,xoff,a*fy+yoff,r,xoff,yoff,xs*fx,(b:=ys-a)*fy,$C0)
          y:=y+b
          yoff:=b*fy+yoff
          ys:=a
        ENDIF
      ENDIF
    ELSE
      de:=FALSE
    ENDIF
  ENDIF
  IF de
    Box(xoff,yoff,win.width-win.borderright-1,bot,0)
    IF self.bpoints
      Line(xoff+fx-1,yoff,xoff+fx-1,bot,1)
    ENDIF
    
    Colour(1)
    FOR a:=0 TO ys-1
      yc:=a*fy+yoff
      IF a+y<ListLen(self.tlist)
        s:=self.tlist[a+y]
        bp:=self.bpoint(a+y)
      ELSE
        s:=''
        bp:=FALSE
      ENDIF
      IF x THEN FOR b:=1 TO x DO IF s[] THEN s++
      
      IF bp 
        MemFill(pi,50,0)
        InitArea( ai, pi, 5);
        r.areainfo:=ai
        
        sz:=fx*fy
        buf:=NewM(sz,MEMF_CHIP)
        IF buf
          InitTmpRas(tp,buf,sz)
          r.tmpras:=tp
          
          AreaEllipse(r,xoff+(fx/2)-1,yc+base-(fy/2)+2,fx/4,fy/4)
          AreaEnd(r)
          r.tmpras:=NIL
          Dispose(buf)
        ENDIF
        r.areainfo:=NIL
        ->DrawEllipse(r,xoff+(fx/2),yc+base-(fy/2),fx/4,fy/4)
      ENDIF
      Move(r,xoff+xo2,yc+base)
      Text(r,s,Min(xs-(IF xo2 THEN 1 ELSE 0),StrLen(s)))
    ENDFOR
  ENDIF
  IF (a:=self.current)>=0
    IF (a>=ny) AND (ny+nys>a)
      a:=a-y*fy+yoff
      ClipBlit(r,xoff+xo2,a,r,xoff+xo2,a,xs*fx-xo2,fy,$50)
      self.curvis:=TRUE
    ENDIF
  ENDIF
  self.ox:=x
  self.oy:=ny
  self.oxs:=xs
  self.oys:=nys
  self.ocurrent:=self.current
ENDPROC

PROC extra_init(screen:PTR TO screen) OF scrolltext
  DEF gb:PTR TO gfxbase
  gb:=gfxbase
  self.font:=gb.defaultfont	-> needs openfont?
ENDPROC

PROC extra_unit() OF scrolltext IS self.font.xsize, self.font.ysize
PROC extra_max() OF scrolltext IS self.cols, self.lines
