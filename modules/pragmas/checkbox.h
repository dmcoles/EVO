#ifndef PRAGMAS_CHECKBOX_PRAGMAS_H
#define PRAGMAS_CHECKBOX_PRAGMAS_H

/*
**	$Id: checkbox_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_CHECKBOX_PROTOS_H
#include <clib/checkbox_protos.h>
#endif /* CLIB_CHECKBOX_PROTOS_H */

/* "checkbox.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall CheckBoxBase CheckBox_GetClass 1e 00

#endif /* PRAGMAS_CHECKBOX_PRAGMAS_H */
