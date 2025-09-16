OPT LARGE, OSVERSION=37
MODULE 'tools/EasyGUI','tools/constructors','asl','libraries/Asl','dos/dos','exec/nodes','exec','exec/lists'

ENUM ABORT=0,ERR_OPEN,ERR_NOMEM,ERR_TOONEW,ERR_JOBID,ERR_TEMP

ENUM JOB_DONE,JOB_CONST,JOB_OBJ,JOB_CODE,JOB_PROCS,
     JOB_SYS,JOB_LIB,JOB_RELOC,JOB_GLOBS,JOB_MODINFO,JOB_DEBUG,JOB_MACROS

CONST MODVERS=15,     -> upto which version we understand 
                      -> MODVER = 11 for Creative, MODVER=12 for Evo 3.5.0
                      -> MODVER=13 FOR Evo 3.6.0
                      -> MODVER=14 FOR Evo 3.8.0
                      -> MODVER=15 FOR Evo 3.9.0
      SKIPMARK=$FFFF8000

DEF caseSensitive=TRUE
DEF subString=FALSE
DEF briefOutput=FALSE
DEF consoleOutput=FALSE
DEF recursive=TRUE
DEF searchText[255]:STRING
DEF dirPath[255]:STRING
DEF gh
DEF searchGad,dirPathGad,statusGad,outputGad,errorGad
DEF outputList=NIL
DEF error
DEF aborted

DEF objNames=0
DEF objOids=0
DEF objCount=0,objAlloc=0

PROC addObj(name,oid)
  DEF newNames,newOids
  IF objCount=objAlloc
    objAlloc:=objAlloc+100
    newNames:=List(objAlloc)
    newOids:=List(objAlloc)
    IF objNames
      ListAdd(newNames,objNames)
      DisposeLink(objNames)
    ENDIF
    IF objOids
      ListAdd(newOids,objOids)
      DisposeLink(objOids)
    ENDIF
    objNames:=newNames
    objOids:=newOids
  ENDIF
  ListAddItem(objNames,AstrClone(name))
  ListAddItem(objOids,oid)
ENDPROC

PROC findObj(oid)
  DEF i
  FOR i:=0 TO ListLen(objNames)-1
    IF ListItem(objOids,i)=oid THEN RETURN ListItem(objNames,i)
  ENDFOR
ENDPROC

PROC readPrefs()
  DEF temptext[100]:STRING
  DEF fh
  fh:=Open('envarc:findmodule.prefs',MODE_OLDFILE)
  IF fh>=0
    WHILE(ReadStr(fh,temptext)<>-1) OR (StrLen(temptext)>0)
      IF StrCmp(temptext,'DIRPATH=',8) THEN StrCopy(dirPath,temptext+8)
      IF StrCmp(temptext,'CASESENSITIVE=',14) THEN caseSensitive:=StrCmp(temptext+14,'TRUE')
      IF StrCmp(temptext,'SUBSTRING=',10) THEN subString:=StrCmp(temptext+10,'TRUE')
      IF StrCmp(temptext,'BRIEF=',6) THEN briefOutput:=StrCmp(temptext+6,'TRUE')
      IF StrCmp(temptext,'RECURSIVE=',10) THEN recursive:=StrCmp(temptext+10,'TRUE')
      IF StrCmp(temptext,'CONSOLEOUTPUT=',14) THEN consoleOutput:=StrCmp(temptext+14,'TRUE')
    ENDWHILE
    Close(fh)
  ENDIF
ENDPROC

