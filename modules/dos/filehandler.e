OPT MODULE
OPT EXPORT

MODULE 'exec/ports'

OBJECT dosenvec
  tablesize:LONG
  sizeblock:LONG
  secorg:LONG
  surfaces:LONG
  sectorperblock:LONG
  blockspertrack:LONG
  reserved:LONG
  prealloc:LONG
  interleave:LONG
  lowcyl:LONG
  highcyl:LONG
  numbuffers:LONG
  bufmemtype:LONG
  maxtransfer:LONG
  mask:LONG
  bootpri:LONG
  dostype:LONG
  baud:LONG
  control:LONG
  bootblocks:LONG
ENDOBJECT     /* SIZEOF=80 */

CONST DE_TABLESIZE=0,
      DE_SIZEBLOCK=1,
      DE_SECORG=2,
      DE_NUMHEADS=3,
      DE_SECSPERBLK=4,
      DE_BLKSPERTRACK=5,
      DE_RESERVEDBLKS=6,
      DE_PREFAC=7,
      DE_INTERLEAVE=8,
      DE_LOWCYL=9,
      DE_UPPERCYL=10,
      DE_NUMBUFFERS=11,
      DE_MEMBUFTYPE=12,
      DE_BUFMEMTYPE=12,
      DE_MAXTRANSFER=13,
      DE_MASK=14,
      DE_BOOTPRI=15,
      DE_DOSTYPE=16,
      DE_BAUD=17,
      DE_CONTROL=18,
      DE_BOOTBLOCKS=19

OBJECT filesysstartupmsg
  unit:LONG
  device:PTR TO CHAR
  environ:LONG
  flags:LONG
ENDOBJECT     /* SIZEOF=16 */

OBJECT devicenode
  next:PTR TO CHAR
  type:LONG
  task:PTR TO mp
  lock:LONG
  handler:PTR TO CHAR
  stacksize:LONG
  priority:LONG
  startup:LONG
  seglist:LONG
  globalvec:LONG
  name:PTR TO CHAR
ENDOBJECT     /* SIZEOF=44 */
