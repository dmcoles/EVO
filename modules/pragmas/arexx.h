#ifndef PRAGMAS_AREXX_PRAGMAS_H
#define PRAGMAS_AREXX_PRAGMAS_H

/*
**	$Id: arexx_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_AREXX_PROTOS_H
#include <clib/arexx_protos.h>
#endif /* CLIB_AREXX_PROTOS_H */

/* "arexx.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall ARexxBase ARexx_GetClass 1e 00

#endif /* PRAGMAS_AREXX_PRAGMAS_H */
