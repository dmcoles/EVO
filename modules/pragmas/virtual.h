#ifndef PRAGMAS_VIRTUAL_PRAGMAS_H
#define PRAGMAS_VIRTUAL_PRAGMAS_H

/*
**	$Id: virtual_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_VIRTUAL_PROTOS_H
#include <clib/virtual_protos.h>
#endif /* CLIB_VIRTUAL_PROTOS_H */

/* "virtual.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall VirtualBase Virtual_GetClass 1e 00
#pragma libcall VirtualBase RefreshVirtualGadget 24 BA9804
#pragma libcall VirtualBase RethinkVirtualSize 2a 0BA9805

#endif /* PRAGMAS_VIRTUAL_PRAGMAS_H */
