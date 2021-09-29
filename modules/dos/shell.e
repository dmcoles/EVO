  OPT MODULE
  OPT EXPORT

  MODULE 'utility/hooks','exec/nodes'

OBJECT extendedcommandlineinterface
  result2:LONG
  setnam:LONG
  commanddir:LONG
  returncode:LONG
  commandname:LONG
  faillevel:LONG
  prompt:LONG
  standardinput:LONG
  currentinput:LONG
  commandfile:LONG
  interactive:LONG
  background:LONG
  currentoutput:LONG
  defaultstack:LONG
  standardoutput:LONG
  module:LONG
  hook: hook
  version:LONG
ENDOBJECT

OBJECT historynode
  node:mln
  line:CHAR
ENDOBJECT

CONST SHELL_DUMMY=$80000BB8,
      SHELL_FGETS_FULL=$80000BB9,
      SHELL_ADDH_LINE=$80000BBA,
      SHELL_METH_METHODS=$4C495354,
      SHELL_METH_GETHIST=$47455448,
      SHELL_METH_CLRHIST=$434C5248,
      SHELL_METH_ADDHIST=$41444448,
      SHELL_METH_FGETS=$47455453

