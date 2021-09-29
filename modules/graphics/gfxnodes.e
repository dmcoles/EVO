  OPT MODULE
  OPT EXPORT

  MODULE 'exec/nodes','graphics/gfxbase'

OBJECT xln
  succ:PTR TO ln
  pred:PTR TO ln
  type:CHAR
  pri:CHAR  -> This is signed
  name:PTR TO CHAR
  subsystem:CHAR
  subtype:CHAR
  library:PTR TO gfxbase
  init:LONG
ENDOBJECT     /* SIZEOF=24 */

CONST SS_GRAPHICS=2,
      VIEW_EXTRA_TYPE=1,
      VIEWPORT_EXTRA_TYPE=2,
      SPECIAL_MONITOR_TYPE=3,
      MONITOR_SPEC_TYPE=4

