  OPT MODULE
  OPT EXPORT

MODULE 'exec/lists',
       'exec/nodes'

OBJECT mp
  ln:ln
  flags:CHAR
  sigbit:CHAR
  sigtask:LONG
  msglist:lh
ENDOBJECT     /* SIZEOF=34 */

CONST MP_SOFTINT=16,
      PF_ACTION=3,
      PA_SIGNAL=0,
      PA_SOFTINT=1,
      PA_IGNORE=2     
      
OBJECT mn
  ln:ln
  replyport:PTR TO mp
  length:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=20 */

