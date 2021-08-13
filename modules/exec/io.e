OPT MODULE
OPT EXPORT

MODULE 'exec/ports',
       'exec/devices'

OBJECT io
  mn:mn
  device:PTR TO dd
  unit:PTR TO unit
  command:INT  -> This is unsigned
  flags:CHAR
  error:CHAR  -> This is signed
ENDOBJECT     /* SIZEOF=32 */

OBJECT iostd
  mn:mn
  device:PTR TO dd
  unit:PTR TO unit
  command:INT  -> This is unsigned
  flags:CHAR
  error:CHAR  -> This is signed
  actual:LONG
  length:LONG
  data:LONG
  offset:LONG
ENDOBJECT     /* SIZEOF=48 */

CONST IOB_QUICK=0,
      IOF_QUICK=1,
      CMD_INVALID=0,
      CMD_RESET=1,
      CMD_READ=2,
      CMD_WRITE=3,
      CMD_UPDATE=4,
      CMD_CLEAR=5,
      CMD_STOP=6,
      CMD_START=7,
      CMD_FLUSH=8,
      CMD_NONSTD=9,
      DEV_BEGINIO=-30,
      DEV_ABORTIO=-36

