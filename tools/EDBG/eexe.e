/* E executable load and debug objects

probs: all that uses task-structure
- Forbid(): broken by debugger?
etc.

*/

OPT MODULE

MODULE 'exec/tasks', 'dos/doshunks'
MODULE 'tools/file'

/*---------------load-e-exe-functions------------------*/

EXPORT OBJECT e_exe PRIVATE
  file,code,codelen,sources:PTR TO e_source
ENDOBJECT

EXPORT OBJECT e_source PRIVATE
  next:PTR TO e_source
  lines:PTR TO LONG,numlines		-> of LINEDEBUG info
  bpoints:PTR TO CHAR
  sourcename,source
  procs:PTR TO e_proc
  globs:PTR TO e_var
  sourcelines:PTR TO LONG
ENDOBJECT

PROC sources() OF e_exe IS self.sources
PROC next() OF e_source IS self.next
PROC name() OF e_source IS self.sourcename
PROC lines() OF e_source IS self.sourcelines
PROC bpoints() OF e_source IS self.bpoints

OBJECT e_proc PRIVATE
  next:PTR TO e_proc
  name:PTR TO CHAR
  firstvarline
  vars:PTR TO e_var
ENDOBJECT

EXPORT OBJECT e_var PRIVATE
  next:PTR TO e_var
  name:PTR TO CHAR
PUBLIC
  regno:INT,offs:INT	-> if 0 then other
  type:PTR TO CHAR
ENDOBJECT

PROC setbreakpoint(vy,exe) OF e_source
  DEF l:PTR TO CHAR
  l:=self.bpoints
  IF l
    l[vy]:=TRUE
  ENDIF
  setbreak(self.findpc(vy,exe))
ENDPROC

PROC togglebreakpoint(vy,exe) OF e_source
  DEF l:PTR TO CHAR
  ->setbreak(self.findpc(vy,exe))
  l:=self.bpoints
  IF l
    l[vy]:=Not(l[vy])
  ENDIF
  IF l[vy] THEN setbreak(self.findpc(vy,exe)) ELSE rembreak(self.findpc(vy,exe))
ENDPROC

PROC clearbreakpoints(exe) OF e_source
  DEF l:PTR TO CHAR,i
  
  l:=self.bpoints
  IF l
    FOR i:=0 TO self.numlines-1
      IF l[i]
        rembreak(self.findpc(i,exe))
        l[i]:=FALSE
      ENDIF
    ENDFOR
  ENDIF
ENDPROC

PROC findsrc(name) OF e_source
  WHILE self
    IF StrCmp(self.sourcename,name) THEN RETURN self
    self:=self.next
  ENDWHILE
ENDPROC NIL

PROC locate(vx,vy,var) OF e_source
  DEF l,l2,c
  IF (vy<0) OR (vy>=ListLen(self.sourcelines))
    vy:=-1
  ELSE
    l:=self.sourcelines[vy]
    vx:=Bounds(vx,0,StrLen(l))
    l:=l+vx
    IF isalnum(l[])
      l2:=l
      WHILE isalnum(l[-1]) DO l--
      WHILE isalnum(l2[]) DO l2++
      IF ((c:=l[])>="_") AND (c<="z") THEN StrCopy(var,l,l2-l)
    ENDIF
  ENDIF
ENDPROC vy

PROC isalnum(c) IS ((c>="A") AND (c<="Z")) OR ((c>="_") AND (c<="z")) OR ((c>="0") AND (c<="9"))

PROC findproc(linenum) OF e_source
  DEF pr:PTR TO e_proc
  pr:=self.procs
  WHILE pr
    EXIT IF pr.vars THEN pr.firstvarline<=linenum ELSE FALSE
    pr:=pr.next
  ENDWHILE
ENDPROC pr

