OPT MODULE
OPT EXPORT

MODULE 'exec/io'

CONST DEFPITCH=$6E,
      DEFRATE=$96,
      DEFVOL=$40,
      DEFFREQ=$56B8,
      NATURALF0=0,
      ROBOTICF0=1,
      MANUALF0=2,
      MALE=0,
      FEMALE=1,
      DEFSEX=0,
      DEFMODE=0,
      DEFARTIC=$64,
      DEFCENTRAL=0,
      DEFF0PERT=0,
      DEFF0ENTHUS=$20,
      DEFPRIORITY=$64,
      MINRATE=$28,
      MAXRATE=$190,
      MINPITCH=$41,
      MAXPITCH=$140,
      MINFREQ=$1388,
      MAXFREQ=$6D60,
      MINVOL=0,
      MAXVOL=$40,
      MINCENT=0,
      MAXCENT=$64,
      ND_NOTUSED=-1,
      ND_NOMEM=-2,
      ND_NOAUDLIB=-3,
      ND_MAKEBAD=-4,
      ND_UNITERR=-5,
      ND_CANTALLOC=-6,
      ND_UNIMPL=-7,
      ND_NOWRITE=-8,
      ND_EXPUNGED=-9,
      ND_PHONERR=-20,
      ND_RATEERR=-21,
      ND_PITCHERR=-22,
      ND_SEXERR=-23,
      ND_MODEERR=-24,
      ND_FREQERR=-25,
      ND_VOLERR=-26,
      ND_DCENTERR=-27,
      ND_CENTPHONERR=-28,
      NDB_NEWIORB=0,
      NDB_WORDSYNC=1,
      NDB_SYLSYNC=2,
      NDF_NEWIORB=1,
      NDF_WORDSYNC=2,
      NDF_SYLSYNC=4

OBJECT ndi
  iostd:iostd
  rate:INT  -> This is unsigned
  pitch:INT  -> This is unsigned
  mode:INT  -> This is unsigned
  sex:INT  -> This is unsigned
  chmasks:PTR TO CHAR
  nummasks:INT  -> This is unsigned
  volume:INT  -> This is unsigned
  sampfreq:INT  -> This is unsigned
  mouths:CHAR
  chanmask:CHAR
  numchan:CHAR
  flags:CHAR
  f0enthusiasm:CHAR
  f0perturb:CHAR
  f1adj:CHAR  -> This is signed
  f2adj:CHAR  -> This is signed
  f3adj:CHAR  -> This is signed
  a1adj:CHAR  -> This is signed
  a2adj:CHAR  -> This is signed
  a3adj:CHAR  -> This is signed
  articulate:CHAR
  centralize:CHAR
  centphon:PTR TO CHAR
  avbias:CHAR  -> This is signed
  afbias:CHAR  -> This is signed
  priority:CHAR  -> This is signed
  pad1:CHAR
ENDOBJECT     /* SIZEOF=88 */

OBJECT mrb
  ndi:ndi
  width:CHAR
  height:CHAR
  shape:CHAR
  sync:CHAR
ENDOBJECT     /* SIZEOF=92 */

