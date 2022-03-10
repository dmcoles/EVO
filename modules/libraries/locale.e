OPT MODULE
OPT EXPORT

MODULE 'exec/libraries',
       'exec/nodes'

CONST DAY_1=1,
      DAY_2=2,
      DAY_3=3,
      DAY_4=4,
      DAY_5=5,
      DAY_6=6,
      DAY_7=7,
      ABDAY_1=8,
      ABDAY_2=9,
      ABDAY_3=10,
      ABDAY_4=11,
      ABDAY_5=12,
      ABDAY_6=13,
      ABDAY_7=14,
      MON_1=15,
      MON_2=16,
      MON_3=17,
      MON_4=18,
      MON_5=19,
      MON_6=20,
      MON_7=21,
      MON_8=22,
      MON_9=23,
      MON_10=24,
      MON_11=25,
      MON_12=26,
      ABMON_1=27,
      ABMON_2=28,
      ABMON_3=29,
      ABMON_4=30,
      ABMON_5=31,
      ABMON_6=$20,
      ABMON_7=$21,
      ABMON_8=$22,
      ABMON_9=$23,
      ABMON_10=$24,
      ABMON_11=$25,
      ABMON_12=$26,
      YESSTR=$27,
      NOSTR=$28,
      AM_STR=$29,
      PM_STR=$2A,
      SOFTHYPHEN=$2B,
      HARDHYPHEN=$2C,
      OPENQUOTE=$2D,
      CLOSEQUOTE=$2E,
      YESTERDAYSTR=$2F,
      TODAYSTR=$30,
      TOMORROWSTR=$31,
      FUTURESTR=$32,
      ALTDAY_1=52,
      ALTDAY_2=53,
      ALTDAY_3=54,
      ALTDAY_4=55,
      ALTDAY_5=56,
      ALTDAY_6=57,
      ALTDAY_7=58,
      ALTMON_1=59,
      ALTMON_2=60,
      ALTMON_3=61,
      ALTMON_4=62,
      ALTMON_5=63,
      ALTMON_6=64,
      ALTMON_7=65,
      ALTMON_8=66,
      ALTMON_9=67,
      ALTMON_10=68,
      ALTMON_11=69,
      ALTMON_12=70,
      MAXSTRMSG=71

OBJECT localebase
  lib:lib
  syspatches:INT
ENDOBJECT     /* SIZEOF=NONE !!! */

OBJECT locale
  localename:PTR TO CHAR
  languagename:PTR TO CHAR
  preflanguages[10]:ARRAY OF LONG
  flags:LONG
  codeset:LONG
  countrycode:LONG
  telephonecode:LONG
  gmtoffset:LONG
  measuringsystem:CHAR
  calendartype:CHAR
  reserved0[2]:ARRAY
  datetimeformat:PTR TO CHAR
  dateformat:PTR TO CHAR
  timeformat:PTR TO CHAR
  shortdatetimeformat:PTR TO CHAR
  shortdateformat:PTR TO CHAR
  shorttimeformat:PTR TO CHAR
  decimalpoint:PTR TO CHAR
  groupseparator:PTR TO CHAR
  fracgroupseparator:PTR TO CHAR
  grouping:PTR TO CHAR
  fracgrouping:PTR TO CHAR
  mondecimalpoint:PTR TO CHAR
  mongroupseparator:PTR TO CHAR
  monfracgroupseparator:PTR TO CHAR
  mongrouping:PTR TO CHAR
  monfracgrouping:PTR TO CHAR
  monfracdigits:CHAR
  monintfracdigits:CHAR
  reserved1[2]:ARRAY
  moncs:PTR TO CHAR
  monsmallcs:PTR TO CHAR
  monintcs:PTR TO CHAR
  monpositivesign:PTR TO CHAR
  monpositivespacesep:CHAR
  monpositivesignpos:CHAR
  monpositivecspos:CHAR
  reserved2:CHAR
  monnegativesign:PTR TO CHAR
  monnegativespacesep:CHAR
  monnegativesignpos:CHAR
  monnegativecspos:CHAR
  reserved3:CHAR
ENDOBJECT     /* SIZEOF=168 */

CONST MS_ISO=0,
      MS_AMERICAN=1,
      MS_IMPERIAL=2,
      MS_BRITISH=3,
      CT_7SUN=0,
      CT_7MON=1,
      CT_7TUE=2,
      CT_7WED=3,
      CT_7THU=4,
      CT_7FRI=5,
      CT_7SAT=6,
      SS_NOSPACE=0,
      SS_SPACE=1,
      SP_PARENS=0,
      SP_PREC_ALL=1,
      SP_SUCC_ALL=2,
      SP_PREC_CURR=3,
      SP_SUCC_CURR=4,
      CSP_PRECEDES=0,
      CSP_SUCCEEDS=1,
      OC_TAGBASE=$80090000,
      OC_BUILTINLANGUAGE=$80090001,
      OC_BUILTINCODESET=$80090002,
      OC_VERSION=$80090003,
      OC_LANGUAGE=$80090004,
      SC_ASCII=0,
      SC_COLLATE1=1,
      SC_COLLATE2=2

OBJECT catalog
  ln:ln
  pad:INT
  language:PTR TO CHAR
  codeset:LONG
  version:INT  -> This is unsigned
  revision:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=28 */