PROC findvar(name,pr=NIL:PTR TO e_proc) OF e_source
  DEF var=NIL:PTR TO e_var,isglob=FALSE
  IF pr THEN var:=lookupvar(pr.vars,name)
  IF var=NIL THEN (isglob:=TRUE) BUT var:=lookupvar(self.globs,name)
ENDPROC var,isglob

PROC lookupvar(v:PTR TO e_var,name)
  WHILE v
    IF StrCmp(v.name,name) THEN RETURN v
    v:=v.next
  ENDWHILE
ENDPROC NIL

PROC grabvarinfo(src:PTR TO e_source,o:PTR TO INT,end)
  DEF pr=NIL:PTR TO e_proc,job,v
  WHILE (job:=o[]++) BUT o<end
    SELECT 6 OF job
      CASE 1,2
        o,v:=collectvars(o,pr.vars,src,pr,job)
        pr.vars:=v
      CASE 3
        o,v:=collectvars(o,src.globs,src,pr,job)
        src.globs:=v
      CASE 4
        NEW pr
        v:=o[]++
->WriteF('\nPROC \s:',o)
        pr.name:=o
        pr.firstvarline:=-1
        pr.next:=src.procs	-> in reverse order, for line-search
        src.procs:=pr
        o:=o+v
      CASE 5
        v:=o[]++
        newself(pr,o[],o[1])
        o:=o+v
      DEFAULT
        Raise("eexe")
    ENDSELECT
  ENDWHILE
->WriteF('\n')
ENDPROC

CONST REGVARLIM=30000

PROC newself(pr:PTR TO e_proc,linenum,b)
  DEF i,t
  IF (i:=InStr(pr.name,':'))=-1 THEN Raise("eexe")
  i++
  NEW t[i]
  AstrCopy(t,pr.name,i)
  pr.vars:=NEW [pr.vars,'self',IF b>=REGVARLIM THEN b-REGVARLIM ELSE 0,
                IF b>=REGVARLIM THEN 0 ELSE b,t]:e_var
  pr.firstvarline:=linenum
->WriteF('new self "\s"\n',t)
ENDPROC

PROC collectvars(o:PTR TO INT,varlist,src:PTR TO e_source,pr:PTR TO e_proc,job)
  DEF line,v:PTR TO e_var,num,a,b,s:PTR TO CHAR,st,t
  v:=varlist
  line:=o[]++
  s:=src.sourcelines[line]
  num:=o[]++
  IF pr THEN IF pr.firstvarline<0 THEN pr.firstvarline:=line
  FOR a:=1 TO num
    b:=o[]++
    v:=NEW [v,NIL,IF b>=REGVARLIM THEN b-REGVARLIM ELSE 0,IF b>=REGVARLIM THEN 0 ELSE b,NIL]:e_var
->WriteF(' $\h ',b)
    IF (a=1) AND (job=1) THEN WHILE s[]++<>"(" DO NOP
    IF a>1 THEN WHILE s[]++<>"," DO NOP
    WHILE ((b:=s[])<"_") OR (b>"z") DO s++
    st:=s
    REPEAT
      s++
    UNTIL isalnum(s[])=FALSE
    b:=s-st+1
    NEW t[b]
    AstrCopy(t,st,b)
->WriteF('(\s)',t)
    v.name:=t
    t:=FALSE
    WHILE (b:=s[]) AND (b<>",")
    EXIT t:=((b>="_") AND (b<="z"))
      s++
    ENDWHILE
    IF t
      st:=s
      REPEAT
        s++
      UNTIL isalnum(s[])=FALSE
      b:=s-st+1
      NEW t[b]
      AstrCopy(t,st,b)
      v.type:=t
    ENDIF
  ENDFOR
ENDPROC o,v

