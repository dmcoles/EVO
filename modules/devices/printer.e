OPT MODULE
OPT EXPORT

MODULE 'exec/io',
       'graphics/rastport',
       'graphics/view'

CONST DEVICES_PRINTER_I=1,
      PRD_RAWWRITE=9,
      PRD_PRTCOMMAND=10,
      PRD_DUMPRPORT=11,
      PRD_QUERY=12,
      ARIS=0,
      ARIN=1,
      AIND=2,
      ANEL=3,
      ARI=4,
      ASGR0=5,
      ASGR3=6,
      ASGR23=7,
      ASGR4=8,
      ASGR24=9,
      ASGR1=10,
      ASGR22=11,
      ASFC=12,
      ASBC=13,
      ASHORP0=14,
      ASHORP2=15,
      ASHORP1=16,
      ASHORP4=17,
      ASHORP3=18,
      ASHORP6=19,
      ASHORP5=20,
      ADEN6=21,
      ADEN5=22,
      ADEN4=23,
      ADEN3=24,
      ADEN2=25,
      ADEN1=26,
      ASUS2=27,
      ASUS1=28,
      ASUS4=29,
      ASUS3=30,
      ASUS0=31,
      APLU=$20,
      APLD=$21,
      AFNT0=$22,
      AFNT1=$23,
      AFNT2=$24,
      AFNT3=$25,
      AFNT4=$26,
      AFNT5=$27,
      AFNT6=$28,
      AFNT7=$29,
      AFNT8=$2A,
      AFNT9=$2B,
      AFNT10=$2C,
      APROP2=$2D,
      APROP1=$2E,
      APROP0=$2F,
      ATSS=$30,
      AJFY5=$31,
      AJFY7=$32,
      AJFY6=$33,
      AJFY0=$34,
      AJFY2=$35,
      AJFY3=$36,
      AVERP0=$37,
      AVERP1=$38,
      ASLPP=$39,
      APERF=$3A,
      APERF0=$3B,
      ALMS=$3C,
      ARMS=$3D,
      ATMS=$3E,
      ABMS=$3F,
      ASTBM=$40,
      ASLRM=$41,
      ACAM=$42,
      AHTS=$43,
      AVTS=$44,
      ATBC0=$45,
      ATBC3=$46,
      ATBC1=$47,
      ATBC4=$48,
      ATBCALL=$49,
      ATBSALL=$4A,
      AEXTEND=$4B,
      ARAW=$4C

OBJECT ioprtcmdreq
  io:io
  prtcommand:INT  -> This is unsigned
  parm0:CHAR
  parm1:CHAR
  parm2:CHAR
  parm3:CHAR
ENDOBJECT     /* SIZEOF=38 */

OBJECT iodrpreq
  io:io
  rastport:PTR TO rastport
  colormap:PTR TO colormap
  modes:LONG
  srcx:INT  -> This is unsigned
  srcy:INT  -> This is unsigned
  srcwidth:INT  -> This is unsigned
  srcheight:INT  -> This is unsigned
  destcols:LONG
  destrows:LONG
  special:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=62 */

CONST SPECIAL_MILCOLS=1,
      SPECIAL_MILROWS=2,
      SPECIAL_FULLCOLS=4,
      SPECIAL_FULLROWS=8,
      SPECIAL_FRACCOLS=16,
      SPECIAL_FRACROWS=$20,
      SPECIAL_CENTER=$40,
      SPECIAL_ASPECT=$80,
      SPECIAL_DENSITY1=$100,
      SPECIAL_DENSITY2=$200,
      SPECIAL_DENSITY3=$300,
      SPECIAL_DENSITY4=$400,
      SPECIAL_DENSITY5=$500,
      SPECIAL_DENSITY6=$600,
      SPECIAL_DENSITY7=$700,
      SPECIAL_NOFORMFEED=$800,
      SPECIAL_TRUSTME=$1000,
      SPECIAL_NOPRINT=$2000,
      PDERR_NOERR=0,
      PDERR_CANCEL=1,
      PDERR_NOTGRAPHICS=2,
      PDERR_INVERTHAM=3,
      PDERR_BADDIMENSION=4,
      PDERR_DIMENSIONOVFLOW=5,
      PDERR_INTERNALMEMORY=6,
      PDERR_BUFFERMEMORY=7,
      PDERR_TOOKCONTROL=8,
      SPECIAL_DENSITYMASK=$700,
      SPECIAL_DIMENSIONSMASK=$bf

