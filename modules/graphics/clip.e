OPT MODULE
OPT EXPORT

MODULE 'exec/semaphores',
       'graphics/gfx',
       'graphics/layers',
       'graphics/rastport',
       'graphics/regions',
       'utility/hooks'

CONST NEWLOCKS=1

OBJECT layer
  front:PTR TO layer
  back:PTR TO layer
  cliprect:PTR TO cliprect
  rp:PTR TO rastport
  minx:INT
  miny:INT
  maxx:INT
  maxy:INT
  reserved[4]:ARRAY
  priority:INT  -> This is unsigned
  flags:INT  -> This is unsigned
  superbitmap:PTR TO bitmap
  supercliprect:PTR TO cliprect
  window:LONG
  scroll_x:INT
  scroll_y:INT
  cr:PTR TO cliprect
  cr2:PTR TO cliprect
  crnew:PTR TO cliprect
  supersavercliprects:PTR TO cliprect
-> Um, this had an illegal name
  cliprects_:PTR TO cliprect
  layerinfo:PTR TO layer_info
  lock:ss
  backfill:PTR TO hook
  reserved1:LONG
  clipregion:PTR TO region
  savecliprects:PTR TO region
  reserved2[22]:ARRAY
  damagelist:PTR TO region
ENDOBJECT     /* SIZEOF=160 */

OBJECT cliprect
  next:PTR TO cliprect
  prev:PTR TO cliprect
  lobs:PTR TO layer
  bitmap:PTR TO bitmap
  minx:INT
  miny:INT
  maxx:INT
  maxy:INT
-> Um, these had illegal names
  p1_:LONG
  p2_:LONG
  reserved:LONG
  flags:LONG
ENDOBJECT     /* SIZEOF=40 */

CONST CR_NEEDS_NO_CONCEALED_RASTERS=1,
      CR_NEEDS_NO_LAYERBLIT_DAMAGE=2,
      ISLESSX=1,
      ISLESSY=2,
      ISGRTRX=4,
      ISGRTRY=8,
      LR_FRONT=0,
      LR_BACK=4,
      LR_RASTPORT=12,
      CR_PREV=4,
      CR_LOBS=8

