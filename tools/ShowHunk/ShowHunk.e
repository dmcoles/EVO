/* simple hunk-dump program with 680x0 disassembler for code hunks */

/*
   WARNING: hunk_reloc32_short and hunk_relative_reloc hunks have not been
   tested. If you find a file with this type of hunk, and this program
   doesn't work with it, *PLEASE* contact the program authors so fixes may
   be made.
*/

/* bugs left:
   - link disasms wrong
   - bset should give <illegal ea> with bit > 31
*/

OPT OSVERSION=37

ENUM HUNK_UNIT=$3E7, HUNK_NAME, HUNK_CODE, HUNK_DATA, HUNK_BSS, HUNK_RELOC32,
     HUNK_RELOC16, HUNK_RELOC8, HUNK_EXT, HUNK_SYMBOL, HUNK_DEBUG,
     HUNK_END, HUNK_HEADER, HUNK_OVERLAY=$3F5, HUNK_BREAK, HUNK_DRELOC32,
     HUNK_DRELOC16, HUNK_DRELOC8, HUNK_LIB, HUNK_INDEX, HUNK_RELOC32_S,
     HUNK_REL_RELOC32

ENUM EXT_SYM=0, EXT_DEF, EXT_ABS, EXT_RES, EXT_NEWCOMMON, EXT_REF32=129,
     EXT_COMMON, EXT_REF16, EXT_REF8, EXT_DREF32, EXT_DREF16, EXT_DREF8

ENUM ER_NONE,ER_FILE,ER_MEM,ER_USAGE,ER_HUNKID,ER_BREAK,ER_FILETYPE

DEF flen,o:PTR TO LONG,mem,handle=NIL,hunkid,noreloc=TRUE,hunknr=-1,f=TRUE
DEF pc:PTR TO INT,hibyte,eleven2nine,eight,seven2six,five2three,two2zero,isize
DEF tmp,fname[256]:STRING,disasm

PROC main()
  DEF options:PTR TO LONG,rdargs

  options:=[0,0]
  IF rdargs:=ReadArgs('NAME/A,DISASM/S',options,NIL)
    IF options[0] THEN StrCopy(fname,options[0])
    disasm:=options[1]
    FreeArgs(rdargs)
  ELSE
    error(ER_USAGE)
  ENDIF

  PutStr('ShowHunk v2.0 Copyright (c) 1993 Jim Cooper\n')
  PutStr(' Original ShowHunk v0.1 (c) 1992 $#%!\n\n')

  flen:=FileLength(fname)
  handle:=Open(fname,OLDFILE)
  IF (flen<1) OR (handle=NIL)
    error(ER_FILE)
  ELSE
    mem:=New(flen)
    IF mem=NIL
      error(ER_MEM)
    ELSE
      IF Read(handle,mem,flen)<>flen THEN error(ER_FILE) ELSE process()
    ENDIF
  ENDIF
  error(ER_NONE)
ENDPROC

