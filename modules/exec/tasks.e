  OPT MODULE
  OPT EXPORT

MODULE 'exec/lists',
       'exec/nodes',
       'exec/ports'

OBJECT tc
  ln:ln
  flags:CHAR
  state:CHAR
  idnestcnt:CHAR  -> This is signed
  tdnestcnt:CHAR  -> This is signed
  sigalloc:LONG
  sigwait:LONG
  sigrecvd:LONG
  sigexcept:LONG
  UNION
  [etask:PTR TO etask]
  [trapalloc:INT  -> This is unsigned
    trapable:INT  -> This is unsigned
  ]
  ENDUNION
  exceptdata:LONG
  exceptcode:LONG
  trapdata:LONG
  trapcode:LONG
  spreg:LONG
  splower:LONG
  spupper:LONG
  switch:LONG
  launch:LONG
  mementry:lh
  userdata:LONG
ENDOBJECT     /* SIZEOF=92 */

OBJECT etask
  mn:mn
  parent:PTR TO tc
  uniqueid:LONG
  children:mlh
  trapalloc:INT  -> This is unsigned
  trapable:INT  -> This is unsigned
  result1:LONG
  result2:LONG
  taskmsgport:mp
ENDOBJECT     /* SIZEOF=86 */

CONST CHILD_NOTNEW=1,
      CHILD_NOTFOUND=2,
      CHILD_EXITED=3,
      CHILD_ACTIVE=4

OBJECT stackswapstruct
  lower:LONG
  upper:LONG
  pointer:LONG
ENDOBJECT     /* SIZEOF=12 */

CONST TB_PROCTIME=0,
      TB_STACKCHK=4,
      TB_EXCEPT=5,
      TB_SWITCH=6,
      TB_LAUNCH=7,
      TF_PROCTIME=1,
      TF_ETASK=8,
      TF_STACKCHK=16,
      TF_EXCEPT=$20,
      TF_SWITCH=$40,
      TF_LAUNCH=$80,
      TS_INVALID=0,
      TS_ADDED=1,
      TS_RUN=2,
      TS_READY=3,
      TS_WAIT=4,
      TS_EXCEPT=5,
      TS_REMOVED=6,
      SIGB_ABORT=0,
      SIGB_CHILD=1,
      SIGB_BLIT=4,
      SIGB_SINGLE=4,
      SIGB_INTUITION=5,
      SIGB_NET=7,
      SIGB_DOS=8,
      SIGF_ABORT=1,
      SIGF_CHILD=2,
      SIGF_BLIT=16,
      SIGF_SINGLE=16,
      SIGF_INTUITION=$20,
      SIGF_NET=$80,
      SIGF_DOS=$100,
      SYS_SIGALLOC=$FFFF,
      SYS_TRAPALLOC=$8000

