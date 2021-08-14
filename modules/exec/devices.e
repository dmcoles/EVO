  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

MODULE 'exec/libraries',
       'exec/ports'

OBJECT dd
  lib:lib
ENDOBJECT     /* SIZEOF=34 */

OBJECT unit
  mp:mp
  flags:CHAR
  pad:CHAR
  opencnt:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=38 */

CONST UNITF_ACTIVE=1,
      UNITF_INTASK=2

