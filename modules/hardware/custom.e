OPT MODULE
OPT EXPORT

CONST CUSTOMADDR=$DFF000

OBJECT audchannel
  ptr:PTR TO INT  -> Target is unsigned
  len:INT  -> This is unsigned
  per:INT  -> This is unsigned
  vol:INT  -> This is unsigned
  dat:INT  -> This is unsigned
  pad[2]:ARRAY OF INT
ENDOBJECT

OBJECT spritedef
  pos:INT  -> This is unsigned
  ctl:INT  -> This is unsigned
  dataa:INT  -> This is unsigned
  datab:INT  -> This is unsigned
ENDOBJECT

OBJECT custom
  bltdat:INT  -> This is unsigned
  dmaconr:INT  -> This is unsigned
  vposr:INT  -> This is unsigned
  vhposr:INT  -> This is unsigned
  dskdatr:INT  -> This is unsigned
  joy0dat:INT  -> This is unsigned
  joy1dat:INT  -> This is unsigned
  clxdat:INT  -> This is unsigned
  adkconr:INT  -> This is unsigned
  pot0dat:INT  -> This is unsigned
  pot1dat:INT  -> This is unsigned
  potinp:INT  -> This is unsigned
  serdatr:INT  -> This is unsigned
  dskbytr:INT  -> This is unsigned
  intenar:INT  -> This is unsigned
  intreqr:INT  -> This is unsigned
  dskpt:LONG
  dsklen:INT  -> This is unsigned
  dskdat:INT  -> This is unsigned
  refptr:INT  -> This is unsigned
  vposw:INT  -> This is unsigned
  vhposw:INT  -> This is unsigned
  copcon:INT  -> This is unsigned
  serdat:INT  -> This is unsigned
  serper:INT  -> This is unsigned
  potgo:INT  -> This is unsigned
  joytest:INT  -> This is unsigned
  strequ:INT  -> This is unsigned
  strvbl:INT  -> This is unsigned
  strhor:INT  -> This is unsigned
  strlong:INT  -> This is unsigned
  bltcon0:INT  -> This is unsigned
  bltcon1:INT  -> This is unsigned
  bltafwm:INT  -> This is unsigned
  bltalwm:INT  -> This is unsigned
  bltcpt:LONG
  bltbpt:LONG
  bltapt:LONG
  bltdpt:LONG
  bltsize:INT  -> This is unsigned
  pad2d:CHAR
  bltcon0l:CHAR
  bltsizv:INT  -> This is unsigned
  bltsizh:INT  -> This is unsigned
  bltcmod:INT  -> This is unsigned
  bltbmod:INT  -> This is unsigned
  bltamod:INT  -> This is unsigned
  bltdmod:INT  -> This is unsigned
  pad34[4]:ARRAY OF INT
  bltcdat:INT  -> This is unsigned
  bltbdat:INT  -> This is unsigned
  bltadat:INT  -> This is unsigned
  pad3b[3]:ARRAY OF INT
  deniseid:INT  -> This is unsigned
  dsksync:INT  -> This is unsigned
  cop1lc:LONG
  cop2lc:LONG
  copjmp1:INT  -> This is unsigned
  copjmp2:INT  -> This is unsigned
  copins:INT  -> This is unsigned
  diwstrt:INT  -> This is unsigned
  diwstop:INT  -> This is unsigned
  ddfstrt:INT  -> This is unsigned
  ddfstop:INT  -> This is unsigned
  dmacon:INT  -> This is unsigned
  clxcon:INT  -> This is unsigned
  intena:INT  -> This is unsigned
  intreq:INT  -> This is unsigned
  adkcon:INT  -> This is unsigned
  aud[4]:ARRAY OF audchannel
  bplpt[8]:ARRAY OF LONG
  bplcon0:INT  -> This is unsigned
  bplcon1:INT  -> This is unsigned
  bplcon2:INT  -> This is unsigned
  bplcon3:INT  -> This is unsigned
  bpl1mod:INT  -> This is unsigned
  bpl2mod:INT  -> This is unsigned
  bplcon4:INT  -> This is unsigned
  clxcon2:INT  -> This is unsigned
  bpldat[8]:ARRAY OF INT  -> Array is unsigned
  sprpt[8]:ARRAY OF LONG
  spr[8]:ARRAY OF spritedef
  color[32]:ARRAY OF INT  -> Array is unsigned
  htotal:INT  -> This is unsigned
  hsstop:INT  -> This is unsigned
  hbstrt:INT  -> This is unsigned
  hbstop:INT  -> This is unsigned
  vtotal:INT  -> This is unsigned
  vsstop:INT  -> This is unsigned
  vbstrt:INT  -> This is unsigned
  vbstop:INT  -> This is unsigned
  sprhstrt:INT  -> This is unsigned
  sprhstop:INT  -> This is unsigned
  bplhstrt:INT  -> This is unsigned
  bplhstop:INT  -> This is unsigned
  hhposw:INT  -> This is unsigned
  hhposr:INT  -> This is unsigned
  beamcon0:INT  -> This is unsigned
  hsstrt:INT  -> This is unsigned
  vsstrt:INT  -> This is unsigned
  hcenter:INT  -> This is unsigned
  diwhigh:INT  -> This is unsigned
  padf3[11]:ARRAY OF INT
  fmode:INT  -> This is unsigned
