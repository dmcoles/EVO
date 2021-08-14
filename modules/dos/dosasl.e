  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'dos/dos'

OBJECT anchorpath
  base:PTR TO achain
  last:PTR TO achain
  breakbits:LONG
  foundbreak:LONG
  flags:CHAR  -> This is signed
  reserved:CHAR
  strlen:INT
  info:fileinfoblock
-> Um, what about 'buf[1]:ARRAY'?
ENDOBJECT     /* SIZEOF=280 */

CONST APB_DOWILD=0,
      APF_DOWILD=1,
      APB_ITSWILD=1,      
      APF_ITSWILD=2,
      APB_DODIR=2,
      APF_DODIR=4,
      APB_DIDDIR=3,
      APF_DIDDIR=8,
      APB_NOMEMERR=4,
      APF_NOMEMERR=16,
      APB_DODOT=5,
      APF_DODOT=$20,
      APB_DIRCHANGED=6,
      APF_DIRCHANGED=$40,
      APB_FOLLOWHLINKS=7,
      APF_FOLLOWHLINKS=$80
      
OBJECT achain
  child:PTR TO achain
  parent:PTR TO achain
  lock:LONG
  info:fileinfoblock
  flags:CHAR  -> This is signed
-> Um, what about 'string[1]:ARRAY'?
ENDOBJECT     /* SIZEOF=274 */

CONST DDB_PATTERNBIT=0,
      DDF_PATTERNBIT=1,     
      DDB_EXAMINEDBIT=1,
      DDF_EXAMINEDBIT=2,
      DDB_COMPLETED=2,
      DDF_COMPLETED=4,
      DDB_ALLBIT=3,
      DDF_ALLBIT=8,
      DDB_SINGLE=4,
      DDF_SINGLE=16,
      P_ANY=$80,
      P_SINGLE=$81,
      P_ORSTART=$82,
      P_ORNEXT=$83,
      P_OREND=$84,
      P_NOT=$85,
      P_NOTEND=$86,
      P_NOTCLASS=$87,
      P_CLASS=$88,
      P_REPBEG=$89,
      P_REPEND=$8A,     
      P_STOP=$8B,
      COMPLEX_BIT=1,
      EXAMINE_BIT=2,
      ERROR_BUFFER_OVERFLOW=$12F,
      ERROR_BREAK=$130,
      ERROR_NOT_EXECUTABLE=$131

