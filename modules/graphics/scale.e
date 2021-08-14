  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'graphics/gfx'

OBJECT bitscaleargs
  srcx:INT  -> This is unsigned
  srcy:INT  -> This is unsigned
  srcwidth:INT  -> This is unsigned
  srcheight:INT  -> This is unsigned
  xsrcfactor:INT  -> This is unsigned
  ysrcfactor:INT  -> This is unsigned
  destx:INT  -> This is unsigned
  desty:INT  -> This is unsigned
  destwidth:INT  -> This is unsigned
  destheight:INT  -> This is unsigned
  xdestfactor:INT  -> This is unsigned
  ydestfactor:INT  -> This is unsigned
  srcbitmap:PTR TO bitmap
  destbitmap:PTR TO bitmap
  flags:LONG
  xdda:INT  -> This is unsigned
  ydda:INT  -> This is unsigned
  reserved1:LONG
  reserved2:LONG
ENDOBJECT     /* SIZEOF=48 */

