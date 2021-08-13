OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/nodes'

#define IsListEmpty(x)    (x::mlh.tailpred = (x))
#define IsMsgPortEmpty(x) (x::mp.ln.tailpred = x::mp.ln)

OBJECT lh
  head:PTR TO ln
  tail:PTR TO ln
  tailpred:PTR TO ln
  type:CHAR
  pad:CHAR
ENDOBJECT     /* SIZEOF=14 */

OBJECT mlh
  head:PTR TO mln
  tail:PTR TO mln
  tailpred:PTR TO mln
ENDOBJECT     /* SIZEOF=12 */

