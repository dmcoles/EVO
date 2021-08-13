OPT MODULE
OPT EXPORT

CONST ID_PTRN=$5054524E

OBJECT wbpatternprefs
  reserved[4]:ARRAY OF LONG
  which:INT  -> This is unsigned
  flags:INT  -> This is unsigned
  revision:CHAR
  depth:CHAR
  datalength:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=24 */

CONST WBP_ROOT=0,
      WBP_DRAWER=1,
      WBP_SCREEN=2,
      WBPF_PATTERN=1,
      WBPF_NOREMAP=16,
      MAXDEPTH=3,
      DEFPATDEPTH=2,
      PAT_WIDTH=16,
      PAT_HEIGHT=16

