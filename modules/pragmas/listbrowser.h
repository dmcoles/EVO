#ifndef PRAGMAS_LISTBROWSER_PRAGMAS_H
#define PRAGMAS_LISTBROWSER_PRAGMAS_H

/*
**	$Id: listbrowser_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_LISTBROWSER_PROTOS_H
#include <clib/listbrowser_protos.h>
#endif /* CLIB_LISTBROWSER_PROTOS_H */

/* "listbrowser.class" */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall ListBrowserBase ListBrowser_GetClass 1e 00
#pragma libcall ListBrowserBase AllocListBrowserNodeA 24 8002
#if defined(__SASC_60)
#pragma tagcall ListBrowserBase AllocListBrowserNode 24 8002
#endif /* __SASC_60 */
#pragma libcall ListBrowserBase FreeListBrowserNode 2a 801
#pragma libcall ListBrowserBase SetListBrowserNodeAttrsA 30 9802
#if defined(__SASC_60)
#pragma tagcall ListBrowserBase SetListBrowserNodeAttrs 30 9802
#endif /* __SASC_60 */
#pragma libcall ListBrowserBase GetListBrowserNodeAttrsA 36 9802
#if defined(__SASC_60)
#pragma tagcall ListBrowserBase GetListBrowserNodeAttrs 36 9802
#endif /* __SASC_60 */
#pragma libcall ListBrowserBase ListBrowserSelectAll 3c 801
#pragma libcall ListBrowserBase ShowListBrowserNodeChildren 42 0802
#pragma libcall ListBrowserBase HideListBrowserNodeChildren 48 801
#pragma libcall ListBrowserBase ShowAllListBrowserChildren 4e 801
#pragma libcall ListBrowserBase HideAllListBrowserChildren 54 801
#pragma libcall ListBrowserBase FreeListBrowserList 5a 801
/*--- functions in V45 or higher (Release 3.9) ---*/
#pragma libcall ListBrowserBase AllocLBColumnInfoA 60 8002
#if defined(__SASC_60)
#pragma tagcall ListBrowserBase AllocLBColumnInfo 60 8002
#endif /* __SASC_60 */
#pragma libcall ListBrowserBase SetLBColumnInfoAttrsA 66 8902
#if defined(__SASC_60)
#pragma tagcall ListBrowserBase SetLBColumnInfoAttrs 66 8902
#endif /* __SASC_60 */
#pragma libcall ListBrowserBase GetLBColumnInfoAttrsA 6c 8902
#if defined(__SASC_60)
#pragma tagcall ListBrowserBase GetLBColumnInfoAttrs 6c 8902
#endif /* __SASC_60 */
#pragma libcall ListBrowserBase FreeLBColumnInfo 72 801
#pragma libcall ListBrowserBase ListBrowserClearAll 78 801

#endif /* PRAGMAS_LISTBROWSER_PRAGMAS_H */
