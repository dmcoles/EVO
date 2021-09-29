  OPT MODULE
  OPT EXPORT

  MODULE 'graphics/text'

OBJECT reactionprefs
  beveltype:INT
  glyphtype:INT
  layoutspacing:INT
  _3dprop:INT
  labelpen:INT
  labelplace:INT
  _3dlabel:INT
  simplerefresh:INT
  _3dlool:INT
  fallbackattr:textattr
  labelattr:textattr
  fallbackname[128]:ARRAY OF CHAR
  labelname[128]:ARRAY OF CHAR
  pattern[256]:ARRAY OF CHAR
ENDOBJECT

CONST ID_RACT=$52414354,
      FONTNAMESIZE=128