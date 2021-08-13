OPT MODULE
OPT EXPORT

CONST ID_SCRM=$5343524D

OBJECT screenmodeprefs
  reserved[4]:ARRAY OF LONG
  displayid:LONG
  width:INT  -> This is unsigned
  height:INT  -> This is unsigned
  depth:INT  -> This is unsigned
  control:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=28 */

CONST SMB_AUTOSCROLL=0,
      SMF_AUTOSCROLL=1

