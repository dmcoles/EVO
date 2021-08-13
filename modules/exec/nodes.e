OPT MODULE
OPT EXPORT

OBJECT ln
  succ:PTR TO ln
  pred:PTR TO ln
  type:CHAR
  pri:CHAR  -> This is signed
  name:PTR TO CHAR
ENDOBJECT     /* SIZEOF=14 */

OBJECT mln
  succ:PTR TO mln
  pred:PTR TO mln
ENDOBJECT     /* SIZEOF=8 */

CONST NT_UNKNOWN=0,
      NT_TASK=1,
      NT_INTERRUPT=2,
      NT_DEVICE=3,
      NT_MSGPORT=4,
      NT_MESSAGE=5,
      NT_FREEMSG=6,
      NT_REPLYMSG=7,
      NT_RESOURCE=8,
      NT_LIBRARY=9,
      NT_MEMORY=10,
      NT_SOFTINT=11,
      NT_FONT=12,
      NT_PROCESS=13,
      NT_SEMAPHORE=14,
      NT_SIGNALSEM=15,
      NT_BOOTNODE=16,
      NT_KICKMEM=17,
      NT_GRAPHICS=18,
      NT_DEATHMESSAGE=19,
      NT_USER=$FE,
      NT_EXTENDED=$FF

