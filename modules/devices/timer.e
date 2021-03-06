  OPT MODULE
  OPT EXPORT

  OPT PREPROCESS

  MODULE 'exec/io'

CONST UNIT_MICROHZ=0,
      UNIT_VBLANK=1,
      UNIT_ECLOCK=2,
      UNIT_WAITUNTIL=3,
      UNIT_WAITECLOCK=4

#define TIMERNAME 'timer.device'

OBJECT timeval
  secs:LONG
  micro:LONG
ENDOBJECT     /* SIZEOF=8 */

OBJECT eclockval
  hi:LONG
  lo:LONG
ENDOBJECT     /* SIZEOF=8 */

OBJECT timerequest
  io:io
  time:timeval
ENDOBJECT     /* SIZEOF=40 */

CONST TR_ADDREQUEST=9,
      TR_GETSYSTIME=10,
      TR_SETSYSTIME=11

