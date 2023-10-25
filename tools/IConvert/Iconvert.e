/* Iconvert.e

   This little utility converts a '.i' assembly include file
   into an E binary module.
   it understands '=' and 'EQU' for constant definitions, and builds
   OBJECTs out of STRUCTURE definitions (from "exec/types.i").
   it needs a macroassembler like A68k to run.
   USAGE: iconvert <.ifile>       */

OBJECT def
  type:INT,name
ENDOBJECT

ENUM T_ARRAY,T_CHAR,T_INT,T_LONG=4,T_CONST=$10,T_STRUCT,T_END
ENUM ER_NONE,ER_IN,ER_OUT,ER_MEM,ER_WORK,ER_BREAK,ER_FORM,ER_TEMPW,
     ER_INVOKE,ER_TEMPR,ER_OFORM,ER_I

CONST MAX_DEF=2500,IDMAX=10

DEF defs[MAX_DEF]:ARRAY OF def,
    infile[100]:STRING,outfile[100]:STRING,
    handle=NIL,flen,buf,bbuf,defn=0,line=0,mode=0,a,phx=FALSE

PROC main()
  WriteF('Iconvert v0.2 1992 $#%!\n\n')
  readinfile()
  collectidents()
  makeasmfile()
  invokea68k()
  readbinary()
  makemodule()
  error(ER_NONE)
ENDPROC

PROC readinfile()
  DEF len
  IF (arg[0]="-") AND (arg[1]="p") AND (arg[2]=" ")
    arg:=arg+3
    phx:=TRUE
  ENDIF
  StrCopy(infile,arg,ALL)
  len:=EstrLen(infile)-2
  IF infile[len]<>"." THEN error(ER_I)
  StrCopy(outfile,arg,ALL); outfile[len+1]:="m"
  IF (flen:=FileLength(infile))<1 THEN error(ER_IN)
  IF (buf:=New(flen+1))=NIL THEN error(ER_MEM)
  buf[flen]:=10
  IF (handle:=Open(infile,OLDFILE))=NIL THEN error(ER_IN)
  IF Read(handle,buf,flen)<>flen THEN error(ER_IN)
  Close(handle); handle:=NIL
ENDPROC

