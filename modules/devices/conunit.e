  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

MODULE 'devices/keymap',
       'exec/ports',
       'graphics/text',
       'intuition/intuition',
       'libraries/keymap'

CONST CONU_LIBRARY=-1,
      CONU_STANDARD=0,
      CONU_CHARMAP=1,
      CONU_SNIPMAP=3,
      CONFLAG_DEFAULT=0,
      CONFLAG_NODRAW_ON_NEWSIZE=1,
      PMB_ASM=21,
      PMB_AWM=22,
      MAXTABS=$50

OBJECT conunit NOALIGN
  mp:mp
  window:PTR TO window
  xcp:INT
  ycp:INT
  xmax:INT
  ymax:INT
  xrsize:INT
  yrsize:INT
  xrorigin:INT
  yrorigin:INT
  xrextant:INT
  yrextant:INT
  xminshrink:INT
  yminshrink:INT
  xccp:INT
  yccp:INT
  keymapstruct:keymap
  tabstops[$50]:ARRAY OF INT  -> Array is unsigned
  mask:CHAR  -> This is signed
  fgpen:CHAR  -> This is signed
  bgpen:CHAR  -> This is signed
  aolpen:CHAR  -> This is signed
  drawmode:CHAR  -> This is signed
  obsolete1:CHAR
  obsolete2:LONG
  minterms[8]:ARRAY OF CHAR
  font:PTR TO textfont
  algostyle:CHAR
  txflags:CHAR
  txheight:INT  -> This is unsigned
  txwidth:INT  -> This is unsigned
  txbaseline:INT  -> This is unsigned
  txspacing:INT
  modes[3]:ARRAY OF CHAR
  rawevents[3]:ARRAY OF CHAR
ENDOBJECT     /* SIZEOF=296 */

