  OPT MODULE
  OPT EXPORT

  OPT PREPROCESS

  MODULE 'graphics/rastport','intuition/screens','intuition/intuition','utility/tagitem'

#define GADGET_BOX(g) ((g)+GD_LEFTEDGE)
#define IM_BOX(im)    ((im)+IG_LEFTEDGE)
#define IM_FGPEN(im)  (im::image.planepick)
#define IM_BGPEN(im)  (im::image.planeonoff)

CONST CUSTOMIMAGEDEPTH=-1,
      IMAGE_ATTRIBUTES=$80020000,
      IA_LEFT=$80020001,
      IA_TOP=$80020002,
      IA_WIDTH=$80020003,
      IA_HEIGHT=$80020004,
      IA_FGPEN=$80020005,
      IA_BGPEN=$80020006,
      IA_DATA=$80020007,
      IA_LINEWIDTH=$80020008,
      IA_PENS=$8002000E,     
      IA_RESOLUTION=$8002000F,
      IA_APATTERN=$80020010,
      IA_APATSIZE=$80020011,
      IA_MODE=$80020012,
      IA_FONT=$80020013,
      IA_OUTLINE=$80020014,
      IA_RECESSED=$80020015,
      IA_DOUBLEEMBOSS=$80020016,
      IA_EDGESONLY=$80020017,
      SYSIA_SIZE=$8002000B,
      SYSIA_DEPTH=$8002000C,
      SYSIA_WHICH=$8002000D,
      SYSIA_DRAWINFO=$80020018,
      SYSIA_PENS=$8002000E,
      IA_SHADOWPEN=$80020009,
      IA_HIGHLIGHTPEN=$8002000A,
      SYSIA_REFERENCEFONT=$80020019,
      IA_SUPPORTSDISABLE=$8002001A,
      IA_FRAMETYPE=$8002001B,
      IA_UNDERSCORE=$8002001C,
      IA_SCALABLE=$8002001D,
      IA_ACTIVATEKEY=$8002001E,
      IA_SCREEN=$8002001F,
      IA_PRECISION=$80020020,
      IA_ORIENTATION=$80020023,
      IA_LABEL=$80020028,
      IA_ERASEBACKGROUND=$8002002D,
      IA_LABELPEN=$80020038,
      SYSISIZE_MEDRES=0,
      SYSISIZE_LOWRES=1,
      SYSISIZE_HIRES=2,
      DEPTHIMAGE=0,
      ZOOMIMAGE=1,
      SIZEIMAGE=2,
      CLOSEIMAGE=3,
      SDEPTHIMAGE=5,
      SDOWNBACKMAGE=6,
      LEFTIMAGE=10,
      UPIMAGE=11,
      RIGHTIMAGE=12,
      DOWNIMAGE=13,
      CHECKIMAGE=14,
      MXIMAGE=15,
      MENUCHECK=16,
      AMIGAKEY=17,
      ICONIFYIMAGE=$16,
      MENUMX=$1B,
      MENUSUB=$1C,
      SHIFTKEYIMAGE=$2A,
      FRAMEF_MINIMAL=2,
      IDOMAIN_MINIMUM=0,
      IDOMAIN_NOMINAL=1,
      IDOMAIN_MAXIMUM=2,
      FRAME_DEFAULT=0,
      FRAME_BUTTON=1,
      FRAME_RIDGE=2,
      FRAME_ICONDROPBOX=3,
      FRAME_PROPBORDER=4,
      FRAME_PROPKNOB=5,
      FRAME_DISPLAY=6,
      FRAME_CONTEXT=7,
      IM_DRAW=$202,
      IM_HITTEST=$203,
      IM_ERASE=$204,
      IM_MOVE=$205,
      IM_DRAWFRAME=$206,
      IM_FRAMEBOX=$207,
      IM_HITFRAME=$208,
      IM_ERASEFRAME=$209,
      IM_DOMAINFRAME=$20A,
      IDS_NORMAL=0,
      IDS_SELECTED=1,
      IDS_DISABLED=2,
      IDS_BUSY=3,
      IDS_INDETERMINATE=4,
      IDS_INACTIVENORMAL=5,
      IDS_INACTIVESELECTED=6,
      IDS_INACTIVEDISABLED=7,
      IDS_INDETERMINANT=4

OBJECT impdomainframe
  methodid:LONG
  drinfo:PTR TO drawinfo
  rport:PTR TO rastport
  which:LONG
  domain:ibox
  attrs:PTR TO tagitem
ENDOBJECT

OBJECT impframebox
  methodid:LONG
  contentsbox:PTR TO ibox
  framebox:PTR TO ibox
  drinfo:PTR TO drawinfo
  frameflags:LONG
ENDOBJECT     /* SIZEOF=NONE !!! */

CONST FRAMEB_SPECIFY=0,
      FRAMEF_SPECIFY=1

OBJECT impdraw
  methodid:LONG
  rport:PTR TO rastport
  offsetx:INT
  offsety:INT
  state:LONG
  drinfo:PTR TO drawinfo
  dimensionswidth:INT
  dimensionsheight:INT
ENDOBJECT     /* SIZEOF=24 */


OBJECT impdrawframe
  methodid:LONG
  rport:PTR TO rastport
  offsetx:INT
  offsety:INT
  state:LONG
  drinfo:PTR TO drawinfo
  dimensionswidth:INT
  dimensionsheight:INT
ENDOBJECT     /* SIZEOF=24 */

OBJECT imperase
  methodid:LONG
  rport:PTR TO rastport
  offsetx:INT
  offsety:INT
  dimensionswidth:INT
  dimensionsheight:INT
ENDOBJECT     /* SIZEOF=16 */

OBJECT imperaseframe
  methodid:LONG
  rport:PTR TO rastport
  offsetx:INT
  offsety:INT
  dimensionswidth:INT
  dimensionsheight:INT
ENDOBJECT     /* SIZEOF=16 */


OBJECT imphittest
  methodid:LONG
  pointx:INT
  pointy:INT
  dimensionswidth:INT
  dimensionsheight:INT
ENDOBJECT     /* SIZEOF=12 */

OBJECT imphitframe
  methodid:LONG
  pointx:INT
  pointy:INT
  dimensionswidth:INT
  dimensionsheight:INT
ENDOBJECT     /* SIZEOF=12 */
