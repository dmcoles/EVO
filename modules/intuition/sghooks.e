OPT MODULE
OPT EXPORT

MODULE 'devices/inputevent',
       'graphics/text',
       'intuition/cghooks',
       'intuition/intuition',
       'utility/hooks'

OBJECT stringextend
  font:PTR TO textfont
  pens[2]:ARRAY
  activepens[2]:ARRAY
  initialmodes:LONG
  edithook:PTR TO hook
  workbuffer:PTR TO CHAR
  reserved[4]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=36 */

OBJECT sgwork
  gadget:PTR TO gadget
  stringinfo:PTR TO stringinfo
  workbuffer:PTR TO CHAR
  prevbuffer:PTR TO CHAR
  modes:LONG
  ievent:PTR TO inputevent
  code:INT  -> This is unsigned
  bufferpos:INT
  numchars:INT
  actions:LONG
  longint:LONG
  gadgetinfo:PTR TO gadgetinfo
  editop:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=44 */

CONST EO_NOOP=1,
      EO_DELBACKWARD=2,
      EO_DELFORWARD=3,
      EO_MOVECURSOR=4,
      EO_ENTER=5,
      EO_RESET=6,
      EO_REPLACECHAR=7,
      EO_INSERTCHAR=8,
      EO_BADFORMAT=9,
      EO_BIGCHANGE=10,
      EO_UNDO=11,
      EO_CLEAR=12,
      EO_SPECIAL=13,
      SGM_REPLACE=1,
      SGMB_REPLACE=0,
      SGMF_REPLACE=1,
      SGM_FIXEDFIELD=2,
      SGMB_FIXEDFIELD=1,
      SGMF_FIXEDFIELD=2,
      SGM_NOFILTER=4,
      SGMB_NOFILTER=2,
      SGMF_NOFILTER=4,
      SGM_EXITHELP=$80,
      SGMB_EXITHELP=7,
      SGMF_EXITHELP=$80,
      SGA_USE=1,
      SGAB_USE=0,
      SGAF_USE=1,
      SGA_END=2,
      SGAB_END=1,
      SGAF_END=2,
      SGA_BEEP=4,
      SGAB_BEEP=2,
      SGAF_BEEP=4,
      SGA_REUSE=8,
      SGAB_REUSE=3,
      SGAF_REUSE=8,
      SGA_REDISPLAY=16,
      SGAB_REDISPLAY=4,
      SGAF_REDISPLAY=16,
      SGA_NEXTACTIVE=$20,
      SGAB_NEXTACTIVE=5,
      SGAF_NEXTACTIVE=$20,
      SGA_PREVACTIVE=$40,
      SGAB_PREVACTIVE=6,
      SGAF_PREVACTIVE=$40,
      SGH_KEY=1,
      SGH_CLICK=2