PROC load(name) OF e_exe
  DEF o:PTR TO LONG,i,l,cl,c,dbl,numrel,a,b:PTR TO LONG,src=NIL:PTR TO e_source,add

  -> read exe

  o,l:=readfile(name,0)
  self.file:=o

  -> eat header

  IF (o[]++<>HUNK_HEADER) OR (o[]++<>0) OR (o[]++<>1) OR (o[]++<>0) OR (o[]++<>0) THEN Raise("eexe")
  o++

  -> eat code hunk

  IF o[]++<>HUNK_CODE THEN Raise("eexe")
  self.codelen:=cl:=o[]++*4
  self.code:=c:=o
  o:=o+cl

  -> eat and digest reloc

  IF o[]++<>HUNK_RELOC32 THEN Raise("eexe")
  numrel:=o[]++
  IF o[]++<>0 THEN Raise("eexe")
  IF numrel
    FOR a:=1 TO numrel				-> do own reloc!
      b:=c+o[]++
      b[]:=b[]+c
    ENDFOR
  ENDIF
  IF o[]++<>0 THEN Raise("eexe")

  -> skip symbol hunk if necessary

  IF o[]=HUNK_SYMBOL
    o++
    WHILE a:=o[]++ DO o:=a*4+o+4
  ENDIF

  -> eat debug hunks

  IF o[]<>HUNK_DEBUG THEN Raise("eexd")

  WHILE (a:=o[]++)<>HUNK_END
    IF a=HUNK_DEBUG
      IF o[2]="EVAR"
        IF src=NIL THEN Raise("eexe")
        dbl:=o[]++
        grabvarinfo(src,o+8,o:=dbl*4+o)
      ELSE
        NEW src
        dbl:=o[]++
        IF (o[]++<>0) THEN Raise("eexe")
        IF o[]="LINE"
          add:=0
        ELSEIF Char(o)="L"
          add:=o[] AND $FFFFFF
        ELSE
          Raise("eexe")
        ENDIF
        o++
        src.numlines:=dbl:=dbl-(a:=o[]++)-3
        src.sourcename:=o
        o:=a*4+o
        src.lines:=o
        
        make_illegal(c,o,dbl,add)
        o:=dbl*4+o
        src.next:=self.sources
        self.sources:=src
        src.load()
        src.bpoints:=New(ListLen(src.sourcelines))
        src.globs:=add_globs(src.globs)
      ENDIF
    ELSE
      Raise("eexe")
    ENDIF
  ENDWHILE

  CacheClearU()					-> important!

ENDPROC

PROC new_var(v,s,off,type=NIL) IS NEW [v,s,0,off,type]:e_var

PROC add_globs(v)
  v:=new_var(v,'stdout',       -$8)
  v:=new_var(v,'conout',       -$C)
  v:=new_var(v,'stdrast',      -$10, 'rastport')
  v:=new_var(v,'arg',          -$20)
  v:=new_var(v,'wbmessage',    -$24, 'wbstartup')
  v:=new_var(v,'execbase',     -$28, 'execbase')
  v:=new_var(v,'dosbase',      -$2C, 'doslibrary')
  v:=new_var(v,'intuitionbase',-$30, 'intuitionbase')
  v:=new_var(v,'gfxbase',      -$34, 'gfxbase')
  v:=new_var(v,'exception',    -$54)
  v:=new_var(v,'stdin',        -$5C)
  v:=new_var(v,'exceptioninfo',-$60)
ENDPROC v

CONST OPCODE_NOP=$4E71, OPCODE_ILLEGAL=$4AFC, OPCODE_BKPT=$F000

PROC make_illegal(code,dbg:PTR TO LONG,len,add)
  DEF a,b:PTR TO INT
  IF len
    FOR a:=1 TO len STEP 2
      dbg++
      dbg[]++:=b:=dbg[]+add
      b:=b+code
      IF b[]<>OPCODE_NOP THEN Raise("eexd")
      b[]:=OPCODE_ILLEGAL
    ENDFOR
  ENDIF
ENDPROC

PROC end() OF e_exe
  DEF p:PTR TO e_source
  IF self.file THEN freefile(self.file)
  p:=self.sources
  END p
