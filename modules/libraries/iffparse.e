OPT MODULE
OPT EXPORT

MODULE 'devices/clipboard',
       'exec/nodes',
       'exec/ports'

OBJECT iffhandle
  stream:LONG
  flags:LONG
  depth:LONG
ENDOBJECT     /* SIZEOF=12 */

CONST IFFF_READ=0,
      IFFF_WRITE=1,
      IFFF_RWBITS=1,
      IFFF_FSEEK=2,
      IFFF_RSEEK=4,
      IFFF_RESERVED=$FFFF0000

OBJECT iffstreamcmd
  command:LONG
  buf:PTR TO CHAR
  nbytes:LONG
ENDOBJECT     /* SIZEOF=12 */

OBJECT contextnode
  mln:mln
  id:LONG
  type:LONG
  size:LONG
  scan:LONG
ENDOBJECT     /* SIZEOF=24 */

OBJECT localcontextitem
  mln:mln
  id:LONG
  type:LONG
  ident:LONG
ENDOBJECT     /* SIZEOF=20 */

OBJECT storedproperty
  size:LONG
  data:LONG
ENDOBJECT     /* SIZEOF=8 */

OBJECT collectionitem
  next:PTR TO collectionitem
  size:LONG
  data:LONG
ENDOBJECT     /* SIZEOF=12 */

OBJECT clipboardhandle
  iocr:ioclipreq
  cbport:mp
  satisfyport:mp
ENDOBJECT     /* SIZEOF=120 */

CONST IFFERR_EOF=-1,
      IFFERR_EOC=-2,
      IFFERR_NOSCOPE=-3,
      IFFERR_NOMEM=-4,
      IFFERR_READ=-5,
      IFFERR_WRITE=-6,
      IFFERR_SEEK=-7,
      IFFERR_MANGLED=-8,
      IFFERR_SYNTAX=-9,
      IFFERR_NOTIFF=-10,
      IFFERR_NOHOOK=-11,
      IFF_RETURN2CLIENT=-12,
      ID_FORM=$464F524D,
      ID_LIST=$4C495354,
      ID_CAT=$43415420,
      ID_PROP=$50524F50,
      ID_NULL=$20202020,
      IFFLCI_PROP=$70726F70,
      IFFLCI_COLLECTION=$636F6C6C,
      IFFLCI_ENTRYHANDLER=$656E6864,
      IFFLCI_EXITHANDLER=$65786864,
      IFFPARSE_SCAN=0,
      IFFPARSE_STEP=1,
      IFFPARSE_RAWSTEP=2,
      IFFSLI_ROOT=1,
      IFFSLI_TOP=2,
      IFFSLI_PROP=3,
      IFFSIZE_UNKNOWN=-1,
      IFFCMD_INIT=0,
      IFFCMD_CLEANUP=1,
      IFFCMD_READ=2,
      IFFCMD_WRITE=3,
      IFFCMD_SEEK=4,
      IFFCMD_ENTRY=5,
      IFFCMD_EXIT=6,
      IFFCMD_PURGELCI=7,
      IFFSCC_INIT=0,
      IFFSCC_CLEANUP=1,
      IFFSCC_READ=2,
      IFFSCC_WRITE=3,
      IFFSCC_SEEK=4

