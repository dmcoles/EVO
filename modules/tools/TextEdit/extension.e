  OPT MODULE
  OPT EXPORT

OBJECT texteditinterface
  installchangelistener:LONG
  installleftbarhook:LONG
  executerexxcommand:LONG
  insertmenu:LONG
  installtopgadget:LONG
  installbottomgadget:LONG
  installsidegadget:LONG
  setwindowformatstrings:LONG
  activategadget:LONG
ENDOBJECT

OBJECT extension
  extensiondata:LONG
  tei:PTR TO texteditinterface
  sigmask:LONG
  setwindowpointer:LONG
  onnewdocument:LONG
  oncurrentdocumentchanged:LONG
  ondisposedocument:LONG
  handlegadgetup:LONG
  handlerawkey:LONG
  handlesignal:LONG
  abouttoquit:LONG
  terminate:LONG
ENDOBJECT

CONST EXTENSIONPLUGIN_VERSION=1,
      EXTENSIONPLUGINHEAD_ID=$45585453
