OPT MODULE
OPT EXPORT

MODULE 'exec/nodes'

CONST LIB_VECTSIZE=6,
      LIB_RESERVED=4,
      LIB_BASE=-6,
      LIB_USERDEF=-30,
      LIB_NONSTD=-30,
      LIB_OPEN=-6,
      LIB_CLOSE=-12,
      LIB_EXPUNGE=-18,
      LIB_EXTFUNC=-24

OBJECT lib
  ln:ln
  flags:CHAR
  pad:CHAR
  negsize:INT  -> This is unsigned
  possize:INT  -> This is unsigned
  version:INT  -> This is unsigned
  revision:INT  -> This is unsigned
  idstring:PTR TO CHAR
  sum:LONG
  opencnt:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=34 */

CONST LIBF_SUMMING=1,
      LIBF_CHANGED=2,
      LIBF_SUMUSED=4,
      LIBF_DELEXP=8,
      LIBF_EXP0CNT=16