PROC writePrefs()
  DEF temptext[100]:STRING
  DEF fh
  fh:=Open('envarc:findmodule.prefs',MODE_NEWFILE)
  IF fh>=0
    StringF(temptext,'DIRPATH=\s\n',dirPath); Write(fh,temptext,EstrLen(temptext))
    StringF(temptext,'CASESENSITIVE=\s\n',IF caseSensitive THEN 'TRUE' ELSE 'FALSE'); Write(fh,temptext,EstrLen(temptext))
    StringF(temptext,'SUBSTRING=\s\n',IF subString THEN 'TRUE' ELSE 'FALSE'); Write(fh,temptext,EstrLen(temptext))
    StringF(temptext,'BRIEF=\s\n',IF briefOutput THEN 'TRUE' ELSE 'FALSE'); Write(fh,temptext,EstrLen(temptext))
    StringF(temptext,'RECURSIVE=\s\n',IF recursive THEN 'TRUE' ELSE 'FALSE'); Write(fh,temptext,EstrLen(temptext))
    StringF(temptext,'CONSOLEOUTPUT=\s\n',IF consoleOutput THEN 'TRUE' ELSE 'FALSE'); Write(fh,temptext,EstrLen(temptext))
    
    Close(fh)
  ENDIF
ENDPROC

PROC searchCompare(text:PTR TO CHAR)
  DEF search[255]:STRING
  DEF search2[255]:STRING
  
  StrCopy(search,text)
  StrCopy(search2,searchText)
  IF caseSensitive=FALSE 
    UpperStr(search)
    UpperStr(search2)
  ENDIF
  IF subString
    RETURN InStr(search,search2)>=0
  ELSE
    RETURN StrCmp(search,search2)
  ENDIF
ENDPROC

PROC freeList()
  DEF nd:PTR TO ln
  REPEAT
    nd:=RemTail(outputList)
    IF nd<>0
      DisposeLink(nd.name)
      FastDispose(nd,SIZEOF ln)
    ENDIF
  UNTIL nd=0
ENDPROC

PROC addListText(text:PTR TO CHAR)
  AddTail(outputList, newnode(NIL, text))
ENDPROC

PROC processTfile(tfile,tempText)
  Seek(tfile,0,OFFSET_BEGINNING)
  setlistvlabels(gh,outputGad,-1)
  WHILE(ReadStr(tfile,tempText)<>-1) OR (StrLen(tempText)>0)
    IF consoleOutput THEN WriteF('\s\n',tempText)
    addListText(StrClone(tempText))
  ENDWHILE
  setlistvlabels(gh,outputGad,outputList)
  Close(tfile)
  DeleteFile('t:find.000')
ENDPROC

