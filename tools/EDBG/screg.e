-> screg.e

OPT MODULE

MODULE '*sctext', '*eexe'

EXPORT OBJECT scrollreg OF scrolltext PRIVATE
  txt:PTR TO LONG, frame:stackframe
ENDOBJECT

CONST LIST_SIZE=20

PROC scrollreg(stackframe:PTR TO stackframe) OF scrollreg
  DEF m:PTR TO LONG,x
  IF (m:=List(LIST_SIZE))=NIL THEN Raise("MEM")
  SetList(m,LIST_SIZE)
  self.txt:=m
  MapList({x},m,m,`String(13))
  IF ForAll({x},m,`x)=FALSE THEN Raise("MEM")
  copyframe(stackframe,self.frame)
  pokeregs(m,stackframe,self.frame)
  self.settext(m,NIL,13)
ENDPROC

PROC copyframe(st:PTR TO stackframe,old:PTR TO stackframe)
  CopyMem(st,old,SIZEOF stackframe-4)
  old.stack[]:=st.stack
ENDPROC

SET C, V, Z, N, X

CONST S=$2000, T=$8000, I=$0E00

PROC pokeregs(t:PTR TO LONG,st:PTR TO stackframe,old:PTR TO stackframe)
  DEF a, b, regs:PTR TO LONG
  regs:=old.regs
  FOR a:=0 TO 7 DO StringF(t[a],'D\d=$\z\h[8]\c',a,b:=st.regs[a],IF b=regs[a] THEN " " ELSE "*")
  FOR a:=0 TO 6 DO StringF(t[a+9],'A\d=$\z\h[8]\c',a,b:=st.regs[a+8],IF b=regs[a+8] THEN " " ELSE "*")
  StringF(t[16],'A7=$\z\h[8]\c',b:=st.stack,IF b=old.stack[] THEN " " ELSE "*")
  StringF(t[18],'PC=$\z\h[8]\c',b:=st.returnpc,IF b=old.returnpc THEN " " ELSE "*")
  b:=st.status
  StringF(t[19],'ST=\c\c\c\c\c\c\c\c\c\c',
          IF b AND T THEN "T" ELSE " ",
          IF b AND S THEN "S" ELSE " ",
          IF a:=Shr(b AND I,9) THEN "I" ELSE " ",
          IF a THEN "0"+a ELSE " ",
          IF b AND X THEN "X" ELSE " ",
          IF b AND N THEN "N" ELSE " ",
          IF b AND Z THEN "Z" ELSE " ",
          IF b AND V THEN "V" ELSE " ",
          IF b AND C THEN "C" ELSE " ",
          IF b=old.status THEN " " ELSE "*")
  copyframe(st,old)
ENDPROC

PROC refreshreg(stackframe:PTR TO stackframe) OF scrollreg
  pokeregs(self.txt,stackframe,self.frame)
  self.refreshwindow()
ENDPROC
