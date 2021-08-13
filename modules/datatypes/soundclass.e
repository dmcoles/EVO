OPT MODULE
OPT EXPORT

OPT PREPROCESS

CONST SDTA_DUMMY=$800011F4,
      SDTA_VOICEHEADER=$800011F5,
      SDTA_SAMPLE=$800011F6,
      SDTA_SAMPLELENGTH=$800011F7,
      SDTA_PERIOD=$800011F8,  -> Data for this tag is unsigned INT
      SDTA_VOLUME=$800011F9,  -> Data for this tag is unsigned INT
      SDTA_CYCLES=$800011FA,
      SDTA_SIGNALTASK=$800011FB,
      SDTA_SIGNALBIT=$800011FC,
      SDTA_CONTINUOUS=$800011FD

#define SOUNDDTCLASS 'sound.datatype'

OBJECT voiceheader
  oneshothisamples:LONG
  repeathisamples:LONG
  samplesperhicycle:LONG
  samplespersec:INT  -> This is unsigned
  octaves:CHAR
  compression:CHAR
  volume:LONG
ENDOBJECT     /* SIZEOF=20 */

CONST CMP_NONE=0,
      CMP_FIBDELTA=1,
      ID_8SVX=$38535658,
      ID_VHDR=$56484452,
      ID_BODY=$424F4459