PROC collectidents()
  DEF p,a,id[IDMAX]:ARRAY OF LONG,num,f,c,end,zero=NIL,macro=FALSE
  DEF struct=FALSE,d:PTR TO def,size,work[10]:STRING
  WriteF('Now trying to convert "\s".\n',infile)
  INC line; p:=buf; end:=p+flen; d:=defs
  WHILE p<end
    FOR a:=0 TO IDMAX-1 DO id[a]:=0
    num:=0; f:=TRUE
    WHILE f
      c:=p[]++
      IF zero; zero[]:=0; zero:=NIL; ENDIF
      IF (c=10) OR (c=0)
        f:=FALSE
      ELSEIF (c<=" ") OR (c=",")
      ELSEIF (c=";") OR (c="*")
        f:=FALSE
        WHILE p[]++<>10 DO NOP
      ELSE
        id[num]:=p-1
        WHILE ((c:=p[]++)>" ") AND (c<>",") AND (c<>";") DO NOP
        p--; zero:=p
        IF num++=IDMAX THEN error(ER_WORK)
      ENDIF
    ENDWHILE
    IF num
      size:=-1
      IF StrCmp(id[1],'MACRO',ALL)
        macro:=TRUE
      ELSEIF StrCmp(id[1],'EQU',ALL) OR StrCmp(id[1],'=',ALL) OR StrCmp(id[1],'equ',ALL)
        IF macro=FALSE
          d.type:=T_CONST
          d.name++:=id[0]
          defn++
        ENDIF
      ELSEIF StrCmp(id[0],'STRUCTURE',ALL)
        struct:=TRUE
        d.type:=T_STRUCT
        d.name++:=id[1]
        defn++
        IF (InStr(id[2],'SIZEOF',0)<>-1) OR (InStr(id[2],'SIZE',0)<>-1)
          IF defn>=MAX_DEF THEN error(ER_WORK)
          d.type:=T_ARRAY
          c:=InStr(id[2],'_',0)
          IF c<>-1 THEN PutChar(id[2]+c,0)
          d.name++:=id[2]
          defn++
	ELSEIF (Val(id[2],{c})<>0) OR (c=0)
          WriteF('WARNING: object "\s" does not start at offset 0\n',id[1])
        ENDIF
      ELSEIF StrCmp(id[0],'LABEL',ALL)
        IF struct=FALSE THEN error(ER_FORM)
        IF (InStr(id[1],'SIZEOF',0)<>-1) OR (InStr(id[1],'SIZE',0)<>-1)
          struct:=FALSE
          d.type:=T_END
          d.name++:=id[1]
          defn++
        ENDIF
      ELSEIF StrCmp(id[0],'BYTE',ALL); size:=1
      ELSEIF StrCmp(id[0],'UBYTE',ALL); size:=1
      ELSEIF StrCmp(id[0],'WORD',ALL); size:=2
      ELSEIF StrCmp(id[0],'UWORD',ALL); size:=2
      ELSEIF StrCmp(id[0],'SHORT',ALL); size:=2
      ELSEIF StrCmp(id[0],'USHORT',ALL); size:=2
      ELSEIF StrCmp(id[0],'LONG',ALL); size:=4
      ELSEIF StrCmp(id[0],'ULONG',ALL); size:=4
      ELSEIF StrCmp(id[0],'APTR',ALL); size:=4
      ELSEIF StrCmp(id[0],'BPTR',ALL); size:=4
      ELSEIF StrCmp(id[0],'CPTR',ALL); size:=4
      ELSEIF StrCmp(id[0],'BSTR',ALL); size:=4
      ELSEIF StrCmp(id[0],'BOOL',ALL); size:=2
      ELSEIF StrCmp(id[0],'FPTR',ALL); size:=4
      ELSEIF StrCmp(id[0],'STRUCT',ALL); size:=0
      ELSEIF StrCmp(id[1],'MACRO',ALL)
        macro:=TRUE
      ELSEIF StrCmp(id[0],'ENDM',ALL)
        macro:=FALSE
      ELSEIF StrCmp(id[0],'BITDEF',ALL)     /* depends on correctness */
        c:=id[1]-1
        FOR a:=1 TO id[2]-id[1]-1 DO c[]++:=c[1]
        c[]++:="F"; c[]++:="_"
        d.type:=T_CONST
        d.name++:=id[1]-1
        defn++
      ELSEIF StrCmp(id[0],'EITEM',ALL)
        d.type:=T_CONST
        d.name++:=id[1]
        defn++
      ELSEIF StrCmp(id[0],'DEVCMD',ALL)
        d.type:=T_CONST
        d.name++:=id[1]
        defn++
      ELSEIF StrCmp(id[1],'SET',ALL) OR StrCmp(id[0],'IFND',ALL) OR StrCmp(id[0],'ENDC',ALL) OR StrCmp(id[0],'INCLUDE',ALL) OR StrCmp(id[0],'ENUM',ALL) OR StrCmp(id[0],'LIBENT',ALL) OR StrCmp(id[0],'LIBINIT',ALL) OR StrCmp(id[0],'LIBDEF',ALL) OR StrCmp(id[0],'DEVINIT',ALL) OR StrCmp(id[0],'FUNCDEF',ALL) OR StrCmp(id[0],'include',ALL) OR StrCmp(id[0],'IFD',ALL)
      ELSE
        IF macro=FALSE THEN error(ER_FORM)
      ENDIF
      IF size<>-1
        IF (InStr(id[1],'Kludge',0)<>-1)       /* ask for deletion */
          WriteF('Skip member "\s" (y/n)? >',id[1])
          Read(stdout,work,2)
          c:=work[0]
        ELSE
          c:=0
        ENDIF
        IF (c<>"y") AND (macro=FALSE)
          IF struct=FALSE THEN error(ER_FORM)
          IF size=1 THEN d.type:=T_CHAR ELSE IF size=2 THEN d.type:=T_INT ELSE IF size=4 THEN d.type:=T_LONG ELSE d.type:=T_ARRAY
          d.name++:=id[1]
          defn++
        ENDIF
      ENDIF
      IF defn>=MAX_DEF THEN error(ER_WORK)
    ENDIF
    IF CtrlC() THEN error(ER_BREAK)
    IF (line AND $F)=0 THEN WriteF('line=\d\b',line)
    INC line
  ENDWHILE
  line:=0
ENDPROC

PROC makeasmfile()
  DEF a,oldout,d:PTR TO def
  IF (handle:=Open('ram:iconvert.s',NEWFILE))=NIL THEN error(ER_TEMPW)
  IF defn=0 THEN error(ER_FORM)
  d:=defs
  oldout:=SetStdOut(handle)
  IF phx THEN WriteF(' TTL ""\n')
  WriteF(' INCLUDE "\s"\n\n',infile)
  FOR a:=1 TO defn
    WriteF(' DC.L \s\n',d.name++)
  ENDFOR
  WriteF('\n END\n')
  SetStdOut(oldout)
  Close(handle); handle:=NIL
