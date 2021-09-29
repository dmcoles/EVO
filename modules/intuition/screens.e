  OPT MODULE
  OPT EXPORT

  MODULE 'exec/nodes','graphics/view','graphics/rastport','graphics/gfx','graphics/layers','exec/tasks','graphics/text','intuition/intuition','utility/tagitem','graphics/clip'


CONST DRI_VERSION=3

OBJECT drawinfo
  version:INT  -> This is unsigned
  numpens:INT  -> This is unsigned
  pens:PTR TO INT  -> Target is unsigned
  font:PTR TO textfont
  depth:INT  -> This is unsigned
  resolutionx:INT  -> This is unsigned
  resolutiony:INT  -> This is unsigned
  flags:LONG
  checkmark:PTR TO image
  amigakey:PTR TO image
  longreserved[5]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=NONE !!! */

CONST DRIF_NEWLOOK=1,
      DRIB_NEWLOOK=0,
      DETAILPEN=0,
      BLOCKPEN=1,
      TEXTPEN=2,
      SHINEPEN=3,
      SHADOWPEN=4,
      FILLPEN=5,
      FILLTEXTPEN=6,
      BACKGROUNDPEN=7,
      HIGHLIGHTTEXTPEN=8,
      BARDETAILPEN=9,
      BARBLOCKPEN=10,
      BARTRIMPEN=11,
      BARCONTOURPEN=12,
      NUMDRIPENS=13,
      PEN_C3=$FEFC,
      PEN_C2=$FEFD,
      PEN_C1=$FEFE,
      PEN_C0=$FEFF

OBJECT screen
  nextscreen:PTR TO screen
  firstwindow:PTR TO window
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  mousey:INT
  mousex:INT
  flags:INT  -> This is unsigned
  title:PTR TO CHAR
  defaulttitle:PTR TO CHAR
  barheight:CHAR  -> This is signed
  barvborder:CHAR  -> This is signed
  barhborder:CHAR  -> This is signed
  menuvborder:CHAR  -> This is signed
  menuhborder:CHAR  -> This is signed
  wbortop:CHAR  -> This is signed
  wborleft:CHAR  -> This is signed
  wborright:CHAR  -> This is signed
  wborbottom:CHAR  -> This is signed
  font:PTR TO textattr
  viewport:viewport
  rastport:rastport
  bitmap:bitmap
  layerinfo:layer_info
  firstgadget:PTR TO gadget
  detailpen:CHAR
  blockpen:CHAR
  savecolor0:INT  -> This is unsigned
  barlayer:PTR TO layer
  extdata:PTR TO CHAR
  userdata:PTR TO CHAR
ENDOBJECT     /* SIZEOF=346 */

CONST SCREENTYPE=15,
      WBENCHSCREEN=1,
      PUBLICSCREEN=2,
      CUSTOMSCREEN=15,
      SHOWTITLE=16,
      BEEPING=$20,
      CUSTOMBITMAP=$40,
      SCREENBEHIND=$80,
      SCREENQUIET=$100,
      SCREENHIRES=$200,
      STDSCREENHEIGHT=-1,
      STDSCREENWIDTH=-1,
      NS_EXTENDED=$1000,
      AUTOSCROLL=$4000,
      PENSHARED=$400,
      SA_DUMMY=$80000020,
      SA_LEFT=$80000021,
      SA_TOP=$80000022,
      SA_WIDTH=$80000023,
      SA_HEIGHT=$80000024,
      SA_DEPTH=$80000025,
      SA_DETAILPEN=$80000026,
      SA_BLOCKPEN=$80000027,
      SA_TITLE=$80000028,
      SA_COLORS=$80000029,
      SA_ERRORCODE=$8000002A,
      SA_FONT=$8000002B,
      SA_SYSFONT=$8000002C,
      SA_TYPE=$8000002D,
      SA_BITMAP=$8000002E,
      SA_PUBNAME=$8000002F,
      SA_PUBSIG=$80000030,
      SA_PUBTASK=$80000031,
      SA_DISPLAYID=$80000032,
      SA_DCLIP=$80000033,
      SA_OVERSCAN=$80000034,
      SA_OBSOLETE1=$80000035,
      SA_SHOWTITLE=$80000036,
      SA_BEHIND=$80000037,
      SA_QUIET=$80000038,
      SA_AUTOSCROLL=$80000039,
      SA_PENS=$8000003A,
      SA_FULLPALETTE=$8000003B,
      SA_COLORMAPENTRIES=$8000003C,
      SA_PARENT=$8000003D,
      SA_DRAGGABLE=$8000003E,
      SA_EXCLUSIVE=$8000003F,
      SA_SHAREPENS=$80000040,
      SA_BACKFILL=$80000041,
      SA_INTERLEAVED=$80000042,
      SA_COLORS32=$80000043,
      SA_VIDEOCONTROL=$80000044,
      SA_FRONTCHILD=$80000045,
      SA_BACKCHILD=$80000046,
      SA_LIKEWORKBENCH=$80000047,
      SA_RESERVED=$80000048,
      SA_MINIMIZEISG=$80000049,
      SA_OFFSCREENDRAGGING=$8000004A,
      OSERR_NOMONITOR=1,
      OSERR_NOCHIPS=2,
      OSERR_NOMEM=3,
      OSERR_NOCHIPMEM=4,
      OSERR_PUBNOTUNIQUE=5,
      OSERR_UNKNOWNMODE=6,
      OSERR_TOODEEP=7,
      OSERR_ATTACHFAIL=8,
      OSERR_NOTAVAILABLE=9,
      OSERR_NORTGBITMAP=10

OBJECT ns
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  depth:INT
  detailpen:CHAR
  blockpen:CHAR
  viewmodes:INT  -> This is unsigned
  type:INT  -> This is unsigned
  font:PTR TO textattr
  defaulttitle:PTR TO CHAR
  gadgets:PTR TO gadget
  custombitmap:PTR TO bitmap
ENDOBJECT     /* SIZEOF=32 */

OBJECT extnewscreen
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  depth:INT
  detailpen:CHAR
  blockpen:CHAR
  viewmodes:INT  -> This is unsigned
  type:INT  -> This is unsigned
  font:PTR TO textattr
  defaulttitle:PTR TO CHAR
  gadgets:PTR TO gadget
  custombitmap:PTR TO bitmap
  extension:PTR TO tagitem
ENDOBJECT     /* SIZEOF=36 */

CONST OSCAN_TEXT=1,
      OSCAN_STANDARD=2,
      OSCAN_MAX=3,
      OSCAN_VIDEO=4

OBJECT pubscreennode
  ln:ln
  screen:PTR TO screen
  flags:INT  -> This is unsigned
  size:INT
  visitorcount:INT
  sigtask:PTR TO tc
  sigbit:CHAR
  pad1:CHAR
ENDOBJECT     /* SIZEOF=30 */

CONST PSNF_PRIVATE=1,
      MAXPUBSCREENNAME=$8B,
      SHANGHAI=1,
      POPPUBSCREEN=2,
      SDEPTH_TOFRONT=0,
      SDEPTH_TOBACK=1,
      SDEPTH_INFAMILY=2,
      SDEPTH_CHILDONLY=2,
      SPOS_RELATIVE=0,
      SPOS_ABSOLUTE=1,
      SPOS_MAKEVISIBLE=2,
      SPOS_FORCEDRAG=4

OBJECT screenbuffer
  bitmap:PTR TO bitmap
  dbufinfo:PTR TO dbufinfo
ENDOBJECT     /* SIZEOF=8 */

CONST SB_SCREEN_BITMAP=1,
      SB_COPY_BITMAP=2

