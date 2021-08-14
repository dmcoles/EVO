  OPT MODULE
  OPT EXPORT

  OPT PREPROCESS

#define DATATYPESCLASS 'datatypesclass'

MODULE 'intuition/cghooks','utility/tagitem','graphics/rastport','devices/printer','exec/io','graphics/gfx','intuition/screens','graphics/view','exec/semaphores'

CONST DTA_DUMMY=$80001000,
      DTA_TEXTATTR=$8000100A,
      DTA_TOPVERT=$8000100B,
      DTA_VISIBLEVERT=$8000100C,
      DTA_TOTALVERT=$8000100D,
      DTA_VERTUNIT=$8000100E,
      DTA_TOPHORIZ=$8000100F,
      DTA_VISIBLEHORIZ=$80001010,
      DTA_TOTALHORIZ=$80001011,
      DTA_HORIZUNIT=$80001012,
      DTA_NODENAME=$80001013,
      DTA_TITLE=$80001014,
      DTA_TRIGGERMETHODS=$80001015,
      DTA_DATA=$80001016,
      DTA_TEXTFONT=$80001017,
      DTA_METHODS=$80001018,
      DTA_PRINTERSTATUS=$80001019,
      DTA_PRINTERPROC=$8000101A,
      DTA_LAYOUTPROC=$8000101B,
      DTA_BUSY=$8000101C,
      DTA_SYNC=$8000101D,
      DTA_BASENAME=$8000101E,
      DTA_GROUPID=$8000101F,
      DTA_ERRORLEVEL=$80001020,
      DTA_ERRORNUMBER=$80001021,
      DTA_ERRORSTRING=$80001022,
      DTA_CONDUCTOR=$80001023,
      DTA_CONTROLPANEL=$80001024,
      DTA_IMMEDIATE=$80001025,
      DTA_REPEAT=$80001026,
      DTA_SOURCEADDRESS=$80001027,
      DTA_SOURCESIZE=$80001028,
      DTA_RESERVED=$80001029,
      DTA_CLASS=$8000103E,
      DTA_NAME=$80001064,
      DTA_SOURCETYPE=$80001065,
      DTA_HANDLE=$80001066,
      DTA_DATATYPE=$80001067,
      DTA_DOMAIN=$80001068,
      DTA_LEFT=$80001069,
      DTA_TOP=$8000106A,
      DTA_WIDTH=$8000106B,
      DTA_HEIGHT=$8000106C,
      DTA_OBJNAME=$8000106D,
      DTA_OBJAUTHOR=$8000106E,
      DTA_OBJANNOTATION=$8000106F,
      DTA_OBJCOPYRIGHT=$80001070,
      DTA_OBJVERSION=$80001071,
      DTA_OBJECTID=$80001072,
      DTA_USERDATA=$80001073,
      DTA_FRAMEINFO=$80001074,
      DTA_RELRIGHT=$80001075,
      DTA_RELBOTTOM=$80001076,
      DTA_RELWIDTH=$80001077,
      DTA_RELHEIGHT=$80001078,
      DTA_SELECTDOMAIN=$80001079,
      DTA_TOTALPVERT=$8000107A,
      DTA_TOTALPHORIZ=$8000107B,
      DTA_NOMINALVERT=$8000107C,
      DTA_NOMINALHORIZ=$8000107D,
      DTA_DESTCOLS=$80001190,
      DTA_DESTROWS=$80001191,
      DTA_SPECIAL=$80001192,  -> Data for this tag is unsigned INT
      DTA_RASTPORT=$80001193,
      DTA_AREXXPORTNAME=$80001194,
      DTST_RAM=1,
      DTST_FILE=2,
      DTST_CLIPBOARD=3,
      DTST_HOTLINK=4,
      DTST_MEMORY=5

OBJECT dtspecialinfo
  lock:ss
  flags:LONG
  topvert:LONG
  visvert:LONG
  totvert:LONG
  otopvert:LONG
  vertunit:LONG
  tophoriz:LONG
  vishoriz:LONG
  tothoriz:LONG
  otophoriz:LONG
  horizunit:LONG
ENDOBJECT     /* SIZEOF=90 */

CONST DTSIF_LAYOUT=1,
      DTSIF_NEWSIZE=2,
      DTSIF_DRAGGING=4,
      DTSIF_DRAGSELECT=8,
      DTSIF_HIGHLIGHT=16,
      DTSIF_PRINTING=$20,
      DTSIF_LAYOUTPROC=$40

OBJECT dtmethod
  label:PTR TO CHAR
  command:PTR TO CHAR
  method:LONG
