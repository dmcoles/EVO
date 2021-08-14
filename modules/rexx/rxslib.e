OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/libraries',
       'exec/lists',
       'exec/ports',
       'rexx/storage'

#define RXSNAME 'rexxsyslib.library'
#define RXSDIR 'REXX'
#define RXSTNAME 'ARexx'

OBJECT rxslib
  lib:lib
  flags:CHAR
  shadow:CHAR
  sysbase:LONG
  dosbase:LONG
  ieeedpbase:LONG
  seglist:LONG
  nil:LONG
  chunk:LONG
  maxnest:LONG
  null:PTR TO nexxstr
  false:PTR TO nexxstr
  true:PTR TO nexxstr
  rexx:PTR TO nexxstr
  command:PTR TO nexxstr
  stdin:PTR TO nexxstr
  stdout:PTR TO nexxstr
  stderr:PTR TO nexxstr
  version:PTR TO CHAR
  taskname:PTR TO CHAR
  taskpri:LONG
  taskseg:LONG
  stacksize:LONG
  rexxdir:PTR TO CHAR
  ctable:PTR TO CHAR
  notice:PTR TO CHAR
  rexxport:mp
  readlock:INT  -> This is unsigned
  tracefh:LONG
  tasklist:lh
  numtask:INT
  liblist:lh
  numlib:INT
  cliplist:lh
  numclip:INT
  msglist:lh
  nummsg:INT
  pgmlist:lh
  numpgm:INT
  tracecnt:INT  -> This is unsigned
  avail:INT
  utilitybase:LONG
ENDOBJECT     /* SIZEOF=256 */

CONST RLFB_TRACE=0,
      RLFB_HALT=1,
      RLFB_SUSP=2,
      RLFB_STOP=6,
      RLFB_CLOSE=7,
      RLFMASK=7,
      RXSCHUNK=$400,
      RXSNEST=$20,
      RXSTPRI=0,
      RXSSTACK=$1000,
      CTB_SPACE=0,
      CTB_DIGIT=1,
      CTB_ALPHA=2,
      CTB_REXXSYM=3,
      CTB_REXXOPR=4,
      CTB_REXXSPC=5,
      CTB_UPPER=6,
      CTB_LOWER=7,
      CTF_SPACE=1,
      CTF_DIGIT=2,
      CTF_ALPHA=4,
      CTF_REXXSYM=8,
      CTF_REXXOPR=16,
      CTF_REXXSPC=$20,
      CTF_UPPER=$40,
      CTF_LOWER=$80

