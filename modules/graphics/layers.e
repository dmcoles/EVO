  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'exec/semaphores','exec/lists','graphics/clip','graphics/gfx','utility/hooks'

CONST LAYERSIMPLE=1,
      LAYERSMART=2,
      LAYERSUPER=4,
      LAYERUPDATING=16,
      LAYERBACKDROP=$40,
      LAYERREFRESH=$80,
      LAYERIREFRESH=$200,
      LAYERIREFRESH2=$400,
      LAYER_CLIPRECTS_LOST=$100,
      LAYERSAVEBACK=$800,
      LAYERHIDDEN=$1000,
      LAYER_BACKMOST=0,
      LAYER_FRONTMOST=1

OBJECT layer_info
  top_layer:PTR TO layer
  resptr1:LONG
  resptr2:LONG
  freecliprects:PTR TO cliprect
  bounds:rectangle
  lock:ss
  gs_head:mlh
  privatereserve3:INT
  privatereserve4:LONG
  flags:INT  -> This is unsigned
  res_count:CHAR
  locklayerscount:CHAR
  privatereserve5:CHAR
  usercliprecscount:CHAR
  blankhook:PTR TO hook
  resptr5:LONG
ENDOBJECT     /* SIZEOF=102 */

CONST NEWLAYERINFO_CALLED=1,
      ALERTLAYERSNOMEM=$83010000,
      LAYERS_NOBACKFILL=1,
      LAYERS_BACKFILL=0

