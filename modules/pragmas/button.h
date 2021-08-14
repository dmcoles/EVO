#ifndef PRAGMAS_BUTTON_PRAGMAS_H
#define PRAGMAS_BUTTON_PRAGMAS_H

/*
**	$Id: button_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_BUTTON_PROTOS_H
#include <clib/button_protos.h>
#endif /* CLIB_BUTTON_PROTOS_H */

/* "button.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall ButtonBase Button_GetClass 1e 00

#endif /* PRAGMAS_BUTTON_PRAGMAS_H */
