  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'exec/ports','intuition/screens','utility/tagitem','graphics/gfx','graphics/rastport','graphics/clip','graphics/text','intuition/sghooks','devices/keymap','libraries/keymap'
OBJECT menu
  nextmenu:PTR TO menu
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  flags:INT  -> This is unsigned
  menuname:PTR TO CHAR
  firstitem:PTR TO menuitem
  jazzx:INT
  jazzy:INT
  beatx:INT
  beaty:INT
ENDOBJECT     /* SIZEOF=30 */

CONST MENUENABLED=1,
      MIDRAWN=$100

OBJECT menuitem
  nextitem:PTR TO menuitem
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  flags:INT  -> This is unsigned
  mutualexclude:LONG
  itemfill:LONG
  selectfill:LONG
  command:CHAR
  subitem:PTR TO menuitem
  nextselect:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=34 */

CONST CHECKIT=1,
      ITEMTEXT=2,
      COMMSEQ=4,
      MENUTOGGLE=8,
      ITEMENABLED=16,
      SUBMENU=$200,
      HIGHFLAGS=$C0,
      HIGHIMAGE=0,
      HIGHCOMP=$40,
      HIGHBOX=$80,
      HIGHNONE=$C0,
      CHECKED=$100,
      MIF_SHIFTCOMMSEQ=$800,
      MIF_EXTENDE=$8000,
      MIF_RESERVED=$400,
      ISDRAWN=$1000,
      HIGHITEM=$2000,
      MENUTOGGLED=$4000

OBJECT requester
  olderrequest:PTR TO requester
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  relleft:INT
  reltop:INT
  reqgadget:PTR TO gadget
  reqborder:PTR TO border
  reqtext:PTR TO intuitext
  flags:INT  -> This is unsigned
  backfill:CHAR
  reqlayer:PTR TO layer
  reqpad1[32]:ARRAY OF CHAR
  imagebmap:PTR TO bitmap
  rwindow:PTR TO window
  reqimage:PTR TO image
  reqpad2[32]:ARRAY OF CHAR
ENDOBJECT     /* SIZEOF=112 */

CONST POINTREL=1,
      PREDRAWN=2,
      NOISYREQ=4,
      SIMPLEREQ=16,
      USEREQIMAGE=$20,
      NOREQBACKFILL=$40,
      REQOFFWINDOW=$1000,
      REQACTIVE=$2000,
      SYSREQUEST=$4000,
      DEFERREFRESH=$8000

CONST GD_LEFTEDGE=4

OBJECT gadget
  nextgadget:PTR TO gadget
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  flags:INT  -> This is unsigned
  activation:INT  -> This is unsigned
  gadgettype:INT  -> This is unsigned
  gadgetrender:LONG
  selectrender:LONG
  gadgettext:PTR TO intuitext
  mutualexclude:LONG
  specialinfo:LONG
  gadgetid:INT  -> This is unsigned
  userdata:LONG
ENDOBJECT     /* SIZEOF=44 */

OBJECT extgadget
  nextgadget:PTR TO extgadget
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  flags:INT  -> This is unsigned
  activation:INT  -> This is unsigned
  gadgettype:INT  -> This is unsigned
  gadgetrender:LONG
  selectrender:LONG
  gadgettext:PTR TO intuitext
  mutualexclude:LONG
  specialinfo:LONG
  gadgetid:INT  -> This is unsigned
  userdata:LONG
  moreflags:LONG
  boundsleftedge:INT
  boundstopedge:INT
  boundswidth:INT
  boundsheight:INT
ENDOBJECT     /* SIZEOF=56 */

