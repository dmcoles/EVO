OPT MODULE
OPT EXPORT

MODULE 'dos/dos'

OBJECT datetime
  stamp:datestamp
  format:CHAR
  flags:CHAR
  strday:PTR TO CHAR
  strdate:PTR TO CHAR
  strtime:PTR TO CHAR
ENDOBJECT     /* SIZEOF=26 */

CONST LEN_DATSTRING=16,
      DTB_SUBST=0,
      DTF_SUBST=1,
      DTB_FUTURE=1,
      DTF_FUTURE=2,
      FORMAT_DOS=0,
      FORMAT_INT=1,
      FORMAT_USA=2,
      FORMAT_CDN=3,
      FORMAT_MAX=3

