/* E executable load and debug objects

probs: all that uses task-structure
- Forbid(): broken by debugger?
etc.

*/

OPT MODULE

MODULE 'exec/tasks', 'dos/doshunks'
MODULE 'tools/file'

/*---------------load-e-exe-functions------------------*/

EXPORT OBJECT e_code PRIVATE
  code,codelen
ENDOBJECT

EXPORT OBJECT e_exe PRIVATE
  codeList:PTR TO LONG
  file,sources:PTR TO e_source
  seg
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
  DEF pc
  pc:=self.findpc(vy,exe)
  IF pc<>NIL
    l:=self.bpoints
    IF l
      l[vy]:=TRUE
      setbreak(pc)
    ENDIF
  ENDIF
ENDPROC

PROC togglebreakpoint(vy,exe) OF e_source
  DEF l:PTR TO CHAR
  DEF pc
  pc:=self.findpc(vy,exe)
  IF pc<>NIL
    l:=self.bpoints
    IF l
      l[vy]:=Not(l[vy])
    ENDIF
    IF l[vy] THEN setbreak(pc) ELSE rembreak(pc)
  ENDIF
ENDPROC

PROC clearbreakpoints(exe) OF e_source
  DEF l:PTR TO CHAR,i
  
  l:=self.bpoints
  IF l
    FOR i:=0 TO ListLen(self.sourcelines)-1
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

PROC load(name,trap1,trap2) OF e_exe
  DEF o:PTR TO LONG,i,l,cl,dbl,numrel,a,b:PTR TO LONG,src=NIL:PTR TO e_source,add,h
  DEF code:PTR TO e_code,c
  DEF hcurr,hcount
  DEF segptr=0:PTR TO LONG
  DEF d=FALSE

  self.seg:=NIL
  self.codeList:=List(100)
  -> read exe

  o,l:=readfile(name,0)
  self.file:=o

  -> eat header

  IF (o[]++<>HUNK_HEADER) OR (o[]++<>0) THEN Raise("eexe")
  hcount:=o[]++

  IF (o[]++<>0) OR (o[]++<>(hcount-1)) THEN Raise("eexe")
  o:=o+(4*hcount)
  hcurr:=0

  -> eat code hunk

  h:=o[]
  IF h<>HUNK_CODE THEN Raise("eexe")
  WHILE ((h=HUNK_CODE) OR (h=HUNK_DATA) OR (h=HUNK_BSS)) AND (hcurr<hcount)
    o[]++
    code:=NEW code
    ListAdd(self.codeList,[code])
    code.codelen:=cl:=o[]++*4
    o:=o+cl
    h:=o[]

    -> eat and digest reloc
    WHILE (h=HUNK_RELOC32) OR (h=HUNK_DREL32) OR (h=HUNK_RELOC32SHORT)
      o[]++
      IF h=HUNK_RELOC32
        numrel:=o[]++
        IF numrel>0
          o:=o+4
          REPEAT
            o:=o+(4*numrel)
            numrel:=o[]++
            IF numrel>0 THEN o:=o+4
          UNTIL numrel=0
        ENDIF
        o:=(o+3) AND $FFFFFFFC
      ELSE
        numrel:=Int(o)
        o:=o+2
        IF numrel>0
          o:=o+2
          REPEAT
            o:=o+(2*numrel)
            numrel:=Int(o)
            o:=o+2
            IF numrel>0 THEN o:=o+2
          UNTIL numrel=0
        ENDIF
        o:=(o+3) AND $FFFFFFFC
      ENDIF
      h:=o[]
    ENDWHILE

    -> eat debug hunks

    WHILE (a:=o[]++)<>HUNK_END
      -> skip symbol hunk if necessary
      IF a=HUNK_SYMBOL
        WHILE a:=o[]++ DO o:=a*4+o+4
      ELSEIF a=HUNK_DEBUG
        d:=TRUE
        IF o[2]="EVAR"
          IF src=NIL THEN Raise("eexe")
          dbl:=o[]++
          grabvarinfo(src,o+8,o:=dbl*4+o)
        ELSE
          dbl:=o[]++
          IF o[]="VDBG"
            o:=o+(dbl*4)
            CONT TRUE
          ELSEIF o[]="LDBG"
            o++
            add:=0
          ELSE
            IF (o[]++<>0) THEN Raise("eexe")
            IF o[]="LINE"
              add:=0
            ELSEIF Char(o)="L"
              add:=o[] AND $FFFFFF
            ELSE
              Raise("eexe")
            ENDIF
          ENDIF

          NEW src
          src.sourcename:=NIL
          src.lines:=NIL

          o++
          src.numlines:=dbl:=dbl-(a:=o[]++)-3
          src.sourcename:=String(StrLen(o))
          StrCopy(src.sourcename,o)
          o:=a*4+o
          src.lines:=New(src.numlines*4)
          FOR i:=0 TO src.numlines-1 DO src.lines[i]:=o[i]
          
          FOR a:=1 TO src.numlines STEP 2
            src.lines[a]:=src.lines[a]+add
          ENDFOR
          
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
    h:=o[]
    hcurr++
  ENDWHILE

  IF self.file THEN freefile(self.file)
  self.file:=NIL

  self.seg:=LoadSeg(name)
  IF self.seg=0 THEN Raise("eexe")
  
  segptr:=self.seg*4
  hcurr:=0
  WHILE (segptr<>NIL)
    code:=self.codeList[hcurr]
    hcurr++
    code.code:=segptr+4
    segptr:=segptr[]*4
  ENDWHILE

  src:=self.sources
  WHILE (src<>NIL)
    make_illegal(self.codeList,src.lines,src.numlines,trap1,trap2)
    src:=src.next
  ENDWHILE

  IF d=FALSE THEN Raise("eexd")
  
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

