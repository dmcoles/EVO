OPT MODULE
OPT EXPORT

MODULE 'exec/libraries',
       'exec/lists',
       'exec/nodes',
       'exec/tasks',
       'utility/hooks'

CONST TICK_FREQ=$4B0

OBJECT conductor
  ln:ln
  reserved0:INT
  players:mlh
  clocktime:LONG
  starttime:LONG
  externaltime:LONG
  maxexternaltime:LONG
  metronome:LONG
  reserved1:INT
  flags:INT  -> This is unsigned
  state:CHAR
ENDOBJECT

CONST CONDUCTF_EXTERNAL=1,
      CONDUCTF_GOTTICK=2,
      CONDUCTF_METROSET=4,
      CONDUCTF_PRIVATE=8,
      CONDUCTB_EXTERNAL=0,
      CONDUCTB_GOTTICK=1,
      CONDUCTB_METROSET=2,
      CONDUCTB_PRIVATE=3,
      CONDSTATE_STOPPED=0,
      CONDSTATE_PAUSED=1,
      CONDSTATE_LOCATE=2,
      CONDSTATE_RUNNING=3,
      CONDSTATE_METRIC=-1,
      CONDSTATE_SHUTTLE=-2,
      CONDSTATE_LOCATE_SET=-3

OBJECT player
  ln:ln
  reserved0:CHAR
  reserved1:CHAR
  hook:PTR TO hook
  source:PTR TO conductor
  task:PTR TO tc
  metrictime:LONG
  alarmtime:LONG
  userdata:LONG
  playerid:INT  -> This is unsigned
  flags:INT  -> This is unsigned
ENDOBJECT

CONST PLAYERF_READY=1,
      PLAYERF_ALARMSET=2,
      PLAYERF_QUIET=4,
      PLAYERF_CONDUCTED=8,
      PLAYERF_EXTSYNC=16,
      PLAYERB_READY=0,
      PLAYERB_ALARMSET=1,
      PLAYERB_QUIET=2,
      PLAYERB_CONDUCTED=3,
      PLAYERB_EXTSYNC=4,
      PLAYER_BASE=$80000040,
      PLAYER_HOOK=$80000041,
      PLAYER_NAME=$80000042,
      PLAYER_PRIORITY=$80000043,
      PLAYER_CONDUCTOR=$80000044,
      PLAYER_READY=$80000045,
      PLAYER_ALARMTIME=$8000004c,
      PLAYER_ALARM=$8000004d,
      PLAYER_ALARMSIGTASK=$80000046,
      PLAYER_ALARMSIGBIT=$80000048,
      PLAYER_CONDUCTED=$80000047,
      PLAYER_QUIET=$80000049,
      PLAYER_USERDATA=$8000004A,
      PLAYER_ID=$8000004B,
      PLAYER_EXTSYNC=$8000004E,
      PLAYER_ERRORCODE=$8000004F,
      PM_TICK=0,
      PM_STATE=1,
      PM_POSITION=2,
      PM_SHUTTLE=3

OBJECT pmtime
  method:LONG
  time:LONG
ENDOBJECT

OBJECT pmstate
  method:LONG
  oldstate:LONG
ENDOBJECT

CONST RT_CONDUCTORS=0,
      RTE_NOMEMORY=$321,
      RTE_NOCONDUCTOR=$322,
      RTE_NOTIMER=$323,
      RTE_PLAYING=$324

OBJECT realtimebase
  lib:lib
  reserved0[2]:ARRAY
  time:LONG
  timefrac:LONG
  reserved1:INT
  tickerr:INT
ENDOBJECT

CONST REALTIME_TICKERR_MIN=-$2C1,
      REALTIME_TICKERR_MAX=$2C1

