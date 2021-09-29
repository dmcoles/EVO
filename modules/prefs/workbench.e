  OPT MODULE
  OPT EXPORT

  MODULE 'graphics/gfx'

OBJECT workbenchprefs
  defaultstacksize:LONG
  typerestarttime:LONG
  iconprecision:LONG
  embossrect:rectangle
  borderless:INT
  maxnamelength:LONG
  newiconssupport:INT
  coloriconsupport:INT
ENDOBJECT

OBJECT workbenchextendedprefs
  basicprefs:workbenchprefs
  iconmemorytype:LONG
  lockpens:INT
  disabletitlebar:INT
  disablevolumegauge:INT
  titleupdatedelay:INT
  copybuffersize:LONG
  flags:LONG
ENDOBJECT

OBJECT workbenchhiddendeviceprefs
  name:CHAR
ENDOBJECT

OBJECT workbenchtitleformatprefs
  format:CHAR
ENDOBJECT

CONST ID_WBHD=$57424844,
      ID_WBTF=$57425446