CONST OPCODE_NOP=$4E71, OPCODE_TRAP0=$4E40,OPCODE_JSR=$4EB9

PROC make_illegal(codeList:PTR TO LONG,dbg:PTR TO LONG,len,trap1,trap2)
  DEF a,b:PTR TO INT,c:PTR TO LONG,i,p
  DEF code:PTR TO e_code
  IF len
    FOR a:=1 TO len STEP 2
      dbg++
      b:=dbg[]
      IF b
        i:=0
        p:=0
        WHILE (i<ListLen(codeList)) AND (p<b)
          code:=codeList[i]
          p:=p+code.codelen
          i++
        ENDWHILE
        b:=b-(p-code.codelen)+code.code
        dbg[]++:=b
        IF b[]<>OPCODE_NOP THEN Raise("eexd")
        IF (trap1>=0) AND (trap1<=15) AND (trap2>=0) AND (trap2<=15)
          b[]:=OPCODE_TRAP0 OR trap1
        ELSE
          c:=b+2
          IF b[]<>OPCODE_NOP THEN Raise("eexd")
          IF (b[1]<>OPCODE_NOP) OR (b[2]<>OPCODE_NOP) THEN Raise("db50")
          b[]:=OPCODE_JSR
          c[]:={tcode_jsr1}
        ENDIF
      ENDIF
    ENDFOR
  ENDIF
ENDPROC

PROC end() OF e_exe
  DEF p:PTR TO e_source,i
  DEF code:PTR TO e_code
  
  IF self.file THEN freefile(self.file)
  p:=self.sources
  END p
  FOR i:=0 TO ListLen(self.codeList)-1
    code:=self.codeList[i]
    END code
  ENDFOR
  DisposeLink(self.codeList)
  IF self.seg THEN UnLoadSeg(self.seg)
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
  IF self.sourcename THEN DisposeLink(self.sourcename)
  IF self.lines THEN Dispose(self.lines)
  n:=self.next
  IF self.source THEN freefile(self.source)
  END n
  IF self.bpoints<>NIL THEN Dispose(self.bpoints)
