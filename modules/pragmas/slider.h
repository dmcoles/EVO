#ifndef PRAGMAS_SLIDER_PRAGMAS_H
#define PRAGMAS_SLIDER_PRAGMAS_H

/*
**	$Id: slider_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_SLIDER_PROTOS_H
#include <clib/slider_protos.h>
#endif /* CLIB_SLIDER_PROTOS_H */

/* "slider.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall SliderBase Slider_GetClass 1e 00

#endif /* PRAGMAS_SLIDER_PRAGMAS_H */