PROC search(mem,flen,filename:PTR TO CHAR) HANDLE
  DEF end,job,len,val,f,off,types:PTR TO LONG,types2:PTR TO LONG,c,r,c2,l,narg,priv,darg:PTR TO LONG
  DEF fl,dimscount,ptrrep,ptrRepText[255]:STRING,dimsText[255]:STRING,tempstr[10]:STRING,d,o:PTR TO INT
  DEF match=FALSE,match2=FALSE,thisvers=0
  DEF tempText[4000]:STRING
  DEF temp2[100]:STRING
  DEF p1,p2
  DEF tfile=-1,ofile=-1
  DEF objoid=0
  DEF i,defval,vartype,varflags,varoid,varptrrep,vardimscount,vardims

  o:=mem
  end:=o+flen
  types:=['substructure','CHAR','INT','','LONG']
  types2:=['substructure','BYTE','WORD','','LONG']
  IF ^o++<>"EMOD" THEN RETURN
  WHILE o<end
    IF aborted THEN Raise(ABORT)
    job:=o[]++
       
    IF ofile<>-1 THEN SetStdOut(ofile)
    IF tfile>=0 
      processTfile(tfile,tempText)
    ENDIF
    tfile:=Open('t:find.000',MODE_NEWFILE)
    ofile:=SetStdOut(tfile)
    IF tfile<0 THEN Raise(ERR_TEMP)
    
    SELECT job
      CASE JOB_CONST
        IF thisvers>=6 THEN o:=o+4
        len:=o[]++;
        WHILE len
          IF aborted THEN Raise(ABORT)
          IF len=$ffffff00
            len:=o[]++


            p1:=o
            o:=o+len
            len:=o[]++
            p2:=o
            
            match:=searchCompare(p1)
            IF match
              WriteF('\s - CONST \s=''\s''',filename,p1,p2)
            ENDIF
            o:=o+len+1
            IF (o & 1) = 1 THEN o:=o+1
          ELSE
            val:=^o++
            match:=searchCompare(o)
            IF match
              WriteF('\s - CONST \s=\u\n',filename,o,val)
            ENDIF
            o:=o+len
          ENDIF
          len:=o[]++;
        ENDWHILE
      CASE JOB_OBJ
        IF thisvers>=6 THEN o:=o+4
        IF thisvers>=15 THEN objoid:=o[]++    

        priv:=0
        l:=o[]++;
        addObj(o+4,objoid)
        
        match:=searchCompare(o+4)
        p1:=o+4
        IF match 
          WriteF('\s - OBJECT \s\n',filename,o+4)
        ENDIF
        o:=o+4+l
        WHILE l:=o[]++
          IF aborted THEN Raise(ABORT)
          val:=o[]++
          off:=o[]++
          IF l>0
            match2:=match AND (briefOutput=FALSE)
            IF searchCompare(o) THEN match2:=TRUE

            IF match2
              IF match AND (briefOutput=FALSE) THEN WriteF('  \s',o) ELSE WriteF('\s - in \s, offset \d, \s',filename,p1, off, o)
            ENDIF
            o:=o+l
            priv:=0
          ELSE
            priv++
          ENDIF
          StrCopy(ptrRepText,'')
          StrCopy(dimsText,'')
          dimscount:=0
          fl:=0
          StrCopy(ptrRepText,'PTR TO ')
          IF thisvers>=12
            IF thisvers>=13
              fl:=o[]++
            ENDIF
            ptrrep:=o[]++
            StrCopy(ptrRepText,'')
            WHILE (ptrrep>=0)
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
                IF match2
                  IF fl
                    WriteF(':\s\n',types2[val])
                  ELSE
                    WriteF(':\s\n',types[val])
                  ENDIF
                ENDIF
              ELSE
                IF val
                  IF match2 THEN WriteF(
                    '\s:\s\s\n',
                    '',
                    ptrRepText,
                    IF fl THEN ListItem(['','BYTE','WORD','','LONG'],c) ELSE ListItem(['','CHAR','INT','','LONG'],c)
                  )
                ELSE
                  IF EstrLen(dimsText)=0 THEN StringF(dimsText,'[\d]',Int(o+IF o[] THEN 4 ELSE 2)-off/c,)
                  IF match2 THEN WriteF(
                    '\s:ARRAY OF \s\s\n',
                    dimsText,
                    ptrRepText,
                    IF fl THEN ListItem(['','BYTE','WORD','','LONG'],c) ELSE ListItem(['','CHAR','INT','','LONG'],c)
                  )
                ENDIF
              ENDIF
            ELSE
              l:=o[]++
              IF match2 
                IF thisvers>=12
                  IF val THEN WriteF('\s:\s\s\n',dimsText,ptrRepText,o) ELSE WriteF('\s:ARRAY OF \s\s\n',dimsText,ptrRepText,o)
                ELSE
                  IF val THEN WriteF(':PTR TO \s\n',o) ELSE WriteF(':\s (or ARRAY OF \s)\n',o,o)
                ENDIF
              ENDIF
              o:=o+l
            ENDIF
          ELSE
             IF match2 THEN WriteF(':\s\n',types[val])
          ENDIF
        ENDWHILE
        val:=o[]++
        IF thisvers>=7
          IF o[]++
            o:=o+4
            l:=o[]++
            o:=o+l+4
            WHILE (c:=o[]++)<>-1
              IF aborted THEN Raise(ABORT)
              o++; l:=o[]++
              match2:=match AND (briefOutput=FALSE)
              IF searchCompare(o) THEN match2:=TRUE

              IF match2
                IF match AND (briefOutput=FALSE) THEN WriteF('         \s(',o) ELSE WriteF('\s - in \s, \s(',filename,p1,o)
              ENDIF
              
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
                        IF match2 THEN WriteF('\c',off+96)
                        IF narg-off<r THEN IF match2 THEN WriteF('=\d',darg[]++) ELSE darg++ 
                        IF match2 THEN IF off<narg THEN WriteF(',')
                    ENDFOR
                 ELSE
                    l:=o
                    FOR off:=1 TO narg
                        IF match2
                          WHILE l[]>"0" DO WriteF('\c',l[]++)
                        ELSE
                          WHILE l[]>"0" DO l[]++
                        ENDIF
                        IF narg-off<r THEN IF match2 THEN WriteF('=\d',darg[]++) ELSE darg++
                        IF match2 THEN IF off<narg THEN WriteF(',')
                        l++
                    ENDFOR
                    o:=o+c2
                 ENDIF
              ENDIF
              IF match2 THEN WriteF(')\n')
            ENDWHILE
            WHILE o[]++<>-1 DO o:=o+4
          ENDIF
        ENDIF
        IF match AND (briefOutput=FALSE) THEN WriteF('ENDOBJECT\n')
      CASE JOB_CODE
        l:=^o++*4
        o:=l+o
      CASE JOB_PROCS
        match:=FALSE
        WHILE (l:=o[]++)>0
          IF aborted THEN Raise(ABORT)
          c:=o
          o:=o+l+4
          IF o[]++=1
            match:=searchCompare(c)

            IF match THEN WriteF('\s - PROC \s(',filename,c)
            narg:=o[]++
            o++
            c2:=o[]++
            IF c2=-1      //special case for NOREGS
              c2:=o[]++
              o:=c2*2+o
              c2:=o[]++
            ENDIF
            IF c2=-2    //special case for CLEANUP and STARTUP
              o[]++
              c2:=o[]++
            ENDIF
            darg:=o
            o:=c2*4+o
            c:=o[]++
            IF c
              IF c2
                l:=o
                FOR r:=1 TO narg
                  
                  WHILE l[]>"0"
                    IF match THEN WriteF('\c',l[])
                    l++
                  ENDWHILE
                  
                  IF narg-r<c2 
                    IF match THEN WriteF('=\d',darg[]) 
                    darg++
                  ENDIF
                  IF match THEN WriteF(IF r<>narg THEN ',' ELSE ')\n')
                  l++
                ENDFOR
              ELSE
                IF match THEN WriteF('\s)\n',o)
              ENDIF
            ELSE
              IF narg 
                FOR c2:=1 TO narg
                  IF match THEN WriteF(IF c2=narg THEN '\c' ELSE '\c,',c2+96)
                ENDFOR
              ENDIF
              IF match THEN WriteF(')\n')
            ENDIF
            o:=o+c
          ELSE
            IF match THEN WriteF('\s:\n',c)
          ENDIF
        ENDWHILE
        
      CASE JOB_SYS
        o:=o+4
        f:=FALSE
        IF c:=o[]++
          f:=TRUE
        ENDIF
        o:=o+4
        c:=o[]++ ->IF ...
        c:=o[]++
        o:=o+2
        IF (thisvers:=o[]++)>MODVERS THEN Raise(ERR_TOONEW)
        IF thisvers>10 THEN o:=o+4  -> for CreativE
        o:=o+4
      CASE JOB_LIB
        c:=o
        WHILE c[]++ DO NOP
        match:=searchCompare(c)
        p1:=c
        IF match THEN WriteF('\s - LIBRARY \s\n',filename,c)
        WHILE c[]++ DO NOP
        off:=-30
        WHILE (c[]<>$FF) AND (c<end)
          IF aborted THEN Raise(ABORT)
          IF c[]=16
            INC c
          ELSE
            c2:=c
            WHILE c[]++>" " DO NOP; c--
            r:=c[]; c[]++:=0
            match2:=match AND (briefOutput=FALSE)
            IF searchCompare(c2) THEN match2:=TRUE
            IF match2
              IF match AND (briefOutput=FALSE) THEN WriteF('  \s',c2) ELSE WriteF('\s - in \s, offset \d, \s',filename,p1, off, c2)
            ENDIF
            IF match2 THEN WriteF('(')
            IF r<>16
              WHILE r<16
                IF match2 THEN IF r<8 THEN WriteF('D\d',r) ELSE WriteF('A\d',r-8)
                r:=c[]++
                IF match2 THEN IF r<16 THEN WriteF(',')
              ENDWHILE
              c--
            ENDIF
            IF match2 THEN WriteF(')     /* \d (\h)\n',off,Abs(off))
          ENDIF
          off:=off-6
        ENDWHILE
        IF match AND (briefOutput=FALSE) THEN WriteF('ENDLIBRARY\n')
        o:=end
      CASE JOB_RELOC
        c:=^o++
        o:=c*4+o
      CASE JOB_DONE
        o:=end
      CASE JOB_GLOBS
        c:=0;
        IF o[]=SKIPMARK THEN o:=o+6
        IF thisvers>=14
          val:=o[]++
        ELSE
          val:=0
        ENDIF
        WHILE (val<>-1) ANDALSO ((len:=o[]++)>=0)
          IF aborted THEN Raise(ABORT)
          IF len
            match:=searchCompare(o)
            IF match THEN WriteF('\s - DEF \s',filename,o)
            o:=o+len

            IF thisvers>=15
              defval:=Long(o)
              o:=o+4
              varflags:=Char(o)
              o:=o+1
              vartype:=Char(o)
              o:=o+1
              varoid:=o[]++
              varptrrep:=o[]++
              vardimscount:=o[]++
              vardims:=0
              IF vardimscount>=0
                vardims:=o
                o:=o+vardimscount+vardimscount
              ENDIF
              IF match
                IF vardims>0
                  WriteF('[')  
                  d:=1
                  FOR i:=0 TO vardimscount-1
                    IF i>0 THEN WriteF('][')
                    WriteF('\d',Div(Word(vardims+i+i),d))
                    d:=Word(vardims+i+i)
                  ENDFOR
                  WriteF(']')  
                ENDIF
                IF (vardims=0) AND ((varoid=0) OR (varptrrep<>-1)) AND (defval<>0)
                  WriteF('=\d',defval)
                ENDIF
                IF varflags AND $80
                  WriteF(':LONG')
                ENDIF
                IF (vardims>0) OR (varptrrep<>-1) OR (varoid<>0)
                  WriteF(':')
                  IF vardims>0
                    WriteF('ARRAY OF ')  
                  ENDIF
                  IF varptrrep<>-1
                    FOR i:=0 TO varptrrep
                      WriteF('PTR TO ')
                    ENDFOR
                  ENDIF
                  IF (vartype=0)
                    WriteF('\s',findObj(varoid))
                  ELSE
                    SELECT vartype
                      CASE 1
                        IF varflags AND $20
                          WriteF('BYTE')
                        ELSE
                          WriteF('CHAR')
                        ENDIF
                      CASE 2
                        IF varflags AND $40
                          WriteF('WORD')
                        ELSE
                          WriteF('INT')
                        ENDIF
                      CASE 4
                        WriteF('LONG')
                    ENDSELECT
                  ENDIF
                ENDIF
              ENDIF
            ENDIF

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
      CASE JOB_MODINFO
        o:=o+4
        WHILE len:=o[]++
          o:=o+len
          WHILE c:=o[]++
            IF aborted THEN Raise(ABORT)
            len:=o[]++
            c2:=o
            o:=o+len
            IF c=2
              f:=o[]++
              c:=o[]++
              o:=c*4+o
            ELSE
              c:=o[]++
              o:=c*6+o
            ENDIF
          ENDWHILE
        ENDWHILE
      CASE JOB_DEBUG
        WHILE ^o++=$3F1
          IF aborted THEN Raise(ABORT)
          len:=^o++
          o:=o+4
          c:=^o++
          o:=len*4+o-8
        ENDWHILE
      CASE JOB_MACROS
        WHILE len:=o[]++
          IF aborted THEN Raise(ABORT)
          match:=searchCompare(o)
          IF match THEN WriteF('\s - #define \s ',filename, o)
          o:=o+len
          o++
          o++
          len:=o[]++
          c:=o
          WHILE (o+len)>c
            EXIT c[]=NIL
            IF match
              IF c[]<20
                 WriteF('\c',"a"-1+c[])
              ELSE
                 WriteF('\c',c[])
              ENDIF
            ENDIF
            INC c
          ENDWHILE
          IF match THEN WriteF('\n')
          o:=o+len
        ENDWHILE
      DEFAULT
        Raise(ERR_JOBID)
    ENDSELECT
  ENDWHILE
