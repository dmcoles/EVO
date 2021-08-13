OPT MODULE
OPT EXPORT

CONST ID_PGFX=$50474658

OBJECT printergfxprefs
  reserved[4]:ARRAY OF LONG
  aspect:INT  -> This is unsigned
  shade:INT  -> This is unsigned
  image:INT  -> This is unsigned
  threshold:INT
  colorcorrect:CHAR
  dimensions:CHAR
  dithering:CHAR
  graphicflags:INT  -> This is unsigned
  printdensity:CHAR
  printmaxwidth:INT  -> This is unsigned
  printmaxheight:INT  -> This is unsigned
  printxoffset:CHAR
  printyoffset:CHAR
ENDOBJECT     /* SIZEOF=36 */

CONST PA_HORIZONTAL=0,
      PA_VERTICAL=1,
      PS_BW=0,
      PS_GREYSCALE=1,
      PS_COLOR=2,
      PS_GREY_SCALE2=3,
      PI_POSITIVE=0,
      PI_NEGATIVE=1,
      PCCB_RED=0,
      PCCB_GREEN=1,
      PCCB_BLUE=2,
      PCCF_RED=1,
      PCCF_GREEN=2,
      PCCF_BLUE=4,
      PD_IGNORE=0,
      PD_BOUNDED=1,
      PD_ABSOLUTE=2,
      PD_PIXEL=3,
      PD_MULTIPLY=4,
      PD_ORDERED=0,
      PD_HALFTONE=1,
      PD_FLOYD=2,
      PGFB_CENTER_IMAGE=0,
      PGFB_INTEGER_SCALING=1,
      PGFB_ANTI_ALIAS=2,
      PGFF_CENTER_IMAGE=1,
      PGFF_INTEGER_SCALING=2,
      PGFF_ANTI_ALIAS=4
