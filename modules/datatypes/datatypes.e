  OPT MODULE
  OPT EXPORT

MODULE 'dos/dos',
       'exec/libraries',
       'exec/lists',
       'exec/nodes',
       'libraries/iffparse',
       'utility/tagitem'

CONST ID_DTYP=$44545950,
      ID_DTHD=$44544844

OBJECT datatypeheader
  name:PTR TO CHAR
  basename:PTR TO CHAR
  pattern:PTR TO CHAR
  mask:PTR TO INT
  groupid:LONG
  id:LONG
  masklen:INT
  pad:INT
  flags:INT  -> This is unsigned
  priority:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=32 */

CONST DTF_TYPE_MASK=15,
      DTF_BINARY=0,
      DTF_ASCII=1,
      DTF_IFF=2,
      DTF_MISC=3,
      DTF_CASE=16,
      DTF_SYSTEM1=$1000,
      GID_SYSTEM=$73797374,
      GID_TEXT=$74657874,
      GID_DOCUMENT=$646F6375,
      GID_SOUND=$736F756E,
      GID_INSTRUMENT=$696E7374,
      GID_MUSIC=$6D757369,
      GID_PICTURE=$70696374,
      GID_ANIMATION=$616E696D,
      GID_MOVIE=$6D6F7669,
      ID_CODE=$44544344,
      TOOLA_DUMMY=$80000000,
      TOOLA_PROGRAM=$80000001,
      TOOLA_WHICH=$80000002,
      TOOLA_LAUNCHTYPE=$80000003,
      DTHSIZE=$20

OBJECT dthookcontext
  sysbase:PTR TO lib
  dosbase:PTR TO lib
  iffparsebase:PTR TO lib
  utilitybase:PTR TO lib
  lock:LONG
  fib:PTR TO fileinfoblock
  filehandle:LONG
  iff:PTR TO iffhandle
  buffer:PTR TO CHAR
  bufferlength:LONG
ENDOBJECT     /* SIZEOF=40 */

CONST ID_TOOL=$4454544C

OBJECT tool
  which:INT  -> This is unsigned
  flags:INT  -> This is unsigned
  program:PTR TO CHAR
ENDOBJECT     /* SIZEOF=8 */

CONST TW_INFO=1,
      TW_BROWSE=2,
      TW_EDIT=3,
      TW_PRINT=4,
      TW_MAIL=5,
      TF_LAUNCH_MASK=15,
      TF_SHELL=1,
      TF_WORKBENCH=2,
      TF_RX=3,
      ID_TAGS=$44545447

OBJECT datatype
  node1:ln
  node2:ln
  header:PTR TO datatypeheader
  toollist:lh
  functionname:PTR TO CHAR
  attrlist:PTR TO tagitem
  length:LONG
ENDOBJECT     /* SIZEOF=58 */

OBJECT toolnode
  node:ln
  tool:tool
  length:LONG
ENDOBJECT     /* SIZEOF=26 */

CONST ID_NAME=$4E414D45,
      DTERROR_UNKNOWN_DATATYPE=$7D0,
      DTERROR_COULDNT_SAVE=$7D1,
      DTERROR_COULDNT_OPEN=$7D2,     
      DTERROR_COULDNT_SEND_MESSAGE=$7D3,
      DTERROR_COULDNT_OPEN_CLIPBOARD=$7D4,
      DTERROR_RESERVED=$7D5,
      DTERROR_UNKNOWN_COMPRESSION=$7D6,
      DTERROR_NOT_ENOUGH_DATA=$7D7,
      DTERROR_INVALID_DATA=$7D8,
      DTERROR_NOT_AVAILABLE=$7D9,
      DTMSG_TYPE_OFFSET=$834,
      DTNSIZE=$3A,
      TNSIZE=26

