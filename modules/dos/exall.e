  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'utility/hooks'

CONST ED_NAME=1,
      ED_TYPE=2,
      ED_SIZE=3,
      ED_PROTECTION=4,
      ED_DATE=5,
      ED_COMMENT=6,
      ED_OWNER=7

OBJECT exalldata
  next:PTR TO exalldata
  name:PTR TO CHAR
  type:LONG
  size:LONG
  prot:LONG
  days:LONG
  mins:LONG
  ticks:LONG
  comment:PTR TO CHAR
  owneruid:INT  -> This is unsigned
  ownergid:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=40 */

OBJECT exallcontrol
  entries:LONG
  lastkey:LONG
  matchstring:PTR TO CHAR
  matchfunc:PTR TO hook
ENDOBJECT     /* SIZEOF=16 */

