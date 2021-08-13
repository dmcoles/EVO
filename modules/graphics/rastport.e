OPT MODULE
OPT EXPORT

MODULE 'graphics/clip',
       'graphics/gels',
       'graphics/gfx',
       'graphics/text',
       'graphics/view'

OBJECT tmpras
  rasptr:PTR TO CHAR
  size:LONG
ENDOBJECT     /* SIZEOF=8 */

OBJECT gelsinfo
  sprrsrvd:CHAR  -> This is signed
  flags:CHAR
  gelhead:PTR TO vs
  geltail:PTR TO vs
  nextline:PTR TO INT
-> This is actually PTR TO PTR TO INT
  lastcolor:PTR TO LONG
  collhandler:PTR TO colltable
  leftmost:INT
  rightmost:INT
  topmost:INT
  bottommost:INT
  firstblissobj:LONG
  lastblissobj:LONG
ENDOBJECT     /* SIZEOF=38 */

CONST RPF_FRST_DOT=1,
      RPF_ONE_DOT=2,
      RPF_DBUFFER=4,
      RPF_AREAOUTLINE=8,
      RPF_NOCROSSFILL=$20,
      RP_JAM1=0,
      RP_JAM2=1,
      RP_COMPLEMENT=2,
      RP_INVERSVID=4,
      RPF_TXSCALE=1

CONST RP_AREAPTRN=8,
      RP_MASK=24,
      RP_AOLPEN=27,
      RP_AREAPTSZ=29,
      RP_LINPATCNT=30,
      RP_FLAGS=32,
      RP_LINEPTRN=34

OBJECT rastport
  layer:PTR TO layer
  bitmap:PTR TO bitmap
  areaptrn:PTR TO INT  -> Target is unsigned
  tmpras:PTR TO tmpras
  areainfo:PTR TO areainfo
  gelsinfo:PTR TO gelsinfo
  mask:CHAR
  fgpen:CHAR  -> This is signed
  bgpen:CHAR  -> This is signed
  aolpen:CHAR  -> This is signed
  drawmode:CHAR  -> This is signed
  areaptsz:CHAR  -> This is signed
  linpatcnt:CHAR  -> This is signed
  dummy:CHAR
  flags:INT  -> This is unsigned
  lineptrn:INT  -> This is unsigned
  cp_x:INT
  cp_y:INT
  minterms[8]:ARRAY
  penwidth:INT
  penheight:INT
  font:PTR TO textfont
  algostyle:CHAR
  txflags:CHAR
  txheight:INT  -> This is unsigned
  txwidth:INT  -> This is unsigned
  txbaseline:INT  -> This is unsigned
  txspacing:INT
  rp_user:PTR TO LONG
  longreserved[2]:ARRAY OF LONG
  wordreserved[7]:ARRAY OF INT  -> Array is unsigned
  reserved[8]:ARRAY
ENDOBJECT     /* SIZEOF=100 */

OBJECT areainfo
  vctrtbl:PTR TO INT
  vctrptr:PTR TO INT
  flagtbl:PTR TO CHAR  -> Target is signed
  flagptr:PTR TO CHAR  -> Target is signed
  count:INT
  maxcount:INT
  firstx:INT
  firsty:INT
ENDOBJECT     /* SIZEOF=24 */

CONST ONE_DOTN=1,
      ONE_DOT=2,
      FRST_DOTN=0,
      FRST_DOT=1

