  OPT MODULE
  OPT EXPORT

  OPT PREPROCESS
  
MODULE 'exec/io',
       'exec/ports'

#define AUDIONAME 'audio.device'  

CONST ADHARD_CHANNELS=4,
      ADALLOC_MINPREC=$FFFFFF80,
      ADALLOC_MAXPREC=$7F,
      ADCMD_FREE=9,
      ADCMD_SETPREC=10,
      ADCMD_FINISH=11,
      ADCMD_PERVOL=12,
      ADCMD_LOCK=13,
      ADCMD_WAITCYCLE=14,
      ADCMD_ALLOCATE=$20,
      ADIOB_PERVOL=4,
      ADIOF_PERVOL=16,
      ADIOB_SYNCCYCLE=5,
      ADIOF_SYNCCYCLE=$20,
      ADIOB_NOWAIT=6,
      ADIOF_NOWAIT=$40,
      ADIOB_WRITEMESSAGE=7,
      ADIOF_WRITEMESSAGE=$80,
      ADIOERR_NOALLOCATION=-10,
      ADIOERR_ALLOCFAILED=-11,
      ADIOERR_CHANNELSTOLEN=-12

OBJECT ioaudio
  io:io
  allockey:INT
  data:PTR TO CHAR
  length:LONG
  period:INT  -> This is unsigned
  volume:INT  -> This is unsigned
  cycles:INT  -> This is unsigned
  writemsg:mn
ENDOBJECT     /* SIZEOF=68 */

