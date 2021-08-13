OPT MODULE
OPT EXPORT

MODULE 'intuition/intuition'

CONST ID_PALT=$50414C54

OBJECT paletteprefs
  reserved[4]:ARRAY OF LONG
-> Um, these had illegal names
  x4colorpens[32]:ARRAY OF INT
  x8colorpens[32]:ARRAY OF INT
  colors[32]:ARRAY OF colorspec
ENDOBJECT     /* SIZEOF=400 */

