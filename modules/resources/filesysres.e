OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/lists',
       'exec/nodes',
       'exec/tasks'

OBJECT filesysresource
  ln:ln
  creator:PTR TO CHAR
  filesysentries:lh
ENDOBJECT     /* SIZEOF=32 */

OBJECT filesysentry
  ln:ln
  dostype:LONG
  version:LONG
  patchflags:LONG
  type:LONG
  task:PTR TO tc
  lock:LONG
  handler:PTR TO CHAR
  stacksize:LONG
  priority:LONG
  startup:LONG
  seglist:LONG
  globalvec:LONG
ENDOBJECT     /* SIZEOF=NONE !!! */

#define FSRNAME 'FileSystem.resource'
