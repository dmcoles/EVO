OPT MODULE
OPT EXPORT

MODULE 'exec/nodes'

OBJECT mathieeeresource
  node:ln
  flags:INT  -> This is unsigned
  baseaddr:PTR TO INT  -> The target is unsigned
  dblbasinit:LONG
  dbltransinit:LONG
  sglbasinit:LONG
  sgltransinit:LONG
  extbasinit:LONG
  exttransinit:LONG
ENDOBJECT     /* SIZEOF=44 */

CONST MATHIEEERESOURCEF_DBLBAS=1,
      MATHIEEERESOURCEF_DBLTRANS=2,
      MATHIEEERESOURCEF_SGLBAS=4,
      MATHIEEERESOURCEF_SGLTRANS=8,
      MATHIEEERESOURCEF_EXTBAS=16,
      MATHIEEERESOURCEF_EXTTRANS=$20

