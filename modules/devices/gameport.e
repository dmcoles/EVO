  OPT MODULE
  OPT EXPORT

CONST GPD_READEVENT=9,
      GPD_ASKCTYPE=10,
      GPD_SETCTYPE=11,
      GPD_ASKTRIGGER=12,
      GPD_SETTRIGGER=13,
      GPTB_DOWNKEYS=0,
      GPTF_DOWNKEYS=1,
      GPTB_UPKEYS=1,
      GPTF_UPKEYS=2
      
OBJECT gameporttrigger
  keys:INT  -> This is unsigned
  timeout:INT  -> This is unsigned
  xdelta:INT  -> This is unsigned
  ydelta:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=8 */

CONST GPCT_ALLOCATED=-1,
      GPCT_NOCONTROLLER=0,
      GPCT_MOUSE=1,
      GPCT_RELJOYSTICK=2,
      GPCT_ABSJOYSTICK=3,
      GPDERR_SETCTYPE=1