PROC process()
  DEF end,type

  o:=mem
  end:=o+flen
  IF (o[]<>HUNK_HEADER) AND (o[]<>HUNK_UNIT) AND (o[]<>HUNK_LIB) THEN error(ER_FILETYPE)
  PrintF('Hunk layout of file "\s" (\d bytes)\n\n',fname,flen)
  WHILE o<end
    IF CtrlC() THEN error(ER_BREAK)
    type:=Int(o); hunkid:=Int(o+2); o:=o+4
    IF (hunkid<>HUNK_UNIT) AND (hunkid<>HUNK_HEADER) AND (hunkid<>HUNK_BREAK) AND (hunkid<>HUNK_LIB) AND (hunkid<>HUNK_INDEX)
      IF f
        PrintF('HUNK \d',hunknr)
        INC hunknr
      ENDIF
      f:=FALSE
    ENDIF
    IF type
      IF type=$4000
        PutStr('\t** hunk forced to CHIP-mem\n')
      ELSE
        PrintF('\t** type: \d\n',type)
      ENDIF
    ENDIF
    SELECT hunkid
      CASE HUNK_UNIT;        PutStr('\thunk_unit: '); name()
      CASE HUNK_NAME;        PutStr('\thunk_name: '); name()
      CASE HUNK_CODE;
        PutStr('\thunk_code')
        IF disasm
          PutStr('\n'); code()
        ELSE
          PrintF(': \d bytes\n', skip())
        ENDIF
      CASE HUNK_DATA;        PrintF('\thunk_data: \d bytes\n',skip())
      CASE HUNK_BSS;         PrintF('\thunk_bss: \d bytes\n',Mul(o[]++,4))
      CASE HUNK_RELOC32;     PutStr('\thunk_reloc32\n'); reloc(4)
      CASE HUNK_RELOC16;     PutStr('\thunk_reloc16\n'); reloc(4)
      CASE HUNK_RELOC8;      PutStr('\thunk_reloc8\n'); reloc(4)
      CASE HUNK_EXT;         PutStr('\thunk_ext\n'); symbol()
      CASE HUNK_SYMBOL;      PutStr('\thunk_symbol\n'); symbol()
      CASE HUNK_DEBUG;       PrintF('\thunk_debug: \d bytes\n',skip())
      CASE HUNK_END;         f:=TRUE
      CASE HUNK_HEADER;      PutStr('\thunk_header\n'); head()
      CASE HUNK_OVERLAY;     PutStr('\thunk_overlay\n'); overlay()
      CASE HUNK_BREAK;       PutStr('\thunk_break\n'); hunknr:=1; f:=TRUE
      CASE HUNK_DRELOC32;    PutStr('\thunk_data-reloc32\n'); reloc(4)
      CASE HUNK_DRELOC16;    PutStr('\thunk_data-reloc16\n'); reloc(4)
      CASE HUNK_DRELOC8;     PutStr('\thunk_data-reloc8\n'); reloc(4)
      CASE HUNK_LIB;         PrintF('\tlibrary_hunk: \d bytes\n',Mul(o[]++,4)); hunknr:=0
      CASE HUNK_INDEX;       PrintF('\tlibrary_index: \d bytes\n\n',skip())
      CASE HUNK_RELOC32_S;   PutStr('\thunk_reloc32_short\n'); reloc(2);
      CASE HUNK_REL_RELOC32; PutStr('\thunk_relative_reloc32\n'); reloc(4);
      DEFAULT
        error(ER_HUNKID)
    ENDSELECT
  ENDWHILE
  PutStr(IF noreloc THEN '\nPosition independant code!\n' ELSE '\n')
ENDPROC

PROC overlay()
  DEF m,ts
  ts:=o[]++
  PrintF('\t  tablesize = \d\n',ts)
  m:=o[]++-2
  PrintF('\t  max. level overlay tree uses = \d\n',m)
  o:=ts*4+o
  hunknr:=1; f:=TRUE
ENDPROC

PROC symbol()
  DEF t,l,s,c,r
  t:=Char(o); l:=Int(o+2); o:=o+4
  WHILE l
    IF CtrlC() THEN error(ER_BREAK)
    IF t<EXT_NEWCOMMON                  /* sym def */
      s:=o; o:=l*4+o; c:=o[]++; PutChar(o-4,0)
      PrintF('\t  \s = $\h\n',s,c)
    ELSEIF t=EXT_COMMON OR t=EXT_NEWCOMMON  /* common ref */
      s:=o; o:=l*4+o; c:=o[]++; PutChar(o-4,0); r:=o[]++
      PrintF('\t  \s (\d ref\s) commonsize = \d\n',s,r,
             IF r=1 THEN '' ELSE 's',c)
      o:=r*4+o
    ELSE                                /* sym ref */
      s:=o; o:=l*4+o; r:=o[]++; PutChar(o-4,0)
      PrintF('\t  \s (\d ref\s)\n',s,r,IF r=1 THEN '' ELSE 's')
      o:=r*4+o
    ENDIF
    t:=Char(o); l:=Int(o+2); o:=o+4
  ENDWHILE
ENDPROC

PROC head()
  DEF a,b
  a:=0
  b:=o[a]++
  WHILE b
    PrintF('\t  libname: \s\n',o)
    a:=a+b
    b:=o[a]++
  ENDWHILE
  b:=o[]++
  hunknr:=o[]++
  a:=o[]++-hunknr+1
  PrintF('\t  #of hunks: \d\n',a)
  o:=a*4+o
ENDPROC

PROC reloc(size)
  DEF a
  noreloc:=FALSE
  a:=o[]++
  WHILE a
    IF CtrlC() THEN error(ER_BREAK)
    PrintF('\t  \d reloc entr\s for hunk #\d\n',a,
           IF a=1 THEN 'y' ELSE 'ies',o[]++)
    o:=a*size+o
    a:=o[]++
  ENDWHILE
