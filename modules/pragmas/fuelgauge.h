#ifndef PRAGMAS_FUELGAUGE_PRAGMAS_H
#define PRAGMAS_FUELGAUGE_PRAGMAS_H

/*
**	$Id: fuelgauge_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_FUELGAUGE_PROTOS_H
#include <clib/fuelgauge_protos.h>
#endif /* CLIB_FUELGAUGE_PROTOS_H */

/* "fuelgauge.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall FuelGaugeBase FuelGauge_GetClass 1e 00

#endif /* PRAGMAS_FUELGAUGE_PRAGMAS_H */