ENDPROC

PROC invokea68k()
  IF phx
    IF Execute('SmallPhxAss I INCLUDES: FROM ram:iconvert.s noexe opt 0',NIL,stdout)=FALSE THEN error(ER_INVOKE)
  ELSE
    IF Execute('A68k -iINCLUDES: ram:iconvert.s',NIL,stdout)=FALSE THEN error(ER_INVOKE)
  ENDIF
ENDPROC

PROC readbinary()
  DEF bsize
  bsize:=defn*4+32
  IF FileLength('ram:iconvert.o')<>bsize THEN error(ER_TEMPR)
  bbuf:=New(bsize)
  IF bbuf=NIL THEN error(ER_MEM)
  IF (handle:=Open('ram:iconvert.o',OLDFILE))=NIL THEN error(ER_TEMPR)
  IF Read(handle,bbuf,bsize)<>bsize THEN error(ER_TEMPR)
  Close(handle); handle:=NIL
ENDPROC

PROC makemodule()
  DEF v:PTR TO LONG,work[3]:ARRAY OF INT,d:PTR TO def,l,x,obj=NIL
  v:=bbuf+28; d:=defs
  IF (handle:=Open(outfile,NEWFILE))=NIL THEN error(ER_OUT)
  Write(handle,'EMOD',4)
  FOR a:=1 TO defn
    IF d.type=T_CONST
      IF mode=2 THEN endobj(obj)
      IF mode=0 THEN Write(handle,[1]:INT,2)
      l:=StrLen(d.name)+1
      work[0]:=IF Odd(l) THEN l+1 ELSE l
      PutLong(work+2,v[]++)
      Write(handle,work,6)
      UpperStr(d.name)
      Write(handle,d.name++,l)
      IF Odd(l) THEN Write(handle,'',1)
      mode:=1
    ELSEIF d.type=T_END
      IF mode<>2 THEN error(ER_OFORM)
      mode:=0
      Write(handle,[0,v[]++]:INT,4)
      d++
    ELSE
      IF (mode=2) AND (d.type=T_STRUCT) THEN endobj(obj)
      IF mode=1 THEN Write(handle,[0]:INT,2)
      IF mode<>2
        Write(handle,[2]:INT,2)
        IF d.type<>T_STRUCT THEN error(ER_OFORM)
        obj:=d.name
      ENDIF
      work[1]:=IF d.type=T_STRUCT THEN -1 ELSE d.type
      work[2]:=v[]++
      x:=InStr(d.name,'_',0)
      IF x<>-1 THEN d.name:=d.name+x+1
      LowerStr(d.name)
      l:=StrLen(d.name)+1
      work[0]:=IF Odd(l) THEN l+1 ELSE l
      Write(handle,work,6)
      Write(handle,d.name++,l)
      IF Odd(l) THEN Write(handle,'',1)
      mode:=2
    ENDIF
  ENDFOR
  IF mode=2 THEN endobj(obj)
  IF mode=1 THEN Write(handle,[0]:INT,2)
  Close(handle); handle:=NIL
ENDPROC

PROC endobj(obj)
  Write(handle,[0,-1]:INT,4)
  WriteF('WARNING: object "\s" has no SIZE\n',obj)
  mode:=0
ENDPROC

PROC error(er)
  IF handle THEN Close(handle)
  SELECT er
    CASE ER_NONE;   WriteF('Done.\n')
    CASE ER_IN;     WriteF('Could not read "\s"\n',infile)
    CASE ER_OUT;    WriteF('Could not write "\s"\n',outfile)
    CASE ER_MEM;    WriteF('Could not allocate memory\n')
    CASE ER_WORK;   WriteF('Work buffer overflow\n')
    CASE ER_BREAK;  WriteF('User terminated convertion\n')
    CASE ER_FORM;   WriteF('.i file format error\n')
    CASE ER_TEMPW;  WriteF('Trouble creating temporarily file\n')
    CASE ER_TEMPR;  WriteF('Trouble reading temporarily file\n')
    CASE ER_INVOKE; WriteF('Could not invoke A68k\n')
    CASE ER_OFORM;  WriteF('Error in object order line \d in "ram:iconvert.s"\n',a+1)
    CASE ER_I;      WriteF('Not a ".i" file: "\s"\n',infile)
  ENDSELECT
  IF line THEN WriteF('At line \d in file "\s"\n',line,infile)
  IF er>0 THEN DeleteFile(outfile)
  CleanUp(0)
ENDPROC