CONST GFLG_GADGHIGHBITS=3,
      GFLG_GADGHCOMP=0,
      GFLG_GADGHBOX=1,
      GFLG_GADGHIMAGE=2,
      GFLG_GADGHNONE=3,
      GFLG_GADGIMAGE=4,
      GFLG_RELBOTTOM=8,
      GFLG_RELRIGHT=16,
      GFLG_RELWIDTH=$20,
      GFLG_RELHEIGHT=$40,
      GFLG_RELSPECIAL=$4000,
      GFLG_SELECTED=$80,
      GFLG_DISABLED=$100,
      GFLG_LABELMASK=$3000,
      GFLG_LABELITEXT=0,
      GFLG_LABELSTRING=$1000,
      GFLG_LABELIMAGE=$2000,
      GFLG_TABCYCLE=$200,
      GFLG_STRINGEXTEND=$400,
      GFLG_IMAGEDISABLE=$800,
      GFLG_EXTENDED=$8000,
      GACT_RELVERIFY=1,
      GACT_IMMEDIATE=2,
      GACT_ENDGADGET=4,
      GACT_FOLLOWMOUSE=8,
      GACT_RIGHTBORDER=16,
      GACT_LEFTBORDER=$20,
      GACT_TOPBORDER=$40,
      GACT_BOTTOMBORDER=$80,
      GACT_BORDERSNIFF=$8000,
      GACT_TOGGLESELECT=$100,
      GACT_BOOLEXTEND=$2000,
      GACT_STRINGLEFT=0,
      GACT_STRINGCENTER=$200,
      GACT_STRINGRIGHT=$400,
      GACT_LONGINT=$800,
      GACT_ALTKEYMAP=$1000,
      GACT_STRINGEXTEND=$2000,
      GACT_ACTIVEGADGET=$4000,
      GTYP_GADGETTYPE=$FC00,
      GTYP_SYSGADGET=$8000,
      GTYP_SCRGADGET=$4000,
      GTYP_GZZGADGET=$2000,
      GTYP_REQGADGET=$1000,
      GTYP_SIZING=16,
      GTYP_WDRAGGING=$20,
      GTYP_SDRAGGING=$30,
      GTYP_WUPFRONT=$40,
      GTYP_SUPFRONT=$50,
      GTYP_WDOWNBACK=$60,
      GTYP_SDOWNBACK=$70,
      GTYP_CLOSE=$80,
      GTYP_ICONIFY=$90,
      GTYP_BOOLGADGET=1,
      GTYP_GADGET0002=2,
      GTYP_PROPGADGET=3,
      GTYP_STRGADGET=4,
      GTYP_CUSTOMGADGET=5,
      GTYP_GTYPEMASK=7,
      GTYP_SYSTYPEMASK=$F0,
      GTYP_WDEPTH=$40,
      GTYP_SDEPTH=$50,
      GTYP_WZOOM=$60,
      GTYP_SUNUSED=$70,
      GMORE_BOUNDS=1,
      GMORE_GADGETHELP=2,
      GMORE_SCROLLRASTER=4,
      GMORE_HIDDEN=$10,
      GMORE_BOOPSIGADGET=$400,
      GMORE_FREEIMAGE=$800,
      GMORE_PARENTHIDDEN=$1000000

  OBJECT boolinfo
  flags:INT  -> This is unsigned
  mask:PTR TO INT  -> Target is unsigned
  reserved:LONG
ENDOBJECT     /* SIZEOF=10 */

CONST BOOLMASK=1

OBJECT propinfo
  flags:INT  -> This is unsigned
  horizpot:INT  -> This is unsigned
  vertpot:INT  -> This is unsigned
  horizbody:INT  -> This is unsigned
  vertbody:INT  -> This is unsigned
  cwidth:INT  -> This is unsigned
  cheight:INT  -> This is unsigned
  hpotres:INT  -> This is unsigned
  vpotres:INT  -> This is unsigned
  leftborder:INT  -> This is unsigned
  topborder:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=22 */

CONST AUTOKNOB=1,
      FREEHORIZ=2,
      FREEVERT=4,
      PROPBORDERLESS=8,
      KNOBHIT=$100,
      PROPNEWLOOK=16,
      SMARTKNOBIMAGE=$20,
      KNOBHMIN=6,
      KNOBVMIN=4,
      MAXBODY=$FFFF,
      MAXPOT=$FFFF

