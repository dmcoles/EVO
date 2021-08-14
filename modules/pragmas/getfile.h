#ifndef PRAGMAS_GETFILE_PRAGMAS_H
#define PRAGMAS_GETFILE_PRAGMAS_H

/*
**	$Id: getfile_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_GETFILE_PROTOS_H
#include <clib/getfile_protos.h>
#endif /* CLIB_GETFILE_PROTOS_H */

/* "getfile.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall GetFileBase GetFile_GetClass 1e 00

#endif /* PRAGMAS_GETFILE_PRAGMAS_H */
