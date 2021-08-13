OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/nodes'

CONST TDTA_BUFFER=$8000112C,
      TDTA_BUFFERLEN=$8000112D,
      TDTA_LINELIST=$8000112E,
      TDTA_WORDSELECT=$8000112F,
      TDTA_WORDDELIM=$80001130,
      TDTA_WORDWRAP=$80001131

#define TEXTDTCLASS 'text.datatype'

OBJECT line
  link:mln
  text:PTR TO CHAR
  textlen:LONG
  xoffset:INT  -> This is unsigned
  yoffset:INT  -> This is unsigned
  width:INT  -> This is unsigned
  height:INT  -> This is unsigned
  flags:INT  -> This is unsigned
  fgpen:CHAR  -> This is signed
  bgpen:CHAR  -> This is signed
  style:LONG
  data:LONG
ENDOBJECT     /* SIZEOF=36 */

CONST LNF_LF=1,
      LNF_LINK=2,
      LNF_OBJECT=4,
      LNF_SELECTED=8,
      ID_FTXT=$46545854,
      ID_CHRS=$43485253

