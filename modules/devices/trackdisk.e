  OPT MODULE
  OPT EXPORT

  OPT PREPROCESS

MODULE 'exec/devices',
       'exec/io'

CONST NUMSECS=11,
      NUMUNITS=4,
      TD_SECTOR=$200,
      TD_SECSHIFT=9,
      TDF_EXTCOM=$8000,
      TD_MOTOR=9,
      TD_SEEK=10,
      TD_FORMAT=11,     
      TD_REMOVE=12,
      TD_CHANGENUM=13,
      TD_CHANGESTATE=14,
      TD_PROTSTATUS=15,
      TD_RAWREAD=16,
      TD_RAWWRITE=17,
      TD_GETDRIVETYPE=18,
      TD_GETNUMTRACKS=19,
      TD_ADDCHANGEINT=20,
      TD_REMCHANGEINT=21,
      TD_GETGEOMETRY=22,
      TD_EJECT=23,
      TD_LASTCOMM=24,
      TD_READ64=24,
      TD_WRITE64=25,
      TD_SEEK64=26,
      TD_FORMAT64=27,
      ETD_WRITE=$8003,
      ETD_READ=$8002,
      ETD_MOTOR=$8009,
      ETD_SEEK=$800A,
      ETD_FORMAT=$800B,
      ETD_UPDATE=$8004,
      ETD_CLEAR=$8005,
      ETD_RAWREAD=$8010,
      ETD_RAWWRITE=$8011

#define TD_NAME 'trackdisk.device'

OBJECT ioexttd
  iostd:iostd
  count:LONG
  seclabel:LONG
ENDOBJECT     /* SIZEOF=56 */

OBJECT drivegeometry
  sectorsize:LONG
  totalsectors:LONG
  cylinders:LONG
  cylsectors:LONG
  heads:LONG
  tracksectors:LONG
  bufmemtype:LONG
  devicetype:CHAR
  flags:CHAR
  reserved:INT
ENDOBJECT     /* SIZEOF=32 */

CONST DG_DIRECT_ACCESS=0,
      DG_SEQUENTIAL_ACCESS=1,
      DG_PRINTER=2,
      DG_PROCESSOR=3,
      DG_WORM=4,
      DG_CDROM=5,
      DG_SCANNER=6,
      DG_OPTICAL_DISK=7,
      DG_MEDIUM_CHANGER=8,
      DG_COMMUNICATION=9,
      DG_UNKNOWN=31,
      DGB_REMOVABLE=0,
      DGF_REMOVABLE=1,
      IOTDB_INDEXSYNC=4,
      IOTDF_INDEXSYNC=16,
      IOTDB_WORDSYNC=5,
      IOTDF_WORDSYNC=$20,
      TD_LABELSIZE=16,
      TDB_ALLOW_NON_3_5=0,
      TDF_ALLOW_NON_3_5=1,
      DRIVE3_5=1,
      DRIVE5_25=2,
      DRIVE3_5_150RPM=3,
      TDERR_NOTSPECIFIED=20,
      TDERR_NOSECHDR=21,
      TDERR_BADSECPREAMBLE=22,
      TDERR_BADSECID=23,
      TDERR_BADHDRSUM=24,
      TDERR_BADSECSUM=25,
      TDERR_TOOFEWSECS=26,
      TDERR_BADSECHDR=27,
      TDERR_WRITEPROT=28,
      TDERR_DISKCHANGED=29,
      TDERR_SEEKERROR=30,
      TDERR_NOMEM=31,
      TDERR_BADUNITNUM=$20,
      TDERR_BADDRIVETYPE=$21,
      TDERR_DRIVEINUSE=$22,
      TDERR_POSTRESET=$23

OBJECT publicunit
  unit:unit
  comp01track:INT  -> This is unsigned
  comp10track:INT  -> This is unsigned
  comp11track:INT  -> This is unsigned
  stepdelay:LONG
  settledelay:LONG
  retrycnt:CHAR
  pubflags:CHAR
  currtrk:INT  -> This is unsigned
  calibratedelay:LONG
  counter:LONG
  postwritedelay:LONG
  sideselectdelay:LONG
ENDOBJECT     /* SIZEOF=72 */

CONST TDPB_NOCLICK=0,
      TDPF_NOCLICK=1
