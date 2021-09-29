  OPT MODULE
  OPT EXPORT

  MODULE 'exec/libraries','exec/ports','devices/parallel','devices/serial','devices/timer','exec/tasks','intuition/preferences','utility/tagitem'
CONST DEVICES_PRTBASE_I=1
  
OBJECT devicedata
  lib:lib
  segment:LONG
  execbase:LONG
  cmdvectors:LONG
  cmdbytes:PTR TO CHAR
  numcommands:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=52 */

CONST DU_FLAGS=9,
      IOF_QUEUED=16,
      IOF_CURRENT=$20,
      IOF_SERVICING=$40,
      IOF_DONE=$80,
      DUB_STOPPED=0,
      DUF_STOPPED=1,
      P_OLDSTKSIZE=$800,
      P_STKSIZE=$1000,
      P_BUFSIZE=$100,
      P_SAFESIZE=$80,
      PB_IOOPENED=2,
      PB_EXPUNGED=7,
      PB_IOR0=0,
      PB_IOR1=1,
      PF_IOR0=1,
      PF_IOR1=2,
      PF_IOOPENDED=4,
      PF_EXPUNGED=$80,
      IOB_QUEUED=4,
      IOB_CURRENT=5,
      IOB_SERVICING=6,
      IOB_DONE=7,
      PPCB_EXTENDED=2,
      PPCF_EXTENDED=4,
      PPCB_NOSTRIP=3,
      PPCF_NOSTRIP=8,
      PRTA_DUMMY=$80050000,
      PRTA_8BITGUNS=$80050001,
      PRTA_CONVERTSOURCE=$80050002,
      PRTA_FLOYDDITHERING=$80050003,
      PRTA_ANTIALIAS=$80050004,
      PRTA_COLORCORRECTION=$80050005,
      PRTA_NOIO=$80050006,
      PRTA_NEWCOLOR=$80050007,
      PRTA_COLORSIZE=$80050008,
      PRTA_NOSCALING=$80050009,
      PRTA_DITHERNAMES=$80050014,
      PRTA_SHADINGNAMES=$80050015,
      PRTA_COLORCORRECT=$80050016,
      PRTA_DENSITYINFO=$80050017,
      PRTA_LEFTBORDER=$8005001E,
      PRTA_TOPBORDER=$8005001F,
      PRTA_MIXBWCOLOR=$80050020,
      PRTA_PREFERENCES=$80050028

OBJECT printerdata
  dd:devicedata   ->private and obsolete
  unit:mp
  printersegment:LONG
  printertype:INT  -> This is unsigned
  segmentdata:PTR TO printersegment
  printbuf:PTR TO CHAR
  pwrite:LONG
  pbothready:LONG
  UNION
  [p0:ioextpar]
  [s0:ioextser]
  ENDUNION
  UNION
  [p1:ioextpar]
  [s1:ioextser]
  ENDUNION
  tior:timerequest
  iorport:mp
  tc:tc
  oldstk[2048]:ARRAY OF CHAR
  flags:CHAR
  pad:CHAR
  preferences:preferences
  pwaitenabled:CHAR
  pad1:CHAR
  stk[4096]:ARRAY OF CHAR
  punit:LONG
  pread:LONG
  callerrhook:LONG
  unitnumber:LONG
  drivername:PTR TO CHAR
  pquery:LONG
ENDOBJECT     /* SIZEOF=6818 */

CONST PPCB_GFX=0,
      PPCF_GFX=1,
      PPCB_COLOR=1,
      PPCF_COLOR=2,
      PPC_BWALPHA=0,
      PPC_BWGFX=1,
      PPC_COLORALPHA=2,
      PPC_COLORGFX=3,
      PCC_BW=1,
      PCC_YMC=2,
      PCC_YMC_BW=3,
      PCC_YMCB=4,
      PCC_4COLOR=4,
      PCC_ADDITIVE=8,
      PCC_WB=9,
      PCC_BGR=10,
      PCC_BGR_WB=11,
      PCC_BGRW=12,
      PCC_MULTI_PASS=16

OBJECT printerextendeddata
  printername:PTR TO CHAR
  init:LONG
  expunge:LONG
  open:LONG
  close:LONG
  printerclass:CHAR
  colorclass:CHAR
  maxcolumns:CHAR
  numcharsets:CHAR
  numrows:INT  -> This is unsigned
  maxxdots:LONG
  maxydots:LONG
  xdotsinch:INT  -> This is unsigned
  ydotsinch:INT  -> This is unsigned
  commands:PTR TO LONG
  dospecial:LONG
  render:LONG
  timeoutsecs:LONG
-> Um, this had an illegal name
  x8bitchars:PTR TO LONG
  printmode:LONG
  convfunv:LONG
  ->The following only exists if the segment version is >= 44
  ->AND PPCB_EXTENDED is set in ped_PrinterClass:
  taglist:PTR TO tagitem
  dopreferences:LONG
  callerrhook:LONG
ENDOBJECT     /* SIZEOF=66 */

OBJECT printersegment
  nextsegment:LONG
  runalert:LONG
  version:INT  -> This is unsigned
  revision:INT  -> This is unsigned
-> Um, this was missing
  ped:printerextendeddata
ENDOBJECT     /* SIZEOF=78 */

