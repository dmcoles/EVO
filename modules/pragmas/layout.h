#ifndef PRAGMAS_LAYOUT_PRAGMAS_H
#define PRAGMAS_LAYOUT_PRAGMAS_H

/*
**	$Id: layout_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_LAYOUT_PROTOS_H
#include <clib/layout_protos.h>
#endif /* CLIB_LAYOUT_PROTOS_H */

/* "layout.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall LayoutBase Layout_GetClass 1e 00
#pragma libcall LayoutBase ActivateLayoutGadget 24 0A9804
#pragma libcall LayoutBase FlushLayoutDomainCache 2a 801
#pragma libcall LayoutBase RethinkLayout 30 0A9804
#pragma libcall LayoutBase LayoutLimits 36 BA9804
#pragma libcall LayoutBase PAGE_GetClass 3c 00
#pragma libcall LayoutBase SetPageGadgetAttrsA 42 CBA9805
#if defined(__SASC_60)
#pragma tagcall LayoutBase SetPageGadgetAttrs 42 CBA9805
#endif /* __SASC_60 */
#pragma libcall LayoutBase RefreshPageGadget 48 BA9804

#endif /* PRAGMAS_LAYOUT_PRAGMAS_H */
