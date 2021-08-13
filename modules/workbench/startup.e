OPT MODULE
OPT EXPORT

MODULE 'exec/ports'

CONST WORKBENCH_STARTUP_I=1

OBJECT wbstartup
  message:mn
  process:PTR TO mp
  segment:LONG
  numargs:LONG
  toolwindow:PTR TO CHAR
  arglist:PTR TO wbarg
ENDOBJECT     /* SIZEOF=40 */

OBJECT wbarg
  lock:LONG
  name:PTR TO CHAR
ENDOBJECT     /* SIZEOF=8 */

