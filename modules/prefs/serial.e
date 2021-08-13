OPT MODULE
OPT EXPORT

CONST ID_SERL=$5345524C

OBJECT serialprefs
  reserved[3]:ARRAY OF LONG
  unit0map:LONG
  baudrate:LONG
  inputbuffer:LONG
  outputbuffer:LONG
  inputhandshake:CHAR
  outputhandshake:CHAR
  parity:CHAR
  bitsperchar:CHAR
  stopbits:CHAR
ENDOBJECT     /* SIZEOF=33 */

CONST PARITY_NONE=0,
      PARITY_EVEN=1,
      PARITY_ODD=2,
      PARITY_MARK=3,
      PARITY_SPACE=4,
      HSHAKE_XON=0,
      HSHAKE_RTS=1,
      HSHAKE_NONE=2

