OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/lists',
       'exec/ports',
       'rexx/storage'

CONST RXBUFFSZ=$CC

OBJECT iobuff
-> Um, this was all wrong
  node:rexxrsrc
  rpt:LONG
  rct:LONG
  dfh:LONG
  lock:LONG
  bct:LONG
  area[$CC]:ARRAY
ENDOBJECT     /* SIZEOF=256 */

CONST IOBNAME=10,
      IOBMODE=24,
      IOBEOF=25,
      IOBPOS=28,
      RXIO_EXIST=-1,
      RXIO_STRF=0,
      RXIO_READ=1,
      RXIO_WRITE=2,
      RXIO_APPEND=3,
      RXIO_BEGIN=-1,
      RXIO_CURR=0,
      RXIO_END=1

#define LLOFFSET(rrp) (rrp::rexxrsrc.arg1)
#define LLVERS(rrp)   (rrp::rexxrsrc.arg2)
#define CLVALUE(rrp)  (rrp::rexxrsrc.arg1)

OBJECT rexxmsgport
-> Um, this was all wrong
  rrsizeof:rexxrsrc
  port:mp
  replylist:lh
ENDOBJECT     /* SIZEOF=80 */

CONST DT_DEV=0,
      DT_DIR=1,
      DT_VOL=2,
      ACTION_STACK=$7D2,
      ACTION_QUEUE=$7D3

