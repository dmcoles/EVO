OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/interrupts',
       'exec/nodes'

#define CARDRESNAME 'card.resource'

OBJECT cardhandle
  cardnode:ln
  cardremoved:PTR TO is
  cardinserted:PTR TO is
  cardstatus:PTR TO is
  cardflags:CHAR
ENDOBJECT     /* SIZEOF=27 */

OBJECT devicetdata
  dtsize:LONG
  dtspeed:LONG
  dttype:CHAR
  dtflags:CHAR
ENDOBJECT     /* SIZEOF=10 */

OBJECT cardmemorymap
  commonmemory:PTR TO CHAR
  attributememory:PTR TO CHAR
  iomemory:PTR TO CHAR
  commonmemsize:LONG
  attributememsize:LONG
  iomemsize:LONG
ENDOBJECT     /* SIZEOF=12 */

CONST CARDB_RESETREMOVE=0,
      CARDF_RESETREMOVE=1,
      CARDB_IFAVAILABLE=1,
      CARDF_IFAVAILABLE=2,
      CARDB_DELAYOWNERSHIP=2,
      CARDF_DELAYOWNERSHIP=4,
      CARDB_POSTSTATUS=3,
      CARDF_POSTSTATUS=8,
      CARDB_REMOVEHANDLE=0,
      CARDF_REMOVEHANDLE=1,
      CARD_STATUSB_CCDET=6,
      CARD_STATUSF_CCDET=$40,
      CARD_STATUSB_BVD1=5,
      CARD_STATUSF_BVD1=$20,
      CARD_STATUSB_SC=5,
      CARD_STATUSF_SC=$20,
      CARD_STATUSB_BVD2=4,
      CARD_STATUSF_BVD2=16,
      CARD_STATUSB_DA=4,
      CARD_STATUSF_DA=16,
      CARD_STATUSB_WR=3,
      CARD_STATUSF_WR=8,
      CARD_STATUSB_BSY=2,
      CARD_STATUSF_BSY=4,
      CARD_STATUSB_IRQ=2,
      CARD_STATUSF_IRQ=4,
      CARD_VOLTAGE_0V=0,
      CARD_VOLTAGE_5V=1,
      CARD_VOLTAGE_12V=2,
      CARD_ENABLEB_DIGAUDIO=1,
      CARD_ENABLEF_DIGAUDIO=2,
      CARD_DISABLEB_WP=3,
      CARD_DISABLEF_WP=8,
      CARD_INTERFACE_AMIGA_0=0,
      CARD_INTB_SETCLR=7,
      CARD_INTF_SETCLR=128,
      CARD_INTB_BVD1=5,
      CARD_INTF_BVD1=32,
      CARD_INTB_SC=5,
      CARD_INTF_SC=32,
      CARD_INTB_BVD2=4,
      CARD_INTF_BVD2=16,
      CARD_INTB_DA=4,
      CARD_INTF_DA=16,
      CARD_INTB_BSY=2,
      CARD_INTF_BSY=4,
      CARD_INTB_IRQ=2,
      CARD_INTF_IRQ=4,
      CISTPL_AMIGAXIP=$91

OBJECT amigaxip
-> Um, this was all wrong
  code:CHAR
  link:CHAR
  xiploc[4]:ARRAY
  xipflags:CHAR
  xipresrv:CHAR
ENDOBJECT     /* SIZEOF=8 */

CONST XIPFLAGB_AUTORUN=0,
      XIPFLAGF_AUTORUN=1