ENDPROC

PROC name()
  DEF a
  a:=o[]++
  PrintF('\s\n',o)
  o:=a*4+o
ENDPROC

PROC skip()
  DEF a
  a:=Mul(o[]++,4)
  o:=o+a
ENDPROC a

PROC error(nr)
  IF handle THEN Close(handle)
  PutStr('\n')
  SELECT nr
    CASE ER_FILE;     PrintF('Could not read file "\s" !\n',fname)
    CASE ER_MEM;      PutStr('No memory for hunks!\n')
    CASE ER_USAGE;    PutStr('USAGE: ShowHunk <exe/objfile>\n')
    CASE ER_HUNKID;   PrintF('Illegal hunk id: $\h !\n',hunkid)
    CASE ER_BREAK;    PutStr('** BREAK: ShowHunk\n')
    CASE ER_FILETYPE; PutStr('Not an executable or object file.\n')
  ENDSELECT
  CleanUp()
ENDPROC

PROC illegal()
  PrintF('<illegal opcode: $\h>\n',pc[])
ENDPROC

PROC opsize(bit) RETURN ListItem(["b","w","l","?"],bit)

PROC bitsize(bit) RETURN IF bit THEN "l" ELSE "w"

PROC immed(val)
  PrintF(IF val < 16 THEN '\d' ELSE '$\h',val)
ENDPROC

PROC ccode(val,b) RETURN ListItem([IF b THEN 'ra' ELSE 't',
  IF b THEN 'sr' ELSE 'f','hi','ls','cc','cs','ne','eq','vc',
  'vs','pl','mi','ge','lt','gt','le','??'],val)

PROC ea(mode,reg,sd)
  IF mode < 5 THEN
    PrintF(ListItem(['d\d','a\d','(a\d)','(a\d)+','-(a\d)'],mode),reg)
  SELECT mode
    CASE 5;
       PutStr('(')
       immed(pc[1]++)
       PrintF(',a\d)',reg)
    CASE 6;
      tmp:=pc[1]++
      PutStr('(')
      immed(tmp AND $f)
      PrintF(',a\d,\s\d\s',reg,
                           IF tmp AND $8000 THEN 'a' ELSE 'd',
                           (Shr(tmp,12) AND 7),
                           IF tmp AND $800 THEN '.L)' ELSE '.W)')
    CASE 7;
      SELECT reg
        CASE 0;  PrintF('(\d).W',pc[1]++)
        CASE 1;  immed(Long(pc+2)); pc:=pc+4      /* bug! was: immed(^pc++) */
        CASE 2;
          PutStr('(')
          immed(pc[1]++)
          PutStr(',PC)')
        CASE 3;
          tmp:=pc[1]++
          PutStr('(')
          immed(tmp AND $f)
          PrintF(',PC,\c\d\s',IF tmp AND $8000 THEN "a" ELSE "d",
                              (Shr(tmp,12) AND 7),
                              IF tmp AND $800 THEN '.L)' ELSE '.W)')
        CASE 4;
          IF sd
            PutStr('#')
            immed(IF isize=2 THEN pc[1] ELSE Long(pc+2))
            pc:=pc+isize
          ELSE
            PutStr('SR')
          ENDIF
        DEFAULT;
          PutStr('<unknown ea!>')
      ENDSELECT
  ENDSELECT
ENDPROC

PROC movemregs(val,predec)
  DEF index,first=1,regs:PTR TO LONG

  regs:=['d0','d1','d2','d3','d4','d5','d6','d7',
         'a0','a1','a2','a3','a4','a5','a6','a7']

  IF predec
    FOR index:=15 TO 0 STEP -1
      IF val AND Shl(1,index)
        IF first = 0 THEN PutStr('/')
        PutStr(regs[15-index])
        first:=0
      ENDIF
    ENDFOR
  ELSE
    FOR index:=0 TO 15 STEP 1
      IF val AND Shl(1,index)
        IF first = 0 THEN PutStr('/')
        PutStr(regs[index])
        first:=0
      ENDIF
    ENDFOR
  ENDIF
ENDPROC

