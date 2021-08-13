OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/ports'

#define CxFilter(d)          CreateCxObj(CX_FILTER, (d), 0)
#define CxSender(port, id)   CreateCxObj(CX_SEND, (port), (id))
#define CxSignal(task, sig)  CreateCxObj(CX_SIGNAL, (task), (sig))
#define CxTranslate(ie)      CreateCxObj(CX_TRANSLATE, (ie), 0)
#define CxDebug(id)          CreateCxObj(CX_DEBUG, (id), 0)
#define CxCustom(action, id) CreateCxObj(CX_CUSTOM, (action), id)

OBJECT newbroker
  version:CHAR
  reserve1:CHAR
  name:PTR TO CHAR
  title:PTR TO CHAR
  descr:PTR TO CHAR
  unique:INT
  flags:INT
  pri:CHAR  -> This is signed
  reserve2:CHAR
  port:PTR TO mp
  reservedchannel:INT
ENDOBJECT     /* SIZEOF=26 */

CONST NB_VERSION=5,
      CBD_NAMELEN=24,
      CBD_TITLELEN=$28,
      CBD_DESCRLEN=$28,
      NBU_DUPLICATE=0,
      NBU_UNIQUE=1,
      NBU_NOTIFY=2,
      COF_SHOW_HIDE=4,
      CX_INVALID=0,
      CX_FILTER=1,
      CX_TYPEFILTER=2,
      CX_SEND=3,
      CX_SIGNAL=4,
      CX_TRANSLATE=5,
      CX_BROKER=6,
      CX_DEBUG=7,
      CX_CUSTOM=8,
      CX_ZERO=9,
      CXM_IEVENT=$20,
      CXM_COMMAND=$40,
      CXCMD_DISABLE=15,
      CXCMD_ENABLE=17,
      CXCMD_APPEAR=19,
      CXCMD_DISAPPEAR=21,
      CXCMD_KILL=23,
      CXCMD_LIST_CHG=27,
      CXCMD_UNIQUE=25

OBJECT inputxpression
  version:CHAR
  class:CHAR
  code:INT  -> This is unsigned
  codemask:INT  -> This is unsigned
  qualifier:INT  -> This is unsigned
  qualmask:INT  -> This is unsigned
  qualsame:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=12 */

#define NULL_IX(ix) (ix::inputxpression.class=IECLASS_NULL)

CONST IX_VERSION=2,
      IXSYM_SHIFT=1,
      IXSYM_CAPS=2,
      IXSYM_ALT=4,
      IXSYM_SHIFTMASK=3,
      IXSYM_CAPSMASK=7,
      IXSYM_ALTMASK=$30,
      IX_NORMALQUALS=$7FFF,
      CBERR_OK=0,
      CBERR_SYSERR=1,
      CBERR_DUP=2,
      CBERR_VERSION=3,
      COERR_ISNULL=1,
      COERR_NULLATTACH=2,
      COERR_BADFILTER=4,
      COERR_BADTYPE=8

