-> a memory-display window based on scrollwin

OPT MODULE

MODULE 'class/sc','intuition/intuition','graphics/rastport',
       'graphics/gfxbase','graphics/text'

EXPORT OBJECT scrollhex OF scrollwin PRIVATE
  addr,font:PTR TO textfont,osx,osy
ENDOBJECT

CONST ONELINE=50

PROC setmem(addr) OF scrollhex
  self.addr:=addr
ENDPROC

PROC extra_refresh(x,y,xs,ys,xoff,yoff,win:PTR TO window) OF scrollhex
  DEF fx,fy,a,b,c,d,e,ad,base,r:PTR TO rastport,bot,rnum,addr:PTR TO LONG,s[200]:ARRAY,t[10]:STRING
  r:=stdrast:=win.rport
  fx:=self.font.xsize
  fy:=self.font.ysize
  SetFont(r,self.font)
  base:=self.font.baseline
  bot:=win.height-win.borderbottom-1
  r.mask:=1
  IF (self.osx<>xs) OR (self.osy<>ys) THEN Box(xoff,yoff,win.width-win.borderright-1,bot,0)
  Colour(1)
  rnum:=Bounds(Abs(xs-13)/13,1,12)
  addr:=rnum*4*y+self.addr AND -2
  FOR a:=1 TO ys
    StringF(s,'\z\h[8]: ',addr)
    ad:=addr
    FOR b:=1 TO rnum DO StrAdd(s,StringF(t,'\z\h[8] ',addr[]++))
    StrAdd(s,' "')
    c:=EstrLen(s)
    e:=rnum*4+c-1
    FOR b:=c TO e DO s[b]:=IF ((d:=ad[]++)>31) AND (d<127) THEN d ELSE "."
    SetStr(s,e+1)
    StrAdd(s,'"')
    Move(r,xoff,a-1*fy+yoff+base)
    Text(r,s,Min(xs,StrLen(s)))
  ENDFOR
  self.osx:=xs
  self.osy:=ys
ENDPROC

PROC extra_init(screen) OF scrollhex
  DEF gb:PTR TO gfxbase
  gb:=gfxbase
  self.font:=gb.defaultfont	-> needs openfont?
ENDPROC

PROC extra_unit() OF scrollhex IS self.font.xsize, self.font.ysize
PROC extra_max() OF scrollhex IS 1,1000
