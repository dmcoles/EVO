OPT MODULE
OPT EXPORT

MODULE 'exec/lists',
       'exec/nodes',
       'exec/ports',
       'exec/tasks'

OBJECT ssr
  mln:mln
  waiter:PTR TO tc
ENDOBJECT     /* SIZEOF=12 */

OBJECT ss
  ln:ln
  nestcount:INT
  waitqueue:mlh
  multiplelink:ssr
  owner:PTR TO tc
  queuecount:INT
ENDOBJECT     /* SIZEOF=46 */

OBJECT semaphoremessage
  mn:mn
  semaphore:PTR TO ss
ENDOBJECT     /* SIZEOF=24 */

OBJECT sm
  mp:mp
  bids:INT
ENDOBJECT     /* SIZEOF=36 */

CONST SM_LOCKMSG=16,
      SM_SHARED=1,
      SM_EXCLUSIVE=0


