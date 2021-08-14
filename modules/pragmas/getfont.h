#ifndef PRAGMAS_GETFONT_PRAGMAS_H
#define PRAGMAS_GETFONT_PRAGMAS_H

/*
**	$Id: getfont_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_GETFONT_PROTOS_H
#include <clib/getfont_protos.h>
#endif /* CLIB_GETFONT_PROTOS_H */

/* "getfont.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall GetFontBase GetFont_GetClass 1e 00

#endif /* PRAGMAS_GETFONT_PRAGMAS_H */
