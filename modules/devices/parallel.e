  OPT MODULE
  OPT EXPORT

  OPT PREPROCESS

  MODULE 'exec/io'

CONST PARERR_DEVBUSY=1,
      PARERR_BUFTOOBIG=2,
      PARERR_INVPARAM=3,
      PARERR_LINEERR=4,
      PARERR_NOTOPEN=5,
      PARERR_PORTRESET=6,
      PARERR_INITERR=7,
      PDCMD_QUERY=9,
      PDCMD_SETPARAMS=10,
      PAR_DEVFINISH=10,
      PARB_SHARED=5,
      PARF_SHARED=$20,
      PARB_SLOWMODE=4,
      PARF_SLOWMODE=16,
      PARB_FASTMODE=3,
      PARF_FASTMODE=8,
      PARB_RAD_BOOGIE=3,
      PARF_RAD_BOOGIE=8,
      PARB_ACKMODE=2,
      PARF_ACKMODE=4,
      PARB_EOFMODE=1,
      PARF_EOFMODE=2,
      IOPARB_QUEUED=6,
      IOPARF_QUEUED=$40,
      IOPARB_ABORT=5,
      IOPARF_ABORT=$20,
      IOPARB_ACTIVE=4,
      IOPARF_ACTIVE=16,
      IOPTB_RWDIR=3,
      IOPTF_RWDIR=8,
      IOPTB_PARSEL=2,
      IOPTF_PARSEL=4,
      IOPTB_PAPEROUT=1,
      IOPTF_PAPEROUT=2,
      IOPTB_PARBUSY=0,
      IOPTF_PARBUSY=1

#define PARALLELNAME 'parallel.device'

OBJECT ioparray
-> Um, names were wrong and illegal
  ptermarray0:LONG
  ptermarray1:LONG
ENDOBJECT     /* SIZEOF=8 */

OBJECT ioextpar
  iostd:iostd
  pextflags:LONG
  parstatus:CHAR
  parflags:CHAR
  ptermarray:ioparray
ENDOBJECT     /* SIZEOF=62 */