ENDOBJECT     /* SIZEOF=12 */

CONST DTM_FRAMEBOX=$601,
      DTM_PROCLAYOUT=$602,
      DTM_ASYNCLAYOUT=$603,
      DTM_REMOVEDTOBJECT=$604,
      DTM_SELECT=$605,
      DTM_CLEARSELECTED=$606,
      DTM_COPY=$607,
      DTM_PRINT=$608,
      DTM_ABORTPRINT=$609,
      DTM_NEWMEMBER=$610,
      DTM_DISPOSEMEMBER=$611,
      DTM_GOTO=$630,
      DTM_TRIGGER=$631,
      DTM_OBTAINDRAWINFO=$640,
      DTM_DRAW=$641,
      DTM_RELEASEDRAWINFO=$642,
      DTM_WRITE=$650
      
OBJECT frameinfo
  propertyflags:LONG
  resolution:tpoint
  redbits:CHAR
  greenbits:CHAR
  bluebits:CHAR
  width:LONG
  height:LONG
  depth:LONG
  screen:PTR TO screen
  colormap:PTR TO colormap
  flags:LONG
ENDOBJECT     /* SIZEOF=36 */

CONST FIF_SCALABLE=1,
      FIF_SCROLLABLE=2,
      FIF_REMAPPABLE=4

OBJECT dtgeneral
  methodid:LONG
  ginfo:PTR TO gadgetinfo
ENDOBJECT     /* SIZEOF=8 */

OBJECT dtselect
  methodid:LONG
  ginfo:PTR TO gadgetinfo
  select:rectangle
ENDOBJECT     /* SIZEOF=16 */

OBJECT dtframebox
  methodid:LONG
  ginfo:PTR TO gadgetinfo
  contentsinfo:PTR TO frameinfo
  frameinfo:PTR TO frameinfo
  sizeframeinfo:LONG
  frameflags:LONG
ENDOBJECT     /* SIZEOF=24 */

CONST FRAMEF_SPECIFY=1

OBJECT dtgoto
  methodid:LONG
  ginfo:PTR TO gadgetinfo
  nodename:PTR TO CHAR
  attrlist:PTR TO tagitem
ENDOBJECT     /* SIZEOF=16 */

OBJECT dttrigger
  methodid:LONG
  ginfo:PTR TO gadgetinfo
  function:LONG
  data:LONG
ENDOBJECT     /* SIZEOF=16 */

CONST STM_PAUSE=1,
      STM_PLAY=2,
      STM_CONTENTS=3,
      STM_INDEX=4,
      STM_RETRACE=5,
      STM_BROWSE_PREV=6,
      STM_BROWSE_NEXT=7,
      STM_NEXT_FIELD=8,
      STM_PREV_FIELD=9,
      STM_ACTIVATE_FIELD=10,
      STM_COMMAND=11,
      STM_REWIND=12,
      STM_FASTFORWARD=13,
      STM_STOP=14,
      STM_RESUME=15,
      STM_LOCATE=16,
      STM_HELP=17,
      STM_SEARCH=18,
      STM_SEARCH_NEXT=19,
      STM_SEARCH_PREV=20,
      STM_UNRETRACE=21,
      STM_USER=100,

      STMF_METHOD_MASK=$0000FFFF,
      STMF_DATA_MASK=$00FF0000,
      STMF_RESERVED_MASK=$FF000000,
      STMD_VOID=$00010000,
      STMD_ULONG=$00020000,
      STMD_STRPTR=$00030000,
      STMD_TAGLIST=$00040000

OBJECT dtprint
  methodid:LONG
  ginfo:PTR TO gadgetinfo
  UNION
  [iodrp:PTR TO iodrpreq]
  [iopc:PTR TO ioprtcmdreq]
  [ios:PTR TO iostd]
  ENDUNION
  attrlist:PTR TO tagitem
ENDOBJECT     /* SIZEOF=16 */

OBJECT dtdraw
  methodid:LONG
  rport:PTR TO rastport
  left:LONG
  top:LONG
  width:LONG
  height:LONG
  tophoriz:LONG
  topvert:LONG
  attrlist:PTR TO tagitem
ENDOBJECT     /* SIZEOF=36 */

OBJECT dtwrite
  methodid:LONG
  ginfo:PTR TO gadgetinfo
  filehandle:LONG
  mode:LONG
  attrlist:PTR TO tagitem
ENDOBJECT     /* SIZEOF=20 */
CONST DTWM_IFF=0,
      DTWM_RAW=1
