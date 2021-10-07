-> ShowCache.e

MODULE 'exec/ports'

OBJECT cache
  port:mp, cookie, modlist, debuginfo, lock:INT, reserved:INT, name[50]:ARRAY
ENDOBJECT

OBJECT mod
  next,memlen,stradr,strlen,moduleadr,modulelen,checksum,reserved
ENDOBJECT

PROC main()
  DEF c:PTR TO cache, m:PTR TO mod, total=0, x
  WriteF('Emodule Cache Show (c) 1993 $#%!\n')
  IF c:=FindPort('EmoduleCache')
    IF c.lock=0
      IF c.cookie=$DEADBEEF
        m:=c.modlist
        IF m
          WriteF('\nsize    name\n------- -----------------------------------\n')
          WHILE m
            WriteF('\d[7] \s\n',m.modulelen,m.stradr)
            total:=total+m.modulelen+SIZEOF mod+StrLen(m.stradr)+8
            m:=m.next
            IF CtrlC() THEN m:=NIL
          ENDWHILE
          WriteF('\nTotal memory occupied by cached E-modules: \d bytes.\n',total)
        ELSE
          WriteF('\nEmpty cache.\n')
        ENDIF
      ELSE
        WriteF('\nDead cookie.\n')
      ENDIF
    ELSE
      WriteF('Cache currently in use!\n')
    ENDIF
  ELSE
    WriteF('\nNo module cache available.\n')
  ENDIF
ENDPROC
