  OPT MODULE
  OPT EXPORT

MODULE 'exec/ports',
       'exec/tasks'

CONST NOTIFY_CLASS=$40000000,
      NOTIFY_CODE=$1234

OBJECT notifymessage
  execmessage:mn
  class:LONG
  code:INT  -> This is unsigned
  nreq:PTR TO notifyrequest
  donottouch:LONG
  donottouch2:LONG
ENDOBJECT     /* SIZEOF=38 */

OBJECT notifyrequest
  name:PTR TO CHAR
  fullname:PTR TO CHAR
  userdata:LONG
  flags:LONG
  UNION
  
  [task:PTR TO tc]
  [port:PTR TO mp
    signalnum:CHAR
    pada:CHAR
    padb[2]:ARRAY OF CHAR
  ]
  ENDUNION
  reserved[4]:ARRAY OF LONG
  msgcount:LONG
  handler:PTR TO mp
ENDOBJECT     /* SIZEOF=48 */

CONST NRF_SEND_MESSAGE=1,
      NRF_SEND_SIGNAL=2,
      NRF_WAIT_REPLY=8,
      NRF_NOTIFY_INITIAL=16,
      NRF_MAGIC=$80000000,
      NRB_SEND_MESSAGE=0,
      NRB_SEND_SIGNAL=1,
      NRB_WAIT_REPLY=3,
      NRB_NOTIFY_INITIAL=4,
      NRB_MAGIC=31,
      NR_HANDLER_FLAGS=$FFFF0000