ENDOBJECT

CONST VARVBLANK=$1000,
      LOLDIS=$800,
      CSCBLANKEN=$400,
      VARVSYNC=$200,
      VARHSYNC=$100,
      VARBEAM=$80,
      DISPLAYDUAL=$40,
      DISPLAYPAL=$20,
      VARCSYNC=$10,
      CSBLANK=8,
      CSYNCTRUE=4,
      VSYNCTRUE=2,
      HSYNCTRUE=1,
      USE_BPLCON3=1,
      BPLCON2_ZDCTEN=$400,
      BPLCON2_ZDBPEN=$800,
      BPLCON2_ZDBPSEL0=$1000,
      BPLCON2_ZDBPSEL1=$2000,
      BPLCON2_ZDBPSEL2=$4000,
      BPLCON3_EXTBLNKEN=1,
      BPLCON3_EXTBLKZD=2,
      BPLCON3_ZDCLKEN=4,
      BPLCON3_BRDNTRAN=$10,
      BPLCON3_BRDNBLNK=$20

CONST BLTDDAT=0,
      DMACONR=2,
      VPOSR=4,
      VHPOSR=6,
      DSKDATR=8,
      JOY0DAT=10,
      JOY1DAT=12,
      CLXDAT=14,
      ADKCONR=16,
      POT0DAT=18,
      POT1DAT=20,
      POTINP=22,
      SERDATR=24,
      DSKBYTR=26,
      INTENAR=28,
      INTREQR=30,
      DSKPT=$20,
      DSKLEN=$24,
      DSKDAT=$26,
      REFPTR=$28,
      VPOSW=$2A,
      VHPOSW=$2C,
      COPCON=$2E,
      SERDAT=$30,
      SERPER=$32,
      POTGO=$34,
      JOYTEST=$36,
      STREQU=$38,
      STRVBL=$3A,
      STRHOR=$3C,
      STRLONG=$3E,
      BLTCON0=$40,
      BLTCON1=$42,
      BLTAFWM=$44,
      BLTALWM=$46,
      BLTCPT=$48,
      BLTBPT=$4C,
      BLTAPT=$50,
      BLTDPT=$54,
      BLTSIZE=$58,
      BLTCON0L=$5B,
      BLTSIZV=$5C,
      BLTSIZH=$5E,
      BLTCMOD=$60,
      BLTBMOD=$62,
      BLTAMOD=$64,
      BLTDMOD=$66,
      BLTCDAT=$70,
      BLTBDAT=$72,
      BLTADAT=$74,
      DENISEID=$7C,
      DSKSYNC=$7E,
      COP1LC=$80,
      COP2LC=$84,
      COPJMP1=$88,
      COPJMP2=$8A,
      COPINS=$8C,
      DIWSTRT=$8E,
      DIWSTOP=$90,
      DDFSTRT=$92,
      DDFSTOP=$94,
      DMACON=$96,
      CLXCON=$98,
      INTENA=$9A,
      INTREQ=$9C,
      ADKCON=$9E,
      AUD=$A0,
      AUD0=$A0,
      AUD1=$B0,
      AUD2=$C0,
      AUD3=$D0,
      AC_PTR=0,
      AC_LEN=4,
      AC_PER=6,
      AC_VOL=8,
      AC_DAT=10,
      AC_SIZEOF=16,
      BPLPT=$E0,
      BPLCON0=$100,
      BPLCON1=$102,
      BPLCON2=$104,
      BPLCON3=$106,
      BPL1MOD=$108,
      BPL2MOD=$10A,
      BPLCON4=$10C,
      CLXCON2=$10E,
      BPLDAT=$110,
      SPRPT=$120,
      SPR=$140,
      SD_POS=0,
      SD_CTL=2,
      SD_DATAA=4,
      SD_DATAB=6,
      SD_SIZEOF=8,
      COLOR=$180,
      HTOTAL=$1C0,
      HSSTOP=$1C2,
      HBSTRT=$1C4,
      HBSTOP=$1C6,
      VTOTAL=$1C8,
      VSSTOP=$1CA,
      VBSTRT=$1CC,
      VBSTOP=$1CE,
      SPRHSTRT=$1D0,
      SPRHSTOP=$1D2,
      BPLHSTRT=$1D4,
      BPLHSTOP=$1D6,
      HHPOSW=$1D8,
      HHPOSR=$1DA,
      BEAMCON0=$1DC,
      HSSTRT=$1DE,
      VSSTRT=$1E0,
      HCENTER=$1E2,
      DIWHIGH=$1E4,
      FMODE=$1FC

