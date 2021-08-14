OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/lists',
       'intuition/cghooks',
       'utility/tagitem'

OBJECT msg
  methodid:LONG
ENDOBJECT     /* SIZEOF=4 */

#define ROOTCLASS     'rootclass'
#define IMAGECLASS    'imageclass'
#define FRAMEICLASS   'frameiclass'
#define SYSICLASS     'sysiclass'
#define FILLRECTCLASS 'fillrectclass'
#define GADGETCLASS   'gadgetclass'
#define PROPGCLASS    'propgclass'
#define STRGCLASS     'strgclass'
#define BUTTONGCLASS  'buttongclass'
#define FRBUTTONCLASS 'frbuttonclass'
#define GROUPGCLASS   'groupgclass'
#define ICCLASS       'icclass'
#define MODELCLASS    'modelclass'
#define ITEXTICLASS   'itexticlass'
#define POINTERCLASS  'pointerclass'

CONST OM_NEW=$101,
      OM_DISPOSE=$102,
      OM_SET=$103,
      OM_GET=$104,
      OM_ADDTAIL=$105,
      OM_REMOVE=$106,
      OM_NOTIFY=$107,
      OM_UPDATE=$108,
      OM_ADDMEMBER=$109,
      OM_REMMEMBER=$10A

OBJECT opnew
  methodid:LONG
  attrlist:PTR TO tagitem
  ginfo:PTR TO gadgetinfo
ENDOBJECT     /* SIZEOF=12 */

OBJECT opset
  methodid:LONG
  attrlist:PTR TO tagitem
  ginfo:PTR TO gadgetinfo
ENDOBJECT     /* SIZEOF=12 */

OBJECT opupdate
  methodid:LONG
  attrlist:PTR TO tagitem
  ginfo:PTR TO gadgetinfo
  flags:LONG
ENDOBJECT     /* SIZEOF=16 */

OBJECT opnotify
  methodid:LONG
  attrlist:PTR TO tagitem
  ginfo:PTR TO gadgetinfo
  flags:LONG
ENDOBJECT     /* SIZEOF=16 */

CONST OPUB_INTERIM=0,
      OPUF_INTERIM=1

OBJECT opget
  methodid:LONG
  attrid:LONG
  storage:PTR TO LONG
ENDOBJECT     /* SIZEOF=12 */

OBJECT opaddtail
  methodid:LONG
  list:PTR TO lh
ENDOBJECT     /* SIZEOF=8 */

OBJECT opmember
  methodid:LONG
  object:LONG
ENDOBJECT     /* SIZEOF=8 */

OBJECT opaddmember
  methodid:LONG
  object:LONG
ENDOBJECT     /* SIZEOF=8 */

OBJECT opremmember
  methodid:LONG
  object:LONG
ENDOBJECT     /* SIZEOF=8 */
