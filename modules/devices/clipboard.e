OPT MODULE
OPT EXPORT

MODULE 'exec/devices',
       'exec/nodes',
       'exec/ports'

CONST DEVICES_CLIPBOARD_I=1,
      CBD_POST=9,
      CBD_CURRENTREADID=10,
      CBD_CURRENTWRITEID=11,
      CBD_CHANGEHOOK=12,
      CBERR_OBSOLETEID=1

OBJECT clipboardunitpartial
  node:ln
  unitnum:LONG
ENDOBJECT     /* SIZEOF=NONE !!! */

OBJECT ioclipreq
  message:mn
  device:PTR TO dd
  unit:PTR TO clipboardunitpartial
  command:INT  -> This is unsigned
  flags:CHAR
  error:CHAR  -> This is signed
  actual:LONG
  length:LONG
  data:PTR TO CHAR
  offset:LONG
  clipid:LONG
ENDOBJECT     /* SIZEOF=52 */

CONST PRIMARY_CLIP=0

OBJECT satisfymsg
  msg:mn
  unit:INT  -> This is unsigned
  clipid:LONG
ENDOBJECT     /* SIZEOF=26 */

OBJECT cliphookmsg
  type:LONG
  changecmd:LONG
  clipid:LONG
ENDOBJECT     /* SIZEOF=NONE !!! */

