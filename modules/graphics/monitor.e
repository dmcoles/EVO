OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/lists',
       'exec/semaphores',
       'graphics/gfx',
       'graphics/gfxnodes'

OBJECT analogsignalinterval
  start:INT  -> This is unsigned
  stop:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=4 */

OBJECT specialmonitor
  xln:xln
  flags:INT  -> This is unsigned
  do_monitor:LONG
  reserved1:LONG
  reserved2:LONG
  reserved3:LONG
  hblank:analogsignalinterval
  vblank:analogsignalinterval
  hsync:analogsignalinterval
  vsync:analogsignalinterval
ENDOBJECT     /* SIZEOF=58 */

OBJECT monitorspec
  xln:xln
  flags:INT  -> This is unsigned
  ratioh:LONG
  ratiov:LONG
  total_rows:INT  -> This is unsigned
  total_colorclocks:INT  -> This is unsigned
  denisemaxdisplaycolumn:INT  -> This is unsigned
  beamcon0:INT  -> This is unsigned
  min_row:INT  -> This is unsigned
  special:PTR TO specialmonitor
  opencount:INT  -> This is unsigned
  transform:LONG
  translate:LONG
  scale:LONG
  xoffset:INT  -> This is unsigned
  yoffset:INT  -> This is unsigned
  legalview:rectangle
  maxoscan:LONG
  videoscan:LONG
  denisemindisplaycolumn:INT  -> This is unsigned
  displaycompatible:LONG
  displayinfodatabase:lh
  didbsemaphore:ss
  mrgcop:LONG
  loadview:LONG
  killview:LONG
ENDOBJECT     /* SIZEOF=160 */

CONST MSB_REQUEST_NTSC=0,
      MSB_REQUEST_PAL=1,
      MSB_REQUEST_SPECIAL=2,
      MSB_REQUEST_A2024=3,
      MSB_DOUBLE_SPRITES=4,
      MSF_REQUEST_NTSC=1,
      MSF_REQUEST_PAL=2,
      MSF_REQUEST_SPECIAL=4,
      MSF_REQUEST_A2024=8,
      MSF_DOUBLE_SPRITES=16,
      STANDARD_VIEW_X=$81,
      STANDARD_VIEW_Y=$2C,
      TO_MONITOR=0,
      FROM_MONITOR=1,
      STANDARD_XOFFSET=9,
      STANDARD_YOFFSET=0,
      REQUEST_NTSC=1,
      REQUEST_PAL=2,
      REQUEST_SPECIAL=4,
      REQUEST_A2024=8,
      STANDARD_MONITOR_MASK=3,
      STANDARD_NTSC_ROWS=262,
      STANDARD_PAL_ROWS=312,
      STANDARD_COLORCLOCKS=226,
      STANDARD_DENISE_MAX=455,
      STANDARD_DENISE_MIN=93,
      STANDARD_NTSC_BEAMCON=0,
      STANDARD_PAL_BEAMCON=$20,
      SPECIAL_BEAMCON=$1b8a,
      MIN_NTSC_ROW=21,
      MIN_PAL_ROW=29,
      STANDARD_VIEW_X=$81,
      STANDARD_VIEW_Y=$2C,
      STANDARD_HBSTRT=$6,
      STANDARD_HSSTRT=$B,
      STANDARD_HSSTOP=$1C,
      STANDARD_HBSTOP=$2C,
      STANDARD_VBSTRT=$122,
      STANDARD_VSSTRT=$2A6,
      STANDARD_VSSTOP=$3AA,
      STANDARD_VBSTOP=$1066,
      VGA_COLORCLOCKS=113,
      VGA_TOTAL_ROWS=131,
      VGA_DENISE_MIN=59,
      MIN_VGA_ROW=29,
      VGA_HBSTRT=$8,
      VGA_HSSTRT=$0E,
      VGA_HSSTOP=$1C,
      VGA_HBSTOP=$1E,
      VGA_VBSTRT=0,
      VGA_VSSTRT=$153,
      VGA_VSSTOP=$235,
      VGA_VBSTOP=$CCD,
      BROADCAST_HBSTRT=$1,
      BROADCAST_HSSTRT=$6,
      BROADCAST_HSSTOP=$17,
      BROADCAST_HBSTOP=$27,
      BROADCAST_VBSTRT=0,
      BROADCAST_VSSTRT=$2A6,
      BROADCAST_VSSTOP=$054C,
      BROADCAST_VBSTOP=$1C40,
      BROADCAST_BEAMCON=$808,
      RATIO_FIXEDPART=4,
      RATIO_UNITY=16

#define DEFAULT_MONITOR_NAME 'default.monitor'
#define NTSC_MONITOR_NAME 'ntsc.monitor'
#define PAL_MONITOR_NAME 'pal.monitor'
#define VGA_MONITOR_NAME 'vga.monitor'
