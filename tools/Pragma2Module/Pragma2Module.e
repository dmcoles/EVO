/* Pragma2Module
   convert a SAS/C library pragma file to an E module.
   Usage: p2m <file>
   converts <file.h> to <file.m>                                  */
   
ENUM INPUT_ERROR=10,OUTPUT_ERROR,FORMAT_ERROR

DEF cfh,efh,eof,
    gotbase=FALSE,
    offset=30,
    cfile[200]:STRING,
    efile[200]:STRING,
    cstring[200]:STRING

PROC main()
  StrCopy(cfile,arg,ALL)
  StrAdd(cfile,'.h',ALL)
  StrCopy(efile,arg,ALL)
  StrAdd(efile,'.m',ALL)
  WriteF('Amiga E Pragma2Module by $#%! in 1992\nconverting: "\s"\n',cfile)
  IF (cfh:=Open(cfile,OLDFILE))=0 THEN closeall(INPUT_ERROR)
  IF (efh:=Open(efile,NEWFILE))=0 THEN closeall(OUTPUT_ERROR)
  REPEAT
    eof:=ReadStr(cfh,cstring)
    convert(cstring)
  UNTIL eof
  Write(efh,[$FF,0,0,0]:CHAR,4)
  WriteF('last offset: -\d\n',offset)
  WriteF('Done.\n')
  closeall(0)
ENDPROC

PROC closeall(er)
  IF cfh<>0 THEN Close(cfh)
  IF efh<>0 THEN Close(efh)
  SELECT er
    CASE INPUT_ERROR;  WriteF('Could not open input file!\n')
    CASE OUTPUT_ERROR; WriteF('Could not open output file!\n')
    CASE FORMAT_ERROR; WriteF('Pragma file format error!\n')
  ENDSELECT
  CleanUp(er)
ENDPROC

/* format of line to convert:
   #pragma libcall <lib>Base <funcname> <hexoffset> <regsused>     */

PROC convert(str)
  DEF pos,pos2,off2,len,narg,a,empty,dstr[50]:STRING,basestr[50]:STRING
  DEF funcstr[50]:STRING,regstr[20]:STRING
  IF StrCmp(str,'#pragma libcall ',STRLEN)        /* just those lines */
    pos:=STRLEN
    pos2:=InStr(str,' ',pos)                      /* find base */
    IF pos2=-1 THEN closeall(FORMAT_ERROR)
    IF gotbase=FALSE                              /* get base */
      gotbase:=TRUE
      MidStr(basestr,str,pos,pos2-pos)
      LowerStr(basestr)
      WriteF('Base will be: \s\n',basestr)
      Write(efh,["EM","OD",6]:INT,6)
      Out(efh,0)
      Write(efh,basestr,EstrLen(basestr)+1)
    ENDIF
    pos:=pos2+1
    pos2:=InStr(str,' ',pos)                 /* find func */
    IF pos2=-1 THEN closeall(FORMAT_ERROR)
    MidStr(funcstr,str,pos,pos2-pos)
    IF (funcstr[0]>="a") AND (funcstr[0]<="z") THEN funcstr[0]:=funcstr[0]-32  /* Func, not fUnc */
    IF (funcstr[1]>="A") AND (funcstr[1]<="Z") THEN funcstr[1]:=funcstr[1]+32
    str[pos2]:="$"
    UpperStr(str+pos2)
    off2:=Val(str+pos2,NIL)                      /* get offset */
    IF off2=0 THEN closeall(FORMAT_ERROR)
    empty:=0
    WHILE off2<>offset
      Out(efh,16)                     /* "empty function slots" */
      offset:=offset+6
      INC empty
      IF offset>off2 THEN closeall(FORMAT_ERROR)
    ENDWHILE
    IF empty>0 THEN  WriteF('found \d empty or private functions before -\d.\n',empty,offset)
    pos2:=InStr(str,' ',pos2+1)              /* find offset/regs */
    IF pos2=-1 THEN closeall(FORMAT_ERROR)
    pos:=pos2+1
    MidStr(dstr,str,pos,ALL)
    Write(efh,funcstr,EstrLen(funcstr))
    len:=EstrLen(dstr)
    narg:=Val(dstr+len-1,NIL)
    IF len>2
      IF len-2<narg THEN StrCopy(regstr,'0',ALL)
      StrAdd(regstr,dstr,len-2)
    ELSE
      StrCopy(regstr,'',ALL)
    ENDIF
    len:=EstrLen(regstr)
    StrCopy(dstr,'$ ',ALL)
    IF len>0
      FOR a:=1 TO len
        dstr[1]:=regstr[len-a]
        Out(efh,Val(dstr,NIL))
      ENDFOR
    ELSE
      IF narg=0 THEN Out(efh,16) ELSE Out(efh,0)
    ENDIF
    offset:=offset+6
  ENDIF
ENDPROC
