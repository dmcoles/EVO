#ifndef PRAGMAS_INTEGER_PRAGMAS_H
#define PRAGMAS_INTEGER_PRAGMAS_H

/*
**	$Id: integer_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_INTEGER_PROTOS_H
#include <clib/integer_protos.h>
#endif /* CLIB_INTEGER_PROTOS_H */

/* "integer.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall IntegerBase Integer_GetClass 1e 00

#endif /* PRAGMAS_INTEGER_PRAGMAS_H */
