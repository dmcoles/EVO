OPT MODULE
OPT EXPORT

MODULE 'exec/nodes',
       'libraries/configregs'

OBJECT configdev
  node:ln
  flags:CHAR
  pad:CHAR
  rom:expansionrom
  boardaddr:LONG
  boardsize:LONG
  slotaddr:INT  -> This is unsigned
  slotsize:INT  -> This is unsigned
  driver:LONG
  nextcd:PTR TO configdev
  unused[4]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=68 */

CONST CDB_SHUTUP=0,
      CDB_CONFIGME=1,
      CDB_BADMEMORY=2,
      CDB_PROCESSED=3,
      CDF_SHUTUP=1,
      CDF_CONFIGME=2,
      CDF_BADMEMORY=4,
      CDF_PROCESSED=8

OBJECT currentbinding
  configdev:PTR TO configdev
  filename:PTR TO CHAR
  productstring:PTR TO CHAR
  tooltypes:PTR TO LONG
ENDOBJECT     /* SIZEOF=16 */