ENDPROC

PROC findline(pc) OF e_exe
  DEF l:PTR TO e_source,a,b,dbg:PTR TO LONG,num

  l:=self.sources
  WHILE l
    dbg:=l.lines
    num:=l.numlines-1
    FOR a:=0 TO num STEP 2
      b:=dbg[]++-1
      IF dbg[]++=pc THEN RETURN l,b
    ENDFOR
    l:=l.next
  ENDWHILE
  MOVE.L lastpc(PC),a
ENDPROC NIL,NIL,a

CONST STARTUP_SIZE=$196

PROC findoffset(off) OF e_exe
  DEF l:PTR TO e_source,a,b,dbg:PTR TO LONG,num,best=$7fffffff,src=NIL,line,start=0,largest=0,i,e
  DEF code:PTR TO e_code,s

  IF (off<0) THEN RETURN NIL
  e:=0
  i:=0
  WHILE (i<ListLen(self.codeList)) AND (off>=e)
    code:=self.codeList[i]
    e:=e+code.codelen
    i++
  ENDWHILE
  IF (off>e) THEN RETURN NIL
  off:=off-(e-code.codelen)+code.code
  
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
      IF ((dbg[]-off)<best) AND (dbg[]>=off)
        best:=dbg[]-off
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
  
  dbg:=self.lines
  num:=self.numlines-1
  FOR a:=0 TO num STEP 2 DO IF dbg[]++-1=line THEN RETURN dbg[] ELSE dbg++
ENDPROC NIL

PROC edebug(trap1,trap2,do_at_break,do_at_refresh,cli_arg) OF e_exe
  DEF mytask:PTR TO tc,cptr:PTR TO e_code,code,alen
  
  cptr:=self.codeList[0]
  code:=cptr.code

  PutInt({opcodetrap1},OPCODE_TRAP0 OR trap1)
  PutInt({opcodetrap2},OPCODE_TRAP0 OR trap2)
  
  alen:=StrLen(cli_arg)+1
  mytask:=FindTask(NIL)
  mytask.trapcode:={tcode}
  LEA codejmp(PC),A0
  MOVE.L do_at_break,(A0)
  LEA refreshjmp(PC),A0
  MOVE.L do_at_refresh,(A0)
  LEA debuga4(PC),A0
  MOVE.L A4,(A0)
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
  BTST.B  #0,297(A0)
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
  MOVE.L D0,64(A7)			-> prepare return pc
  LEA pcstore(PC),A0
  SUBQ.L #2,D0
  MOVE.L D0,(A0)

  ->MOVE.L breakpoint(PC),D0		-> check for breakpoint
  ->BEQ.S nobreak
  
  MOVE.L	pcstore(PC),A0
  ->MOVE.L D0,A0
  MOVE.W (A0),D0
  CMP.W opcodetrap2(PC),D0
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
  BRA.S norefresh

dontstop:
  MOVE.L debuga4(PC),A4			-> restore A4
  MOVE.L A7,-(A7)
  MOVE.L refreshjmp(PC),A0
  JSR (A0)				-> call E func with frame
  ADDQ.L #4,A7
  TST.L D0
  BNE stophere

norefresh:  
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

tcode_jsr1:
 MOVEM.L A0/D0,-(A7)
 INT $42C0           -> MOVE.W CCR,D0
 LEA brkflag(PC),A0
 CLR.B (A0)
 BRA.S continue2      -> Ends up at same place.

tcode_jsr2:
 MOVEM.L A0/D0,-(A7)
 INT $42C0           -> MOVE.W CCR,D0
 LEA brkflag(PC),A0
 ST.B (A0)

continue2:
 LEA pcstore(PC),A0
 MOVE.L 8(A7),(A0)
 SUBQ.L #6,(A0)      -> Skip back to PC of our "ILLEGAL" command
 MOVE.W D0,-(A0)
 MOVEM.L (A7)+,A0/D0

