OPT MODULE
OPT EXPORT

MODULE 'exec/nodes',
       'graphics/text'

CONST MAXFONTPATH=$100

OBJECT fc
  filename[$100]:ARRAY
  ysize:INT  -> This is unsigned
  style:CHAR
  flags:CHAR
ENDOBJECT     /* SIZEOF=260 */

OBJECT tfc
  filename[$fe]:ARRAY
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
ENDOBJECT     /* SIZEOF=NONE !!! */

CONST DFH_ID=$F80,
      MAXFONTNAME=$20

OBJECT diskfontheader
  df:ln
  fileid:INT  -> This is unsigned
  revision:INT  -> This is unsigned
  segment:LONG
  name[$20]:ARRAY
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
ENDOBJECT     /* SIZEOF=NONE !!! */