EXCEPT DO
  IF ofile<>-1 THEN SetStdOut(ofile)
  IF tfile>=0 THEN processTfile(tfile,tempText)
  IF exception<>0
    aborted:=TRUE
    SELECT exception
      CASE ERR_TOONEW
        StringF(temp2,'Last Error: Module too new \s',FilePart(filename))
        settext(gh,errorGad,temp2)
      CASE ERR_JOBID
        StringF(temp2,'Last Error: Garbled module -  \s',FilePart(filename))
        settext(gh,errorGad,temp2)
    ENDSELECT
  ENDIF
  ReThrow()
ENDPROC


PROC processFile(filename:PTR TO CHAR)
  DEF l
  DEF statusText[255]:STRING
  DEF fh
  DEF flen,file
  l:=StrLen(filename)  
 
  IF (l>2) ANDALSO (filename[l-2]=".") ANDALSO (UpperChar(filename[l-1])="M")
    StringF(statusText,'Status: Scanning \s',FilePart(filename))
    settext(gh,statusGad,statusText)
    flen:=FileLength(filename)
    IF(fh:=Open(filename,MODE_OLDFILE))<>0
      file:=New(flen+10)
      IF file<>0
        Read(fh,file,flen)
        Close(fh)
        search(file,flen,filename)
        Dispose(file)
      ELSE
        StringF(statusText,'Last Error: Not enough memory to load \s',FilePart(filename))
        settext(gh,errorGad,statusText)
        Raise(ERR_NOMEM)
      ENDIF
    ELSE
      StringF(statusText,'Last Error: Error opening \s',FilePart(filename))
      settext(gh,errorGad,statusText)
      Raise(ERR_OPEN)
    ENDIF
  ENDIF
