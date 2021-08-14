#ifndef PRAGMAS_TEXTEDITOR_PRAGMAS_H
#define PRAGMAS_TEXTEDITOR_PRAGMAS_H

/*
**	$Id: texteditor_pragmas.h 40.2 2001-07-08 12:50:28 olsen Exp $
**
**	Lattice 'C', Aztec 'C', SAS/C and DICE format pragma files.
*/

#ifndef CLIB_TEXTEDITOR_PROTOS_H
#include <clib/texteditor_protos.h>
#endif /* CLIB_TEXTEDITOR_PROTOS_H */

/* "texteditor.class" */
/* NOTE: The library base name is "TextFieldBase" and not "TextEditorBase". */
/*--- functions in V40 or higher (Release 3.1) ---*/
#pragma libcall TextFieldBase TextEditor_GetClass 1e 00
/*--- functions in V47 or higher (Release 3.2) ---*/
#pragma libcall TextFieldBase HighlightSetFormat 24 210804

#endif /* PRAGMAS_TEXTEDITOR_PRAGMAS_H */
