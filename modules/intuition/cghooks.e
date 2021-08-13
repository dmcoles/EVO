OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'graphics/clip',
       'graphics/rastport',
       'intuition/intuition',
       'intuition/screens'

#define CUSTOM_HOOK(g) (g::gadget.mutualexclude)

OBJECT gadgetinfo
  screen:PTR TO screen
  window:PTR TO window
  requester:PTR TO requester
  rastport:PTR TO rastport
  layer:PTR TO layer
  domain:ibox
  detailpen:CHAR
  blockpen:CHAR
  drinfo:PTR TO drawinfo
ENDOBJECT     /* SIZEOF=NONE !!! */

-> Um, this object was missing
OBJECT pgx
  container:ibox
  newknob:ibox
ENDOBJECT
