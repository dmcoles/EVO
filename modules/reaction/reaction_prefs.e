  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'exec/semaphores','graphics/text'

OBJECT uiprefs
  semaphore:ss
  prefsversion:INT
	prefssize:INT
  beveltype:CHAR
  layoutspacing:INT
  _3dlook:INT
  labelpen:INT
  labelplace:CHAR
  _3dlabel:CHAR
  reserved1:LONG
  simplerefresh:INT
  pattern[256]:ARRAY OF CHAR
  reserved2:LONG
  _3dprop:INT
  reserved3:INT
  glyphtype:CHAR
	reserved4:CHAR
  fallbackattr:PTR TO textattr
  labelattr:PTR TO textattr
ENDOBJECT

CONST  BVT_GT=0,
       BVT_THIN=1,
       BVT_THICK=2,
       BVT_XEN=3,
       BVT_XENTHIN=4,
       GLT_GT=0,
       GLT_FLAT=1,
       GLT_3D=2
       
#define RAPREFSSEMAPHORE "REACTION-PREFS"