OBJECT stringinfo
  buffer:PTR TO CHAR
  undobuffer:PTR TO CHAR
  bufferpos:INT
  maxchars:INT
  disppos:INT
  undopos:INT
  numchars:INT
  dispcount:INT
  cleft:INT
  ctop:INT
  extension:PTR TO stringextend
  longint:LONG
  altkeymap:PTR TO keymap
ENDOBJECT     /* SIZEOF=36 */

OBJECT intuitext
  frontpen:CHAR
  backpen:CHAR
  drawmode:CHAR
  leftedge:INT
  topedge:INT
  itextfont:PTR TO textattr
  itext:PTR TO CHAR
  nexttext:PTR TO intuitext
ENDOBJECT     /* SIZEOF=20 */

OBJECT border
  leftedge:INT
  topedge:INT
  frontpen:CHAR
  backpen:CHAR
  drawmode:CHAR
  count:CHAR  -> This is signed
  xy:PTR TO INT
  nextborder:PTR TO border
ENDOBJECT     /* SIZEOF=16 */

CONST IG_LEFTEDGE=0

OBJECT image
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  depth:INT
  imagedata:PTR TO INT  -> Target is unsigned
  planepick:CHAR
  planeonoff:CHAR
  nextimage:PTR TO image
ENDOBJECT     /* SIZEOF=20 */

OBJECT intuimessage
  execmessage:mn
  class:LONG
  code:INT  -> This is unsigned
  qualifier:INT  -> This is unsigned
  iaddress:LONG
  mousex:INT
  mousey:INT
  seconds:LONG
  micros:LONG
  idcmpwindow:PTR TO window
  speciallink:PTR TO intuimessage
ENDOBJECT     /* SIZEOF=52 */

OBJECT extintuimessage
  intuimessage:intuimessage
  tabletdata:PTR TO tabletdata
ENDOBJECT     /* SIZEOF=56 */

OBJECT intuiwheeldata
  version:INT
  reserved:INT
  wheelx:INT
  wheely:INT
  hoveredgadget:PTR TO gadget
ENDOBJECT

CONST INTUIWHEELDATA_VERSION=2,
      IMSGCODE_INTUIRAWKEYDATA=$8000,
      IMSGCODE_INTUIWHEELDATA=$10000,
      IMSGCODE_INTUIWHEELDATAREJECT=$4000

CONST IDCMP_SIZEVERIFY=1,
      IDCMP_NEWSIZE=2,
      IDCMP_REFRESHWINDOW=4,
      IDCMP_MOUSEBUTTONS=8,
      IDCMP_MOUSEMOVE=16,
      IDCMP_GADGETDOWN=$20,
      IDCMP_GADGETUP=$40,
      IDCMP_REQSET=$80,
      IDCMP_MENUPICK=$100,
      IDCMP_CLOSEWINDOW=$200,
      IDCMP_RAWKEY=$400,
      IDCMP_REQVERIFY=$800,
      IDCMP_REQCLEAR=$1000,
      IDCMP_MENUVERIFY=$2000,
      IDCMP_NEWPREFS=$4000,
      IDCMP_DISKINSERTED=$8000,
      IDCMP_DISKREMOVED=$10000,
      IDCMP_WBENCHMESSAGE=$20000,
      IDCMP_ACTIVEWINDOW=$40000,
      IDCMP_INACTIVEWINDOW=$80000,
      IDCMP_DELTAMOVE=$100000,
      IDCMP_VANILLAKEY=$200000,
      IDCMP_INTUITICKS=$400000,
      IDCMP_IDCMPUPDATE=$800000,
      IDCMP_MENUHELP=$1000000,
      IDCMP_CHANGEWINDOW=$2000000,
      IDCMP_GADGETHELP=$4000000,
      IDCMP_EXTENDEDMOUSE=$08000000,
      IDCMP_LONELYMESSAGE=$80000000,
      CWCODE_MOVESIZE=0,
      CWCODE_DEPTH=1,
      CWCODE_HIDE=2,
      CWCODE_SHOW=3,
      MENUHOT=1,
      MENUCANCEL=2,
      MENUWAITING=3,
      OKOK=1,
      OKABORT=4,
      OKCANCEL=2,
      WBENCHOPEN=1,
      WBENCHCLOSE=2

