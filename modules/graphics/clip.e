  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'exec/semaphores','graphics/layers','graphics/gfx','graphics/rastport','utility/hooks','graphics/regions','exec/lists'
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
  nlink:PTR TO layer
  priority:INT  -> This is unsigned
  flags:INT  -> This is unsigned
  superbitmap:PTR TO bitmap
  supercliprect:PTR TO cliprect
  window:LONG
  scroll_x:INT
  scroll_y:INT
  onscreen:PTR TO cliprect
  offscreen:PTR TO cliprect
  backup:PTR TO cliprect
  supersavercliprects:PTR TO cliprect
  undamaged:PTR TO cliprect
  layerinfo:PTR TO layer_info
  lock:ss
  backfill:PTR TO hook
  reserved1:LONG
  clipregion:PTR TO region
  clipped:PTR TO region
  reserved2[22]:ARRAY OF CHAR
  damagelist:PTR TO region
ENDOBJECT     /* SIZEOF=160 */

OBJECT cliprect
  next:PTR TO cliprect
  reservedlink:PTR TO cliprect
  obscured:PTR TO layer
  bitmap:PTR TO bitmap
  minx:INT
  miny:INT
  maxx:INT
  maxy:INT
  vlink:PTR TO cliprect
  home:PTR TO layer_info
  reserved:LONG
  flags:LONG
ENDOBJECT     /* SIZEOF=40 */

CONST ISLESSX=1,
      ISLESSY=2,
      ISGRTRX=4,
      ISGRTRY=8,
      LR_FRONT=0,
      LR_BACK=4,
      LR_RASTPORT=12,
      CR_PREV=4,
      CR_LOBS=8,
      CR_USERCLIPPED=16,
      CR_DAMAGECLIPPED=32

