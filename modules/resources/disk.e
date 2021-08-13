OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/interrupts',
       'exec/libraries',
       'exec/lists',
       'exec/ports',
       'exec/tasks'

OBJECT discresourceunit
  mn:mn
  discblock:is
  discsync:is
  index:is
ENDOBJECT     /* SIZEOF=86 */

OBJECT discresource
  lib:lib
  current:PTR TO discresourceunit
  flags:CHAR
  pad:CHAR
  syslib:PTR TO lib
  ciaresource:PTR TO lib
  unitid[4]:ARRAY OF LONG
  waiting:lh
  discblock:is
  discsync:is
  index:is
  currtask:PTR TO tc
ENDOBJECT     /* SIZEOF=148 */

#define DISKNAME 'disk.resource'

CONST DRB_ALLOC0=0,
      DRB_ALLOC1=1,
      DRB_ALLOC2=2,
      DRB_ALLOC3=3,
      DRB_ACTIVE=7,
      DRF_ALLOC0=1,
      DRF_ALLOC1=2,
      DRF_ALLOC2=4,
      DRF_ALLOC3=8,
      DRF_ACTIVE=$80,
      DSKDMAOFF=$4000,
      DR_ALLOCUNIT=-6,
      DR_FREEUNIT=-$c,
      DR_GETUNIT=-$12,
      DR_GIVEUNIT=-$18,
      DR_GETUNITID=-$1e,
      DR_READUNITID=-$24,
      DR_LASTCOMM=$FFFFFFDC,
      DRT_AMIGA=0,
      DRT_37422D2S=$55555555,
      DRT_EMPTY=-1,
      DRT_150RPM=$AAAAAAAA
