#ifndef PRAGMAS_SPACE_PRAGMAS_H
#define PRAGMAS_SPACE_PRAGMAS_H

/*
**	$Id: space_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_SPACE_PROTOS_H
#include <clib/space_protos.h>
#endif /* CLIB_SPACE_PROTOS_H */

/* "space.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall SpaceBase Space_GetClass 1e 00

#endif /* PRAGMAS_SPACE_PRAGMAS_H */
