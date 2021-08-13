OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/lists',
       'exec/ports',
       'intuition/intuition',
       'workbench/startup'

CONST WORKBENCH_WORKBENCH_I=1,
      WBDISK=1,
      WBDRAWER=2,
      WBTOOL=3,
      WBPROJECT=4,
      WBGARBAGE=5,
      WBDEVICE=6,
      WBKICK=7,
      WBAPPICON=8

-> Um, this object was missing
OBJECT olddrawerdata
  newwindow:nw
  currentx:LONG
  currenty:LONG
ENDOBJECT

CONST OLDDRAWERDATAFILESIZE=$38

OBJECT drawerdata
  newwindow:nw
  currentx:LONG
  currenty:LONG
  flags:LONG
  viewmodes:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=62 */

CONST DRAWERDATAFILESIZE=$3E

OBJECT diskobject
  magic:INT  -> This is unsigned
  version:INT  -> This is unsigned
  gadget:gadget
  type:CHAR
  pad_byte:CHAR
  defaulttool:PTR TO CHAR
  tooltypes:PTR TO LONG
  currentx:LONG
  currenty:LONG
  drawerdata:PTR TO drawerdata
  toolwindow:PTR TO CHAR
  stacksize:LONG
ENDOBJECT     /* SIZEOF=78 */

CONST WB_DISKMAGIC=$E310,
      WB_DISKVERSION=1,
      WB_DISKREVISION=1,
      WB_DISKREVISIONMASK=$FF

OBJECT freelist
  numfree:INT
  memlist:lh
ENDOBJECT     /* SIZEOF=16 */

CONST GFLG_GADGBACKFILL=1,
      GADGBACKFILL=1,
      NO_ICON_POSITION=$80000000,
      AM_VERSION=1,
      AMTYPE_APPWINDOW=7,
      AMTYPE_APPICON=8,
      AMTYPE_APPMENUITEM=9

#define WORKBENCH_NAME 'workbench.library'

OBJECT appmessage
  message:mn
  type:INT  -> This is unsigned
  userdata:LONG
  id:LONG
  numargs:LONG
  arglist:PTR TO wbarg
  version:INT  -> This is unsigned
  class:INT  -> This is unsigned
  mousex:INT
  mousey:INT
  seconds:LONG
  micros:LONG
  reserved[8]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=62 */

OBJECT appwindow
  private:LONG
ENDOBJECT     /* SIZEOF=0 */

OBJECT appicon
  private:LONG
ENDOBJECT     /* SIZEOF=0 */

OBJECT appmenuitem
  private:LONG
ENDOBJECT     /* SIZEOF=0 */

