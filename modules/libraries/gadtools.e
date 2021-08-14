OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'graphics/gfx',
       'graphics/rastport',
       'graphics/text',
       'intuition/screens'

CONST GENERIC_KIND=0,
      BUTTON_KIND=1,
      CHECKBOX_KIND=2,
      INTEGER_KIND=3,
      LISTVIEW_KIND=4,
      MX_KIND=5,
      NUMBER_KIND=6,
      CYCLE_KIND=7,
      PALETTE_KIND=8,
      SCROLLER_KIND=9,
      SLIDER_KIND=11,
      STRING_KIND=12,
      TEXT_KIND=13,
      NUM_KINDS=14,
      ARROWIDCMP=$400068,
      BUTTONIDCMP=$40,
      CHECKBOXIDCMP=$40,
      INTEGERIDCMP=$40,
      LISTVIEWIDCMP=$400078,
      MXIDCMP=$20,
      NUMBERIDCMP=0,
      CYCLEIDCMP=$40,
      PALETTEIDCMP=$40,
      SCROLLERIDCMP=$70,
      SLIDERIDCMP=$70,
      STRINGIDCMP=$40,
      TEXTIDCMP=0

OBJECT newgadget
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  gadgettext:PTR TO CHAR
  textattr:PTR TO textattr
  gadgetid:INT  -> This is unsigned
  flags:LONG
  visualinfo:LONG
  userdata:LONG
ENDOBJECT     /* SIZEOF=30 */

CONST PLACETEXT_LEFT=1,
      PLACETEXT_RIGHT=2,
      PLACETEXT_ABOVE=4,
      PLACETEXT_BELOW=8,
      PLACETEXT_IN=16,
      NG_HIGHLABEL=$20,
      NG_GRIDLAYOUT=$80

OBJECT newmenu
  type:CHAR
  pad:CHAR
  label:PTR TO CHAR
  commkey:PTR TO CHAR
  flags:INT  -> This is unsigned
  mutualexclude:LONG
  userdata:LONG
ENDOBJECT     /* SIZEOF=20 */

#define GTMENU_USERDATA(m)      (Long((m)+SIZEOF menu))
#define GTMENUITEM_USERDATA(mi) (Long((mi)+SIZEOF menuitem))
#define MENU_USERDATA(mi)       (GTMENUITEM_USERDATA(mi))

