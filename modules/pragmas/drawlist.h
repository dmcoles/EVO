#ifndef PRAGMAS_DRAWLIST_PRAGMAS_H
#define PRAGMAS_DRAWLIST_PRAGMAS_H

/*
**	$Id: drawlist_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_DRAWLIST_PROTOS_H
#include <clib/drawlist_protos.h>
#endif /* CLIB_DRAWLIST_PROTOS_H */

/* "drawlist.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall DrawListBase DrawList_GetClass 1e 00

#endif /* PRAGMAS_DRAWLIST_PRAGMAS_H */
