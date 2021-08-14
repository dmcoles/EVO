  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'graphics/gfx','intuition/cghooks'

OBJECT specialpens
  version:INT
  darkpen:LONG
  lightpen:LONG
ENDOBJECT

OBJECT gpcliprect
  methodid:LONG
  ginfo:PTR TO gadgetinfo
  rect:PTR TO rectangle
  flags:LONG
ENDOBJECT

CONST GM_CLIPRECT=$550001,
      GMC_VISIBLE=2,
      GMC_PARTIAL=1,
      GMC_INVISIBLE=0