CONST MENU_IMAGE=$80,
      NM_TITLE=1,
      NM_ITEM=2,
      NM_SUB=3,
      IM_ITEM=$82,
      IM_SUB=$83,
      NM_END=0,
      NM_IGNORE=$40,
      NM_BARLABEL=-1,
      NM_MENUDISABLED=1,
      NM_ITEMDISABLED=16,
      NM_COMMANDSTRING=4,
      NM_FLAGMASK=$FFFFFF39,
      NM_FLAGMASK_V39=$FFFFFF3D,
      GTMENU_TRIMMED=1,
      GTMENU_INVALID=2,
      GTMENU_NOMEM=3,
      MX_WIDTH=17,
      MX_HEIGHT=9,
      CHECKBOX_WIDTH=26,
      CHECKBOX_HEIGHT=11,
      GT_TAGBASE=$80080000,
      GTVI_NEWWINDOW=$80080001,
      GTVI_NWTAGS=$80080002,
      GT_PRIVATE0=$80080003,
      GTCB_CHECKED=$80080004,
      GTLV_TOP=$80080005,
      GTLV_LABELS=$80080006,
      GTLV_READONLY=$80080007,
      GTLV_SCROLLWIDTH=$80080008,
      GTMX_LABELS=$80080009,
      GTMX_ACTIVE=$8008000A,
      GTTX_TEXT=$8008000B,
      GTTX_COPYTEXT=$8008000C,
      GTNM_NUMBER=$8008000D,
      GTCY_LABELS=$8008000E,
      GTCY_ACTIVE=$8008000F,
      GTPA_DEPTH=$80080010,
      GTPA_COLOR=$80080011,
      GTPA_COLOROFFSET=$80080012,
      GTPA_INDICATORWIDTH=$80080013,
      GTPA_INDICATORHEIGHT=$80080014,
      GTSC_TOP=$80080015,
      GTSC_TOTAL=$80080016,
      GTSC_VISIBLE=$80080017,
      GTSC_OVERLAP=$80080018,
      GTSL_MIN=$80080026,
      GTSL_MAX=$80080027,
      GTSL_LEVEL=$80080028,
      GTSL_MAXLEVELLEN=$80080029,
      GTSL_LEVELFORMAT=$8008002A,
      GTSL_LEVELPLACE=$8008002B,
      GTSL_DISPFUNC=$8008002C,
      GTST_STRING=$8008002D,
      GTST_MAXCHARS=$8008002E,
      GTIN_NUMBER=$8008002F,
      GTIN_MAXCHARS=$80080030,
      GTMN_TEXTATTR=$80080031,
      GTMN_FRONTPEN=$80080032,
      GTBB_RECESSED=$80080033,
      GT_VISUALINFO=$80080034,
      GTLV_SHOWSELECTED=$80080035,
      GTLV_SELECTED=$80080036,
      GT_RESERVED1=$80080038,
      GTTX_BORDER=$80080039,
      GTNM_BORDER=$8008003A,
      GTSC_ARROWS=$8008003B,
      GTMN_MENU=$8008003C,
      GTMX_SPACING=$8008003D,
      GTMN_FULLMENU=$8008003E,
      GTMN_SECONDARYERROR=$8008003F,
      GT_UNDERSCORE=$80080040,
      GTST_EDITHOOK=$80080037,
      GTIN_EDITHOOK=$80080037,
      GTMN_CHECKMARK=$80080041,
      GTMN_AMIGAKEY=$80080042,
      GTMN_NEWLOOKMENUS=$80080043,
      GTCB_SCALED=$80080044,
      GTMX_SCALED=$80080045,
      GTPA_NUMCOLORS=$80080046,
      GTMX_TITLEPLACE=$80080047,
      GTTX_FRONTPEN=$80080048,
      GTTX_BACKPEN=$80080049,
      GTTX_JUSTIFICATION=$8008004A,
      GTNM_FRONTPEN=$80080048,
      GTNM_BACKPEN=$80080049,
      GTNM_JUSTIFICATION=$8008004A,
      GTNM_FORMAT=$8008004B,
      GTNM_MAXNUMBERLEN=$8008004C,
      GTBB_FRAMETYPE=$8008004D,
      GTLV_MAKEVISIBLE=$8008004E,
      GTLV_ITEMHEIGHT=$8008004F,
      GTSL_MAXPIXELLEN=$80080050,
      GTSL_JUSTIFICATION=$80080051,
      GTPA_COLORTABLE=$80080052,
      GTLV_CALLBACK=$80080053,
      GTLV_MAXPEN=$80080054,
      GTTX_CLIPPED=$80080055,
      GTNM_CLIPPED=$80080055,
      GTBB_RESERVED1=$8008005A,
      GTMN_RESERVED1=$8008005B,
      GTLV_TOTAL=$8008005C,
      GTLV_VISIBLE=$8008005D,
      GTBB_SCALE=$8008005C,
      GTBB_HEADLINE=$8008005D,
      GTBB_HEADLINEPEN=$8008005E,
      GTBB_HEADLINEFONT=$8008005F,
      GTVI_LEFTBORDER=$80080060,
      GTVI_TOPBORDER=$80080061,
      GTVI_ALIGNRIGHT=$80080062,
      GTVI_ALIGNBOTTOM=$80080063,
      GTVI_MINFONTWIDTH=$80080064,
      GTVI_MINFONTHEIGHT=$80080065,
      GTMX_SCALEDSPACING=$80080066,
      GT_RESERVED0=$80080037,      
      GTJ_LEFT=0,
      GTJ_RIGHT=1,
      GTJ_CENTER=2,
      BBFT_BUTTON=1,
      BBFT_RIDGE=2,
      BBFT_ICONDROPBOX=3,
      BBFT_DISPLAY=6,
      BBFT_CTXTFRAME=7,
      INTERWIDTH=8,
      INTERHEIGHT=4,
      NWAY_KIND=7,
      NWAYIDCMP=$40,
      GTNW_LABELS=$8008000E,
      GTNW_ACTIVE=$8008000F,
      GADTOOLBIT=$8000,
      GADTOOLMASK=$FFFF7FFF,
      LV_DRAW=$202,
      LVCB_OK=0,
      LVCB_UNKNOWN=1,
      LVR_NORMAL=0,
      LVR_SELECTED=1,
      LVR_NORMALDISABLED=2,
      LVR_SELECTEDDISABLED=8

OBJECT lvdrawmsg
  methodid:LONG
  rastport:PTR TO rastport
  drawinfo:PTR TO drawinfo
  bounds:rectangle
  state:LONG
ENDOBJECT     /* SIZEOF=NONE !!! */