PROC code0000()
  DEF c,tmp2

  IF (eleven2nine = 7) OR (seven2six = 3)
    IF (eleven2nine = 7) AND (eight = 0)
      tmp:=pc[1]++
      PrintF('moves.\c\t',opsize(seven2six))
      IF Shr(tmp,11) AND 1
        ea(five2three,two2zero,1)
        PrintF(',\c\d\n',IF tmp AND $8000 THEN "a" ELSE "d",Shr(tmp,12) AND 7)
      ELSE
        PrintF('\c\d,',IF tmp AND $8000 THEN "a" ELSE "d",Shr(tmp,12) AND 7)
        ea(five2three,two2zero,0)
        PutStr('\n')
      ENDIF
    ELSEIF (eight = 0) AND (seven2six = 3)
      tmp:=pc[1]++
      IF (five2three = 7) AND (two2zero = 4)
        tmp2:=pc[1]++
        PrintF('cas2\td\d:d\d,d\d:d\d,\c\d:\c\d\n',
               (tmp AND 7), (tmp2 AND 7),
               (Shr(tmp,6) AND 7), (Shr(tmp2,6) AND 7),
               IF tmp AND $8000 THEN "a" ELSE "d", (Shr(tmp,12) AND 7),
               IF tmp2 AND $8000 THEN "a" ELSE "d", (Shr(tmp2,12) AND 7))
      ELSE
        PrintF('cas\td\d,d\d,',tmp AND 7, Shr(tmp,6) AND 7)
        ea(five2three,two2zero,0)
        PutStr('\n')
      ENDIF
    ELSE
      illegal()
    ENDIF
  ELSE
    IF five2three = 1
      PrintF('movep.\c\t',bitsize(seven2six AND 1))
      IF seven2six AND 2
        PrintF('d\d,\d(a\d)\n',eleven2nine,pc[1]++,two2zero)
      ELSE
        PrintF('\d(a\d),d\d\n',pc[1]++,two2zero,eleven2nine)
      ENDIF
    ELSEIF (eight = 1) OR ((((eleven2nine AND 3) = 0) AND (eight = 0)))
      PrintF(ListItem(['btst\t','bchg\t','bclr\t','bset\t'],seven2six))
      IF eight = 1
        PrintF('d\d,',eleven2nine)
      ELSE
        PrintF('#\d,',pc[1]++)
      ENDIF
      ea(five2three,two2zero,0)
      PutStr('\n')
    ELSE
      IF seven2six = 3
        tmp:=pc[1]++
        PrintF('\s.\c\t',IF Shr(tmp,11) AND 1 THEN 'chk2' ELSE 'cmp2',opsize(eleven2nine))
        ea(five2three,two2zero,1)
        PrintF(',\c\d\n',IF tmp AND $8000 THEN "d" ELSE "a",Shr(tmp,12) AND 3)
      ELSE
        c:=ListItem(['ori.','andi.','subi.','addi.',0,'eori.','cmpi.',0],eleven2nine)
        IF c THEN PutStr(c) ELSE illegal()
        PrintF('\c\t#',opsize(seven2six))
        immed(IF seven2six < 2 THEN pc[1]++ ELSE ^pc++)
        PutStr(',')
        ea(five2three,two2zero,0)
        PutStr('\n')
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC code0100()
  DEF subfield,bitseven,bitsix,curcode

  bitseven:=Shr(seven2six,1)
  bitsix:=seven2six AND 1

  IF pc[] = $4afa
    PutStr('bgnd\n')
  ELSE
    IF eight = 1
      IF bitsix = 1
        PutStr('lea\t')
        ea(five2three,two2zero,1)
        PrintF(',a\d\n',eleven2nine)
      ELSE
        PutStr('chk\t')
        ea(five2three,two2zero,0)
        PrintF(',d\d\n',eleven2nine)
      ENDIF
    ELSE
      subfield:=Shl(eleven2nine,1)+eight

      SELECT subfield
        CASE 0;
          IF seven2six = 3
            PutStr('move.w\t')
            ea(five2three,two2zero,1)
            PutStr(',sr\n')
          ELSE
            PrintF('negx.\c\t',opsize(seven2six))
            ea(five2three,two2zero,0)
            PutStr('\n')
          ENDIF
        CASE 1;
          IF seven2six = 3
            PutStr('move.w\tccr,')
            ea(five2three,two2zero,0)
            PutStr('\n')
          ELSE
            illegal()
          ENDIF
        CASE 2;
          PrintF('clr.\c\t',opsize(seven2six))
          ea(five2three,two2zero,0)
          PutStr('\n')
        CASE 4;
          IF seven2six = 3
            PutStr('move.w\t')
            ea(five2three,two2zero,1)
            PutStr(',ccr\n')
          ELSE
            PrintF('neg.\c\t',opsize(seven2six))
            ea(five2three,two2zero,0)
            PutStr('\n')
          ENDIF
        CASE 6;
          IF seven2six = 3
            PutStr('move.w\tsr,')
            ea(five2three,two2zero,0)
            PutStr('\n')
          ELSE
            PrintF('not.\c\t',opsize(seven2six))
            ea(five2three,two2zero,0)
            PutStr('\n')
          ENDIF
        CASE 8;
          IF seven2six = 0
            IF five2three = 1
              PrintF('link.l\ta\d,#-$\h\n',two2zero,0-1-^pc++)
            ELSE
              PutStr('nbcd\t')
              ea(five2three,two2zero,0)
              PutStr('\n')
            ENDIF
          ELSEIF seven2six = 1
            IF five2three = 0
              PrintF('swap\td\d\n',two2zero)
            ELSEIF five2three = 1
              PrintF('bkpt\t#\d\n',two2zero)
            ELSE
              PutStr('pea\t')
              ea(five2three,two2zero,0)
              PutStr('\n')
            ENDIF
          ELSE
            IF five2three = 0
              IF (Shl(eight,2)+seven2six) = 7 THEN PrintF('extb.l\td\d\n',two2zero) ELSE PrintF('ext.\c\td\d\n',bitsize(bitsix),two2zero)
            ELSE
              PrintF('movem.\c\t',bitsize(bitsix))
              movemregs(pc[1]++, IF five2three = 4 THEN 1 ELSE 0)
              PutStr(',')
              ea(five2three,two2zero,0)
              PutStr('\n')
            ENDIF
          ENDIF
        CASE 10;
          IF pc[] = $4afc
            PutStr('illegal\n')
          ELSE
            IF seven2six = 3
              PutStr('tas\t')
              ea(five2three,two2zero,0)
              PutStr('\n')
            ELSE
              PrintF('tst.\c\t',opsize(seven2six))
              ea(five2three,two2zero,0)
              PutStr('\n')
            ENDIF
          ENDIF
        CASE 12;
          tmp:=pc[1]++

          IF (Shl(eight,2)+seven2six) < 2
            IF seven2six = 1
              PrintF('div\c',IF Shr(tmp,11) AND 1 THEN "s" ELSE "u")
              IF ((Shr(tmp,10) AND 1) = 0) AND ((Shr(tmp,12) AND 7) <> (tmp AND 7))
                PutStr('l.l\t')
                ea(five2three,two2zero,1)
                PrintF(',d\d:d\d\n',Shr(tmp,12) AND 7,tmp AND 7)
              ELSE
                PutStr('.l\t')
                ea(five2three,two2zero,1)
                PrintF(',d\d',Shr(tmp,12) AND 7)
                IF Shr(tmp,10) AND 1 THEN PrintF(':d\d',tmp AND 7)
                PutStr('\n')
              ENDIF
            ELSE
              PrintF('mul\c.l\t',IF Shr(tmp,11) AND 1 THEN "s" ELSE "u")
              ea(five2three,two2zero,1)
              PrintF(',d\d',Shr(tmp,12) AND 7)
              IF Shr(tmp,10) AND 1 THEN PrintF(':d\d',tmp AND 7)
              PutStr('\n')
            ENDIF
          ELSE
            PrintF('movem.\c\t',bitsize(bitsix))
            ea(five2three,two2zero,0)
            PutStr(',')
            movemregs(tmp, IF five2three = 4 THEN 1 ELSE 0)
            PutStr('\n')
          ENDIF
        CASE 14;
          curcode:=pc[]

          SELECT curcode
            CASE $4e70;
              PutStr('reset\n')
            CASE $4e71;
              PutStr('nop\n')
            CASE $4e72;
              PutStr('stop\n')
            CASE $4e73;
              PutStr('rte\n')
            CASE $4e74;
              PrintF('rtd\t#\d\n',(Shl(pc[1]<32767+1,16)-pc[1]++))
            CASE $4e75;
              PutStr('rts\n')
            CASE $4e76;
              PutStr('trapv\n')
            CASE $4e77;
              PutStr('rtr\n')
            DEFAULT;
              IF bitseven = 1
                PutStr(IF bitsix = 1 THEN 'jmp\t' ELSE 'jsr\t')
                ea(five2three,two2zero,0)
                PutStr('\n')
              ELSE
                IF bitsix = 1
                  tmp:=Shr(five2three,1)

                  SELECT tmp
                    CASE 0;
                      PrintF('trap\t\d\n',(Shl((five2three AND 1),2)+two2zero))
                    CASE 1;
                      IF five2three AND 1
                        PrintF('unlk\ta\d\n',two2zero)
                      ELSE
                        PrintF('link.w\ta\d,#-$\h\n',two2zero,65536-pc[1]); pc++

                      ENDIF
                    CASE 2;
                      PrintF(IF five2three AND 1 THEN 'move\tusp,a\d\n' ELSE 'move\ta\d,usp\n',two2zero)
                    CASE 3;
                      PrintF('rtm\t\c\d\n',IF five2three AND 1 THEN "a" ELSE "d",two2zero)
                  ENDSELECT
                ELSE
                  illegal()
                ENDIF
              ENDIF
          ENDSELECT
        DEFAULT; illegal()
      ENDSELECT
    ENDIF
  ENDIF
