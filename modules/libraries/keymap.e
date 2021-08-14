  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'exec/nodes','exec/lists'

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

CONST DP_2DINDEXMASK=15,
      KCF_CONTROL=4,
      KCB_CONTROL=2,
      KC_VANILLA=7,
      KCF_ALT=2,
      KCB_ALT=1,
      KCF_STRING=$40,
      KCB_STRING=6,
      DP_2DFACSHIFT=4,
      KCF_SHIFT=1,
      KCB_SHIFT=0,
      DPF_DEAD=8,
      DPB_DEAD=3,
      KCF_DEAD=$20,
      KCB_DEAD=5,
      DPF_MOD=1,
      DPB_MOD=0,
      KC_NOQUAL=0,
      KCF_DOWNUP=8,
      KCB_DOWNUP=3,
      KCF_NOP=$80,
      KCB_NOP=7,
      RAWKEY_SPACE=$40,
      RAWKEY_BACKSPACE=$41,
      RAWKEY_TAB=$42,
      RAWKEY_ENTER=$43,
      RAWKEY_RETURN=$44,
      RAWKEY_ESC=$45,
      RAWKEY_DEL=$46,
      RAWKEY_INSERT=$47,
      RAWKEY_PAGEUP=$48,
      RAWKEY_PAGEDOWN=$49,
      RAWKEY_F11=$4B,
      RAWKEY_CRSRUP=$4C,
      RAWKEY_CRSRDOWN=$4D,
      RAWKEY_CRSRRIGHT=$4E,
      RAWKEY_CRSRLEFT=$4F,
      RAWKEY_F1=$50,
      RAWKEY_F2=$51,
      RAWKEY_F3=$52,
      RAWKEY_F4=$53,
      RAWKEY_F5=$54,
      RAWKEY_F6=$55,
      RAWKEY_F7=$56,
      RAWKEY_F8=$57,
      RAWKEY_F9=$58,
      RAWKEY_F10=$59,
      RAWKEY_HELP=$5F,
      RAWKEY_LSHIFT=$60,
      RAWKEY_RSHIFT=$61,
      RAWKEY_CAPSLOCK=$62,
      RAWKEY_LCTRL=$63,
      RAWKEY_LALT=$64,
      RAWKEY_RALT=$65,
      RAWKEY_LCOMMAND=$66,
      RAWKEY_RCOMMAND=$67,
      RAWKEY_MENU=$6B,
      RAWKEY_PRINTSCR=$6D,
      RAWKEY_BREAK=$6E,
      RAWKEY_F12=$6F,
      RAWKEY_HOME=$70,
      RAWKEY_END=$71,
      RAWKEY_MEDIA_STOP=$72,
      RAWKEY_MEDIA_PLAY_PAUSE=$73,
      RAWKEY_MEDIA_PREV_TRACK=$74,
      RAWKEY_MEDIA_NEXT_TRACK=$75,
      RAWKEY_MEDIA_SHUFFLE=$76,
      RAWKEY_MEDIA_REPEAT=$77,
      RAWKEY_WHEEL_UP=$7A,
      RAWKEY_WHEEL_DOWN=$7B,
      RAWKEY_WHEEL_LEFT=$7C,
      RAWKEY_WHEEL_RIGHT=$7D