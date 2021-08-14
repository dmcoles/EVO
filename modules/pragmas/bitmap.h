#ifndef PRAGMAS_BITMAP_PRAGMAS_H
#define PRAGMAS_BITMAP_PRAGMAS_H

/*
**	$Id: bitmap_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_BITMAP_PROTOS_H
#include <clib/bitmap_protos.h>
#endif /* CLIB_BITMAP_PROTOS_H */

/* "bitmap.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall BitMapBase BitMap_GetClass 1e 00

#endif /* PRAGMAS_BITMAP_PRAGMAS_H */