OBJECT ibox
  left:INT
  top:INT
  width:INT
  height:INT
ENDOBJECT     /* SIZEOF=8 */

OBJECT window
  nextwindow:PTR TO window
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  mousey:INT
  mousex:INT
  minwidth:INT
  minheight:INT
  maxwidth:INT  -> This is unsigned
  maxheight:INT  -> This is unsigned
  flags:LONG
  menustrip:PTR TO menu
  title:PTR TO CHAR
  firstrequest:PTR TO requester
  dmrequest:PTR TO requester
  reqcount:INT
  wscreen:PTR TO screen
  rport:PTR TO rastport
  borderleft:CHAR  -> This is signed
  bordertop:CHAR  -> This is signed
  borderright:CHAR  -> This is signed
  borderbottom:CHAR  -> This is signed
  borderrport:PTR TO rastport
  firstgadget:PTR TO gadget
  parent:PTR TO window
  descendant:PTR TO window
  pointer:PTR TO INT  -> Target is unsigned
  ptrheight:CHAR  -> This is signed
  ptrwidth:CHAR  -> This is signed
  xoffset:CHAR  -> This is signed
  yoffset:CHAR  -> This is signed
  idcmpflags:LONG
  userport:PTR TO mp
  windowport:PTR TO mp
  messagekey:PTR TO intuimessage
  detailpen:CHAR
  blockpen:CHAR
  checkmark:PTR TO image
  screentitle:PTR TO CHAR
  gzzmousex:INT
  gzzmousey:INT
  gzzwidth:INT
  gzzheight:INT
  extdata:PTR TO CHAR
  userdata:PTR TO CHAR
  wlayer:PTR TO layer
  ifont:PTR TO textfont
  moreflags:LONG
ENDOBJECT     /* SIZEOF=136 */

CONST WFLG_SIZEGADGET=1,
      WFLG_DRAGBAR=2,
      WFLG_DEPTHGADGET=4,
      WFLG_CLOSEGADGET=8,
      WFLG_SIZEBRIGHT=16,
      WFLG_SIZEBBOTTOM=$20,
      WFLG_REFRESHBITS=$C0,
      WFLG_SMART_REFRESH=0,
      WFLG_SIMPLE_REFRESH=$40,
      WFLG_SUPER_BITMAP=$80,
      WFLG_OTHER_REFRESH=$C0,
      WFLG_BACKDROP=$100,
      WFLG_REPORTMOUSE=$200,
      WFLG_GIMMEZEROZERO=$400,
      WFLG_BORDERLESS=$800,
      WFLG_ACTIVATE=$1000,
      WFLG_RMBTRAP=$10000,
      WFLG_NOCAREREFRESH=$20000,
      WFLG_NW_EXTENDED=$40000,
      WFLG_NEWLOOKMENUS=$200000,
      WFLG_WINDOWACTIVE=$2000,
      WFLG_INREQUEST=$4000,
      WFLG_MENUSTATE=$8000,
      WFLG_WINDOWREFRESH=$1000000,
      WFLG_WBENCHWINDOW=$2000000,
      WFLG_WINDOWTICKED=$4000000,
      WFLG_VISITOR=$8000000,
      WFLG_ZOOMED=$10000000,
      WFLG_HASZOOM=$20000000,
      WFLG_HASICONIFY=$40000000,
      SUPER_UNUSED=$FCFC0000,
      DEFAULTMOUSEQUEUE=5

OBJECT nw
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  detailpen:CHAR
  blockpen:CHAR
  idcmpflags:LONG
  flags:LONG
  firstgadget:PTR TO gadget
  checkmark:PTR TO image
  title:PTR TO CHAR
  screen:PTR TO screen
  bitmap:PTR TO bitmap
  minwidth:INT
  minheight:INT
  maxwidth:INT  -> This is unsigned
  maxheight:INT  -> This is unsigned
  type:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=48 */

