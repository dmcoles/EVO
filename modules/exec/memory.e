  OPT MODULE
  OPT EXPORT

  MODULE 'exec/nodes'

OBJECT ml
  ln:ln
  numentries:INT  -> This is unsigned
-> Um, what about 'me[1]:ARRAY OF me' 
ENDOBJECT     /* SIZEOF=16 */

OBJECT me
  UNION
  [reqs:LONG]
  [addr:LONG]
  ENDUNION
  length:LONG
ENDOBJECT     /* SIZEOF=8 */

CONST MEMF_ANY=0,
      MEMF_PUBLIC=1,
      MEMF_CHIP=2,
      MEMF_FAST=4,
      MEMF_LOCAL=$100,
      MEMF_24BITDMA=$200,
      MEMF_KICK=$400,
      MEMF_CLEAR=$10000,
      MEMF_LARGEST=$20000,
      MEMF_REVERSE=$40000,
      MEMF_TOTAL=$80000,
      MEMF_NO_EXPUNGE=$80000000,
      MEM_BLOCKSIZE=8,
      MEM_BLOCKMASK=7

OBJECT memhandlerdata
  requestsize:LONG
  requestflags:LONG
  flags:LONG
ENDOBJECT     /* SIZEOF=12 */

CONST MEMHF_RECYCLE=1,
      MEM_DID_NOTHING=0,
      MEM_ALL_DONE=-1,
      MEM_TRY_AGAIN=1

OBJECT mh
  ln:ln
  attributes:INT  -> This is unsigned
  first:PTR TO mc
  lower:LONG
  upper:LONG
  free:LONG
ENDOBJECT     /* SIZEOF=32 */

OBJECT mc
  next:PTR TO mc
  bytes:LONG
ENDOBJECT     /* SIZEOF=8 */


