OPT MODULE
OPT EXPORT

OPT PREPROCESS

#define RASSIZE(w,h) (Mul((h),Shr((w)+15,3) AND $FFFE))

CONST BITSET=$8000,
      BITCLR=0,
      AGNUS=1,
      DENISE=1

OBJECT bitmap
  bytesperrow:INT  -> This is unsigned
  rows:INT  -> This is unsigned
  flags:CHAR
  depth:CHAR
  pad:INT
  planes[8]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=40 */

OBJECT rectangle
  minx:INT
  miny:INT
  maxx:INT
  maxy:INT
ENDOBJECT     /* SIZEOF=8 */

OBJECT rect32
  minx:LONG
  miny:LONG
  maxx:LONG
  maxy:LONG
ENDOBJECT     /* SIZEOF=16 */

OBJECT tpoint
  x:INT
  y:INT
ENDOBJECT     /* SIZEOF=4 */

CONST BMB_CLEAR=0,
      BMB_DISPLAYABLE=1,
      BMB_INTERLEAVED=2,
      BMB_STANDARD=3,
      BMB_MINPLANES=4,
      BMF_CLEAR=1,
      BMF_DISPLAYABLE=2,
      BMF_INTERLEAVED=4,
      BMF_STANDARD=8,
      BMF_MINPLANES=16,
      BMA_HEIGHT=0,
      BMA_DEPTH=4,
      BMA_WIDTH=8,
      BMA_FLAGS=12