->  SUBQ.L #4,A7       -> make space for return  -> Already taken car of with above routine
  MOVEM.L D0-D7/A0-A6,-(A7)
  LEA continue(PC),A0      -> pc,sr on the stack
  MOVE.L -(A0),D0
  MOVE.L -(A0),-(A7)
  ADDQ.L #6,D0                     -> Used to cross over ILLEGAL. JSR already sticks next IP on stack for us. So skip over JSR now.
  MOVE.L D0,64(A7)     -> prepare return pc

  LEA brkflag(PC),A0
  TST.B (A0)
  BNE.S stophere2

nobreak2:
  MOVE.L breakpointmem(PC),D0    -> check for breakpoint on mem
  BEQ.S nomembreak2
  MOVE.L D0,A0
  MOVE.L (A0),D0
  CMP.L  memval(PC),D0
  BNE.S stophere2

nomembreak2:
  MOVE.L stepovera7(PC),D0   -> check for step over
  BEQ.S stophere2
  CMPA.L stepovera5(PC),A5
  BEQ.S stophere2
  CMPA.L D0,A7       -> we compare TOP of frame, not actual A7
  BMI.S dontstop2

stophere2:
  MOVE.L debuga4(PC),A4      -> restore A4
  MOVE.L A7,-(A7)
  MOVE.L codejmp(PC),A0
  JSR (A0)       -> call E func with frame
  ADDQ.L #4,A7
  TST.L D0       -> see if we need to raise an exception
  BNE raise

dontstop2:
  MOVE.L pcstore(PC), D0
  LEA lastpc(PC), A0
  MOVE.L D0, (A0)
  MOVE.L (A7)+,D0
->  MOVEQ #-1,D1               -> This no longer functions anymore
->  MOVE.L $4.W,A6
->  JSR -144(A6)       -> SetSr(orig_sr,$FF)
  INT $44C0   -> MOVE D0,CCR         -> So we do this. Since we have no need nor should we be looking at the system SR bits
                         -> CCR is fine for the job. I doubt calling Supervisor in E would work on classic.
  MOVEM.L (A7)+,D0-D7/A0-A6    -> hold SR!
  RTS          -> retpc is on top!

                         -> That'a sll for the OS4 modifcations.
brkflag: INT 0
codejmp: LONG 0
refreshjmp: LONG 0
debuga4: LONG 0

stepovera7: LONG 0
stepovera5: LONG 0

opcodetrap1: INT 0
opcodetrap2: INT 0

->breakpoint: LONG 0			-> 0=no break, -1=run, other=break
breakpointmem: LONG 0			-> 0=no break, other=memaddress
memval: LONG 0				-> value for breakpointmem

exc: LONG 0
excinfo: LONG 0

-> Last known PC
lastpc: LONG 0

PROC setbreak(a)
  IF a=NIL THEN RETURN
  ->PutLong({breakpoint},a)
  IF Int(a)=OPCODE_JSR
    PutLong(a+2,{tcode_jsr2})
  ELSE
    PutInt(a,Int({opcodetrap2}))
  ENDIF
ENDPROC

PROC rembreak(a)
  IF a=NIL THEN RETURN
  ->PutLong({breakpoint},a)
  IF Int(a)=OPCODE_JSR
    PutLong(a+2,{tcode_jsr1})
  ELSE
    PutInt(a,Int({opcodetrap1}))
  ENDIF
ENDPROC

EXPORT PROC stepover(a7=NIL,a5=NIL) IS PutLong({stepovera7},a7) BUT PutLong({stepovera5},a5)
EXPORT PROC setmembreak(a) IS PutLong({breakpointmem},a) BUT PutLong({memval},IF a THEN Long(a) ELSE NIL)
EXPORT PROC setthrow(e,ei) IS PutLong({exc},e) BUT PutLong({excinfo},ei)