ENDPROC

PROC code0101()
  IF seven2six < 3
    PutStr(IF eight = 1 THEN 'subq.' ELSE 'addq.')
    PrintF('\c\t#\d,',opsize(seven2six),eleven2nine)
    ea(five2three,two2zero,0)
    PutStr('\n')
  ELSE
    IF five2three = 1
      PrintF('db\s\td\d,L\z\h[8]\n',
             ccode((Shl(eleven2nine,1)+eight),0),
             two2zero,
             pc-o-2-(Shl(pc[1]<32767+1,16)-pc[1]))
      pc++
    ELSEIF five2three = 7
      PrintF('trap\s',ccode(Shl(eleven2nine,1)+eight,0))
      IF two2zero < 4
        IF two2zero AND 1 THEN PrintF('.w\t#\d',pc[1]++) ELSE PrintF('.l\t#\d',^pc++)
      ENDIF
      PutStr('\n')
    ELSE
      PrintF('s\s\t',ccode(Shl(eleven2nine,1)+eight,0))
      ea(five2three,two2zero,0)
      PutStr('\n')
    ENDIF
  ENDIF
ENDPROC

PROC code0110()
  DEF tmp2,ctl:PTR TO LONG

  IF (pc[] AND $fffe) = $4e7a
    tmp:=pc[1]++
    tmp2:= tmp AND $fff
    IF tmp2 > 7
      ctl:=ListItem(['usp','vbr','caar','msp','isp','mmusr','urp','srp'],tmp2 - $800)
    ELSE
      ctl:=ListItem(['sfc','dfc','cacr','tc','itt0','itt1','dtt0','dtt1'],tmp2)
    ENDIF
    IF ctl
      PutStr('movec\t')
      IF pc[-1] AND 1
        PrintF('\s,\c\d\n',ctl,IF tmp AND $8000 THEN "a" ELSE "d",Shr(tmp,12) AND 7)
      ELSE
        PrintF('\c\d,\s\n',IF tmp AND $8000 THEN "a" ELSE "d",Shr(tmp,12) AND 7,ctl)
      ENDIF
    ELSE
      illegal()
    ENDIF
  ELSE
    PrintF('b\s',ccode((Shl(eleven2nine,1)+eight),1))
    tmp:=Char(pc+1)
    IF tmp = 0
      PrintF('.w\tL\z\h[8]\n',pc-o-2-(Shl(pc[1]<32767+1,16)-pc[1]))
      pc++
    ELSE
      PrintF('.b\tL\z\h[8]\n',pc-o-2-(Shl(tmp<127+1,8)-tmp))
    ENDIF
  ENDIF
