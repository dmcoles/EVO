  OPT MODULE
  OPT EXPORT

  MODULE 'graphics/text','exec/nodes','exec/libraries','diskfont/glyph','utility/tagitem'

CONST MAXFONTPATH=$100,
      TA_CHARSET=$80000003
      
OBJECT fc
  filename[256]:ARRAY OF CHAR
  ysize:INT  -> This is unsigned
  style:CHAR
  flags:CHAR
ENDOBJECT     /* SIZEOF=260 */

OBJECT tfc
  filename[254]:ARRAY OF CHAR
  tagcount:INT  -> This is unsigned
  ysize:INT  -> This is unsigned
  style:CHAR
  flags:CHAR
ENDOBJECT     /* SIZEOF=260 */

CONST FCH_ID=$F00,
      TFCH_ID=$F02,
      OFCH_ID=$F03

OBJECT fch
  fileid:INT  -> This is unsigned
  numentries:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=4 */

OBJECT eglyphengine
  reserved:LONG
  bulletbase:PTR TO lib
  glyphengine:PTR TO glyphengine
ENDOBJECT

OBJECT outlinefont
  otagpath:PTR TO CHAR
  taglist:PTR TO tagitem
  enginename:PTR TO CHAR
  libraryname:PTR TO CHAR
  eengine:eglyphengine
  reserved:LONG
  userdata:LONG
ENDOBJECT

CONST DFH_ID=$F80,
      MAXFONTNAME=$20

OBJECT diskfontheader
  df:ln
  fileid:INT  -> This is unsigned
  revision:INT  -> This is unsigned
  segment:LONG
  name[32]:ARRAY OF CHAR
  tf:textfont
ENDOBJECT     /* SIZEOF=106 */

CONST DFH_TAGLIST=18,
      AFB_MEMORY=0,
      AFF_MEMORY=1,
      AFB_DISK=1,
      AFF_DISK=2,
      AFB_SCALED=2,
      AFF_SCALED=4,
      AFB_BITMAP=3,
      AFF_BITMAP=8,
      AFB_OTAG=4,
      AFF_OTAG=$10,
      AFB_TYPE=6,
      AFF_CHARSET=$20,
      AFF_TYPE=$40,
      AFB_TAGGED=16,
      AFF_TAGGED=$10000,
      AFF_TTATTR=$10000

OBJECT af
  type:INT  -> This is unsigned
  attr:textattr
ENDOBJECT     /* SIZEOF=10 */

OBJECT taf
  type:INT  -> This is unsigned
  attr:ttextattr
ENDOBJECT     /* SIZEOF=14 */

OBJECT afh
  numentries:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=2 */



