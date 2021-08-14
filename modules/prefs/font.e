OPT MODULE
OPT EXPORT

MODULE 'graphics/text'

CONST ID_FONT=$464F4E54,
      FONTNAMESIZE=$80

OBJECT fontprefs
  reserved[3]:ARRAY OF LONG
  reserved2:INT
  type:INT  -> This is unsigned
  frontpen:CHAR
  backpen:CHAR
  drawmode:CHAR
  specialdrawmode:CHAR
  textattr:textattr
  name[128]:ARRAY OF CHAR
ENDOBJECT     /* SIZEOF=156 */

CONST FP_WBFONT=0,
      FP_SYSFONT=1,
      FP_SCREENFONT=2

