  OPT MODULE
  OPT EXPORT

  MODULE 'exec/nodes','intuition/intuition','utility/hooks'

OBJECT editorsettings
  version:INT
  flags:CHAR ->HasLineNumbers:1;CutCopyLineWhenNoSel:1; AutoIndent:1;
  tabkeypolicy:INT
  wrapcolumn:LONG
  wordwrapmode:CHAR
  indentationwidth:CHAR
  tabwidth:CHAR
  indentusing:CHAR
ENDOBJECT

OBJECT filetype
  node: mln
  workingcopy:PTR TO editorsettings
  menunumber:LONG
  menuitem:PTR TO menuitem
  version:INT
  name:PTR TO CHAR
  typename:PTR TO CHAR
  autofiletypes:PTR TO CHAR
  editorsettings:PTR TO editorsettings
  installchangelistener:LONG
  executerexxcommand:LONG
  plugindata:LONG
  terminate:LONG
  highlighterhook:PTR TO hook
  settingsgadget:LONG
  settingstitle:LONG
  loadsettings:LONG
  savesettings:LONG
  setsettingsfromgui:LONG
  setguifromsettings:LONG
  processgadgetup:LONG
  applysettings:LONG
  disposegadgets:LONG
  assignedtodocument:LONG
  unassignedfromdocument:LONG
ENDOBJECT

CONST FILETYPEPLUGINHEAD_ID=$46545950,
      FILETYPEPLUGIN_VERSION=2
