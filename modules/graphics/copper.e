  OPT MODULE
  OPT EXPORT

  OPT PREPROCESS

  MODULE 'graphics/view'

CONST COPPER_MOVE=0,
      COPPER_WAIT=1,
      CPRNXTBUF=2,
      CPR_NT_LOF=$8000,
      CPR_NT_SHT=$4000,
      CPR_NT_SYS=$2000

OBJECT copins
  opcode:INT
  UNION
  [nxtlist:PTR TO coplist]
  [
  destaddr:INT
  destdata:INT]
  [
  vwaitpos:INT
  hwaitpos:INT]
  ENDUNION
ENDOBJECT     /* SIZEOF=6 */

#define VWAITPOS vwaitpos
#define DESTADDR vwaitpos
#define HWAITPOS hwaitpos
#define DESTDATA hwaitpos

OBJECT cprlist
  next:PTR TO cprlist
  start:PTR TO INT  -> Target is unsigned
  maxcount:INT
ENDOBJECT     /* SIZEOF=10 */

OBJECT coplist
  next:PTR TO coplist
-> Um, these had illegal names
  coplist_:PTR TO coplist
  viewport_:PTR TO viewport
  copins:PTR TO copins
  copptr:PTR TO copins
  coplstart:PTR TO INT  -> Target is unsigned
  copsstart:PTR TO INT  -> Target is unsigned
  count:INT
  maxcount:INT
  dyoffset:INT
-> Um, if V1_3 only?
->  cop2start:PTR TO INT
->  cop3start:PTR TO INT
->  cop4start:PTR TO INT
->  cop5start:PTR TO INT
  slrepeat:INT  -> This is unsigned
  flags:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=38 */

CONST EXACT_LINE=1,
      HALF_LINE=2

OBJECT ucoplist
  next:PTR TO ucoplist
  firstcoplist:PTR TO coplist
  coplist:PTR TO coplist
ENDOBJECT     /* SIZEOF=12 */

OBJECT copinit
  vsync_hblank[2]:ARRAY OF INT  -> Array is unsigned
  diagstrt[12]:ARRAY OF INT  -> Array is unsigned
  fm0[2]:ARRAY OF INT  -> Array is unsigned
  diwstart[10]:ARRAY OF INT  -> Array is unsigned
  bplcon2[2]:ARRAY OF INT  -> Array is unsigned
  sprfix[16]:ARRAY OF INT  -> Array is unsigned
  sprstrtup[32]:ARRAY OF INT  -> Array is unsigned
  wait14[2]:ARRAY OF INT  -> Array is unsigned
  norm_hblank[2]:ARRAY OF INT  -> Array is unsigned
  jump[2]:ARRAY OF INT  -> Array is unsigned
  wait_forever[6]:ARRAY OF INT  -> Array is unsigned
  sprstop[8]:ARRAY OF INT  -> Array is unsigned
ENDOBJECT     /* SIZEOF=192 */

