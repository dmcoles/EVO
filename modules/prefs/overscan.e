OPT MODULE
OPT EXPORT

MODULE 'graphics/gfx'

CONST ID_OSCN=$4F53434E,
      OSCAN_MAGIC=$FEDCBA89

OBJECT overscanprefs
  reserved:LONG
  magic:LONG
  hstart:INT  -> This is unsigned
  hstop:INT  -> This is unsigned
  vstart:INT  -> This is unsigned
  vstop:INT  -> This is unsigned
  displayid:LONG
  viewpos:tpoint
  text:tpoint
  standard:rectangle
ENDOBJECT     /* SIZEOF=36 */