ENDPROC

PROC code1000()
  IF Shr(pc[],4) AND %11111 = %10100   /* bug!: was  Shr(five2three,1) = 0 */
    IF eight
      IF seven2six
        SELECT seven2six
          CASE 1;  PutStr('pack\t')
          CASE 2;  PutStr('unpk\t')
          DEFAULT; illegal()
        ENDSELECT
        PrintF(IF five2three AND 1 THEN '-(a\d),-(a\d),#\d\n' ELSE 'd\d,d\d,#\d\n',two2zero,eleven2nine,pc[1]++)
      ELSE
        PrintF(IF five2three AND 1 THEN 'sbcd\t-(a\d),-(a\d)\n' ELSE 'sbcd\td\d,-d\d\n',two2zero,eleven2nine)
      ENDIF
    ELSE
      illegal()
    ENDIF
  ELSE
    IF seven2six = 3
      PutStr(IF eight = 1 THEN 'divs\t' ELSE 'divu\t')
      ea(five2three,two2zero,1)
      PrintF(',d\d\n',eleven2nine)
    ELSE
      PrintF('or.\c\t',opsize(seven2six))
      IF eight = 1
        PrintF('d\d,',eleven2nine)
        ea(five2three,two2zero,0)
      ELSE
        ea(five2three,two2zero,1)
        PrintF(',d\d',eleven2nine)
      ENDIF
      PutStr('\n')
    ENDIF
  ENDIF
