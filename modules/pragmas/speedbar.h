#ifndef PRAGMAS_SPEEDBAR_PRAGMAS_H
#define PRAGMAS_SPEEDBAR_PRAGMAS_H

/*
**	$Id: speedbar_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_SPEEDBAR_PROTOS_H
#include <clib/speedbar_protos.h>
#endif /* CLIB_SPEEDBAR_PROTOS_H */

/* "speedbar.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall SpeedBarBase SpeedBar_GetClass 1e 00
#pragma libcall SpeedBarBase AllocSpeedButtonNodeA 24 8002
#if defined(__SASC_60)
#pragma tagcall SpeedBarBase AllocSpeedButtonNode 24 8002
#endif /* __SASC_60 */
#pragma libcall SpeedBarBase FreeSpeedButtonNode 2a 801
#pragma libcall SpeedBarBase SetSpeedButtonNodeAttrsA 30 9802
#if defined(__SASC_60)
#pragma tagcall SpeedBarBase SetSpeedButtonNodeAttrs 30 9802
#endif /* __SASC_60 */
#pragma libcall SpeedBarBase GetSpeedButtonNodeAttrsA 36 9802
#if defined(__SASC_60)
#pragma tagcall SpeedBarBase GetSpeedButtonNodeAttrs 36 9802
#endif /* __SASC_60 */

#endif /* PRAGMAS_SPEEDBAR_PRAGMAS_H */
