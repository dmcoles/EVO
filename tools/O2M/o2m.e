-> o2m.e, convert assembly (and a subset of C) .o files to E modules.

MODULE 'dos/doshunks', 'tools/file'

DEF type,codesize,codeadr,relocadr=NIL,relocsize -> filled by process()

OBJECT syminfo
  next,sym,len,val
ENDOBJECT

DEF slist=NIL

PROC main() HANDLE
  DEF infile[100]:STRING, outfile[100]:STRING, m, l
  WriteF('o2m v0.2 by Darren Coles 2025')
  WriteF('Originally by $#%! 1993\n')
  StringF(infile,'\s.o',arg)
  StringF(outfile,'\s.m',arg)
  WriteF('Converting "\s" to "\s"\n',infile,outfile)
  m,l:=readfile(infile)
  process(m,l)
  writeinfos()
  writemodule(outfile)
EXCEPT
  SELECT exception
    CASE "MEM";  WriteF('No Mem!\n')
    CASE "OPEN"; WriteF('Could not open file\n')
    CASE "IN";   WriteF('Problems while reading\n')
    CASE "FORM"; WriteF('Hunk format error!\n')
  ENDSELECT
ENDPROC

PROC process(o:PTR TO LONG,len) HANDLE
  DEF n,hunk,s:PTR TO syminfo,c
  IF o[]++<>HUNK_UNIT THEN Raise("FORM")
  o:=o[]++*4+o
  IF o[]=HUNK_NAME
    o++
    o:=o[]++*4+o    
  ENDIF
  type:=o[]++
  IF (type<>HUNK_CODE) AND (type<>HUNK_DATA) THEN Raise("CODE")
  codesize:=o[]++
  codeadr:=o
  o:=codesize*4+o
  WHILE (hunk:=o[]++)<>HUNK_END
    IF hunk=HUNK_DEBUG
      n:=o[]++
      o:=n*4+o
    ELSEIF hunk=HUNK_SYMBOL
      REPEAT
        n:=o[]++
        IF n
          o++
          o:=n*4+o
        ENDIF
      UNTIL n=0

    ELSEIF hunk=HUNK_RELOC32
      IF relocadr THEN Raise("1REL")
      n:=o[]++
      IF o[]++ THEN Raise("1REL")
      relocadr:=o
      o:=n*4+o
      IF o[]++ THEN Raise("1REL")
      relocsize:=n
    ELSEIF hunk=HUNK_EXT
      REPEAT
        IF Char(o)=EXT_DEF
          n:=o[]++ AND $FFFFFF
          s:=NewR(SIZEOF syminfo)
          s.sym:=o
          c:=Char(o)
          IF (c>="A") AND (c<="Z") THEN PutChar(o,c+32)
          s.len:=n*4
          s.next:=slist
          slist:=s
          o:=n*4+o
          s.val:=o[]++
        ELSE
          n:=o[]++ AND $FFFFFF
          WriteF('unknown \s\n',o)
          o:=n*4+o
          o++
        ENDIF
      UNTIL o[]++=0
      ->IF o[]++ THEN Raise("DEF")
    ELSE
      Raise("HUNK")
    ENDIF
  ENDWHILE
EXCEPT
  SELECT exception
    CASE "HUNK"; WriteF('Only hunk_code, hunk_ext and hunk_reloc32 allowed\n')
    CASE "CODE"; WriteF('hunk_code or hunk_data expected\n')
    CASE "1REL"; WriteF('At most one relochunk expected\n')
    CASE "DEF";  WriteF('Only XDEFs allowed, no XREFs\n')
  ENDSELECT
  Raise("FORM")
ENDPROC

PROC writeinfos()
  DEF list:PTR TO syminfo, s[50]:STRING
  list:=slist
  WriteF('codesize=\d, numreloc=\d\n',codesize*4,relocsize)
  WHILE list
    StrCopy(s,list.sym,list.len)
    WriteF('\s=$\h ',s,list.val)
    list:=list.next
  ENDWHILE
  WriteF('\n')
ENDPROC

PROC writemodule(modname)
  DEF handle,list:PTR TO syminfo, s[50]:STRING, res[50]:STRING, num, l, ll
  IF (handle:=Open(modname,NEWFILE))=NIL THEN Raise("OPEN")
  Write(handle,["EM","OD",5,0,1000,0,0,0,0,0,0,2,0,0,3,0,codesize]:INT,34)
  Write(handle,codeadr,codesize*4)
  IF relocadr
    IF relocsize
      Write(handle,[7,0,relocsize]:INT,6)
      Write(handle,relocadr,relocsize*4)
    ENDIF
  ENDIF
  Write(handle,[4]:INT,2)
  list:=slist
  WHILE list
    StrCopy(s,list.sym,list.len)
    num:=findargs(s,res)
    l:=EstrLen(res)
    ll:=l+IF Even(l) THEN 2 ELSE 1
    Write(handle,[ll]:INT,2)
    Write(handle,res,ll)
    Write(handle,[list.val]:LONG,4)
    IF type=HUNK_CODE
      Write(handle,[1,num,0,0,0]:INT,10)
    ELSE
      Write(handle,[2]:INT,2)
    ENDIF
    list:=list.next
    WriteF('\s/\d ',res,num)
  ENDWHILE
  Write(handle,[-1,0,0]:INT,6)
  Close(handle)
  WriteF('\n')
ENDPROC

PROC findargs(sym,res)
  DEF fpos,lpos,ipos,a=0,c,s
  lpos:=IF (ipos:=InStr(sym,'_i'))>1 THEN ipos ELSE EstrLen(sym)
  fpos:=0
  WHILE sym[fpos]="_" DO fpos++
  WHILE sym[lpos-1]="_" DO lpos--
  IF lpos>fpos THEN StrCopy(res,sym+fpos,lpos-fpos) ELSE StrCopy(res,sym)
  IF ipos>1
    s:=ipos+sym
    WHILE c:=s[]++ DO IF c="i" THEN INC a
  ENDIF
ENDPROC a
