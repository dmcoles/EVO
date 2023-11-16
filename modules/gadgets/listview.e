  OPT MODULE
  OPT EXPORT

  MODULE 'intuition/intuition','exec/nodes'

OBJECT listlabelnode
  node: ln
  userdata:LONG
  renderforeground:INT
  renderbackground:INT
  selectforeground:INT
  selectbackground:INT
  renderimage:PTR TO image
  selectimage:PTR TO image
  
  ->private fields crash & burn!
  textlength:INT
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  justification:INT
  selected:INT
ENDOBJECT

CONST LISTVIEW_DUMMY=$84000000,
      LISTVIEW_LABELS=$84000001,
      LISTVIEW_TOP=$84000002,
      LISTVIEW_VISIBLE=$84000003,
      LISTVIEW_TOTAL=$84000005,
      LISTVIEW_SHOWSELECTED=$84000006,
      LISTVIEW_SELECTED=$84000007,
      LISTVIEW_SELECTEDNODE=$84000007,
      LISTVIEW_MAKEVISIBLE=$84000008,
      LISTVIEW_MULTISELECT=$84000009,
      LISTVIEW_ITEMHEIGHT=$8400000A,
      LISTVIEW_CALLHOOK=$8400000B,
      LISTVIEW_SCROLLUP=$8400000C,
      LISTVIEW_SCROLLDOWN=$8400000D,
      LISTVIEW_SCROLLLEFT=$8400000E,
      LISTVIEW_SCROLLRIGHT=$8400000F,
      LISTVIEW_SPACING=$84000010,
      LVJ_LEFT =0,
      LVJ_CENTER=1,
      LVJ_RIGHT=2