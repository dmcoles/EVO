  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'exec/libraries','exec/nodes','utility/hooks'

OBJECT iclass
  dispatcher:hook
  reserved:LONG
  super:PTR TO iclass
  id:LONG
  instoffset:INT -> This is unsigned
  instsize:INT   -> This is unsigned
  userdata:LONG
  subclasscount:LONG
  objectcount:LONG
  flags:LONG
ENDOBJECT     /* SIZEOF=52 */

CONST CLB_INLIST=0,
      CLF_INLIST=1

-> instoffset and instsize are unsigned so AND with $FFFF      
#define INST_DATA(cl, o) ((o)+(cl::iclass.instoffset AND $FFFF))
#define SIZEOF_INSTANCE(cl) ((cl::iclass.instoffset AND $FFFF)+(cl::iclass.instsize AND $FFFF)+SIZEOF object)

CONST OJ_CLASS=8

OBJECT object
  node:mln
  class:PTR TO iclass
ENDOBJECT     /* SIZEOF=12 */

#define _OBJ(o) (o)
#define BASEOBJECT(_obj) ((_obj)+SIZEOF object)
#define _OBJECT(o) ((o)-SIZEOF object)
#define OCLASS(o) (Long(_OBJECT(o)+OJ_CLASS))

OBJECT classlibrary
  lib:lib
  pad:INT
  class:PTR TO iclass
ENDOBJECT     /* SIZEOF=40 */

