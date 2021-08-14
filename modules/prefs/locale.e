OPT MODULE
OPT EXPORT

CONST ID_LCLE=$4C434C45,
      ID_CTRY=$43545259

OBJECT countryprefs NOALIGN 
  reserved[4]:ARRAY OF LONG
  countrycode:LONG
  telephonecode:LONG
  measuringsystem:CHAR
  datetimeformat[80]:ARRAY OF CHAR
  dateformat[40]:ARRAY OF CHAR
  timeformat[40]:ARRAY OF CHAR
  shortdatetimeformat[80]:ARRAY OF CHAR
  shortdateformat[40]:ARRAY OF CHAR
  shorttimeformat[40]:ARRAY OF CHAR
  decimalpoint[10]:ARRAY OF CHAR
  groupseparator[10]:ARRAY OF CHAR
  fracgroupseparator[10]:ARRAY OF CHAR
  grouping[10]:ARRAY OF CHAR
  fracgrouping[10]:ARRAY OF CHAR
  mondecimalpoint[10]:ARRAY OF CHAR
  mongroupseparator[10]:ARRAY OF CHAR
  monfracgroupseparator[10]:ARRAY OF CHAR
  mongrouping[10]:ARRAY OF CHAR
  monfracgrouping[10]:ARRAY OF CHAR
  monfracdigits:CHAR
  monintfracdigits:CHAR
  moncs[10]:ARRAY OF CHAR
  monsmallcs[10]:ARRAY OF CHAR
  monintcs[10]:ARRAY OF CHAR
  monpositivesign[10]:ARRAY OF CHAR
  monpositivespacesep:CHAR
  monpositivesignpos:CHAR
  monpositivecspos:CHAR
  monnegativesign[10]:ARRAY OF CHAR
  monnegativespacesep:CHAR
  monnegativesignpos:CHAR
  monnegativecspos:CHAR
  calendartype:CHAR
ENDOBJECT     /* SIZEOF=504 */

OBJECT localeprefs
  reserved[4]:ARRAY OF LONG
  countryname[32]:ARRAY
  preferredlanguages[300]:ARRAY
  gmtoffset:LONG
  flags:LONG
  countrydata:countryprefs
ENDOBJECT     /* SIZEOF=860 */
