OPT MODULE
OPT EXPORT

OBJECT simplesprite
  posctldata:PTR TO INT  -> Target is unsigned
  height:INT  -> This is unsigned
  x:INT  -> This is unsigned
  y:INT  -> This is unsigned
  num:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=12 */

OBJECT extsprite
  simplesprite:simplesprite
  wordwidth:INT  -> This is unsigned
  flags:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=16 */

CONST SPRITEA_WIDTH=$81000000,
      SPRITEA_XREPLICATION=$81000002,
      SPRITEA_YREPLICATION=$81000004,
      SPRITEA_OUTPUTHEIGHT=$81000006,
      SPRITEA_ATTACHED=$81000008,
      SPRITEA_OLDDATAFORMAT=$8100000A,
      GSTAG_SPRITE_NUM=$82000020,
      GSTAG_ATTACHED=$82000022,
      GSTAG_SOFTSPRITE=$82000024,
      GSTAG_SCANDOUBLED=$83000000