OBJECT extnewwindow
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  detailpen:CHAR
  blockpen:CHAR
  idcmpflags:LONG
  flags:LONG
  firstgadget:PTR TO gadget
  checkmark:PTR TO image
  title:PTR TO CHAR
  screen:PTR TO screen
  bitmap:PTR TO bitmap
  minwidth:INT
  minheight:INT
  maxwidth:INT  -> This is unsigned
  maxheight:INT  -> This is unsigned
  type:INT  -> This is unsigned
  extension:PTR TO tagitem
ENDOBJECT     /* SIZEOF=52 */

CONST WA_LEFT=$80000064,
      WA_TOP=$80000065,
      WA_WIDTH=$80000066,
      WA_HEIGHT=$80000067,
      WA_DETAILPEN=$80000068,
      WA_BLOCKPEN=$80000069,
      WA_IDCMP=$8000006A,
      WA_FLAGS=$8000006B,
      WA_GADGETS=$8000006C,
      WA_CHECKMARK=$8000006D,
      WA_TITLE=$8000006E,
      WA_SCREENTITLE=$8000006F,
      WA_CUSTOMSCREEN=$80000070,
      WA_SUPERBITMAP=$80000071,
      WA_MINWIDTH=$80000072,
      WA_MINHEIGHT=$80000073,
      WA_MAXWIDTH=$80000074,
      WA_MAXHEIGHT=$80000075,
      WA_INNERWIDTH=$80000076,
      WA_INNERHEIGHT=$80000077,
      WA_PUBSCREENNAME=$80000078,
      WA_PUBSCREEN=$80000079,
      WA_PUBSCREENFALLBACK=$8000007A,
      WA_WINDOWNAME=$8000007B,
      WA_COLORS=$8000007C,
      WA_ZOOM=$8000007D,
      WA_MOUSEQUEUE=$8000007E,
      WA_BACKFILL=$8000007F,
      WA_RPTQUEUE=$80000080,
      WA_SIZEGADGET=$80000081,
      WA_DRAGBAR=$80000082,
      WA_DEPTHGADGET=$80000083,
      WA_CLOSEGADGET=$80000084,
      WA_BACKDROP=$80000085,
      WA_REPORTMOUSE=$80000086,
      WA_NOCAREREFRESH=$80000087,
      WA_BORDERLESS=$80000088,
      WA_ACTIVATE=$80000089,
      WA_RMBTRAP=$8000008A,
      WA_WBENCHWINDOW=$8000008B,
      WA_SIMPLEREFRESH=$8000008C,
      WA_SMARTREFRESH=$8000008D,
      WA_SIZEBRIGHT=$8000008E,
      WA_SIZEBBOTTOM=$8000008F,
      WA_AUTOADJUST=$80000090,
      WA_GIMMEZEROZERO=$80000091,
      WA_MENUHELP=$80000092,
      WA_NEWLOOKMENUS=$80000093,
      WA_AMIGAKEY=$80000094,
      WA_NOTIFYDEPTH=$80000095,
      WA_OBSOLETE=$80000096,
      WA_POINTER=$80000097,
      WA_BUSYPOINTER=$80000098,
      WA_POINTERDELAY=$80000099,
      WA_TABLETMESSAGES=$8000009A,
      WA_HELPGROUP=$8000009B,
      WA_HELPGROUPWINDOW=$8000009C,
      WA_HIDDEN=$8000009F,
      WA_POINTERTYPE=$800000B3,
      WA_ICONIFYGADGET=$800000C3,
      HC_GADGETHELP=1,
      ICTRL_DUMMY=$8001C000,
      WINDOW_BACKMOST=0,
      WINDOW_FRONTMOST=1

OBJECT remember
  nextremember:PTR TO remember
  remembersize:LONG
  memory:PTR TO CHAR
