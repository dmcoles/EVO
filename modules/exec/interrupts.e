  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

MODULE 'exec/lists',
       'exec/nodes'

OBJECT is
  ln:ln
  data:LONG
  code:LONG
ENDOBJECT     /* SIZEOF=22 */

OBJECT iv
  data:LONG
  code:LONG
  node:PTR TO ln
ENDOBJECT     /* SIZEOF=12 */

CONST SF_SAR=$8000,     
      SF_TQE=$4000,
      SF_SINT=$2000

OBJECT sh
  lh:lh
  pad:INT
ENDOBJECT     /* SIZEOF=16 */

CONST SIH_PRIMASK=$F0,
      SIH_QUEUES=5,
      INTB_NMI=15,
      INTF_NMI=$8000