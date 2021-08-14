  OPT MODULE
  OPT EXPORT

CONST ACPU_BUSERR=$80000002,
      ACPU_ADDRESSERR=$80000003,
      ACPU_INSTERR=$80000004,
      ACPU_DIVZERO=$80000005,
      ACPU_CHK=$80000006,
      ACPU_TRAPV=$80000007,
      ACPU_PRIVERR=$80000008,
      ACPU_TRACE=$80000009,
      ACPU_LINEA=$8000000A,
      ACPU_LINEF=$8000000B,
      ACPU_FORMAT=$8000000E,
      ACPU_SPURIOUS=$80000018,
      ACPU_AUTOVEC1=$80000019,
      ACPU_AUTOVEC2=$8000001A,
      ACPU_AUTOVEC3=$8000001B,
      ACPU_AUTOVEC4=$8000001C,
      ACPU_AUTOVEC5=$8000001D,
      ACPU_AUTOVEC6=$8000001E,
      ACPU_AUTOVEC7=$8000001F,
      AT_DEADEND=$80000000,
      AT_RECOVERY=0,
      AG_NOMEMORY=$10000,
      AG_MAKELIB=$20000,
      AG_OPENLIB=$30000,
      AG_OPENDEV=$40000,
      AG_OPENRES=$50000,
      AG_IOERROR=$60000,
      AG_NOSIGNAL=$70000,
      AG_BADPARM=$80000,
      AG_CLOSELIB=$90000,
      AG_CLOSEDEV=$A0000,
      AG_PROCCREATE=$B0000,
      AO_EXECLIB=$8001,
      AO_GRAPHICSLIB=$8002,
      AO_LAYERSLIB=$8003,
      AO_INTUITION=$8004,
      AO_MATHLIB=$8005,
      AO_DOSLIB=$8007,
      AO_RAMLIB=$8008,
      AO_ICONLIB=$8009,
      AO_EXPANSIONLIB=$800A,
      AO_DISKFONTLIB=$800B,
      AO_UTILITYLIB=$800C,
      AO_KEYMAPLIB=$800D,
      AO_AUDIODEV=$8010,
      AO_CONSOLEDEV=$8011,
      AO_GAMEPORTDEV=$8012,
      AO_KEYBOARDDEV=$8013,
      AO_TRACKDISKDEV=$8014,
      AO_TIMERDEV=$8015,
      AO_CIARSRC=$8020,
      AO_DISKRSRC=$8021,
      AO_MISCRSRC=$8022,
      AO_BOOTSTRAP=$8030,
      AO_WORKBENCH=$8031,
      AO_DISKCOPY=$8032,
      AO_GADTOOLS=$8033,
      AO_UNKNOWN=$8035,
      AN_EXECLIB=$1000000,
      AN_EXCPTVECT=$1000001,
      AN_BASECHKSUM=$1000002,
      AN_LIBCHKSUM=$1000003,
      AN_MEMCORRUPT=$81000005,
      AN_INTRMEM=$81000006,
      AN_INITAPTR=$1000007,
      AN_SEMCORRUPT=$1000008,
      AN_FREETWICE=$1000009,
      AN_BOGUSEXCPT=$8100000A,
      AN_BADQUICKINT=$810000FF,
      AN_IOUSEDTWICE=$100000B,
      AN_MEMORYINSANE=$100000C,
      AN_IOAFTERCLOSE=$100000D,
      AN_STACKPROBE=$100000E,
      AN_BADFREEADDR=$100000F,
      AN_BADSEMAPHORE=$1000010,
      AN_AVLNOTIMPL=$1000011,
      AN_TREENOTIMPL=$1000012,
      AN_GRAPHICSLIB=$2000000,
      AN_GFXNOMEM=$82010000,
      AN_GFXNOMEMMSPC=$82010001,
      AN_LONGFRAME=$82010006,
      AN_SHORTFRAME=$82010007,
      AN_TEXTTMPRAS=$2010009,
      AN_BLTBITMAP=$8201000A,
      AN_REGIONMEMORY=$8201000B,
      AN_MAKEVPORT=$82010030,
      AN_GFXNEWERROR=$200000C,
      AN_GFXFREEERROR=$200000D,
      AN_GFXNOLCM=$82011234,
      AN_OBSOLETEFONT=$2000401,
      AN_LAYERSLIB=$3000000,
      AN_LAYERSNOMEM=$83010000,
      AN_INTUITION=$4000000,
      AN_GADGETTYPE=$84000001,
      AN_BADGADGET=$4000001,
      AN_CREATEPORT=$84010002,
      AN_ITEMALLOC=$4010003,
      AN_SUBALLOC=$4010004,
      AN_PLANEALLOC=$84010005,
      AN_ITEMBOXTOP=$84000006,
      AN_OPENSCREEN=$84010007,
      AN_OPENSCRNRAST=$84010008,
      AN_SYSSCRNTYPE=$84000009,
      AN_ADDSWGADGET=$8401000A,
      AN_OPENWINDOW=$8401000B,
      AN_BADSTATE=$8400000C,
      AN_BADMESSAGE=$8400000D,
      AN_WEIRDECHO=$8400000E,
      AN_NOCONSOLE=$8400000F,
      AN_NOISEM=$4000010,
      AN_ISEMORDER=$4000011,
      AN_DEADINTUI=$4000012, 
      AN_MATHLIB=$5000000,
      AN_DOSLIB=$7000000,
      AN_STARTMEM=$7010001,
      AN_ENDTASK=$7000002,
      AN_QPKTFAIL=$7000003,
      AN_ASYNCPKT=$7000004,
      AN_FREEVEC=$7000005,
      AN_DISKBLKSEQ=$7000006,
      AN_BITMAP=$7000007,
      AN_KEYFREE=$7000008,
      AN_BADCHKSUM=$7000009,
      AN_DISKERROR=$700000A,
      AN_KEYRANGE=$700000B,
      AN_BADOVERLAY=$700000C,
      AN_BADINITFUNC=$700000D,
      AN_FILERECLOSED=$700000E,
      AN_CLIOBSOLETE=$700000F,
      AN_RAMLIB=$8000000,
      AN_BADSEGLIST=$8000001,
      AN_ICONLIB=$9000000,
      AN_EXPANSIONLIB=$A000000,
      AN_BADEXPANSIONFREE=$A000001,
      AN_DISKFONTLIB=$B000000,
      AN_AUDIODEV=$10000000,
      AN_CONSOLEDEV=$11000000,
      AN_NOWINDOW=$11000001,
      AN_GAMEPORTDEV=$12000000,
      AN_KEYBOARDDEV=$13000000,
      AN_TRACKDISKDEV=$14000000,
      AN_TDCALIBSEEK=$14000001,
      AN_TDDELAY=$14000002,
      AN_TIMERDEV=$15000000,
      AN_TMBADREQ=$15000001,
      AN_TMBADSUPPLY=$15000002,
      AN_CIARSRC=$20000000,
      AN_DISKRSRC=$21000000,
      AN_DRHASDISK=$21000001,
      AN_DRINTNOACT=$21000002,
      AN_MISCRSRC=$22000000,
      AN_BOOTSTRAP=$30000000,
      AN_BOOTERROR=$30000001,
      AN_WORKBENCH=$31000000,
      AN_NOFONTS=$B1000001,
      AN_WBBADSTARTUPMSG1=$31000001,
      AN_WBBADSTARTUPMSG2=$31000002,
      AN_WBBADIOMSG=$31000003,
      AN_WBRELAYOUTTOOLMENU=$B1010009,
      AN_DISKCOPY=$32000000,
      AN_GADTOOLS=$33000000,
      AN_UTILITYLIB=$34000000,
      AN_UNKNOWN=$35000000