ENDPROC	

PROC load() OF e_source
  DEF m,l,a,p
  m,l:=readfile(self.sourcename)
  self.source:=m
  self.sourcelines:=stringsinfile(m,l,countstrings(m,l))
  p:=m
  FOR a:=1 TO l DO IF p[]++="\t" THEN p[-1]:=" "
ENDPROC

PROC end() OF e_source
  DEF n:PTR TO e_source
  n:=self.next
  IF self.source THEN freefile(self.source)
  END n
  IF self.bpoints<>NIL THEN Dispose(self.bpoints)
ENDPROC

PROC findline(pc) OF e_exe
  DEF l:PTR TO e_source,a,b,dbg:PTR TO LONG,num,c
  l:=self.sources
  c:=self.code
  WHILE l
    dbg:=l.lines
    num:=l.numlines-1
    FOR a:=0 TO num STEP 2
      b:=dbg[]++-1
      IF dbg[]+++c=pc THEN RETURN l,b
    ENDFOR
    l:=l.next
  ENDWHILE
  MOVE.L lastpc(PC),a
ENDPROC NIL,NIL,a

CONST STARTUP_SIZE=$196

PROC findoffset(off) OF e_exe
  DEF l:PTR TO e_source,a,b,dbg:PTR TO LONG,num,best=0,src=NIL,line,start=0,largest=0
  IF (off<0) OR (off>=self.codelen) THEN RETURN NIL
  l:=self.sources
  WHILE l
    dbg:=l.lines
    num:=l.numlines-1
    IF largest<dbg[num]
      start:=dbg[1]
      largest:=dbg[num]
    ENDIF
    FOR a:=0 TO num STEP 2
      b:=dbg[]++-1
    EXIT off<dbg[]
      IF dbg[]>best
        best:=dbg[]
        line:=b
        src:=l
      ENDIF
      dbg++
    ENDFOR
    l:=l.next
  ENDWHILE
  IF (off<STARTUP_SIZE) OR ((start-$12<=off) AND (off<start))
    src:=NIL
  ELSEIF off>(largest+8)
    best:=TRUE
  ELSE
    best:=FALSE
  ENDIF
ENDPROC src,line,best

PROC findpc(line,exe:PTR TO e_exe) OF e_source
  DEF a,dbg:PTR TO LONG,num,c
  c:=exe.code
  dbg:=self.lines
  num:=self.numlines-1
  FOR a:=0 TO num STEP 2 DO IF dbg[]++-1=line THEN RETURN dbg[]+c ELSE dbg++
ENDPROC NIL

PROC edebug(do_at_break,cli_arg) OF e_exe
  DEF mytask:PTR TO tc,code,alen
  alen:=StrLen(cli_arg)+1
  mytask:=FindTask(NIL)
  mytask.trapcode:={tcode}
  LEA codejmp(PC),A0
  MOVE.L do_at_break,(A0)
  LEA debuga4(PC),A0
  MOVE.L A4,(A0)
  code:=self.code
  MOVEM.L D0-D7/A0-A6,-(A7)
  MOVE.L cli_arg,A0
  MOVE.L alen,D0
  MOVE.L code,A1
  JSR (A1)
  MOVEM.L (A7)+,D0-D7/A0-A6
ENDPROC

EXPORT OBJECT stackframe PUBLIC
  status:LONG
  regs[15]:ARRAY OF LONG
  returnpc:LONG
  stack[1]:ARRAY OF LONG	-> from here on
ENDOBJECT

tcode:
  CMP.L #3,(A7)
  MOVEM.L A0,(A7)		-> yeah! keep flags!
  BGT.S noadjust
  MOVE.L $4.W,A0
  BTST #0,297(A0)
  BNE.S noadjust
  MOVE.L (A7),8(A7)		-> for 68000 long-format frames
  ADDQ.L #8,A7
