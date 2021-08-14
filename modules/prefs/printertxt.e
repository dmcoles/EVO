OPT MODULE
OPT EXPORT

CONST ID_PTXT=$50545854,
      ID_PUNT=$50554E54,
      ID_PDEV=$50444556,
      DRIVERNAMESIZE=30,
      DEVICENAMESIZE=$20,
      UNITNAMESIZE=32

OBJECT printertxtprefs
  reserved[4]:ARRAY OF LONG
  driver[30]:ARRAY
  port:CHAR
  papertype:INT  -> This is unsigned
  papersize:INT  -> This is unsigned
  paperlength:INT  -> This is unsigned
  pitch:INT  -> This is unsigned
  spacing:INT  -> This is unsigned
  leftmargin:INT  -> This is unsigned
  rightmargin:INT  -> This is unsigned
  quality:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=63 */

OBJECT printerdeviceunitprefs
  reserved[4]:ARRAY OF LONG
  unitnum:LONG
  unitname[32]:ARRAY OF CHAR
ENDOBJECT     /* SIZEOF=52 */

CONST PP_PARALLEL=0,
      PP_SERIAL=1,
      PT_FANFOLD=0,
      PT_SINGLE=1,
      PS_US_LETTER=0,
      PS_US_LEGAL=1,
      PS_N_TRACTOR=2,
      PS_W_TRACTOR=3,
      PS_CUSTOM=4,
      PS_EURO_A0=5,
      PS_EURO_A1=6,
      PS_EURO_A2=7,
      PS_EURO_A3=8,
      PS_EURO_A4=9,
      PS_EURO_A5=10,
      PS_EURO_A6=11,
      PS_EURO_A7=12,
      PS_EURO_A8=13,
      PP_PICA=0,
      PP_ELITE=1,
      PP_FINE=2,
      PS_SIX_LPI=0,
      PS_EIGHT_LPI=1,
      PQ_DRAFT=0,
      PQ_LETTER=1

OBJECT printerunitprefs
-> Um, this was wrong
  reserved[4]:ARRAY OF LONG
  unitnum:LONG
  opendeviceflags:LONG
  devicename[$20]:ARRAY
ENDOBJECT     /* SIZEOF=44 */

