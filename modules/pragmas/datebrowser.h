#ifndef PRAGMAS_DATEBROWSER_PRAGMAS_H
#define PRAGMAS_DATEBROWSER_PRAGMAS_H

/*
**	$Id: datebrowser_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_DATEBROWSER_PROTOS_H
#include <clib/datebrowser_protos.h>
#endif /* CLIB_DATEBROWSER_PROTOS_H */

/* "datebrowser.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall DateBrowserBase DateBrowser_GetClass 1e 00
#pragma libcall DateBrowserBase JulianWeekDay 24 21003
#pragma libcall DateBrowserBase JulianMonthDays 2a 1002
#pragma libcall DateBrowserBase JulianLeapYear 30 001

#endif /* PRAGMAS_DATEBROWSER_PRAGMAS_H */
