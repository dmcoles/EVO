#ifndef PRAGMAS_WINDOW_PRAGMAS_H
#define PRAGMAS_WINDOW_PRAGMAS_H

/*
**	$Id: window_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_WINDOW_PROTOS_H
#include <clib/window_protos.h>
#endif /* CLIB_WINDOW_PROTOS_H */

/* "window.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall WindowBase Window_GetClass 1e 00

#endif /* PRAGMAS_WINDOW_PRAGMAS_H */
