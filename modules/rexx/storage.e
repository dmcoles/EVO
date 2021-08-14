OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/lists',
       'exec/nodes',
       'exec/ports'

OBJECT nexxstr
  ivalue:LONG
  length:INT  -> This is unsigned
  flags:CHAR
  hash:CHAR
  buff[8]:ARRAY
ENDOBJECT     /* SIZEOF=16 */

#define IVALUE(nsptr) (nsptr::nexxstr.ivalue)

CONST NXADDLEN=9,
      NSB_KEEP=0,
      NSB_STRING=1,
      NSB_NOTNUM=2,
      NSB_NUMBER=3,
      NSB_BINARY=4,
      NSB_FLOAT=5,
      NSB_EXT=6,
      NSB_SOURCE=7,
      NSF_KEEP=1,
      NSF_STRING=2,
      NSF_NOTNUM=4,
      NSF_NUMBER=8,
      NSF_BINARY=16,
      NSF_FLOAT=$20,
      NSF_EXT=$40,
      NSF_SOURCE=$80,
      NSF_INTNUM=26,
      NSF_DPNUM=$28,
      NSF_ALPHA=6,
      NSF_OWNED=$C1,
      KEEPSTR=$86,
      KEEPNUM=$9A

OBJECT rexxarg
  size:LONG
  length:INT  -> This is unsigned
  flags:CHAR
  hash:CHAR
  buff[8]:ARRAY
ENDOBJECT     /* SIZEOF=16 */

OBJECT rexxmsg
  mn:mn
  taskblock:LONG
  libbase:LONG
  action:LONG
  result1:LONG
  result2:LONG
  args[16]:ARRAY OF LONG
  passport:PTR TO mp
  commaddr:PTR TO CHAR
  fileext:PTR TO CHAR
  stdin:LONG
  stdout:LONG
  avail:LONG
ENDOBJECT     /* SIZEOF=128 */

#define ARG0(rmp) (rmp::rexxmsg.args[0])
#define ARG1(rmp) (rmp::rexxmsg.args[1])
#define ARG2(rmp) (rmp::rexxmsg.args[2])

CONST ACTION=28,
      RESULT1=$20,
      RESULT2=$24,
      MAXRMARG=15,
      RXCOMM=$1000000,
      RXFUNC=$2000000,
      RXCLOSE=$3000000,
      RXQUERY=$4000000,
      RXADDFH=$7000000,
      RXADDLIB=$8000000,
      RXREMLIB=$9000000,
      RXADDCON=$A000000,
      RXREMCON=$B000000,
      RXTCOPN=$C000000,
      RXTCCLS=$D000000,
      RXFB_NOIO=16,
      RXFB_RESULT=17,
      RXFB_STRING=18,
      RXFB_TOKEN=19,
      RXFB_NONRET=20,
      RXFB_SCRIPT=21,
      RXFF_RESULT=$20000,
      RXFF_STRING=$40000,
      RXFF_TOKEN=$80000,
      RXFF_NONRET=$100000,
      RXFF_SCRIPT=$200000,
      RXCODEMASK=$FF000000,
      RXARGMASK=15

OBJECT rexxrsrc
  ln:ln
  func:INT
  base:LONG
  size:LONG
  arg1:PTR TO CHAR
  arg2:LONG
ENDOBJECT     /* SIZEOF=32 */

CONST RRTYPE=8,
      RRNAME=10,
      RRSIZE=20,
      RRT_ANY=0,
      RRT_LIB=1,
      RRT_PORT=2,
      RRT_FILE=3,
      RRT_HOST=4,
      RRT_CLIP=5,
      GLOBALSZ=$C8

OBJECT rexxtask
  global[$C8]:ARRAY
  msgport:mp
  flags:CHAR
  sigbit:CHAR  -> This is signed
  clientid:LONG
  msgpkt:LONG
  taskid:LONG
  port:LONG
  errtrap:LONG
  stackptr:LONG
  header1:lh
  header2:lh
  header3:lh
  header4:lh
  header5:lh
ENDOBJECT     /* SIZEOF=330 */

CONST ENVLIST=$104,
      FREELIST=$112,
      MEMLIST=$120,
      FILELIST=$12E,
      PORTLIST=$13C,
      NUMLISTS=5,
      RTFB_TRACE=0,
      RTFB_HALT=1,
      RTFB_SUSP=2,
      RTFB_TCUSE=3,
      RTFB_WAIT=6,
      RTFB_CLOSE=7,
      MEMQUANT=16,
      MEMMASK=-16,
      MEMQUICK=1,
      MEMCLEAR=$10000

OBJECT srcnode
  succ:PTR TO srcnode
  pred:PTR TO srcnode
  ptr:LONG
  size:LONG
ENDOBJECT     /* SIZEOF=16 */

#define CHECKREXXMSG(msg) (rexxsysbase AND msg.libbase=rexxsysbase AND msg.taskblock AND IsRexxMsg(msg))
