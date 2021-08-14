#ifndef PRAGMAS_LISTVIEW_PRAGMAS_H
#define PRAGMAS_LISTVIEW_PRAGMAS_H

/*
**	$Id: listview_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_LISTVIEW_PROTOS_H
#include <clib/listview_protos.h>
#endif /* CLIB_LISTVIEW_PROTOS_H */

/* "label.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall ListViewBase ListView_GetClass 1e 00

#endif /* PRAGMAS_LISTVIEW_PRAGMAS_H */
