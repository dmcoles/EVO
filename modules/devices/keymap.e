OPT MODULE
OPT EXPORT

MODULE 'exec/lists',
       'exec/nodes'

OBJECT keymap
  lokeymaptypes:PTR TO CHAR
  lokeymap:PTR TO LONG
  locapsable:PTR TO CHAR
  lorepeatable:PTR TO CHAR
  hikeymaptypes:PTR TO CHAR
  hikeymap:PTR TO LONG
  hicapsable:PTR TO CHAR
  hirepeatable:PTR TO CHAR
ENDOBJECT     /* SIZEOF=32 */

OBJECT keymapnode
  node:ln
  keymap:keymap
ENDOBJECT     /* SIZEOF=46 */

OBJECT keymapresource
  node:ln
  list:lh
ENDOBJECT     /* SIZEOF=28 */

CONST KCB_NOP=7,
      KCF_NOP=$80,
      KC_NOQUAL=0,
      KC_VANILLA=7,
      KCB_SHIFT=0,
      KCF_SHIFT=1,
      KCB_ALT=1,
      KCF_ALT=2,
      KCB_CONTROL=2,
      KCF_CONTROL=4,
      KCB_DOWNUP=3,
      KCF_DOWNUP=8,
      KCB_DEAD=5,
      KCF_DEAD=$20,
      KCB_STRING=6,
      KCF_STRING=$40,
      DPB_MOD=0,
      DPF_MOD=1,
      DPB_DEAD=3,
      DPF_DEAD=8,
      DP_2DINDEXMASK=15,
      DP_2DFACSHIFT=4
