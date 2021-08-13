OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/nodes'

OBJECT nvinfo
  maxstorage:LONG
  freestorage:LONG
ENDOBJECT

OBJECT nventry
  node:mln
  name:PTR TO CHAR
  size:LONG
  protection:LONG
ENDOBJECT

#define SizeNVData(dataptr) (Long((dataptr)-4)-4)

CONST NVEB_DELETE=0,
      NVEF_DELETE=1,
      NVEB_APPNAME=31,
      NVEF_APPNAME=$80000000,
      NVERR_BADNAME=1,
      NVERR_WRITEPROT=2,
      NVERR_FAIL=3,
      NVERR_FATAL=4

