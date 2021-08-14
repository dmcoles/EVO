  OPT MODULE
  OPT EXPORT

  OPT PREPROCESS

CONST SUSERFLAGS=$FF,
      VSF_VSPRITE=1,
      VSF_SAVEBACK=2,
      VSF_OVERLAY=4,
      VSF_MUSTDRAW=8,
      VSF_BACKSAVED=$100,
      VSF_BOBUPDATE=$200,
      VSF_GELGONE=$400,
      VSF_VSOVERFLOW=$800,
      BUSERFLAGS=$FF,
      BF_SAVEBOB=1,
      BF_BOBISCOMP=2,
      BF_BWAITING=$100,
      BF_BDRAWN=$200,
      BF_BOBSAWAY=$400,
      BF_BOBNIX=$800,
      BF_SAVEPRESERVE=$1000,
      BF_OUTSTEP=$2000,
      ANFRACSIZE=6,
      ANIMHALF=$20,
      RINGTRIGGER=1

OBJECT vs
  nextvsprite:PTR TO vs
  prevvsprite:PTR TO vs
  drawpath:PTR TO vs
  clearpath:PTR TO vs
  oldy:INT
  oldx:INT
  vsflags:INT
  y:INT
  x:INT
  height:INT
  width:INT
  depth:INT
  memask:INT
  hitmask:INT
  imagedata:PTR TO INT
  borderline:PTR TO INT
  collmask:PTR TO INT
  sprcolors:PTR TO INT
  vsbob:PTR TO bob
  planepick:CHAR  -> This is signed
  planeonoff:CHAR  -> This is signed
  vuserext:LONG
ENDOBJECT     /* SIZEOF=62 */

OBJECT bob
  bobflags:INT
  savebuffer:PTR TO INT
  imageshadow:PTR TO INT
  before:PTR TO bob
  after:PTR TO bob
  bobvsprite:PTR TO vs
  bobcomp:PTR TO ac
  dbuffer:PTR TO dbp
  buserext:LONG
ENDOBJECT     /* SIZEOF=34 */

OBJECT ac
  compflags:INT
  timer:INT
  timeset:INT
  nextcomp:PTR TO ac
  prevcomp:PTR TO ac
  nextseq:PTR TO ac
  prevseq:PTR TO ac
  animcroutine:LONG
  ytrans:INT
  xtrans:INT
  headob:PTR TO ao
  animbob:PTR TO bob
ENDOBJECT     /* SIZEOF=38 */

OBJECT ao
  nextob:PTR TO ao
  prevob:PTR TO ao
  clock:LONG
  anoldy:INT
  anoldx:INT
  any:INT
  anx:INT
  yvel:INT
  xvel:INT
  yaccel:INT
  xaccel:INT
  ringytrans:INT
  ringxtrans:INT
  animoroutine:LONG
  headcomp:PTR TO ac
  auserext:LONG
ENDOBJECT     /* SIZEOF=44 */

OBJECT dbp
  bufy:INT
  bufx:INT
  bufpath:PTR TO vs
  bufbuffer:PTR TO INT
  bufplanes:PTR TO LONG
ENDOBJECT     /* SIZEOF=16 */

#define InitAnimate(animKey) PutLong(animKey,NIL)
#define RemBob(b)            PutInt(b, Int(b) OR BF_BOBSAWAY)

CONST B2NORM=0,
      B2SWAP=1,
      B2BOBBER=2

OBJECT colltable
  collptrs[16]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=64 */

