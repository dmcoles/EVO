  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS
  
  MODULE 'exec/nodes'
  
CONST CD_RESET=1,
      CD_READ=2,
      CD_WRITE=3,
      CD_UPDATE=4,
      CD_CLEAR=5,
      CD_STOP=6,
      CD_START=7,
      CD_FLUSH=8,
      CD_MOTOR=9,
      CD_SEEK=10,
      CD_FORMAT=11,
      CD_REMOVE=12,
      CD_CHANGENUM=13,
      CD_CHANGESTATE=14,
      CD_PROTSTATUS=15,
      CD_GETDRIVETYPE=18,
      CD_GETNUMTRACKS=19,
      CD_ADDCHANGEINT=20,
      CD_REMCHANGEINT=21,
      CD_GETGEOMETRY=22,
      CD_EJECT=23,
      CD_INFO=32,
      CD_CONFIG=33,
      CD_TOCMSF=34,
      CD_TOCLSN=35,
      CD_READXL=36,
      CD_PLAYTRACK=37,
      CD_PLAYMSF=38,
      CD_PLAYLSN=39,
      CD_PAUSE=40,
      CD_SEARCH=41,
      CD_QCODEMSF=42,
      CD_QCODELSN=43,
      CD_ATTENUATE=44,
      CD_ADDFRAMEINT=45,
      CD_REMFRAMEINT=46,
      CDERR_OPENFAIL=-1,
      CDERR_ABORTED=-2,
      CDERR_NOCMD=-3,
      CDERR_BADLENGTH=-4,
      CDERR_BADADDRESS=-5,
      CDERR_UNITBUSY=-6,     
      CDERR_SELFTEST=-7,
      CDERR_NOTSPECIFIED=20,
      CDERR_NOSECHDR=21,
      CDERR_BADSECPREAMBLE=22,
      CDERR_BADSECID=23,
      CDERR_BADHDRSUM=24,
      CDERR_BADSECSUM=25,
      CDERR_TOOFEWSECS=26,
      CDERR_BADSECHDR=27,
      CDERR_WRITEPROT=28,
      CDERR_NODISK=29,
      CDERR_SEEKERROR=30,
      CDERR_NOMEM=31,
      CDERR_BADUNITNUM=32,
      CDERR_BADDRIVETYPE=33,
      CDERR_DRIVEINUSE=34,
      CDERR_POSTRESET=35,
      CDERR_BADDATATYPE=36,
      CDERR_INVALIDSTATE=37,
      CDERR_PHASE=42,
      CDERR_NOBOARD=50,
      TAGCD_PLAYSPEED=1,
      TAGCD_READSPEED=2,
      TAGCD_READXLSPEED=3,
      TAGCD_SECTORSIZE=4,
      TAGCD_XLECC=5,
      TAGCD_EJECTRESET=6

OBJECT cdinfo
  playspeed:INT  -> This is unsigned
  readspeed:INT  -> This is unsigned
  readxlspeed:INT  -> This is unsigned
  sectorsize:INT  -> This is unsigned
  xlecc:INT  -> This is unsigned
  ejectreset:INT  -> This is unsigned
  reserved1[4]:ARRAY OF INT  -> Array is unsigned
  maxspeed:INT  -> This is unsigned
  audioprecision:INT  -> This is unsigned
  status:INT  -> This is unsigned
  reserved2[4]:ARRAY OF INT  -> Array is unsigned
ENDOBJECT     /* SIZEOF=34 */

CONST CDSTSB_CLOSED=0,
      CDSTSB_DISK=1,
      CDSTSB_SPIN=2,
      CDSTSB_TOC=3,
      CDSTSB_CDROM=4,
      CDSTSB_PLAYING=5,
      CDSTSB_PAUSED=6,
      CDSTSB_SEARCH=7,
      CDSTSB_DIRECTION=8,
      CDSTSF_CLOSED=1,
      CDSTSF_DISK=2,
      CDSTSF_SPIN=4,
      CDSTSF_TOC=8,
      CDSTSF_CDROM=$10,
      CDSTSF_PLAYING=$20,
      CDSTSF_PAUSED=$40,
      CDSTSF_SEARCH=$80,
      CDSTSF_DIRECTION=$100,
      CDMODE_NORMAL=0,
      CDMODE_FFWD=1,
      CDMODE_FREV=2

OBJECT rmsf
  reserved:CHAR
  minute:CHAR
  second:CHAR
  frame:CHAR
ENDOBJECT     /* SIZEOF=4 */

OBJECT lsnmsf
  UNION
  [lsn:LONG]
  [msf:rmsf]
  ENDUNION
ENDOBJECT     /* SIZEOF=4 */

OBJECT cdxl
  node:mln
  buffer:PTR TO CHAR
  length:LONG
  actual:LONG
  intdata:LONG
  intcode:LONG
ENDOBJECT     /* SIZEOF=28 */

OBJECT tocsummary
  firsttrack:CHAR
  lasttrack:CHAR
  leadout:lsnmsf
ENDOBJECT     /* SIZEOF=6 */

OBJECT tocentry
  ctladr:CHAR
  track:CHAR
  position:lsnmsf
ENDOBJECT     /* SIZEOF=6 */
OBJECT cdtoc
  UNION 
  [summary:tocsummary]
  [entry:tocentry]
  ENDUNION
ENDOBJECT     /* SIZEOF=6 */

OBJECT qcode
  ctladr:CHAR
  track:CHAR
  index:CHAR
  zero:CHAR
  trackposition:lsnmsf
  diskposition:lsnmsf
ENDOBJECT     /* SIZEOF=12 */

CONST CTLADR_CTLMASK=$F0,
      CTL_CTLMASK=$D0,
      CTL_2AUD=0,
      CTL_2AUDEMPH=$10,
      CTL_4AUD=$80,
      CTL_4AUDEMPH=$90,
      CTL_DATA=$40,
      CTL_COPYMASK=$20,
      CTL_COPY=$20,
      CTLADR_ADRMASK=$F,
      ADR_POSITION=1,
      ADR_UPC=2,
      ADR_ISRC=3,
      ADR_HYBRID=5
