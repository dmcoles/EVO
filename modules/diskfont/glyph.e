  OPT MODULE
  OPT EXPORT

  MODULE 'exec/nodes','exec/libraries'

CONST DISKFONT_GLYPH_I=1

OBJECT glyphengine
  library:PTR TO lib
  name:LONG
ENDOBJECT     /* SIZEOF=8 */

OBJECT glyphmap
  bmmodulo:INT  -> This is unsigned
  bmrows:INT  -> This is unsigned
  blackleft:INT  -> This is unsigned
  blacktop:INT  -> This is unsigned
  blackwidth:INT  -> This is unsigned
  blackheight:INT  -> This is unsigned
  xorigin:LONG
  yorigin:LONG
  x0:INT
  y0:INT
  x1:INT
  y1:INT
  width:LONG
  bitmap:PTR TO CHAR
ENDOBJECT     /* SIZEOF=36 */

OBJECT glyphwidthentry
  node:mln
  code:INT  -> This is unsigned
  width:LONG
ENDOBJECT     /* SIZEOF=14 */

OBJECT glyphwidthentry32
  node:mln
  reserved:INT
  width:LONG
  code:LONG
ENDOBJECT     /* SIZEOF=18 */
