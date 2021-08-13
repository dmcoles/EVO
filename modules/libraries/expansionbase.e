OPT MODULE
OPT EXPORT

MODULE 'exec/libraries',
       'exec/lists',
       'exec/nodes',
       'libraries/configvars'

OBJECT bootnode
  ln:ln
  flags:INT
  devicenode:LONG
ENDOBJECT     /* SIZEOF=20 */

OBJECT expansionbase
  lib:lib
  flags:CHAR
  private01:CHAR
  private02:LONG
  private03:LONG
  private04:currentbinding
  private05:lh
  mountlist:lh
ENDOBJECT     /* SIZEOF=NONE !!! */

CONST EE_OK=0,
      EE_LASTBOARD=$28,
      EE_NOEXPANSION=$29,
      EE_NOMEMORY=$2A,
      EE_NOBOARD=$2B,
      EE_BADMEM=$2C,
      EBB_CLOGGED=0,
      EBF_CLOGGED=1,
      EBB_SHORTMEM=1,
      EBF_SHORTMEM=2,
      EBB_BADMEM=2,
      EBF_BADMEM=4,
      EBB_DOSFLAG=3,
      EBF_DOSFLAG=8,
      EBB_KICKBACK33=4,
      EBF_KICKBACK33=16,
      EBB_KICKBACK36=5,
      EBF_KICKBACK36=$20,
      EBB_SILENTSTART=6,
      EBF_SILENTSTART=$40,
      EBB_START_CC0=7,
      EBF_START_CC0=$80

