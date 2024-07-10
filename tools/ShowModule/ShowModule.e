OPT PREPROCESS
/* ShowModule.e; dumps all the infos in a '.m' binary file */

#define OSV36

#ifdef OSV36
#define KICK 36
OPT OSVERSION=36
#define PutC(a) FputC(stdout,a)
#define PutS    PutStr
#define PutF    PrintF
#endif
#ifndef OSV36
#define KICK 33
#define PutC(a) Out(stdout,a)
#define PutS    WriteF
#define PutF    WriteF
#endif



ENUM JOB_DONE,JOB_CONST,JOB_OBJ,JOB_CODE,JOB_PROCS,
     JOB_SYS,JOB_LIB,JOB_RELOC,JOB_GLOBS,JOB_MODINFO,JOB_DEBUG,JOB_MACROS

ENUM ER_NONE,ER_FILE,ER_MEM,ER_USAGE,ER_JOBID,
     ER_BREAK,ER_FILETYPE,ER_TOONEW

CONST MODVERS=14,     -> upto which version we understand 
                      -> MODVER = 11 for Creative, MODVER=12 for Evo 3.5.0
                      -> MODVER=13 FOR Evo 3.6.0
                      -> MODVER=14 FOR Evo 3.8.0
      SKIPMARK=$FFFF8000

DEF flen,o:PTR TO INT,mem,handle=NIL,file[250]:STRING,thisvers=0,cmode=FALSE,emode=FALSE


PROC main() HANDLE
  DEF a,b,ae
  PutF('ShowModule v1.\d (c) 1992 $#%!\n'+
       'Update by grio 2001 (4 Kick V\d)\n'+
       'and by Darren Coles 2022 for E-vo\n',MODVERS,KICK)
  IF StrCmp(arg,'',1) OR StrCmp(arg,'?',2)
    Raise(ER_USAGE)
  ELSE
    IF (arg[]="-") AND (arg[1]="c") AND (arg[2]=" ")
      arg:=arg+3
      WHILE arg[]=" " DO arg++
      cmode:=TRUE
    ENDIF
    IF (arg[]="-") AND (arg[1]="e") AND (arg[2]=" ")
      arg:=arg+3
      WHILE arg[]=" " DO arg++
      emode:=TRUE
    ENDIF    
    ae:=arg+StrLen(arg)
    WHILE (ae[-1]=" ") AND (ae>arg) DO ae[]--:=0
    StrCopy(file,arg)
    LowerStr(file)
    IF (file[EstrLen(file)-2]<>".") OR (file[EstrLen(file)-1]<>"m") THEN StrAdd(file,'.m')
    IF emode=FALSE THEN PutF('now showing: "\s"\n',file)
    IF emode=FALSE THEN PutS('NOTE: don\at use this output in your code, use the module instead.\n\n')
    flen:=FileLength(file)
    handle:=Open(file,OLDFILE)
    IF (flen<8) OR (handle=NIL)
      Raise(ER_FILE)
    ELSE
      mem:=New(flen+10)
      IF mem=NIL
        Raise(ER_MEM)
      ELSE
        IF Read(handle,mem,flen)<>flen THEN Raise(ER_FILE)
        Close(handle)
        a:=mem+flen
        FOR b:=1 TO 6 DO a[]++:=0
        handle:=NIL
        process()
      ENDIF
    ENDIF
  ENDIF
EXCEPT
  IF handle THEN Close(handle)
  PutS('\n')
  SELECT exception
    CASE ER_FILE;     PutF('Could not read file "\s" !\n',file)
    CASE ER_MEM;      PutS('No memory for loading module!\n')
    CASE ER_USAGE;    PutS('USAGE: ShowModule [-c] <module>\n')
    CASE ER_JOBID;    PutS('Illegal job id!\n')
    CASE ER_BREAK;    PutS('User interupted ShowModule\n')
    CASE ER_FILETYPE; PutS('Not an E module file.\n')
    CASE ER_TOONEW;   PutS('You need a newer version of ShowModule to view this module\n')
  ENDSELECT
ENDPROC