ENDPROC

PROC scanPath(path: PTR TO CHAR)
  DEF lock
  DEF f_info: PTR TO fileinfoblock
  DEF statusText[255]:STRING

  error:=0

  f_info:=AllocDosObject(DOS_FIB,NIL)
  IF(f_info)=NIL THEN RETURN

  lock:=Lock(path,ACCESS_READ)
  IF(lock)=0
    FreeDosObject(DOS_FIB,f_info)
    StringF(statusText,'Last Error: Error locking \s',path)
    settext(gh,errorGad,statusText)
    RETURN FALSE
  ENDIF

  IF(Examine(lock,f_info))=0
    UnLock(lock)
    FreeDosObject(DOS_FIB,f_info)
    StringF(statusText,'Last Error: Error examining \s',path)
    settext(gh,errorGad,statusText)
    RETURN FALSE
  ENDIF

  scan(lock,f_info,path)

  UnLock(lock)
  FreeDosObject(DOS_FIB,f_info)

  IF aborted
    StringF(statusText,'Status: Aborted')
    settext(gh,statusGad,statusText)
  ELSE
    StringF(statusText,'Status: Idle')
    settext(gh,statusGad,statusText)
  ENDIF
ENDPROC TRUE

PROC scan(lock,f_info1: PTR TO fileinfoblock,path)
  DEF lock2
  DEF path2[255]:STRING
  DEF f_info2: PTR TO fileinfoblock
  DEF statusText[100]:STRING

  IF aborted THEN RETURN

  IF(f_info1.direntrytype>0)
    WHILE((ExNext(lock,f_info1))<>0) AND (aborted=FALSE)
      checkgui(gh)
      IF(f_info1.direntrytype>0)

        IF recursive
          f_info2:=AllocDosObject(DOS_FIB,NIL)
          IF(f_info2)=NIL
            StringF(statusText,'Last Error: AllocDosObject failed')
            settext(gh,errorGad,statusText)
            RETURN
          ENDIF

          StrCopy(path2,path)
          IF path2[EstrLen(path2)-1]<>":" THEN StrAdd(path2,'/')
          StrAdd(path2,f_info1.filename)
                 
          lock2:=Lock(path2,ACCESS_READ)
          IF(lock2)=0
            FreeDosObject(DOS_FIB,f_info2)
            StringF(statusText,'Last Error: Error locking \s',path2)
            settext(gh,errorGad,statusText)
            RETURN
          ENDIF

          IF(Examine(lock2,f_info2))=0
            UnLock(lock2)
            FreeDosObject(DOS_FIB,f_info2)
            StringF(statusText,'Last Error: Error examining \s',path2)
            settext(gh,errorGad,statusText)
            RETURN FALSE
          ENDIF

          scan(lock2,f_info2,path2)

          UnLock(lock2)
          FreeDosObject(DOS_FIB,f_info2)       
        ENDIF
      ELSE
        StrCopy(path2,path)
        AddPart(path2,f_info1.filename,255)
        SetStr(path2,StrLen(path2))

        processFile(path2)
      ENDIF
    ENDWHILE
  ELSE 
    StrCopy(path2,path)
    processFile(path)
  ENDIF