ENDPROC

PROC code1001()
  IF seven2six = 3
    PrintF('suba.\c\t',bitsize(eight))
    ea(five2three,two2zero,1)
    PrintF(',a\d\n',eleven2nine)
  ELSE
    IF (Shr(five2three,1) = 0) AND (eight = 1)
      PrintF('subx.\c\t',opsize(seven2six))
      PrintF(IF five2three AND 1 THEN '-(a\d),-(a\d)\n' ELSE 'd\d,d\d\n',two2zero,eleven2nine)
    ELSE
      PrintF('sub.\c\t',opsize(seven2six))
      IF eight = 1
        PrintF('d\d,',eleven2nine)
        ea(five2three,two2zero,0)
        PutStr('\n')
      ELSE
        ea(five2three,two2zero,1)
        PrintF(',d\d\n',eleven2nine)
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC code1011()
  IF seven2six = 3
    PrintF('cmpa.\c\t',bitsize(eight))
    ea(five2three,two2zero,1)
    PrintF(',a\d\n',eleven2nine)
  ELSE
    IF five2three = 1
      PrintF('cmpm.\c\t(a\d)+,(a\d)+\n',opsize(seven2six),two2zero,eleven2nine)
    ELSE
      IF eight = 1
        PrintF('eor.\c\td\d,',opsize(seven2six),eleven2nine)
        ea(five2three,two2zero,0)
        PutStr('\n')
      ELSE
        PrintF('cmp.\c\t',opsize(seven2six))
        ea(five2three,two2zero,1)
        PrintF(',d\d\n',eleven2nine)
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC code1100()
  IF seven2six = 3
    PutStr(IF eight = 1 THEN 'mulu.w\t' ELSE 'muls.w\t')
    ea(five2three,two2zero,1)
    PrintF(',d\d\n',eleven2nine)
  ELSE
    IF Shr(five2three,1) <> 0
      PrintF('and.\c\t',opsize(seven2six))
      IF eight = 1
        PrintF('d\d,',eleven2nine)
        ea(five2three,two2zero,0)
        PutStr('\n')
      ELSE
        ea(five2three,two2zero,1)
        PrintF(',d\d\n',eleven2nine)
      ENDIF
    ELSE
      IF seven2six = 0
        PrintF(IF five2three AND 1 THEN 'abcd\t-(a\d),-(a\d)\n' ELSE 'abcd\td\d,d\d\n',two2zero,eleven2nine)
      ELSE
        PutStr('exg\t')
        tmp:=Shl(seven2six,3)+five2three
        IF tmp = 8
          PrintF('d\d,d\d\n',two2zero,eleven2nine)
        ELSEIF tmp = 9
          PrintF('a\d,a\d\n',two2zero,eleven2nine)
        ELSEIF tmp = 17
          PrintF('a\d,d\d\n',two2zero,eleven2nine)
        ELSE
          illegal()
        ENDIF
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC code1101()
  IF seven2six = 3
    PrintF('adda.\c\t',bitsize(eight))
    ea(five2three,two2zero,1)
    PrintF(',a\d\n',eleven2nine)
  ELSE
    IF (Shr(five2three,1) = 0) AND (eight = 1)
      PrintF('addx.\c\t',opsize(seven2six))
      PrintF(IF five2three AND 1 THEN '-(a\d),-(a\d)\n' ELSE 'd\d,d\d\n',two2zero,eleven2nine)
    ELSE
      PrintF('add.\c\t',opsize(seven2six))
      IF eight = 1
        PrintF('d\d,',eleven2nine)
        ea(five2three,two2zero,0)
        PutStr('\n')
      ELSE
        ea(five2three,two2zero,1)
        PrintF(',d\d\n',eleven2nine)
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC code1110()
  DEF subfield,tmp2

  IF seven2six = 3
    tmp:=pc[1]++
    tmp2:=tmp AND 31
    subfield:=Shl((eleven2nine AND 3),1)+eight
    PutStr(ListItem(['bftst','bfextu','bfchg','bfexts','bfclr','bfffo','bfset','bfins'],subfield))
    PutStr('\t')
    IF subfield = 7 THEN PrintF('d\d,',Shr(tmp,12) AND 7)
    ea(five2three,two2zero,0)
    PrintF(IF Shr(tmp,11) AND 1 THEN '{d\d:' ELSE '{\d:',Shr(tmp,6) AND 31)
    PrintF(IF Shr(tmp,5) AND 1 THEN 'd\d}' ELSE '\d}',IF tmp2 THEN tmp2 ELSE 32)

    IF (subfield < 7) AND (subfield AND 1) THEN PrintF(',d\d',Shr(tmp,12) AND 7)

    PutStr('\n')
  ELSE
    PrintF('\s\c',ListItem(['as','ls','rox','ro'],IF seven2six=3 THEN eleven2nine ELSE five2three AND 3),IF eight=1 THEN "l" ELSE "r")
    IF seven2six = 3
      PutStr('\t')
      ea(five2three,two2zero,0)
      PutStr('\n')
    ELSE
      PrintF(IF five2three AND 4 THEN '.\c\td\d,d\d\n' ELSE '\c\t#\d,d\d\n',opsize(seven2six),eleven2nine,two2zero)
    ENDIF
  ENDIF
