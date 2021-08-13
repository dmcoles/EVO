OPT MODULE
OPT EXPORT

CONST ID_LCLE=$4C434C45,
      ID_CTRY=$43545259

OBJECT countryprefs
  reserved[4]:ARRAY OF LONG
  countrycode:LONG
  telephonecode:LONG
  measuringsystem:CHAR
-> Um, have to fiddle alignment in .m file
  datetimeformat[80]:ARRAY
  dateformat[40]:ARRAY
  timeformat[40]:ARRAY
  shortdatetimeformat[80]:ARRAY
  shortdateformat[40]:ARRAY
  shorttimeformat[40]:ARRAY
  decimalpoint[10]:ARRAY
  groupseparator[10]:ARRAY
  fracgroupseparator[10]:ARRAY
  grouping[10]:ARRAY
  fracgrouping[10]:ARRAY
  mondecimalpoint[10]:ARRAY
  mongroupseparator[10]:ARRAY
  monfracgroupseparator[10]:ARRAY
  mongrouping[10]:ARRAY
  monfracgrouping[10]:ARRAY
  monfracdigits:CHAR
  monintfracdigits:CHAR
  moncs[10]:ARRAY
  monsmallcs[10]:ARRAY
  monintcs[10]:ARRAY
  monpositivesign[10]:ARRAY
  monpositivespacesep:CHAR
  monpositivesignpos:CHAR
  monpositivecspos:CHAR
-> Um, have to fiddle alignment in .m file
  monnegativesign[10]:ARRAY
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
