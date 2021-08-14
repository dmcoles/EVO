#ifndef PRAGMAS_PENMAP_PRAGMAS_H
#define PRAGMAS_PENMAP_PRAGMAS_H

/*
**	$Id: penmap_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_PENMAP_PROTOS_H
#include <clib/penmap_protos.h>
#endif /* CLIB_PENMAP_PROTOS_H */

/* "penmap.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall PenMapBase PenMap_GetClass 1e 00

#endif /* PRAGMAS_PENMAP_PRAGMAS_H */