ENDPROC

PROC code()
  DEF number

  isize:=2
  number:=Shl(o[],2)+o+4
  pc:=o+4

  PutStr('\n')

  WHILE (pc < number)
    hibyte:=Shr(Char(pc),4)
    eleven2nine:=Shr(Char(pc),1) AND 7
    eight:=Char(pc) AND 1
    seven2six:=Shr(Char(pc+1),6) AND 3
    five2three:=Shr(Char(pc+1),3) AND 7
    two2zero:=Char(pc+1) AND 7

    IF CtrlC() THEN error(ER_BREAK)             /* essential! */

    PrintF('L\z\h[8]:',pc-o-4)                  /* for offsets */

    PutStr('\t')

    IF (hibyte > 0) AND (hibyte < 4)
      PutStr(IF (eight=0) AND (seven2six=1) THEN 'movea.' ELSE 'move.')
      SELECT hibyte
        CASE 1; PutStr('b')
        CASE 2; PutStr('l'); isize:=4
        CASE 3; PutStr('w')
      ENDSELECT
      PutStr('\t')
      ea(five2three,two2zero,1)
      PutStr(',')
      ea(Shl(eight,2)+seven2six,eleven2nine,0)
      PutStr('\n')
      isize:=2
    ELSE
      SELECT hibyte
        CASE 0;                 /* Bit Manipulation/MOVEP/immediate */
          code0000()
        CASE 4;                 /* Miscellaneous */
          code0100()
        CASE 5;                 /* ADDQ/SUBQ/Scc/DBcc/TRAPcc */
          code0101()
        CASE 6;                 /* Bcc/BSR/BRA/MOVEC */
          code0110()
        CASE 7;                 /* MOVEQ */
          PutStr('moveq\t#')
          immed(Char(pc+1))
          PrintF(',d\d\n',eleven2nine)
        CASE 8;                 /* OR/DIV/SBCD */
          code1000()
        CASE 9;                 /* SUB/SUBA/SUBX */
          code1001()
        CASE 10;                /* (unassigned, reserved) */
          illegal()
        CASE 11;                /* CMP/EOR */
          code1011()
        CASE 12;                /* AND/MUL/ABCD/EXG */
          code1100()
        CASE 13;                /* ADD/ADDX */
          code1101()
        CASE 14;                /* Shift/Rotate/Bit Field */
          code1110()
        CASE 15;                /* Coprocessor Interface */
          illegal()
      ENDSELECT
    ENDIF
    pc++
  ENDWHILE

  PutStr('\n')

  o:=number
ENDPROC

