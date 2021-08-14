  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'dos/dos','exec/ports','exec/semaphores','exec/nodes','exec/lists','exec/libraries','exec/tasks','devices/timer'
OBJECT process
  task:tc
  msgport:mp
  pad:INT
  seglist:LONG
  stacksize:LONG
  globvec:LONG
  tasknum:LONG
  stackbase:LONG
  result2:LONG
  currentdir:LONG
  cis:LONG
  cos:LONG
  consoletask:LONG
  filesystemtask:LONG
  cli:LONG
  returnaddr:LONG
  pktwait:LONG
  windowptr:LONG
  homedir:LONG
  flags:LONG
  exitcode:LONG
  exitdata:LONG
  arguments:PTR TO CHAR
  localvars:mlh
  shellprivate:LONG
  ces:LONG
ENDOBJECT     /* SIZEOF=228 */

CONST PRB_FREESEGLIST=0,
      PRF_FREESEGLIST=1,
      PRB_FREECURRDIR=1,
      PRF_FREECURRDIR=2,
      PRB_FREECLI=2,
      PRF_FREECLI=4,
      PRB_CLOSEINPUT=3,
      PRF_CLOSEINPUT=8,
      PRB_CLOSEOUTPUT=4,
      PRF_CLOSEOUTPUT=16,
      PRB_FREEARGS=5,
      PRF_FREEARGS=$20,
      PRB_CLOSEERROR=6,
      PRF_CLOSEERROR=64

OBJECT filehandle
  link:PTR TO mn
  interactive:PTR TO mp
  type:PTR TO mp
  buf:LONG
  pos:LONG
  end:LONG
  funcs:LONG
  func2:LONG
  func3:LONG
  args:LONG
  arg2:LONG
ENDOBJECT     /* SIZEOF=44 */

OBJECT dospacket
  link:PTR TO mn
  port:PTR TO mp
  UNION
  [type:LONG
  res1:LONG
  res2:LONG
  ]
  [action:LONG
  status:LONG
  status2:LONG
  ]
  ENDUNION

  UNION
  [bufaddr:LONG]
  [arg1:LONG]
  ENDUNION
  arg2:LONG
  arg3:LONG
  arg4:LONG
  arg5:LONG
  arg6:LONG
  arg7:LONG
ENDOBJECT     /* SIZEOF=48 */

OBJECT standardpacket
  msg:mn
  pkt:dospacket
ENDOBJECT     /* SIZEOF=68 */

CONST ACTION_NIL=0,
      ACTION_STARTUP=0,
      ACTION_GET_BLOCK=2,
      ACTION_SET_MAP=4,     
      ACTION_DIE=5,
      ACTION_EVENT=6,
      ACTION_CURRENT_VOLUME=7,
      ACTION_LOCATE_OBJECT=8,
      ACTION_RENAME_DISK=9,
      ACTION_FREE_LOCK=15,
      ACTION_DELETE_OBJECT=16,
      ACTION_RENAME_OBJECT=17,
      ACTION_MORE_CACHE=18,
      ACTION_COPY_DIR=19,
      ACTION_WAIT_CHAR=20,
      ACTION_SET_PROTECT=21,
      ACTION_CREATE_DIR=22,
      ACTION_EXAMINE_OBJECT=23,
      ACTION_EXAMINE_NEXT=24,
      ACTION_DISK_INFO=25,
      ACTION_INFO=26,
      ACTION_FLUSH=27,
      ACTION_SET_COMMENT=28,
      ACTION_PARENT=29,
      ACTION_TIMER=30,
      ACTION_INHIBIT=31,
      ACTION_DISK_TYPE=$20,
      ACTION_DISK_CHANGE=$21,
      ACTION_SET_DATE=$22,
      ACTION_SAME_LOCK=$28,
      ACTION_READ=$52,
      ACTION_WRITE=$57,
      ACTION_UNDISK_INFO=513,     
      ACTION_SCREEN_MODE=$3E2,
      ACTION_CHANGE_SIGNAL=$3E3,
      ACTION_READ_RETURN=$3E9,
      ACTION_WRITE_RETURN=$3EA,
      ACTION_FINDUPDATE=$3EC,
      ACTION_FINDINPUT=$3ED,
      ACTION_FINDOUTPUT=$3EE,
      ACTION_END=$3EF,
      ACTION_SEEK=$3F0,
      ACTION_FORMAT=$3FC,
      ACTION_MAKE_LINK=$3FD,
      ACTION_SET_FILE_SIZE=$3FE,
      ACTION_WRITE_PROTECT=$3FF,      
      ACTION_READ_LINK=$400,
      ACTION_FH_FROM_LOCK=$402,
      ACTION_IS_FILESYSTEM=$403,
      ACTION_CHANGE_MODE=$404,
      ACTION_COPY_DIR_FH=$406,
      ACTION_PARENT_FH=$407,
      ACTION_EXAMINE_ALL=$409,
      ACTION_EXAMINE_FH=$40A,
      ACTION_EXAMINE_ALL_END=$40B,
      ACTION_SET_OWNER=$40C,      
      ACTION_LOCK_RECORD=$7D8,
      ACTION_FREE_RECORD=$7D9,
      ACTION_ADD_NOTIFY=$1001,
      ACTION_REMOVE_NOTIFY=$1002,
      ACTION_SERIALIZE_DISK=$1068

OBJECT errorstring
  nums:PTR TO LONG
  strings:PTR TO CHAR
