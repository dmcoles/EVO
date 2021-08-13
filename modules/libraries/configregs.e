OPT MODULE
OPT EXPORT

OPT PREPROCESS

OBJECT expansionrom
  type:CHAR
  product:CHAR
  flags:CHAR
  reserved03:CHAR
  manufacturer:INT  -> This is unsigned
  serialnumber:LONG
  initdiagvec:INT  -> This is unsigned
  reserved0c:CHAR
  reserved0d:CHAR
  reserved0e:CHAR
  reserved0f:CHAR
ENDOBJECT     /* SIZEOF=16 */

OBJECT expansioncontrol
  interrupt:CHAR
  z3_highbase:CHAR
  baseaddress:CHAR
  shutup:CHAR
  reserved14:CHAR
  reserved15:CHAR
  reserved16:CHAR
  reserved17:CHAR
  reserved18:CHAR
  reserved19:CHAR
  reserved1a:CHAR
  reserved1b:CHAR
  reserved1c:CHAR
  reserved1d:CHAR
  reserved1e:CHAR
  reserved1f:CHAR
ENDOBJECT     /* SIZEOF=16 */

CONST E_SLOTSIZE=$10000,
      E_SLOTMASK=$FFFF,
      E_SLOTSHIFT=16,
      E_EXPANSIONBASE=$E80000,
      EZ3_EXPANSIONBASE=$FF000000,
      E_EXPANSIONSIZE=$80000,
      E_EXPANSIONSLOTS=8,
      E_MEMORYBASE=$200000,
      E_MEMORYSIZE=$800000,
      E_MEMORYSLOTS=$80,
      EZ3_CONFIGAREA=$40000000,
      EZ3_CONFIGAREAEND=$7FFFFFFF,
      EZ3_SIZEGRANULARITY=$80000,
      ERT_TYPEMASK=$C0,
      ERT_TYPEBIT=6,
      ERT_TYPESIZE=2,
      ERT_NEWBOARD=$C0,
      ERT_ZORROII=$C0,
      ERT_ZORROIII=$80,
      ERTB_MEMLIST=5,
      ERTB_DIAGVALID=4,
      ERTB_CHAINEDCONFIG=3,
      ERTF_MEMLIST=$20,
      ERTF_DIAGVALID=16,
      ERTF_CHAINEDCONFIG=8,
      ERT_MEMMASK=7,
      ERT_MEMBIT=0,
      ERT_MEMSIZE=3,
      ERFB_MEMSPACE=7,
      ERFB_NOSHUTUP=6,
      ERFB_EXTENDED=5,
      ERFB_ZORRO_III=4,
      ERFF_MEMSPACE=$80,
      ERFF_NOSHUTUP=$40,
      ERFF_EXTENDED=$20,
      ERFF_ZORRO_III=16,
      ERT_Z3_SSMASK=15,
      ERT_Z3_SSBIT=0,
      ERT_Z3_SSSIZE=4,
      ECIB_INTENA=1,
      ECIB_RESET=3,
      ECIB_INT2PEND=4,
      ECIB_INT6PEND=5,
      ECIB_INT7PEND=6,
      ECIB_INTERRUPTING=7,
      ECIF_INTENA=2,
      ECIF_RESET=8,
      ECIF_INT2PEND=16,
      ECIF_INT6PEND=$20,
      ECIF_INT7PEND=$40,
      ECIF_INTERRUPTING=$80

#define ERT_MEMNEEDED(t) (IF (t) AND ERT_MEMMASK THEN Shl($10000, ((t) AND ERT_MEMMASK)-1) ELSE $800000)
#define ERT_SLOTSNEEDED(t) (IF (t) AND ERT_MEMMASK THEN Shl(1, ((t) AND ERT_MEMMASK)-1) ELSE $80)
#define EC_MEMADDR(slot) (Shl((slot), E_SLOTSHIFT))

OBJECT diagarea
  config:CHAR
  flags:CHAR
  size:INT  -> This is unsigned
  diagpoint:INT  -> This is unsigned
  bootpoint:INT  -> This is unsigned
  name:INT  -> This is unsigned
  reserved01:INT
  reserved02:INT
ENDOBJECT     /* SIZEOF=14 */

CONST DAC_BUSWIDTH=$C0,
      DAC_NIBBLEWIDE=0,
      DAC_BYTEWIDE=$40,
      DAC_WORDWIDE=$80,
      DAC_BOOTTIME=$30,
      DAC_NEVER=0,
      DAC_CONFIGTIME=16,
      DAC_BINDTIME=$20

