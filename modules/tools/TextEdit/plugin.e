  OPT MODULE
  OPT EXPORT

OBJECT plugin
  next:PTR TO plugin
  version:INT
  masterversion:INT
  pluginversion:INT
  pluginrevision:INT
  identifier:INT
  flags:INT 
  init:LONG
ENDOBJECT

OBJECT pluginhead
  security:LONG
  id:LONG
  seglist:LONG
  next:PTR TO pluginhead
  version:INT
  reserved:INT
  versstring:PTR TO CHAR
  firstplugin:PTR TO plugin
ENDOBJECT

CONST PLUGINHEAD_SECURITY=$70FF4E75,
      PLUGINHEAD_VERSION=1,
      MASTER_VERSION=2
