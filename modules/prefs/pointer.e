OPT MODULE
OPT EXPORT

CONST ID_PNTR=$504E5452

OBJECT pointerprefs
-> Um, this was wrong
  reserved[4]:ARRAY OF LONG
  which:INT  -> This is unsigned
  size:INT  -> This is unsigned
  width:INT  -> This is unsigned
  ieight:INT  -> This is unsigned
  depth:INT  -> This is unsigned
  ysize:INT  -> This is unsigned
  x:INT
  y:INT
ENDOBJECT     /* SIZEOF=32 */

CONST WBP_NORMAL=0,
      WBP_BUSY=1

OBJECT rgbtable
  red:CHAR
  green:CHAR
  blue:CHAR
ENDOBJECT     /* SIZEOF=3 */
