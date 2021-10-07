-> FlushCache.e

MODULE 'exec/ports'

OBJECT cache
  port:mp, cookie, modlist, debuginfo, lock:INT, reserved:INT, name[50]:ARRAY
ENDOBJECT

OBJECT mod
  next,memlen,stradr,strlen,moduleadr,modulelen,checksum,reserved
ENDOBJECT

PROC main()
  DEF c:PTR TO cache, m:PTR TO mod, d, find, last:PTR TO LONG
  WriteF('Emodule Cache Flush (c) 1993 $#%!\n\n')
  find:=IF arg[] THEN arg ELSE '.m'
  IF c:=FindPort('EmoduleCache')
    IF c.lock=0
      IF c.cookie=$DEADBEEF
        m:=c.modlist
        last:=c+38	-> dirty!
        WHILE m
          d:=m.next
          IF InStr(m.stradr,find)<>-1
            FreeMem(m,m.memlen)
            ^last:=d
          ELSE
            last:=m
          ENDIF
          m:=d
        ENDWHILE
        WriteF('done.\n')
      ELSE
        WriteF('Dead cookie!!!\n')
      ENDIF
    ELSE
      WriteF('Cache currently in use!\n')
    ENDIF
  ELSE
    WriteF('No module cache available.\n')
  ENDIF
ENDPROC
