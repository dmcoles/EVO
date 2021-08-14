#ifndef PRAGMAS_REQUESTER_PRAGMAS_H
#define PRAGMAS_REQUESTER_PRAGMAS_H

/*
**	$Id: requester_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_REQUESTER_PROTOS_H
#include <clib/requester_protos.h>
#endif /* CLIB_REQUESTER_PROTOS_H */

/* "requester.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall RequesterBase Requester_GetClass 1e 00

#endif /* PRAGMAS_REQUESTER_PRAGMAS_H */