ENDPROC

PROC performGo() HANDLE
  aborted:=FALSE
  getstr(gh,searchGad)
  getstr(gh,dirPathGad)
  freeList()
  IF EstrLen(searchText)>0 THEN scanPath(dirPath)
EXCEPT
ENDPROC

PROC performStop() IS aborted:=TRUE

PROC performPick()
  DEF req:PTR TO filerequester
  getstr(gh,dirPathGad)
  IF aslbase:=OpenLibrary('asl.library',37)
    IF req:=AllocAslRequest(ASL_FILEREQUEST,[ASLFR_TITLETEXT,'Pick a Directory',ASLFR_INITIALDRAWER,dirPath,ASLFR_DRAWERSONLY,TRUE,TAG_END])
      IF RequestFile(req) 
        StrCopy(dirPath,req.drawer)
        setstr(gh,dirPathGad,dirPath)
      ENDIF
      FreeAslRequest(req)
    ENDIF
    CloseLibrary(aslbase)
  ENDIF
ENDPROC

PROC caseSensitiveUpdate(p,x) IS caseSensitive:=x
PROC substringUpdate(p,x) IS subString:=x
PROC briefOutputUpdate(p,x) IS briefOutput:=x
PROC consoleOutputUpdate(p,x) IS consoleOutput:=x
PROC recursiveUpdate(p,x) IS recursive:=x
PROC searchTextUpdate(p,x) IS StrCopy(searchText,x)
PROC donothing(p,x) IS EMPTY

