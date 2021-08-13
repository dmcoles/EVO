OPT MODULE
OPT EXPORT

MODULE 'exec/ports',
       'exec/semaphores',
       'graphics/copper',
       'graphics/gfx',
       'graphics/gfxnodes',
       'graphics/monitor',
       'utility/tagitem'

CONST GENLOCK_VIDEO=2,
      V_LACE=4,
      V_DOUBLESCAN=8,
      V_SUPERHIRES=$20,
      V_PFBA=$40,
      V_EXTRA_HALFBRITE=$80,
      GENLOCK_AUDIO=$100,
      V_DUALPF=$400,
      V_HAM=$800,
      V_EXTENDED_MODE=$1000,
      V_VP_HIDE=$2000,
      V_SPRITES=$4000,
      V_HIRES=$8000,
      EXTEND_VSTRUCT=$1000,
      VPF_A2024=$40,
      VPF_TENHZ=16,
      VPB_A2024=6,
      VPB_TENHZ=4

OBJECT colormap
  flags:CHAR
  type:CHAR
  count:INT  -> This is unsigned
  colortable:LONG
  vpe:PTR TO viewportextra
  lowcolorbits:LONG
  transparencyplane:CHAR
  spriteresolution:CHAR
  spriteresdefault:CHAR
  auxflags:CHAR
  vp:PTR TO viewport
  normaldisplayinfo:LONG
  coercedisplayinfo:LONG
  batch_items:PTR TO tagitem
  vpmodeid:LONG
  palextra:PTR TO paletteextra
  spritebase_even:INT  -> This is unsigned
  spritebase_odd:INT  -> This is unsigned
  bp_0_base:INT  -> This is unsigned
  bp_1_base:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=52 */

CONST CM_TRANSPARENYPLANE=16,
      COLORMAP_TYPE_V1_2=0,
      COLORMAP_TYPE_V1_4=1,
      COLORMAP_TYPE_V36=1,
      COLORMAP_TYPE_V39=2,
      COLORMAP_TRANSPARENCY=1,
      COLORPLANE_TRANSPARENCY=2,
      BORDER_BLANKING=4,
      BORDER_NOTRANSPARENCY=8,
      VIDEOCONTROL_BATCH=16,
      USER_COPPER_CLIP=$20,
      BORDER_SPRITES=$40,
      CMF_CMTRANS=1,
      CMF_CPTRANS=2,
      CMF_BRDRBLNK=4,
      CMF_BRDNTRAN=8,
      CMF_BRDRSPRT=$40,
      CMB_CMTRANS=0,
      CMB_CPTRANS=1,
      CMB_BRDRBLNK=2,
      CMB_BRDNTRAN=3,
      CMB_BRDRSPRT=6,
      SPRITERESN_ECS=0,
      SPRITERESN_140NS=1,
      SPRITERESN_70NS=2,
      SPRITERESN_35NS=3,
      SPRITERESN_DEFAULT=-1,
      CMAF_FULLPALETTE=1,
      CMAB_FULLPALETTE=0,
      CMAF_NO_INTERMED_UPDATE=2,
      CMAB_NO_INTERMED_UPDATE=1,
      CMAF_NO_COLOR_LOAD=4,
      CMAB_NO_COLOR_LOAD=2,
      CMAF_DUALPF_DISABLE=3,
      CMAB_DUALPF_DISABLE=8

OBJECT paletteextra
  semaphore:ss
  firstfree:INT  -> This is unsigned
  nfree:INT  -> This is unsigned
  firstshared:INT  -> This is unsigned
  nshared:INT  -> This is unsigned
  refcnt:LONG
  alloclist:LONG
  viewport:PTR TO viewport
  sharablecolors:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=68 */

CONST PRECISION_EXACT=-1,
      PRECISION_IMAGE=0,
      PRECISION_ICON=16,
      PRECISION_GUI=$20,
      OBP_PRECISION=$84000000,
      OBP_FAILIFBAD=$84000001,
      PEN_EXCLUSIVE=1,
      PEN_NO_SETCOLOR=2,
      PENF_EXCLUSIVE=1,
      PENF_NO_SETCOLOR=2,
      PENB_EXCLUSIVE=0,
      PENB_NO_SETCOLOR=1

OBJECT viewport
  next:PTR TO viewport
  colormap:PTR TO colormap
  dspins:PTR TO coplist
  sprins:PTR TO coplist
  clrins:PTR TO coplist
  ucopins:PTR TO ucoplist
  dwidth:INT
  dheight:INT
  dxoffset:INT
  dyoffset:INT
  modes:INT  -> This is unsigned
  spritepriorities:CHAR
  extendedmodes:CHAR
  rasinfo:PTR TO rasinfo
ENDOBJECT     /* SIZEOF=40 */

OBJECT view
  viewport:PTR TO viewport
  lofcprlist:PTR TO cprlist
  shfcprlist:PTR TO cprlist
  dyoffset:INT
  dxoffset:INT
  modes:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=18 */

OBJECT viewextra
  xln:xln
  view:PTR TO view
  monitor:PTR TO monitorspec
  topline:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=34 */

OBJECT viewportextra
  xln:xln
  viewport:PTR TO viewport
  displayclip:rectangle
  vectable:LONG
  driverdata[2]:ARRAY OF LONG
  flags:INT  -> This is unsigned
  origin[2]:ARRAY OF tpoint
  cop1ptr:LONG
  cop2ptr:LONG
ENDOBJECT     /* SIZEOF=58 */

CONST VPXB_FREE_ME=0,
      VPXF_FREE_ME=1,
      VPXB_VP_LAST=1,
      VPXF_VP_LAST=2,
      VPXB_STRADDLES_256=4,
      VPXF_STRADDLES_256=16,
      VPXB_STRADDLES_512=5,
      VPXF_STRADDLES_512=$20

OBJECT rasinfo
  next:PTR TO rasinfo
  bitmap:PTR TO bitmap
  rxoffset:INT
  ryoffset:INT
ENDOBJECT     /* SIZEOF=12 */

CONST MVP_OK=0,
      MVP_NO_MEM=1,
      MVP_NO_VPE=2,
      MVP_NO_DSPINS=3,
      MVP_NO_DISPLAY=4,
      MVP_OFF_BOTTOM=5,
      MCOP_OK=0,
      MCOP_NO_MEM=1,
      MCOP_NOP=2

OBJECT dbufinfo
  link1:LONG
  count1:LONG
  safemessage:mn
  userdata1:LONG
  link2:LONG
  count2:LONG
  dispmessage:mn
  userdata2:LONG
  matchlong:LONG
  copptr1:LONG
  copptr2:LONG
  copptr3:LONG
  beampos1:INT  -> This is unsigned
  beampos2:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=84 */

