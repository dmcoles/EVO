OPT MODULE
OPT EXPORT

CONST ID_POST=$50535044

OBJECT printerpsprefs
  reserved[4]:ARRAY OF LONG
  drivermode:CHAR
  paperformat:CHAR
  reserved1[2]:ARRAY
  copies:LONG
  paperwidth:LONG
  paperheight:LONG
  horizontaldpi:LONG
  verticaldpi:LONG
  font:CHAR
  pitch:CHAR
  orientation:CHAR
  tab:CHAR
  reserved2[8]:ARRAY
  leftmargin:LONG
  rightmargin:LONG
  topmargin:LONG
  bottommargin:LONG
  fontpointsize:LONG
  leading:LONG
  reserved3[8]:ARRAY
  leftedge:LONG
  topedge:LONG
  width:LONG
  height:LONG
  image:CHAR
  shading:CHAR
  dithering:CHAR
  reserved4a:CHAR
  reserved4[8]:ARRAY
  aspect:CHAR
  scalingtype:CHAR
  reserved5:CHAR
  centering:CHAR
  reserved6[8]:ARRAY
ENDOBJECT     /* SIZEOF=124 */

CONST DM_POSTSCRIPT=0,
      DM_PASSTHROUGH=1,
      PF_USLETTER=0,
      PF_USLEGAL=1,
      PF_A4=2,
      PF_CUSTOM=3,
      FONT_COURIER=0,
      FONT_TIMES=1,
      FONT_HELVETICA=2,
      FONT_HELV_NARROW=3,
      FONT_AVANTGARDE=4,
      FONT_BOOKMAN=5,
      FONT_NEWCENT=6,
      FONT_PALATINO=7,
      FONT_ZAPFCHANCERY=8,
      PITCH_NORMAL=0,
      PITCH_COMPRESSED=1,
      PITCH_EXPANDED=2,
      ORIENT_PORTRAIT=0,
      ORIENT_LANDSCAPE=1,
      TAB_4=0,
      TAB_8=1,
      TAB_QUART=2,
      TAB_HALF=3,
      TAB_INCH=4,
      IM_POSITIVE=0,
      IM_NEGATIVE=1,
      SHAD_BW=0,
      SHAD_GREYSCALE=1,
      SHAD_COLOR=2,
      DITH_DEFAULT=0,
      DITH_DOTTY=1,
      DITH_VERT=2,
      DITH_HORIZ=3,
      DITH_DIAG=4,
      ASP_HORIZ=0,
      ASP_VERT=1,
      ST_ASPECT_ASIS=0,
      ST_ASPECT_WIDE=1,
      ST_ASPECT_TALL=2,
      ST_ASPECT_BOTH=3,
      ST_FITS_WIDE=4,
      ST_FITS_TALL=5,
      ST_FITS_BOTH=6,
      CENT_NONE=0,
      CENT_HORIZ=1,
      CENT_VERT=2,
      CENT_BOTH=3