noadjust:
  LEA continue(PC),A0		-> finish superstate
  MOVE.L 6(A7),-4(A0)
  MOVE.W 4(A7),-6(A0)
  MOVE.L A0,6(A7)
  MOVE.L (A7)+,A0
  RTE

  LONG 0
pcstore:
  LONG 0
continue:
  SUBQ.L #4,A7				-> make space for return
  MOVEM.L D0-D7/A0-A6,-(A7)
  LEA continue(PC),A0			-> pc,sr on the stack
  MOVE.L -(A0),D0
  MOVE.L -(A0),-(A7)
  ADDQ.L #2,D0
  MOVE.L D0,64(A7)			-> prepare return pc

  ->MOVE.L breakpoint(PC),D0		-> check for breakpoint
  ->BEQ.S nobreak
  
  MOVE.L	pcstore(PC),A0
  ->MOVE.L D0,A0
  MOVE.W (A0),D0
  CMP.W #OPCODE_BKPT,D0
  BEQ.S stophere
  ->CMP.L	pcstore(PC),D0
  ->BEQ.S stophere

nobreak:
  MOVE.L breakpointmem(PC),D0		-> check for breakpoint on mem
  BEQ.S nomembreak
  MOVE.L D0,A0
  MOVE.L (A0),D0
  CMP.L	memval(PC),D0
  BNE.S stophere

nomembreak:
  MOVE.L stepovera7(PC),D0		-> check for step over
  BEQ.S stophere
  CMPA.L stepovera5(PC),A5
  BEQ.S stophere
  CMPA.L D0,A7				-> we compare TOP of frame, not actual A7
  BMI.S dontstop

stophere:
  MOVE.L debuga4(PC),A4			-> restore A4
  MOVE.L A7,-(A7)
  MOVE.L codejmp(PC),A0
  JSR (A0)				-> call E func with frame
  ADDQ.L #4,A7
  TST.L D0				-> see if we need to raise an exception
  BNE.S raise

dontstop:
  MOVE.L pcstore(PC), D0
  LEA lastpc(PC), A0
  MOVE.L D0, (A0)
  MOVE.L (A7)+,D0
  MOVEQ #-1,D1
  MOVE.L $4.W,A6
  JSR -144(A6)				-> SetSr(orig_sr,$FF)
  MOVEM.L (A7)+,D0-D7/A0-A6		-> hold SR!
  RTS					-> retpc is on top!

raise:
  ADDQ.L #4,A7				-> remove sr
  MOVEM.L (A7)+,D0-D7/A0-A6		-> registers back
  MOVE.L exc(PC),-84(A4)		-> fill programs' exception(-info)
  MOVE.L excinfo(PC),-96(A4)
  ReThrow()

codejmp: LONG 0
debuga4: LONG 0

stepovera7: LONG 0
stepovera5: LONG 0

->breakpoint: LONG 0			-> 0=no break, -1=run, other=break
breakpointmem: LONG 0			-> 0=no break, other=memaddress
memval: LONG 0				-> value for breakpointmem

exc: LONG 0
excinfo: LONG 0

-> Last known PC
lastpc: LONG 0

PROC setbreak(a)
  ->PutLong({breakpoint},a)
  PutInt(a,OPCODE_BKPT)
ENDPROC

PROC rembreak(a)
  ->PutLong({breakpoint},a)
  PutInt(a,OPCODE_ILLEGAL)
ENDPROC

EXPORT PROC stepover(a7=NIL,a5=NIL) IS PutLong({stepovera7},a7) BUT PutLong({stepovera5},a5)
EXPORT PROC setmembreak(a) IS PutLong({breakpointmem},a) BUT PutLong({memval},IF a THEN Long(a) ELSE NIL)
EXPORT PROC setthrow(e,ei) IS PutLong({exc},e) BUT PutLong({excinfo},ei)
