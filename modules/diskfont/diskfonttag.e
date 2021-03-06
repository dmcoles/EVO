  OPT MODULE
  OPT EXPORT

  OPT PREPROCESS

#define OTSUFFIX '.otag'
#define OTE_BULLET 'bullet'

CONST OT_LEVEL0=$80000000,
      OT_LEVEL1=$80001000,
      OT_LEVEL2=$80002000,
      OT_LEVEL3=$80003000,
      OT_INDIRECT=$8000,
      OT_DEVICEDPI=$80000001,
      OT_DOTSIZE=$80000002,
      OT_POINTHEIGHT=$80000008,
      OT_SETFACTOR=$80000009,
      OT_SHEARSIN=$8000000A,
      OT_SHEARCOS=$8000000B,
      OT_ROTATESIN=$8000000C,
      OT_ROTATECOS=$8000000D,
      OT_EMBOLDENX=$8000000E,
      OT_EMBOLDENY=$8000000F,
      OT_POINTSIZE=$80000010,
      OT_GLYPHCODE=$80000011,
      OT_GLYPHCODE2=$80000012,
      OT_GLYPHWIDTH=$80000013,
      OT_OTAGPATH=$80008014,
      OT_OTAGLIST=$80008015,
      OT_GLYPHMAP=$80008020,
      OT_WIDTHLIST=$80008021,
      OT_TEXTKERNPAIR=$80008022,
      OT_DESIGNKERNPAIR=$80008023,
      OT_UNDERLINED=$80000024,  -> Data for this tag is unsigned INT
      OTUL_NONE=0,
      OTUL_SOLID=1,
      OTUL_BROKEN=2,
      OTUL_DOUBLESOLID=3,
      OUTL_DOUBLEBROKEN=4,
      OT_STRIKETHROUGH=$80000025,
      OT_FILEIDENT=$80001001,
      OT_ENGINE=$80009002,
      OT_FAMILY=$80009003,
      OT_BNAME=$8000A005,
      OT_INAME=$8000A006,
      OT_BINAME=$8000A007,
      OT_SYMBOLSET=$80001010,
      OT_YSIZEFACTOR=$80001011,
      OT_SPACEWIDTH=$80002012,
      OT_ISFIXED=$80002013,
      OT_SERIFFLAG=$80001014,
      OT_STEMWEIGHT=$80001015,
      OTS_ULTRATHIN=8,
      OTS_EXTRATHIN=24,
      OTS_THIN=$28,
      OTS_EXTRALIGHT=$38,
      OTS_LIGHT=$48,
      OTS_DEMILIGHT=$58,
      OTS_SEMILIGHT=$68,
      OTS_BOOK=$78,
      OTS_MEDIUM=$88,
      OTS_SEMIBOLD=$98,
      OTS_DEMIBOLD=$A8,
      OTS_BOLD=$B8,
      OTS_EXTRABOLD=$C8,
      OTS_BLACK=$D8,
      OTS_EXTRABLACK=$E8,
      OTS_ULTRABLACK=$F8,
      OT_SLANTSTYLE=$80001016,
      OTS_UPRIGHT=0,
      OTS_ITALIC=1,
      OTS_LEFTITALIC=2,
      OT_HORIZSTYLE=$80001017,
      OTH_ULTRACOMPRESSED=16,
      OTH_EXTRACOMPRESSED=$30,
      OTH_COMPRESSED=$50,
      OTH_CONDENSED=$70,   
      OTH_NORMAL=$90,
      OTH_SEMIEXPANDED=$B0,
      OTH_EXPANDED=$D0,
      OTH_EXTRAEXPANDED=$F0,
      OT_SPACEFACTOR=$80002018,
      OT_INHIBITALGOSTYLE=$80002019,
      OT_ISUNDERLINED=$80002023,
      OT_AVAILSIZES=$80009020,
      OT_RNAME=$8000A009,
      OT_MAXAVAILSIZES=20,
      OT_SPECCOUNT=$80001100,
      OT_SPEC=$80001100,
      OT_SPEC1=$80001101,
      DFCTRL_BASE=$8B000000,
      DFCTRL_XDPI=$8B000001,
      DFCTRL_YDPI=$8B000002,
      DFCTRL_XDOTP=$8B000003,
      DFCTRL_YDOTP=$8B000004,
      DFCTRL_CACHE=$8B000005,
      DFCTRL_SORTMODE=$8B000006,
      DFCTRL_SORT_OFF=0,
      DFCTRL_SORT_ASC=1,
      DFCTRL_SORT_DES=-1,
      DFCTRL_CACHEFLUSH=$8B000007,
      DFCTRL_CHARSET=$8B000008,
      DFCS_NUMBER=$8B000000,
      DFCS_NEXTNUMBER=$8B000001,
      DFCS_NAME=$8B000002,
      DFCS_MIMENAME=$8B000003,
      DFCS_MAPTABLE=$8B000004