PROC process()
  DEF end,job,len,val,f,off,types:PTR TO LONG,types2:PTR TO LONG,c,r,c2,l,narg,priv,darg:PTR TO LONG
  DEF fl,dimscount,ptrrep,ptrRepText[255]:STRING,dimsText[255]:STRING,tempstr[10]:STRING,d
  o:=mem
  end:=o+flen
  types:=['substructure','CHAR','INT','','LONG']
  types2:=['substructure','BYTE','WORD','','LONG']
  IF ^o++<>"EMOD" THEN Raise(ER_FILETYPE)
  IF emode THEN PutS('  OPT MODULE\n  OPT EXPORT\n  OPT PREPROCESS\n\n')
  WHILE o<end
    IF CtrlC() THEN Raise(ER_BREAK)
    job:=o[]++
    SELECT job
      CASE JOB_CONST
        IF thisvers>=6 THEN o:=o+4
        len:=o[]++; f:=TRUE
        WHILE len
          IF len=$ffffff00
            len:=o[]++

            PutS(IF cmode THEN '#define ' ELSE IF f THEN 'CONST ' ELSE '      ')
            PutF(IF cmode THEN '\s ' ELSE '\s=',o)
            o:=o+len
            len:=o[]++
            PutF('''\s''',o)
            o:=o+len+1
            IF (o & 1) = 1 THEN o:=o+1
          ELSE
            val:=^o++
            PutS(IF cmode THEN '#define ' ELSE IF f THEN 'CONST ' ELSE '      ')
            PutF(IF cmode THEN '\s ' ELSE '\s=',o)
            IF (val>=-$20) AND (val<$20) THEN PutF('\d',val) ELSE PutF(IF cmode THEN '0x\h' ELSE '$\h',val)
            o:=o+len
          ENDIF
          len:=o[]++; f:=FALSE
          PutS(IF len THEN (IF cmode THEN '\n' ELSE ',\n') ELSE '\n\n')
          IF CtrlC() THEN Raise(ER_BREAK)
        ENDWHILE
      CASE JOB_OBJ
        IF thisvers>=6 THEN o:=o+4
        priv:=0
        l:=o[]++;
        PutF('\s\s \s\s\n',IF emode THEN '' ELSE '(----) ',IF cmode THEN 'struct' ELSE 'OBJECT',o+4,IF cmode THEN ' {' ELSE '')
        o:=o+4+l
        WHILE l:=o[]++
          val:=o[]++
          off:=o[]++
          IF l>0
            IF emode
              PutF('  \s',o)
            ELSE
              PutF('(\d[4])   \s',off,o)
            ENDIF
            o:=o+l
            priv:=0
          ELSE
            IF priv++=0 THEN PutF('\s  /* private member(s) here */\n',IF emode THEN '' ELSE '(----) ')
          ENDIF
          StrCopy(ptrRepText,'')
          StrCopy(dimsText,'')
          dimscount:=0
          fl:=0
          IF thisvers>=12
            IF thisvers>=13
              fl:=o[]++
            ENDIF
            ptrrep:=o[]++
            WHILE (ptrrep>0)
              StrAdd(ptrRepText,'PTR TO ')
              ptrrep--
            ENDWHILE
            dimscount:=o[]++
            d:=1
            WHILE dimscount>0
              StringF(tempstr,'[\d]',Div(o[],d))
              d:=o[]++
              StrAdd(dimsText,tempstr)
              dimscount--
            ENDWHILE
          ENDIF
          IF thisvers>=6
            IF (c:=o[]++)>=0
              IF c=0
                IF fl
                  PutF(':\s\n',types2[val])
                ELSE
                  PutF(':\s\n',types[val])
                ENDIF
              ELSE
                IF val
                  PutF(
                    '\s:\sPTR TO \s\n',
                    '',
                    ptrRepText,
                    IF fl THEN ListItem(['','BYTE','WORD','','LONG'],c) ELSE ListItem(['','CHAR','INT','','LONG'],c)
                  )
                ELSE
                  IF EstrLen(dimsText)=0 THEN StringF(dimsText,'[\d]',Int(o+IF o[] THEN 4 ELSE 2)-off/c,)
                  PutF(
                    '\s:ARRAY OF \s\n',
                    dimsText,
                    IF fl THEN ListItem(['','BYTE','WORD','','LONG'],c) ELSE ListItem(['','CHAR','INT','','LONG'],c)
                  )
                ENDIF
              ENDIF
            ELSE
              l:=o[]++
              ->PutF(IF val THEN ':PTR TO \s\n' ELSE ':\s (or ARRAY OF \s)\n',o,o)
              IF emode
                IF val THEN PutF(':\sPTR TO \s\n',ptrRepText,o) ELSE PutF(':\s\n',o)
              ELSE
                IF val THEN PutF(':\sPTR TO \s\n',ptrRepText,o) ELSE PutF(':\s (or ARRAY OF \s)\n',o,o)
              ENDIF
              o:=o+l
            ENDIF
          ELSE
            IF fl
              PutF(':\s\n',types2[val])
            ELSE
              PutF(':\s\n',types[val])
            ENDIF
          ENDIF
          IF CtrlC() THEN Raise(ER_BREAK)
        ENDWHILE
        val:=o[]++
        IF thisvers>=7
          IF o[]++
            o:=o+4
            l:=o[]++
            o:=o+l+4
            WHILE (c:=o[]++)<>-1
              o++; l:=o[]++
              PutF('         \s(',o)
              o:=o+l
              narg:=o[]++
              r:=o[]++; darg:=o ; o:=r*4+o
              IF (l:=o[])=SKIPMARK
                 o++
                 c2:=o[]++
                 IF c2=0 THEN l:=0
              ELSE
                 l:=0
              ENDIF
              IF narg
                 IF l=0
                    FOR off:=1 TO narg
                        PutF('\c',off+96)
                        IF narg-off<r THEN PutF('=\d',darg[]++)
                        IF off<narg THEN PutS(',')
                    ENDFOR
                 ELSE
                    l:=o
                    FOR off:=1 TO narg
                        WHILE l[]>"0" DO PutC(l[]++)
                        IF narg-off<r THEN PutF('=\d',darg[]++)
                        IF off<narg THEN PutS(',')
                        l++
                    ENDFOR
                    o:=o+c2
                 ENDIF
              ENDIF
              PutS(')\n')
            ENDWHILE
            WHILE o[]++<>-1 DO o:=o+4
          ENDIF
        ENDIF
        PutF('\s\s     /* SIZEOF=',IF emode THEN '' ELSE '(----) ',IF cmode THEN '}' ELSE 'ENDOBJECT')
        PutF(IF val<>-1 THEN '\d */\n\n' ELSE 'NONE !!! */\n\n',val)
      CASE JOB_CODE
        l:=^o++*4
        PutF('/* this module contains \d bytes of code! */\n\n',l)
        o:=l+o
      CASE JOB_PROCS
        WHILE (l:=o[]++)>0
          c:=o
          o:=o+l+4
          IF o[]++=1
            PutF('PROC \s(',c)
            narg:=o[]++
            o++
            c2:=o[]++
            darg:=o
            o:=c2*4+o
            c:=o[]++
            IF c
              IF c2
                l:=o
                FOR r:=1 TO narg
                  WHILE l[]>"0" DO PutC(l[]++)
                  IF narg-r<c2 THEN PutF('=\d',darg[]++)
                  PutS(IF r<>narg THEN ',' ELSE ')\n')
                  l++
                ENDFOR
              ELSE
                PutF('\s)\n',o)
              ENDIF
            ELSE
              IF narg THEN FOR c2:=1 TO narg DO PutF(IF c2=narg THEN '\c' ELSE '\c,',c2+96)
              PutS(')\n')
            ENDIF
            o:=o+c
          ELSE
            PutF('\s:\n',c)
          ENDIF
        ENDWHILE
        PutS('\n')
      CASE JOB_SYS
        o:=o+4
        f:=FALSE
        IF c:=o[]++
          f:=TRUE
          PutF('/* osvers: \d+  ',c)
        ENDIF
        o:=o+4
        c:=o[]++ ->IF ...
          IF f=FALSE THEN PutS('/* ')
          f:=TRUE
          PutF('cpu: \s+  ',ListItem(['68000/010','68020/030','68040/060'],c))
        ->ENDIF
        IF c:=o[]++
          IF f=FALSE THEN PutS('/* ')
          f:=TRUE
          PutF('fpu: \s+  ',ListItem(['68881/2','68040/060'],c-1))
        ENDIF
        o:=o+2
        IF (thisvers:=o[]++)>MODVERS THEN Raise(ER_TOONEW)
        IF f=FALSE THEN PutS('/* ')
        f:=TRUE
        PutF('\n   module format version: \d\n',thisvers)
        IF thisvers>10 THEN o:=o+4  -> for CreativE
        o:=o+4
        IF f THEN PutS('*/\n\n')
      CASE JOB_LIB
        c:=o
        WHILE c[]++ DO NOP
        PutF(IF cmode THEN '##base _\s\n##bias 30\n##public\n' ELSE 'LIBRARY \s         /* informal notation */\n',c)
        WHILE c[]++ DO NOP
        off:=-30
        WHILE (c[]<>$FF) AND (c<end)
          IF c[]=16
            INC c
          ELSE
            c2:=c
            WHILE c[]++>" " DO NOP; c--
            r:=c[]; c[]++:=0
            PutF(IF cmode THEN '\s' ELSE '  \s',c2)
            IF cmode THEN dargs(r,c)
            PutS('(')
            IF r<>16
              WHILE r<16
                IF r<8 THEN PutF('D\d',r) ELSE PutF('A\d',r-8)
                r:=c[]++
                IF r<16 THEN PutS(',')
              ENDWHILE
              c--
            ENDIF
            PutF(IF cmode THEN ')\n' ELSE ')     /* \d (\h) */\n',off,Abs(off))
          ENDIF
          off:=off-6
        ENDWHILE
        PutS(IF cmode THEN '##end\n\n' ELSE 'ENDLIBRARY\n\n')
        o:=end
      CASE JOB_RELOC
        c:=^o++
        o:=c*4+o
        PutF('/* ... and \d reloc entries */\n\n',c)
      CASE JOB_DONE
        o:=end
      CASE JOB_GLOBS
        c:=0; f:=TRUE
        IF o[]=SKIPMARK THEN o:=o+6
        IF thisvers>=14
          val:=o[]++
        ELSE
          val:=0
        ENDIF
        WHILE (val<>-1) ANDALSO ((len:=o[]++)>=0)
          IF len
            IF f
              PutS('DEF ')
              f:=FALSE
            ELSE
              PutS(',')
            ENDIF
            PutF('\s',o)
            o:=o+len
          ELSE
            c++
          ENDIF
          WHILE ^o++ DO IF thisvers>=10 THEN o++
          IF thisvers>=14
            val:=o[]++
          ELSE
            val:=0
          ENDIF          
        ENDWHILE
        IF f=FALSE THEN PutS('\n')
        IF c THEN PutF('/* \d private global variable(s) in this module */\n',c)
        PutS('\n')
      CASE JOB_MODINFO
        o:=o+4
        PutS('/*\n')
        WHILE len:=o[]++
          PutF('  code from module "\s" used:\n',o)
          o:=o+len
          WHILE c:=o[]++
            len:=o[]++
            c2:=o
            o:=o+len
            IF c=2
              f:=o[]++
              PutF(IF f<>-1 THEN '    \s\c)/\d' ELSE '    \s:',c2,"(",f)
              PutF(' (\dx)\n',c:=o[]++)
              o:=c*4+o
            ELSE
              c:=o[]++
              PutF('  OBJECT \s [\d acc]\n',c2,c)
              o:=c*6+o
            ENDIF
          ENDWHILE
        ENDWHILE
        PutS('*/\n')
      CASE JOB_DEBUG
        WHILE ^o++=$3F1
          len:=^o++
          o:=o+4
          c:=^o++
          o:=len*4+o-8
          PutF('/* This module contains \d bytes \s DEBUG infos! */\n\n',
            len*4,IF c="EVAR" THEN 'EVAR' ELSE 'LINE')
        ENDWHILE
      CASE JOB_MACROS
        WHILE len:=o[]++
          PutF('#define \s',o)
          o:=o+len
          ->->PutF('/\d\n',o[]++)
          ->->o++
          ->->o:=o[]+++o
          PutF('/\d=',o[]++)
          o++
          len:=o[]++
          c:=o
          WHILE (o+len)>c
            EXIT c[]=NIL
            IF c[]<20
               PutC("a"-1+c[])
            ELSE
               PutC(c[])
            ENDIF
            INC c
          ENDWHILE
          PutC("\n")
          ->PutF('\s\n',o)
          o:=o+len
        ENDWHILE
        PutS('\n')
      DEFAULT
        Raise(ER_JOBID)
    ENDSELECT
  ENDWHILE
ENDPROC

PROC dargs(r,c)
  DEF ch="a"
  PutS('(')
  IF r<>16
    WHILE r<16
      PutF('\c',ch++)
      r:=c[]++
      IF r<16 THEN PutS(',')
    ENDWHILE
  ENDIF
  PutS(')')
ENDPROC





