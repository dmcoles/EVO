OPT MODULE
OPT EXPORT

CONST DEVICES_SCSIDISK_I=1,
      HD_SCSICMD=28

OBJECT scsicmd
  data:PTR TO INT  -> Target is unsigned
  length:LONG
  actual:LONG
  command:PTR TO CHAR
  cmdlength:INT  -> This is unsigned
  cmdactual:INT  -> This is unsigned
  flags:CHAR
  status:CHAR
  sensedata:PTR TO CHAR
  senselength:INT  -> This is unsigned
  senseactual:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=30 */

CONST SCSIF_WRITE=0,
      SCSIF_READ=1,
      SCSIB_READ_WRITE=0,
      SCSIF_NOSENSE=0,
      SCSIF_AUTOSENSE=2,
      SCSIF_OLDAUTOSENSE=6,
      SCSIB_AUTOSENSE=1,
      SCSIB_OLDAUTOSENSE=2,
      HFERR_SELFUNIT=$28,
      HFERR_DMA=$29,
      HFERR_PHASE=$2A,
      HFERR_PARITY=$2B,
      HFERR_SELTIMEOUT=$2C,
      HFERR_BADSTATUS=$2D,
      HFERR_NOBOARD=$32

