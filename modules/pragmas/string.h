#ifndef PRAGMAS_STRING_PRAGMAS_H
#define PRAGMAS_STRING_PRAGMAS_H

/*
**	$Id: string_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_STRING_PROTOS_H
#include <clib/string_protos.h>
#endif /* CLIB_STRING_PROTOS_H */

/* "string.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall StringBase String_GetClass 1e 00

#endif /* PRAGMAS_STRING_PRAGMAS_H */
