  OPT MODULE
  OPT EXPORT

OBJECT rigiddiskblock
  id:LONG
  summedlongs:LONG
  chksum:LONG
  hostid:LONG
  blockbytes:LONG
  flags:LONG
  badblocklist:LONG
  partitionlist:LONG
  filesysheaderlist:LONG
  driveinit:LONG
  reserved1[6]:ARRAY OF LONG
  cylinders:LONG
  sectors:LONG
  heads:LONG
  interleave:LONG
  park:LONG
  reserved2[3]:ARRAY OF LONG
  writeprecomp:LONG
  reducedwrite:LONG
  steprate:LONG
  reserved3[5]:ARRAY OF LONG
  rdbblockslo:LONG
  rdbblockshi:LONG
  locylinder:LONG
  hicylinder:LONG
  cylblocks:LONG
  autoparkseconds:LONG
  highrdskblock:LONG
  reserved4:LONG
  diskvendor[8]:ARRAY OF CHAR
  diskproduct[16]:ARRAY OF CHAR
  diskrevision[4]:ARRAY OF CHAR
  controllervendor[8]:ARRAY OF CHAR
  controllerproduct[16]:ARRAY OF CHAR
  controllerrevision[4]:ARRAY OF CHAR
  driveinitname[40]:ARRAY OF CHAR
ENDOBJECT     /* SIZEOF=256 */

CONST IDNAME_RIGIDDISK=$5244534B,
      RDB_LOCATION_LIMIT=16,
      RDBFB_LAST=0,
      RDBFF_LAST=1,
      RDBFB_LASTLUN=1,
      RDBFF_LASTLUN=2,
      RDBFB_LASTTID=2,
      RDBFF_LASTTID=4,
      RDBFB_NORESELECT=3,
      RDBFF_NORESELECT=8,
      RDBFB_DISKID=4,
      RDBFF_DISKID=16,
      RDBFB_CTRLRID=5,
      RDBFF_CTRLRID=$20,
      RDBFB_SYNCH=6,     
      RDBFF_SYNCH=$40

OBJECT badblockentry
  badblock:LONG
  goodblock:LONG
ENDOBJECT     /* SIZEOF=8 */

OBJECT badblockblock
  id:LONG
  summedlongs:LONG
  chksum:LONG
  hostid:LONG
  next:LONG
  reserved:LONG
  blockpairs[61]:ARRAY OF badblockentry
ENDOBJECT     /* SIZEOF=512 */

CONST IDNAME_BADBLOCK=$42414442

OBJECT partitionblock
  id:LONG
  summedlongs:LONG
  chksum:LONG
  hostid:LONG
  next:LONG
  flags:LONG
  reserved1[2]:ARRAY OF LONG
  devflags:LONG
  drivename[32]:ARRAY OF CHAR
  reserved2[15]:ARRAY OF LONG
  environment[20]:ARRAY OF LONG
  ereserved[12]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=256 */
CONST IDNAME_PARTITION=$50415254,
      PBFB_BOOTABLE=0,
      PBFF_BOOTABLE=1,
      PBFB_NOMOUNT=1,
      PBFF_NOMOUNT=2

OBJECT filesysheaderblock
  id:LONG
  summedlongs:LONG
  chksum:LONG
  hostid:LONG
  next:LONG
  flags:LONG
  reserved1[2]:ARRAY OF LONG
  dostype:LONG
  version:LONG
  patchflags:LONG
  type:LONG
  task:LONG
  lock:LONG
  handler:LONG
  stacksize:LONG
  priority:LONG
  startup:LONG
  seglistblocks:LONG
  globalvec:LONG
  reserved2[23]:ARRAY OF LONG
  filesysname[84]:ARRAY OF CHAR
ENDOBJECT     /* SIZEOF=256 */

CONST IDNAME_FILESYSHEADER=$46534844

OBJECT loadsegblock
  id:LONG
  summedlongs:LONG
  chksum:LONG
  hostid:LONG
  next:LONG
  loaddata[123]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=512 */
CONST IDNAME_LOADSEG=$4C534547