ENDOBJECT     /* SIZEOF=8 */

OBJECT doslibrary
  lib:lib
  root:PTR TO rootnode
  gv:LONG
  a2:LONG
  a5:LONG
  a6:LONG
  errors:PTR TO errorstring
  timereq:PTR TO timerequest
  utilitybase:PTR TO lib
  intuitionbase:PTR TO lib
ENDOBJECT     /* SIZEOF=70 */

OBJECT rootnode
  taskarray:LONG
  consolesegment:LONG
  time:datestamp
  restartseg:LONG
  info:LONG
  filehandlersegment:LONG
  clilist:mlh
  bootproc:PTR TO mp
  shellsegment:LONG
  flags:LONG
ENDOBJECT     /* SIZEOF=56 */

CONST RNB_WILDSTAR=24,
      RNF_WILDSTAR=$1000000,
      RNB_PRIVATE1=1,
      RNF_PRIVATE1=2

OBJECT cliproclist
  node:mln
  first:LONG
-> Um, this is really PTR TO PTR TO mp
  array:PTR TO LONG
ENDOBJECT     /* SIZEOF=16 */

OBJECT dosinfo
  mcname:LONG
  devinfo:LONG
  devices:LONG
  handlers:LONG
  nethand:LONG
  devlock:ss
  entrylock:ss
  deletelock:ss
ENDOBJECT     /* SIZEOF=158 */

OBJECT segment
  next:LONG
  uc:LONG
  seg:LONG
  name[4]:ARRAY OF CHAR
ENDOBJECT     /* SIZEOF=16 */

CONST CMD_SYSTEM=-1,
      CMD_INTERNAL=-2,
      CMD_DISABLED=$FFFFFC19

OBJECT commandlineinterface
  result2:LONG
  setname:PTR TO CHAR
  commanddir:LONG
  returncode:LONG
  commandname:PTR TO CHAR
  faillevel:LONG
  prompt:PTR TO CHAR
  standardinput:LONG
  currentinput:LONG
  commandfile:PTR TO CHAR
  interactive:LONG
  background:LONG
  currentoutput:LONG
  defaultstack:LONG
  standardoutput:LONG
  module:LONG
ENDOBJECT     /* SIZEOF=64 */

OBJECT devlist
  next:LONG
  type:LONG
  task:PTR TO mp
  lock:LONG
  volumedate:datestamp
  locklist:LONG
  disktype:LONG
  unused:LONG
  name:PTR TO CHAR
ENDOBJECT     /* SIZEOF=44 */

OBJECT devinfo
  next:LONG
  type:LONG
  task:LONG
  lock:LONG
  handler:PTR TO CHAR
  stacksize:LONG
  priority:LONG
  startup:LONG
  seglist:LONG
  globvec:LONG
  name:PTR TO CHAR
ENDOBJECT     /* SIZEOF=44 */

OBJECT doslist
  next:LONG
  type:LONG
  task:PTR TO mp
  lock:LONG

  UNION [
  handler:PTR TO CHAR
  stacksize:LONG
  priority:LONG
  startup:LONG
  seglist:LONG
  globvec:LONG]
  [
  volumedate:datestamp
  locklist:LONG
  disktype:LONG
  ]

  [
  assignname:PTR TO CHAR
  list:PTR TO assignlist
  ]
  ENDUNION
  name:PTR TO CHAR
ENDOBJECT     /* SIZEOF=44 */


OBJECT assignlist
  next:PTR TO assignlist
  lock:LONG
ENDOBJECT     /* SIZEOF=8 */

CONST DLT_DEVICE=0,
      DLT_DIRECTORY=1,
      DLT_VOLUME=2,
      DLT_LATE=3,
      DLT_NONBINDING=4,
      DLT_PRIVATE=-1

OBJECT devproc
  port:PTR TO mp
  lock:LONG
  flags:LONG
  devnode:PTR TO doslist
ENDOBJECT     /* SIZEOF=16 */

CONST DVPB_UNLOCK=0,
      DVPF_UNLOCK=1,
      DVPB_ASSIGN=1,
      DVPF_ASSIGN=2,
      LDB_DEVICES=2,
      LDF_DEVICES=4,
      LDB_VOLUMES=3,
      LDF_VOLUMES=8,
      LDB_ASSIGNS=4,
      LDF_ASSIGNS=16,
      LDB_ENTRY=5,
      LDF_ENTRY=$20,
      LDB_DELETE=6,
      LDF_DELETE=$40,
      LDB_READ=0,
      LDF_READ=1,
      LDB_WRITE=1,
      LDF_WRITE=2,
      LDF_ALL=28

OBJECT filelock
  link:LONG
  key:LONG
  access:LONG
  task:PTR TO mp
  volume:LONG
ENDOBJECT     /* SIZEOF=20 */

CONST REPORT_STREAM=0,
      REPORT_TASK=1,
      REPORT_LOCK=2,
      REPORT_VOLUME=3,
      REPORT_INSERT=4,
      ABORT_DISK_ERROR=$128,
      ABORT_BUSY=$120,
      RUN_EXECUTE=-1,
      RUN_SYSTEM=-2,
      RUN_SYSTEM_ASYNCH=-3,
      ST_ROOT=1,
      ST_USERDIR=2,
      ST_SOFTLINK=3,
      ST_LINKDIR=4,
      ST_FILE=-3,
      ST_LINKFILE=-4,
      ST_PIPEFILE=-5

