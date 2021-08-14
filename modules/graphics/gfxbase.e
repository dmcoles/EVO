  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'exec/libraries','exec/interrupts','exec/lists','graphics/monitor','graphics/view','graphics/copper','hardware/blit','graphics/text','exec/tasks','exec/semaphores','graphics/regions'

OBJECT gfxbase
  lib:lib
  actiview:PTR TO view
  copinit:PTR TO copinit
  cia:PTR TO LONG
  blitter:PTR TO LONG
  loflist:PTR TO INT  -> Target is unsigned
  shflist:PTR TO INT  -> Target is unsigned
  blthd:PTR TO bltnode
  blttl:PTR TO bltnode
  bsblthd:PTR TO bltnode
  bsblttl:PTR TO bltnode
  vbsrv:is
  timsrv:is
  bltsrv:is
  textfonts:lh
  defaultfont:PTR TO textfont
  modes:INT  -> This is unsigned
  vblank:CHAR  -> This is signed
  debug:CHAR  -> This is signed
  beamsync:INT
  system_bplcon0:INT
  spritereserved:CHAR
  bytereserved:CHAR
  flags:INT  -> This is unsigned
  blitlock:INT
  blitnest:INT
  blitwaitq:lh
  blitowner:PTR TO tc
  tof_waitq:lh
  displayflags:INT  -> This is unsigned
-> This is really PTR TO PTR TO simplesprite
  simplesprites:PTR TO LONG
  maxdisplayrow:INT  -> This is unsigned
  maxdisplaycolumn:INT  -> This is unsigned
  normaldisplayrows:INT  -> This is unsigned
  normaldisplaycolumns:INT  -> This is unsigned
  normaldpmx:INT  -> This is unsigned
  normaldpmy:INT  -> This is unsigned
  lastchancememory:PTR TO ss
  lcmptr:PTR TO INT  -> Target is unsigned
  microsperline:INT  -> This is unsigned
  mindisplaycolumn:INT  -> This is unsigned
  chiprevbits0:CHAR
  memtype:CHAR
  crb_reserved[4]:ARRAY OF CHAR
  monitor_id:INT  -> This is unsigned
  hedley[8]:ARRAY OF LONG
  hedley_sprites[8]:ARRAY OF LONG
  hedley_sprites1[8]:ARRAY OF LONG
  hedley_count:INT
  hedley_flags:INT  -> This is unsigned
  hedley_tmp:INT
  hash_table:PTR TO LONG
  current_tot_rows:INT  -> This is unsigned
  current_tot_cclks:INT  -> This is unsigned
  hedley_hint:CHAR
  hedley_hint2:CHAR
  nreserved[4]:ARRAY OF LONG
  a2024_sync_raster:PTR TO LONG
  control_delta_pal:INT  -> This is unsigned
  control_delta_ntsc:INT  -> This is unsigned
  current_monitor:PTR TO monitorspec
  monitorlist:lh
  default_monitor:PTR TO monitorspec
  monitorlistsemaphore:PTR TO ss
  displayinfodatabase:LONG
  topline:INT  -> This is unsigned
  activiewcprsemaphore:PTR TO ss
  utilbase:PTR TO lib
  execbase:PTR TO lib
  bwshifts:PTR TO CHAR
  strtfetchmasks:PTR TO INT  -> Target is unsigned
  stopfetchmasks:PTR TO INT  -> Target is unsigned
  overrun:PTR TO INT  -> Target is unsigned
  realstops:PTR TO INT
  spritewidth:INT  -> This is unsigned
  spritefmode:INT  -> This is unsigned
  softsprites:CHAR  -> This is signed
  arraywidth:CHAR  -> This is signed
  defaultspritewidth:INT  -> This is unsigned
  sprmovedisable:CHAR  -> This is signed
  wantchips:CHAR
  boardmemtype:CHAR
  bugs:CHAR
  layersbase:PTR TO LONG
  colormask:LONG
  ivector:LONG
  idata:LONG
  specialcounter:LONG
  dblist:LONG
  monitorflags:INT  -> This is unsigned
  scandoubledsprites:CHAR
  bp3bits:CHAR
  monitorvblank:analogsignalinterval
  natural_monitor:PTR TO monitorspec
  progdata:LONG
  extsprites:CHAR
  pad3:CHAR
  gfxflags:INT  -> This is unsigned
  vbcounter:LONG
  hashtablesemaphore:PTR TO ss
  hwemul[9]:ARRAY OF LONG
  scratch:PTR TO regionrectangle
  scratchsize:LONG
ENDOBJECT     /* SIZEOF=544 */

#define chunkytoplanarptr hwemul[0]

CONST OWNBLITTERN=0,
      QBOWNERN=1,
      BLITMSG_FAULTN=2,
      BLITMSG_FAULT=4,
      QBOWNER=2,
      GBFLAGSF_TIMER=$40,
      GBFLAGSF_LASTBLIT=$80,
      GFXB_BIG_BLITS=0,
      GFXB_HR_AGNUS=0,
      GFXB_HR_DENISE=1,
      GFXB_AA_ALICE=2,
      GFXB_AA_LISA=3,
      GFXB_AA_MLISA=4,
      GFXF_BIG_BLITS=1,
      GFXF_HR_AGNUS=1,
      GFXF_HR_DENISE=2,
      GFXF_AA_ALICE=4,
      GFXF_AA_LISA=8,
      GFXF_AA_MLISA=16,
      SETCHIPREV_A=1,
      SETCHIPREV_ECS=3,
      SETCHIPREV_AA=15,
      SETCHIPREV_BEST=-1,
      BUS_16=0,
      NML_CAS=0,
      BUS_32=1,
      DBL_CAS=2,
      BANDWIDTH_1X=0,
      BANDWIDTH_2XNML=1,
      BANDWIDTH_2XDBL=2,
      BANDWIDTH_4X=3,
      NEW_DATABASE=1,
      NTSCN=0,
      NTSC=1,
      GENLOCN=1,
      GENLOC=2,
      PALN=2,
      PAL=4,
      TODA_SAFEN=3,
      TODA_SAFE=8,
      REALLY_PALN=4,
      REALLY_PAL=16,
      LPEN_SWAP_FRAMES=32

#define GRAPHICSNAME 'graphics.library'
