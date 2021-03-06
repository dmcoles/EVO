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
      WBPF_DITHER_MASK=$300,
      WBPF_DITHER_DEF=0,
      WBPF_DITHER_BAD=$100,
      WBPF_DITHER_GOOD=$200,
      WBPF_DITHER_BEST=$300,
      WBPF_PLACEMENT_MASK=$3000,
      WBPF_PLACEMENT_TILE=0,
      WBPF_PLACEMENT_CENTER=$1000,
      WBPF_PLACEMENT_SCALE=$2000,
      WBPF_PLACEMENT_SCALEGOOD=$3000,
      WBPF_ALIGNMENT_MASK=$C000,
      WBPF_ALIGNMENT_MIDDLE=0,
      WBPF_ALIGNMENT_LEFTTOP=$4000,
      WBPF_ALIGNMENT_RIGHTBOTTOM=$8000,
      WBPF_PRECISION_MASK=$C00,
      WBPF_PRECISION_DEF=0,
      WBPF_PRECISION_ICON=$400,
      WBPF_PRECISION_IMAGE=$800,
      WBPF_PRECISION_EXACT=$C00,
      MAXDEPTH=3,
      DEFPATDEPTH=2,
      PAT_WIDTH=16,
      PAT_HEIGHT=16

