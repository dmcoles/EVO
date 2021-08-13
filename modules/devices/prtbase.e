OPT MODULE
OPT EXPORT

MODULE 'devices/serial',
       'devices/timer',
       'exec/libraries',
       'exec/ports',
       'exec/tasks',
       'intuition/preferences'

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
      DUF_STOPPED=1,
      P_PRIORITY=0,
      P_OLDSTKSIZE=$800,
      P_STKSIZE=$1000,
      P_BUFSIZE=$100,
      P_SAFESIZE=$80,
      PF_IOR0=1,
      PF_IOR1=2,
      PF_EXPUNGED=$80

OBJECT printerdata
  dd:devicedata
  unit:mp
  printersegment:LONG
  printertype:INT  -> This is unsigned
  segmentdata:PTR TO printersegment
  printbuf:PTR TO CHAR
  pwrite:LONG
  pbothready:LONG
-> Um, these were both wrong
-> a) next is unioned with "p0:ioextpar"
  s0:ioextser
-> a) next is unioned with "p1:ioextpar"
  s1:ioextser
  tior:timerequest
  iorport:mp
  tc:tc
  oldstk[$800]:ARRAY
  flags:CHAR
  pad:CHAR
  preferences:preferences
  pwaitenabled:CHAR
  pad1:CHAR
  stk[$1000]:ARRAY
ENDOBJECT     /* SIZEOF=6778 */

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
ENDOBJECT     /* SIZEOF=66 */

OBJECT printersegment
  nextsegment:LONG
  runalert:LONG
  version:INT  -> This is unsigned
  revision:INT  -> This is unsigned
-> Um, this was missing
  ped:printerextendeddata
ENDOBJECT     /* SIZEOF=NONE !!! */

