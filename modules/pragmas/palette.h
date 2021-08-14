#ifndef PRAGMAS_PALETTE_PRAGMAS_H
#define PRAGMAS_PALETTE_PRAGMAS_H

/*
**	$Id: palette_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_PALETTE_PROTOS_H
#include <clib/palette_protos.h>
#endif /* CLIB_PALETTE_PROTOS_H */

/* "palette.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall PaletteBase Palette_GetClass 1e 00

#endif /* PRAGMAS_PALETTE_PRAGMAS_H */
