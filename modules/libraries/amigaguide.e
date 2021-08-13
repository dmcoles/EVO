OPT MODULE
OPT EXPORT

MODULE 'exec/nodes',
       'exec/ports',
       'intuition/screens',
       'utility/hooks',
       'utility/tagitem'

CONST APSH_TOOL_ID=$2AF8,
      STARTUPMSGID=$2AF9,
      LOGINTOOLID=$2AFA,
      LOGOUTTOOLID=$2AFB,
      SHUTDOWNMSGID=$2AFC,
      ACTIVATETOOLID=$2AFD,
      DEACTIVATETOOLID=$2AFE,
      ACTIVETOOLID=$2AFF,
      INACTIVETOOLID=$2B00,
      TOOLSTATUSID=$2B01,
      TOOLCMDID=$2B02,
      TOOLCMDREPLYID=$2B03,
      SHUTDOWNTOOLID=$2B04,
      AGA_DUMMY=$80000000,
      AGA_PATH=$80000001,
      AGA_XREFLIST=$80000002,
      AGA_ACTIVATE=$80000003,
      AGA_CONTEXT=$80000004,
      AGA_HELPGROUP=$80000005,
      AGA_RESERVED1=$80000006,
      AGA_RESERVED2=$80000007,
      AGA_RESERVED3=$80000008,
      AGA_AREXXPORT=$80000009,
      AGA_AREXXPORTNAME=$8000000A,
      AGA_WORKPATH=$8000000B,
      AGA_WORKNODE=$8000000C

OBJECT amigaguidemsg
  msg:mn
  type:LONG
  data:LONG
  dsize:LONG
  dtype:LONG
  pri_ret:LONG
  sec_ret:LONG
  system1:LONG
  system2:LONG
ENDOBJECT     /* SIZEOF=52 */

OBJECT newamigaguide
  lock:LONG
  name:PTR TO CHAR
  screen:PTR TO screen
  pubscreen:PTR TO CHAR
  hostport:PTR TO CHAR
  clientport:PTR TO CHAR
  basename:PTR TO CHAR
  flags:LONG
  context:PTR TO LONG
  node:PTR TO CHAR
  line:LONG
  extens:PTR TO tagitem
  client:LONG
ENDOBJECT     /* SIZEOF=52 */

CONST HTF_LOAD_INDEX=1,
      HTF_LOAD_ALL=2,
      HTF_CACHE_NODE=4,
      HTF_CACHE_DB=8,
      HTF_UNIQUE=16,
      HTF_NOACTIVATE=$20,
      HTFC_SYSGADS=$80000000,
      HTH_OPEN=0,
      HTH_CLOSE=1,
      HTERR_NOT_ENOUGH_MEMORY=$64,
      HTERR_CANT_OPEN_DATABASE=$65,
      HTERR_CANT_FIND_NODE=$66,
      HTERR_CANT_OPEN_NODE=$67,
      HTERR_CANT_OPEN_WINDOW=$68,
      HTERR_INVALID_COMMAND=$69,
      HTERR_CANT_COMPLETE=$6A,
      HTERR_PORT_CLOSED=$6B,
      HTERR_CANT_CREATE_PORT=$6C,
      HTERR_KEYWORD_NOT_FOUND=$71

OBJECT xref
  node:ln
  pad:INT  -> This is unsigned
-> Umm, should be 'PTR TO docfile', but 'docfile' not defined
  df:LONG
  file:PTR TO CHAR
  name:PTR TO CHAR
  line:LONG
ENDOBJECT     /* SIZEOF=32 */

CONST XR_GENERIC=0,
      XR_FUNCTION=1,
      XR_COMMAND=2,
      XR_INCLUDE=3,
      XR_MACRO=4,
      XR_STRUCT=5,
      XR_FIELD=6,
      XR_TYPEDEF=7,
      XR_DEFINE=8

OBJECT amigaguidehost
  dispatcher:hook
  reserved:LONG
  flags:LONG
  usecnt:LONG
  systemdata:LONG
  userdata:LONG
ENDOBJECT     /* SIZEOF=40 */

CONST HM_FINDNODE=1,
      HM_OPENNODE=2,
      HM_CLOSENODE=3,
      HM_EXPUNGE=10

-> Um, methodid's were all missing
OBJECT opfindhost
  methodid:LONG
  attrs:PTR TO tagitem
  node:PTR TO CHAR
  toc:PTR TO CHAR
  title:PTR TO CHAR
  next:PTR TO CHAR
  prev:PTR TO CHAR
ENDOBJECT     /* SIZEOF=NONE !!! */

OBJECT opnodeio
  methodid:LONG
  attrs:PTR TO tagitem
  node:PTR TO CHAR
  filename:PTR TO CHAR
  docbuffer:PTR TO CHAR
  bufflen:LONG
  flags:LONG
ENDOBJECT     /* SIZEOF=NONE !!! */

CONST HTNF_KEEP=1,
      HTNF_RESERVED1=2,
      HTNF_RESERVED2=4,
      HTNF_ASCII=8,
      HTNF_RESERVED3=16,
      HTNF_CLEAN=$20,
      HTNF_DONE=$40,
      HTNA_DUMMY=$80000000,
      HTNA_SCREEN=$80000001,
      HTNA_PENS=$80000002,
      HTNA_RECTANGLE=$80000003,
      HTNA_HELPGROUP=$80000005

OBJECT opexpungenode
  methodid:LONG
  attrs:PTR TO tagitem
ENDOBJECT     /* SIZEOF=NONE !!! */
