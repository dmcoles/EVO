OPT MODULE
OPT EXPORT

MODULE 'exec/lists',
       'exec/semaphores',
       'graphics/clip'

CONST LAYERSIMPLE=1,
      LAYERSMART=2,
      LAYERSUPER=4,
      LAYERUPDATING=16,
      LAYERBACKDROP=$40,
      LAYERREFRESH=$80,
      LAYERIREFRESH=$200,
      LAYERIREFRESH2=$400,
      LAYER_CLIPRECTS_LOST=$100

OBJECT layer_info
  top_layer:PTR TO layer
  check_lp:PTR TO layer
  obs:PTR TO cliprect
  freecliprects:PTR TO cliprect
  privatereserve1:LONG
  privatereserve2:LONG
  lock:ss
  gs_head:mlh
  privatereserve3:INT
  privatereserve4:LONG
  flags:INT  -> This is unsigned
  fatten_count:CHAR
  locklayerscount:CHAR
  privatereserve5:INT
  blankhook:LONG
  layerinfo_extra:LONG
ENDOBJECT     /* SIZEOF=102 */

CONST NEWLAYERINFO_CALLED=1,
      ALERTLAYERSNOMEM=$83010000,
      LAYERS_NOBACKFILL=1,
      LAYERS_BACKFILL=0

