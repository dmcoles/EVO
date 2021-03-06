OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'graphics/gfx',
       'graphics/view'

#define ANIMATIONDTCLASS 'animation.datatype'

CONST ADTA_DUMMY=$80001258,
      ADTA_MODEID=$800010C8,
      ADTA_KEYFRAME=$800010CA,
      ADTA_COLORREGISTERS=$800010CB,
      ADTA_CREGS=$800010CC,
      ADTA_GREGS=$800010CD,
      ADTA_COLORTABLE=$800010CE,
      ADTA_COLORTABLE2=$800010CF,
      ADTA_ALLOCATED=$800010D0,
      ADTA_NUMCOLORS=$800010D1,
      ADTA_NUMALLOC=$800010D2,
      ADTA_REMAP=$800010D3,
      ADTA_SCREEN=$800010D4,
      ADTA_NUMSPARSE=$800010D9,  -> Data for this tag is unsigned INT
      ADTA_SPARSETABLE=$800010DA,
      ADTA_WIDTH=$80001259,
      ADTA_HEIGHT=$8000125A,
      ADTA_DEPTH=$8000125B,
      ADTA_FRAMES=$8000125C,
      ADTA_FRAME=$8000125D,
      ADTA_FRAMESPERSECOND=$8000125E,
      ADTA_FRAMEINCREMENT=$8000125F,
      ADTA_SAMPLE=$800011F6,
      ADTA_SAMPLELENGTH=$800011F7,
      ADTA_PERIOD=$800011F8,
      ADTA_VOLUME=$800011F9,
      ADTA_CYCLES=$800011FA,
      ADTA_LEFTSAMPLE=$80001201,
      ADTA_RIGHTSAMPLE=$80001202,
      ADTA_SAMPLESPERSEC=$800011FF,      
      ID_ANIM="ANIM",
      ID_ANHD="ANHD",
      ID_DLTA="DLTA"

OBJECT animheader
  operation:CHAR
  mask:CHAR
  width:INT  -> This is unsigned
  height:INT  -> This is unsigned
  left:INT
  top:INT
  abstime:LONG
  reltime:LONG
  interleave:CHAR
  pad0:CHAR
  flags:LONG
  pad[16]:ARRAY
ENDOBJECT

CONST ADTM_DUMMY=$700,
      ADTM_LOADFRAME=$701,
      ADTM_UNLOADFRAME=$702,
      ADTM_START=$703,
      ADTM_PAUSE=$704,
      ADTM_STOP=$705,
      ADTM_LOCATE=$706,
      ADTM_LOADNEWFORMATFRAME=$707,
      ADTM_UNLOADNEWFORMATFRAME=$708

OBJECT adtframe
  methodid:LONG
  timestamp:LONG
  frame:LONG
  duration:LONG
  bitmap:PTR TO bitmap
  cmap:PTR TO colormap
  sample:PTR TO CHAR
  samplelength:LONG
  period:LONG
  userdata:LONG
ENDOBJECT

OBJECT adtnewformatframe
  methodid:LONG
  timestamp:LONG
  frame:LONG
  duration:LONG
  bitmap:PTR TO bitmap
  cmap:PTR TO colormap
  sample:PTR TO CHAR
  samplelength:LONG
  period:LONG
  userdata:LONG
  size:LONG
  leftsample:PTR TO CHAR
  rightsample:PTR TO CHAR
  samplespersec:LONG
ENDOBJECT     /* SIZEOF=56 */

OBJECT adtstart
  methodid:LONG
  frame:LONG
ENDOBJECT