PROC main() 
  StrCopy(dirPath,'EModules:')
  readPrefs()
  easyguiA('FindModule',
            [ROWS,
              searchGad:=[STR,{searchTextUpdate},'_Find:',searchText,255,10,0,0,"f"],
              [COLS,[SPACEH],[CHECK,{caseSensitiveUpdate},'_Case sensitive?',caseSensitive,TRUE,0,"c"],[CHECK,{substringUpdate},'S_ub-string?',subString,TRUE,0,"u"]],
              [COLS,dirPathGad:=[STR,{donothing},'_Directory:',dirPath,100,10,0,0,"d"],[BUTTON,{performPick},'_Pick',0,"p"]],
              [COLS,[SPACEH],[CHECK,{consoleOutputUpdate},'C_onsole output?',consoleOutput,TRUE,0,"o"],
                [CHECK,{briefOutputUpdate},'_Brief output?',briefOutput,TRUE,0,"b"],[CHECK,{recursiveUpdate},'_Recursive?',recursive,TRUE,0,"r"]],
              [BAR],
              outputGad:=[LISTV,{donothing},'Results:',30,10,outputList:=newlist(),FALSE,0,0],
              statusGad:=[TEXT,'Status: Idle',NIL,FALSE,3],
              errorGad:=[TEXT,'Last Error:',NIL,FALSE,3],
              [BAR],
              [COLS,
                [SPACEH],
                [BUTTON,{performGo},'_GO!',0,"g"],
                [SPACEH],
                [BUTTON,{performStop},'_Stop',0,"s"],
                [SPACEH],
                [BUTTON,4,'_Quit',0,"q"],
                [SPACEH]
              ]
            ],
            [EG_GHVAR,{gh}])
  freeList()
  writePrefs()
  FastDispose(outputList,SIZEOF lh)
ENDPROC
