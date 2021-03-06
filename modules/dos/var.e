  OPT MODULE
  OPT EXPORT

  MODULE 'exec/nodes'

OBJECT localvar
  node:ln
  flags:INT  -> This is unsigned
  value:PTR TO CHAR
  len:LONG
ENDOBJECT     /* SIZEOF=24 */

CONST LV_VAR=0,
      LV_ALIAS=1,
      LVB_IGNORE=7,
      LVF_IGNORE=$80,
      GVB_GLOBAL_ONLY=8,
      GVF_GLOBAL_ONLY=$100,
      GVB_LOCAL_ONLY=9,
      GVF_LOCAL_ONLY=$200,
      GVB_BINARY_VAR=10,
      GVF_BINARY_VAR=$400,
      GVB_DONT_NULL_TERM=11,
      GVF_DONT_NULL_TERM=$800,
      GVB_SAVE_VAR=12,
      GVF_SAVE_VAR=$1000
