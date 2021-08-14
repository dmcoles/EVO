  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

OBJECT csource
  buffer:PTR TO CHAR
  length:LONG
  curchr:LONG
ENDOBJECT     /* SIZEOF=12 */

OBJECT rdargs
  source:csource
  dalist:LONG
  buffer:PTR TO CHAR
  bufsiz:LONG
  exthelp:PTR TO CHAR
  flags:LONG
ENDOBJECT     /* SIZEOF=32 */

CONST RDAB_STDIN=0,
      RDAF_STDIN=1,
      RDAB_NOALLOC=1,
      RDAF_NOALLOC=2,
      RDAB_NOPROMPT=2,
      RDAF_NOPROMPT=4,
      MAX_TEMPLATE_ITEMS=$64,
      MAX_MULTIARGS=$80

