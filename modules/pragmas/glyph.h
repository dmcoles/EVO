#ifndef PRAGMAS_GLYPH_PRAGMAS_H
#define PRAGMAS_GLYPH_PRAGMAS_H

/*
**	$Id: glyph_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_GLYPH_PROTOS_H
#include <clib/glyph_protos.h>
#endif /* CLIB_GLYPH_PROTOS_H */

/* "glyph.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall GlyphBase Glyph_GetClass 1e 00

#endif /* PRAGMAS_GLYPH_PRAGMAS_H */