ENDOBJECT     /* SIZEOF=12 */

OBJECT colorspec
  colorindex:INT
  red:INT  -> This is unsigned
  green:INT  -> This is unsigned
  blue:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=8 */

OBJECT easystruct
  structsize:LONG
  flags:LONG
  title:PTR TO CHAR
  textformat:PTR TO CHAR
  gadgetformat:PTR TO CHAR
ENDOBJECT     /* SIZEOF=20 */

#define MENUNUM(n) ((n) AND $1F)
#define ITEMNUM(n) (Shr((n),5) AND $3F)
#define SUBNUM(n)  (Shr((n),11) AND $1F)

#define SHIFTMENU(n) ((n) AND $1F)
#define SHIFTITEM(n) (Shl((n) AND $3F,5))
#define SHIFTSUB(n)  (Shl((n) AND $1F,11))

#define FULLMENUNUM(menu,item,sub) (SHIFTSUB(sub) OR SHIFTITEM(item) OR \
                                    SHIFTMENU(menu))

#define SRBNUM(n)  (8-Shr((n),4))
#define SWBNUM(n)  (8-((n) AND $F))
#define SSBNUM(n)  (1+Shr((n),4))
#define SPARNUM(n) (Shr((n),4))
#define SHAKNUM(n) ((n) AND $F)

CONST NOMENU=31,
      NOITEM=$3F,
      NOSUB=31,
      MENUNULL=$FFFF,
      CHECKWIDTH=19,
      COMMWIDTH=27,
      LOWCHECKWIDTH=13,
      LOWCOMMWIDTH=16,
      ALERT_TYPE=$80000000,
      RECOVERY_ALERT=0,
      DEADEND_ALERT=$80000000,
      AUTOFRONTPEN=0,
      AUTOBACKPEN=1,
      AUTODRAWMODE=1,
      AUTOLEFTEDGE=6,
      AUTOTOPEDGE=3,
      AUTOITEXTFONT=0,
      AUTONEXTTEXT=0,
      SELECTUP=$E8,
      SELECTDOWN=$68,
      MENUUP=$E9,
      MENUDOWN=$69,
      MIDDLEUP=$EA,
      MIDDLEDOWN=$6A,
      ALTLEFT=16,
      ALTRIGHT=$20,
      AMIGALEFT=$40,
      AMIGARIGHT=$80,
      AMIGAKEYS=$C0,
      CURSORUP=$4C,
      CURSORLEFT=$4F,
      CURSORRIGHT=$4E,
      CURSORDOWN=$4D,
      KEYCODE_Q=16,
      KEYCODE_Z=$31,
      KEYCODE_X=$32,
      KEYCODE_V=$34,
      KEYCODE_B=$35,
      KEYCODE_N=$36,
      KEYCODE_M=$37,
      KEYCODE_LESS=$38,
      KEYCODE_GREATER=$39,
      TABLETA_DUMMY=$8003A000,
      TABLETA_TABLETZ=$8003A001,  -> Data for this tag is unsigned INT
      TABLETA_RANGEZ=$8003A002,
      TABLETA_ANGLEX=$8003A003,
      TABLETA_ANGLEY=$8003A004,
      TABLETA_ANGLEZ=$8003A005,
      TABLETA_PRESSURE=$8003A006,
      TABLETA_BUTTONBITS=$8003A007,
      TABLETA_INPROXIMITY=$8003A008,
      TABLETA_RESOLUTIONX=$8003A009,
      TABLETA_RESOLUTIONY=$8003A00A

OBJECT tabletdata
  xfraction:INT  -> This is unsigned
  yfraction:INT  -> This is unsigned
  tabletx:LONG
  tablety:LONG
  rangex:LONG
  rangey:LONG
  taglist:PTR TO tagitem
ENDOBJECT     /* SIZEOF=24 */

OBJECT tablethookdata
  screen:PTR TO screen
  width:LONG
  height:LONG
  screenchanged:LONG
ENDOBJECT     /* SIZEOF=16 */
