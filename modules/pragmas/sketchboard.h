#ifndef PRAGMAS_SKETCHBOARD_PRAGMAS_H
#define PRAGMAS_SKETCHBOARD_PRAGMAS_H

/*
**	$Id: sketchboard_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_SKETCHBOARD_PROTOS_H
#include <clib/sketchboard_protos.h>
#endif /* CLIB_SKETCHBOARD_PROTOS_H */

/* "sketchboard.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall SketchBoardBase SketchBoard_GetClass 1e 00

#endif /* PRAGMAS_SKETCHBOARD_PRAGMAS_H */
