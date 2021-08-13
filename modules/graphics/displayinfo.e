OPT MODULE
OPT EXPORT

MODULE 'graphics/gfx',
       'graphics/monitor'

CONST DTAG_DISP=$80000000,
      DTAG_DIMS=$80001000,
      DTAG_MNTR=$80002000,
      DTAG_NAME=$80003000,
      DTAG_VEC=$80004000

OBJECT qh
  structid:LONG
  displayid:LONG
  skipid:LONG
  length:LONG
ENDOBJECT     /* SIZEOF=16 */

OBJECT displayinfo
  qh:qh
  notavailable:INT  -> This is unsigned
  propertyflags:LONG
  resolution:tpoint
  pixelspeed:INT  -> This is unsigned
  numstdsprites:INT  -> This is unsigned
  paletterange:INT  -> This is unsigned
  spriteresolution:tpoint
  pad[4]:ARRAY
  redbits:CHAR
  greenbits:CHAR
  bluebits:CHAR
  pad2a:CHAR
  pad2b[4]:ARRAY
  reserved[2]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=56 */

CONST DI_AVAIL_NOCHIPS=1,
      DI_AVAIL_NOMONITOR=2,
      DI_AVAIL_NOTWITHGENLOCK=4,
      DIPF_IS_LACE=1,
      DIPF_IS_DUALPF=2,
      DIPF_IS_PF2PRI=4,
      DIPF_IS_HAM=8,
      DIPF_IS_ECS=16,
      DIPF_IS_AA=$10000,
      DIPF_IS_PAL=$20,
      DIPF_IS_SPRITES=$40,
      DIPF_IS_GENLOCK=$80,
      DIPF_IS_WB=$100,
      DIPF_IS_DRAGGABLE=$200,
      DIPF_IS_PANELLED=$400,
      DIPF_IS_BEAMSYNC=$800,
      DIPF_IS_EXTRAHALFBRITE=$1000,
      DIPF_IS_SPRITES_ATT=$2000,
      DIPF_IS_SPRITES_CHNG_RES=$4000,
      DIPF_IS_SPRITES_BORDER=$8000,
      DIPF_IS_SCANDBL=$20000,
      DIPF_IS_SPRITES_CHNG_BASE=$40000,
      DIPF_IS_SPRITES_CHNG_PRI=$80000,
      DIPF_IS_DBUFFER=$100000,
      DIPF_IS_PROGBEAM=$200000,
      DIPF_IS_FOREIGN=$80000000

OBJECT dimensioninfo
  qh:qh
  maxdepth:INT  -> This is unsigned
  minrasterwidth:INT  -> This is unsigned
  minrasterheight:INT  -> This is unsigned
  maxrasterwidth:INT  -> This is unsigned
  maxrasterheight:INT  -> This is unsigned
  nominal:rectangle
  maxoscan:rectangle
  videooscan:rectangle
  txtoscan:rectangle
  stdoscan:rectangle
  pad[14]:ARRAY
  reserved[2]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=88 */

OBJECT monitorinfo
  qh:qh
  mspc:PTR TO monitorspec
  viewposition:tpoint
  viewresolution:tpoint
  viewpositionrange:rectangle
  totalrows:INT  -> This is unsigned
  totalcolorclocks:INT  -> This is unsigned
  minrow:INT  -> This is unsigned
  compatibility:INT
  pad[32]:ARRAY
  mousetick:tpoint
  defaultviewposition:tpoint
  preferredmodeid:LONG
  reserved[2]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=96 */

CONST MCOMPAT_MIXED=0,
      MCOMPAT_SELF=1,
      MCOMPAT_NOBODY=-1,
      DISPLAYNAMELEN=$20

OBJECT nameinfo
  qh:qh
  name[32]:ARRAY
  reserved[2]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=56 */

OBJECT vecinfo
  qh:qh
  vec:LONG
  data:LONG
  type:INT  -> This is unsigned
  pad[3]:ARRAY OF INT  -> Array is unsigned
  reserved[2]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=40 */

