#ifndef PRAGMAS_LABEL_PRAGMAS_H
#define PRAGMAS_LABEL_PRAGMAS_H

/*
**	$Id: label_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_LABEL_PROTOS_H
#include <clib/label_protos.h>
#endif /* CLIB_LABEL_PROTOS_H */

/* "label.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall LabelBase Label_GetClass 1e 00

#endif /* PRAGMAS_LABEL_PRAGMAS_H */
