#ifndef PRAGMAS_POPCYCLE_PRAGMAS_H
#define PRAGMAS_POPCYCLE_PRAGMAS_H

/*
**	$Id: popcycle_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_POPCYCLE_PROTOS_H
#include <clib/popcycle_protos.h>
#endif /* CLIB_POPCYCLE_PROTOS_H */

/* "popcycle.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall PopCycleBase PopCycle_GetClass 1e 00
#pragma libcall PopCycleBase AllocPopCycleNodeA 24 801
#if defined(__SASC_60)
#pragma tagcall PopCycleBase AllocPopCycleNode 24 801
#endif /* __SASC_60 */
#pragma libcall PopCycleBase FreePopCycleNode 2a 801
#pragma libcall PopCycleBase SetPopCycleNodeAttrsA 30 9802
#if defined(__SASC_60)
#pragma tagcall PopCycleBase SetPopCycleNodeAttrs 30 9802
#endif /* __SASC_60 */
#pragma libcall PopCycleBase GetPopCycleNodeAttrsA 36 9802
#if defined(__SASC_60)
#pragma tagcall PopCycleBase GetPopCycleNodeAttrs 36 9802
#endif /* __SASC_60 */

#endif /* PRAGMAS_POPCYCLE_PRAGMAS_H */
