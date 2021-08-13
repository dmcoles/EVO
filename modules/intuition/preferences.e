OPT MODULE
OPT EXPORT

MODULE 'devices/timer'

CONST FILENAME_SIZE=30,
      DEVNAME_SIZE=16,
      POINTERSIZE=$24,
      TOPAZ_EIGHTY=8,
      TOPAZ_SIXTY=9

OBJECT preferences
  fontheight:CHAR  -> This is signed
  printerport:CHAR
  baudrate:INT  -> This is unsigned
  keyrptspeed:timeval
  keyrptdelay:timeval
  doubleclick:timeval
  pointermatrix[$24]:ARRAY OF INT  -> Array is unsigned
  xoffset:CHAR  -> This is signed
  yoffset:CHAR  -> This is signed
  color17:INT  -> This is unsigned
  color18:INT  -> This is unsigned
  color19:INT  -> This is unsigned
  pointerticks:INT  -> This is unsigned
  color0:INT  -> This is unsigned
  color1:INT  -> This is unsigned
  color2:INT  -> This is unsigned
  color3:INT  -> This is unsigned
  viewxoffset:CHAR  -> This is signed
  viewyoffset:CHAR  -> This is signed
  viewinitx:INT
  viewinity:INT
  enablecli:INT
  printertype:INT  -> This is unsigned
  printerfilename[30]:ARRAY
  printpitch:INT  -> This is unsigned
  printquality:INT  -> This is unsigned
  printspacing:INT  -> This is unsigned
  printleftmargin:INT  -> This is unsigned
  printrightmargin:INT  -> This is unsigned
  printimage:INT  -> This is unsigned
  printaspect:INT  -> This is unsigned
  printshade:INT  -> This is unsigned
  printthreshold:INT
  papersize:INT  -> This is unsigned
  paperlength:INT  -> This is unsigned
  papertype:INT  -> This is unsigned
  serrwbits:CHAR
  serstopbuf:CHAR
  serparshk:CHAR
  lacewb:CHAR
  pad[12]:ARRAY
  prtdevname[16]:ARRAY
  defaultprtunit:CHAR
  defaultserunit:CHAR
  rowsizechange:CHAR  -> This is signed
  columnsizechange:CHAR  -> This is signed
  printflags:INT  -> This is unsigned
  printmaxwidth:INT  -> This is unsigned
  printmaxheight:INT  -> This is unsigned
  printdensity:CHAR
  printxoffset:CHAR
  wb_width:INT  -> This is unsigned
  wb_height:INT  -> This is unsigned
  wb_depth:CHAR
  ext_size:CHAR
ENDOBJECT     /* SIZEOF=232 */

CONST LACEWB=1,
      LW_RESERVED=1,
      SCREEN_DRAG=$4000,
      MOUSE_ACCEL=$8000,
      PARALLEL_PRINTER=0,
      SERIAL_PRINTER=1,
      BAUD_110=0,
      BAUD_300=1,
      BAUD_1200=2,
      BAUD_2400=3,
      BAUD_4800=4,
      BAUD_9600=5,
      BAUD_19200=6,
      BAUD_MIDI=7,
      FANFOLD=0,
      SINGLE=$80,
      PICA=0,
      ELITE=$400,
      FINE=$800,
      DRAFT=0,
      LETTER=$100,
      SIX_LPI=0,
      EIGHT_LPI=$200,
      IMAGE_POSITIVE=0,
      IMAGE_NEGATIVE=1,
      ASPECT_HORIZ=0,
      ASPECT_VERT=1,
      SHADE_BW=0,
      SHADE_GREYSCALE=1,
      SHADE_COLOR=2,
      US_LETTER=0,
      US_LEGAL=16,
      N_TRACTOR=$20,
      W_TRACTOR=$30,
      CUSTOM=$40,
      EURO_A0=$50,
      EURO_A1=$60,
      EURO_A2=$70,
      EURO_A3=$80,
      EURO_A4=$90,
      EURO_A5=$A0,
      EURO_A6=$B0,
      EURO_A7=$C0,
      EURO_A8=$D0,
      CUSTOM_NAME=0,
      ALPHA_P_101=1,
      BROTHER_15XL=2,
      CBM_MPS1000=3,
      DIAB_630=4,
      DIAB_ADV_D25=5,
      DIAB_C_150=6,
      EPSON=7,
      EPSON_JX_80=8,
      OKIMATE_20=9,
      QUME_LP_20=10,
      HP_LASERJET=11,
      HP_LASERJET_PLUS=12,
      SBUF_512=0,
      SBUF_1024=1,
      SBUF_2048=2,
      SBUF_4096=3,
      SBUF_8000=4,
      SBUF_16000=5,
      SREAD_BITS=$F0,
      SWRITE_BITS=15,
      SSTOP_BITS=$F0,
      SBUFSIZE_BITS=15,
      SPARITY_BITS=$F0,
      SHSHAKE_BITS=15,
      SPARITY_NONE=0,
      SPARITY_EVEN=1,
      SPARITY_ODD=2,
      SPARITY_MARK=3,
      SPARITY_SPACE=4,
      SHSHAKE_XON=0,
      SHSHAKE_RTS=1,
      SHSHAKE_NONE=2,
      CORRECT_RED=1,
      CORRECT_GREEN=2,
      CORRECT_BLUE=4,
      CENTER_IMAGE=8,
      IGNORE_DIMENSIONS=0,
      BOUNDED_DIMENSIONS=16,
      ABSOLUTE_DIMENSIONS=$20,
      PIXEL_DIMENSIONS=$40,
      MULTIPLY_DIMENSIONS=$80,
      INTEGER_SCALING=$100,
      ORDERED_DITHERING=0,
      HALFTONE_DITHERING=$200,
      FLOYD_DITHERING=$400,
      ANTI_ALIAS=$800,
      GREY_SCALE2=$1000,
      CORRECT_RGB_MASK=7,
      DIMENSIONS_MASK=$F0,
      DITHERING_MASK=$600

