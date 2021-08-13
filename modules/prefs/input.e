OPT MODULE
OPT EXPORT

MODULE 'devices/timer'

CONST ID_INPT=$494E5054

OBJECT inputprefs
  keymap[16]:ARRAY
  pointerticks:INT  -> This is unsigned
  doubleclick:timeval
  keyrptdelay:timeval
  keyrptspeed:timeval
  mouseaccel:INT
ENDOBJECT     /* SIZEOF=44 */

