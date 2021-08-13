OPT MODULE
OPT EXPORT

CONST ID_ICTL=$4943544C

OBJECT icontrolprefs
  reserved[4]:ARRAY OF LONG
  timeout:INT  -> This is unsigned
  metadrag:INT
  flags:LONG
  wbtofront:CHAR
  fronttoback:CHAR
  reqtrue:CHAR
  reqfalse:CHAR
ENDOBJECT     /* SIZEOF=28 */

CONST ICB_COERCE_COLORS=0,
      ICB_COERCE_LACE=1,
      ICB_STRGAD_FILTER=2,
      ICB_MENUSNAP=3,
      ICB_MODEPROMOTE=4,
      ICF_COERCE_COLORS=1,
      ICF_COERCE_LACE=2,
      ICF_STRGAD_FILTER=4,
      ICF_MENUSNAP=8,
      ICF_MODEPROMOTE=16

