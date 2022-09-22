-> Yes! A real E debugger!

OPT OSVERSION=37, LARGE

MODULE 'tools/clonescreen', 'tools/macros', 'tools/arexx',
       'tools/EasyGUI', 'tools/constructors', 'tools/exceptions',
       'tools/iterators',
       '*eexe', 'class/sc', '*sctext', '*schex', '*screg', 'other/sendexplorer',
       'dos/dostags', 'exec/lists', 'exec/nodes',
       'gadtools', 'libraries/gadtools',
       'intuition/intuition', 'intuition/screens', 'intuition/gadgetclass',
       'graphics/text', 'graphics/rastport',
       'rexx/storage', 'rexxsyslib', 'graphics/gfxbase'

OBJECT dbgwin
  next:PTR TO dbgwin,type
ENDOBJECT

OBJECT srcwin OF dbgwin
  scwin:PTR TO scrolltext,src:PTR TO e_source
ENDOBJECT

OBJECT memwin OF dbgwin
  scwin:PTR TO scrollhex,addr
ENDOBJECT

OBJECT regwin OF dbgwin
  scwin:PTR TO scrollreg
ENDOBJECT

OBJECT varwin OF dbgwin
  scwin:PTR TO scrolltext
ENDOBJECT

OBJECT wvar OF ln
  v:PTR TO CHAR
ENDOBJECT

CONST RXSTR_SIZE=250

DEF exe=NIL:PTR TO e_exe,frame:PTR TO stackframe,
    oscr=NIL,scr=NIL:PTR TO screen,font=NIL:PTR TO textfont,depth,xsize,ysize,
    title,doabout=TRUE,dorefresh=TRUE,dosavewindowpos=TRUE,dosavevars=TRUE,argstring[100]:STRING,
    dwins=NIL:PTR TO dbgwin,numsrc=0,wrapsrc=FALSE,maxsrcs=0,stackwin=NIL:PTR TO memwin,
    vwin=NIL:PTR TO varwin,varlist=NIL:PTR TO LONG,vars:PTR TO lh,
    rwin=NIL:PTR TO regwin,
    visual=NIL,menu=NIL,whatstep,evgh=NIL:PTR TO guihandle,
    followgh=NIL:PTR TO guihandle,followspeed=30,repeatcount=0,repeatover=TRUE,
    toolwin=NIL:PTR TO window,toolgads=NIL:PTR TO LONG,
    currentwin:PTR TO srcwin,		-> active intuition
    activewin:PTR TO srcwin,		-> where (pc) is
    lastsec=0,lastmic=0,findstr[100]:STRING,offstr[12]:STRING,
    casesensitivefind=TRUE,lastfind=-1,ocon=NIL,reqtitle,oldi,oldo,
    first_step_done=FALSE,stop_executing=FALSE,unreachablea7,
    srcport=NIL,rexxport=NIL,rexxname,startExp=FALSE,oldvy=-1,
    fx=0,fy=0,fxs=0,fys=0,explorer[RXSTR_SIZE]:STRING,pubname[100]:STRING,
    rxs1[RXSTR_SIZE]:STRING,rxs2[RXSTR_SIZE]:STRING,rxs3[RXSTR_SIZE]:STRING,
    trap1, trap2

ENUM STEP_NONE,STEP_IN,STEP_OVER,STEP_RUN,STEP_THROW,STEP_FOLLOW

CONST MAX_WATCH=250, MAX_WLINE=100

RAISE "MEM" IF String()=NIL

PROC main() HANDLE
  DEF options:PTR TO LONG,rdargs=NIL,exename[100]:STRING,e:PTR TO dbgwin,
      pubconname[200]:STRING, i
  DEF gb:PTR TO gfxbase
  title:='EDBG v3.6.0, The E Debugger! © 1994-1997 Wouter (and Jason), 2021-2022 Darren Coles'
  reqtitle:='EDBG'
  vars:=newlist()
  options:=[0,0,0,0]
  IF rdargs:=ReadArgs('EXECUTABLE/A,NOTRAP/S,PUBSCREEN/K,ARG/K',options,NIL)
    StrCopy(exename,options[0])
    IF options[3] THEN StrCopy(argstring,options[3])
    IF options[2]
      StrCopy(pubname,options[1])
      IF scr:=LockPubScreen(pubname) THEN font:=scr.rastport::rastport.font
    ENDIF
    FreeArgs(rdargs)
  ELSE
    Raise("ARGS")
  ENDIF
  IF options[1]=0
    trap1:=AllocTrap(-1)
    trap2:=AllocTrap(-1)
  ELSE
    trap1:=-1
    trap2:=-1
  ENDIF
 
  WriteF('\s.\nLoading "\s"...\n',title,exename)
  NEW exe.load(exename,trap1,trap2)
  IF scr=NIL
    StrCopy(pubname,'EDBG')
    IF options[1] THEN StrAdd(pubname,options[1])
    scr,font:=openclonescreen('Workbench',title,2,pubname)
    oscr:=scr
    PubScreenStatus(scr,0)       -> TEMP!!
  ENDIF
  gb:=gfxbase
  font:=gb.defaultfont
  rexxname:=IF oscr THEN pubname ELSE 'EDBG'
  depth,xsize,ysize:=getcloneinfo(scr)
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise("GT")
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN Raise("MENU")
  createmenus()
  createtoolbar()
  IF (srcport:=CreateMsgPort())=NIL THEN Raise("PORT")
  rexxport:=rx_OpenPort(rexxname)
  StrCopy(pubconname,'CON:0/900/640/50/Standard Input and Output:/SCREEN ')
  StrAdd(pubconname,pubname)
  IF ocon:=Open(pubconname,NEWFILE)
    oldi:=SelectInput(ocon)
    oldo:=SelectOutput(ocon)
  ELSE
    Throw("OPEN",'CON:')
  ENDIF
  exe.edebug(trap1,trap2,{step},{update},argstring)
EXCEPT DO
  IF followgh OR repeatcount THEN Delay(6) BUT request1('Program completed execution','_OK',"o")
  IF startExp
    quitExplorer()
    FOR i:=1 TO 20
    EXIT isExplorerRunning()=FALSE
      Delay(6)
    ENDFOR
  ENDIF
  removefollow()
  WHILE dwins
    e:=dwins
    dwins:=dwins.next
    END e
  ENDWHILE
  IF ocon
    SelectInput(oldi)
    SelectOutput(oldo)
    Close(ocon)
  ENDIF
  rx_ClosePort(rexxport)
  rexxport:=NIL
  IF srcport THEN DeleteMsgPort(srcport)
  deletetoolbar()      -> no request()s after this
  IF menu THEN FreeMenus(menu)
  IF visual THEN FreeVisualInfo(visual)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF oscr
    IF closeclonescreen(oscr,font)=FALSE
      Delay(20)
      WHILE closeclonescreen(oscr,font)=FALSE
        request1('Please close other windows on this screen!','_OK',"o")
      ENDWHILE
    ENDIF
  ELSEIF scr
    UnlockPubScreen(NIL,scr)
  ENDIF
  END exe
  IF trap1<>-1 THEN FreeTrap(trap1)
  IF trap2<>-1 THEN FreeTrap(trap2)
  
  SELECT exception
    CASE "MEM";  WriteF('Aaargh! no mem!\n')
    CASE "ARGS"; WriteF('Bad Args! (try "edbg ?")\n')
    CASE "OPEN"; WriteF('Failed to open "\s".\n',exceptioninfo)
    CASE "IN";   WriteF('Problems while reading file.\n')
    CASE "eexe"; WriteF('Not a valid E executable\n')
    CASE "eexd"; WriteF('Try compiling with "DEBUG" first\n')
    CASE "db50"; WriteF('Needs to be compiled with "DEBUG50"\n')
    CASE "SCR";  WriteF('no screen!\n')
    CASE "GT";   WriteF('no "gadtools.library"!\n')
    CASE "MENU"; WriteF('no menus!\n')
    CASE "WIN";  WriteF('no window!\n')
    CASE "DOUB"; WriteF('port with same name already exists! (another EDBG running?)\n')
    CASE "SIG";  WriteF('could not allocate signal!\n')
    DEFAULT; report_exception()
  ENDSELECT
ENDPROC

PROC createmenus()
  IF (menu:=CreateMenusA([
    1,0,'Project',0,0,0,0,
      2,0,'About...',            0 ,0,0,0,
      2,0,'Settings...',        'P',0,0,0,
      2,0,'Save Settings',      'W',0,0,0,
      2,0,'Quit',               'Q',0,0,0,
    1,0,'Windows',0,0,0,0,
      2,0,'Source',             'S',0,0,0,
      2,0,'Registers',          'D',0,0,0,
      2,0,'Memory',             'M',0,0,0,
      2,0,'Stack',              'T',0,0,0,
      2,0,'Variables',          'X',0,0,0,
    1,0,'Debug',0,0,0,0,
      2,0,'Step In (left)',     'I',0,0,0,
      2,0,'Step Over (down)',   'O',0,0,0,
      2,0,'Step Follow',         0 ,0,0,0,
      2,0,'Repeat Step',         0 ,0,0,0,
      2,0,'Pause',               0 ,0,0,0,
      2,0,'Watch Variable',      0 ,0,0,0,
      2,0,'Set Breakpoint',      0 ,0,0,0,
      2,0,'Memory Breakpoint',  'B',0,0,0,
      2,0,'Clear Breakpoints',  'C',0,0,0,
      2,0,'Run upto Breakpoint','R',0,0,0,
      2,0,'Raise Exception',    'E',0,0,0,
    1,0,'Tools',0,0,0,0,
      2,0,'Eval E Expression',  'K',0,0,0,
      2,0,'Modify Variable',     0 ,0,0,0,
      2,0,'Refresh Views',      'V',0,0,0,
      2,0,'Find in Source',     'F',0,0,0,
      2,0,'Find next',          'N',0,0,0,
      2,0,'Locate Offset',      'L',0,0,0,
    1,0,'Rexx',0,0,0,0,
      2,0,'Execute script 1',    0 ,0,0,0,
      2,0,'Execute script 2',    0 ,0,0,0,
      2,0,'Execute script 3',    0 ,0,0,0,
    0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN Raise("MENU")
  IF LayoutMenusA(menu,visual,[GTMN_NEWLOOKMENUS,TRUE,NIL])=FALSE THEN Raise("MENU")
ENDPROC

/*-----------------------------------------------------------------------*/

ENUM T_SRC,T_MEM,T_STACK,T_REG,T_VAR

PROC message() OF dbgwin
  IF self.next THEN self.next.message()
ENDPROC

PROC refresh() OF dbgwin
  IF self.next THEN self.next.refresh()
ENDPROC

PROC end() OF dbgwin
  DEF x:PTR TO dbgwin
  IF (x:=dwins)=self
    dwins:=self.next
  ELSE
    WHILE x.next
    EXIT x.next=self
      x:=x.next
    ENDWHILE
    IF x.next THEN x.next:=self.next
  ENDIF
ENDPROC

/*----------------------------------------------------------------------*/

PROC srcwin(src:PTR TO e_source) OF srcwin
  DEF x:PTR TO scrolltext,a
  self.next:=dwins
  dwins:=self
  self.type:=T_SRC
  self.src:=src
  self.scwin:=NEW x.settext(src.lines(),src.bpoints(),120)
  IF (fx>=xsize) OR (fy>=ysize) OR (fxs>=xsize) OR (fys>=ysize) OR (fxs<40) OR (fys<20)
    a:=(numsrc+1)*(font.ysize+3)+IF wrapsrc THEN 5 ELSE 0
    IF maxsrcs=0
      IF ysize-a<(10*font.ysize)
        maxsrcs:=numsrc
        numsrc:=0
        wrapsrc:=TRUE
        a:=font.ysize+3+5
      ENDIF
    ENDIF
    fx:=numsrc*10+49+IF wrapsrc THEN 5 ELSE 0
    fy:=a
    fxs:=500
    fys:=Min(ysize-a,400)
  ENDIF
  x.open(src.name(),fx,fy,fxs,fys,scr,IDCMP_MENUPICK OR IDCMP_MOUSEBUTTONS OR IDCMP_RAWKEY,{handlesrc},srcport,self)
  IF SetMenuStrip(x.window,menu)=FALSE THEN Raise("MENU")
  IF (numsrc++>=maxsrcs) AND maxsrcs
    numsrc:=0
    wrapsrc:=(wrapsrc=FALSE)
  ENDIF
  fx:=fy:=fxs:=fys:=0
ENDPROC

PROC end() OF srcwin
  DEF sc:PTR TO scrolltext
  sc:=self.scwin
  IF sc.window THEN ClearMenuStrip(sc.window)
  END sc
  SUPER self.end()
  IF 0>numsrc-- THEN numsrc:=maxsrcs
ENDPROC

/*----------------------------------------------------------------------*/

PROC memwin(addr,type) OF memwin
  DEF x:PTR TO scrollhex,a
  self.next:=dwins
  dwins:=self
  self.type:=type
  self.addr:=addr
  IF type=T_STACK THEN stackwin:=self
  self.scwin:=NEW x.setmem(addr)
  a:=40*font.xsize+24
  x.open(IF type=T_MEM THEN 'Memory View' ELSE 'Stack View',
         xsize-a,font.ysize+3,a,ysize/3,scr,IDCMP_MENUPICK,{handlesrc})
  IF SetMenuStrip(x.window,menu)=FALSE THEN Raise("MENU")
ENDPROC

PROC message() OF memwin
  self.scwin.setmem(self.addr)
  IF self.next THEN self.next.message()
  IF self.scwin.handle() THEN END self
ENDPROC

PROC refresh() OF memwin
  self.scwin.setmem(self.addr)
  self.scwin.refreshwindow()
  IF self.next THEN self.next.refresh()
ENDPROC

PROC end() OF memwin
  DEF sc:PTR TO scrolltext
  sc:=self.scwin
  IF self.type=T_STACK THEN stackwin:=NIL
  IF sc.window THEN ClearMenuStrip(sc.window)
  END sc
  SUPER self.end()
ENDPROC

/*----------------------------------------------------------------------*/

PROC regwin() OF regwin
  DEF x:PTR TO scrollreg,a
  self.next:=dwins
  dwins:=self
  self.type:=T_REG
  self.scwin:=NEW x.scrollreg(frame)
  a:=13*font.xsize+24
  x.open('Register View',xsize-a,font.ysize+3,a,ysize/2,scr,IDCMP_MENUPICK,{handlesrc})
  IF SetMenuStrip(x.window,menu)=FALSE THEN Raise("MENU")
  rwin:=self
ENDPROC

PROC message() OF regwin
  IF self.next THEN self.next.message()
  IF self.scwin.handle() THEN END self
ENDPROC

PROC refresh() OF regwin
  self.scwin.refreshreg(frame)
  IF self.next THEN self.next.refresh()
ENDPROC

PROC end() OF regwin
  DEF sc:PTR TO scrolltext
  rwin:=NIL
  sc:=self.scwin
  IF sc.window THEN ClearMenuStrip(sc.window)
  END sc
  SUPER self.end()
ENDPROC

/*----------------------------------------------------------------------*/

PROC varwin() OF varwin
  DEF x:PTR TO scrolltext
  self.next:=dwins
  dwins:=self
  self.type:=T_VAR
  IF varlist=NIL THEN IF (varlist:=List(MAX_WATCH))=NIL THEN Raise("MEM")
  constructvars()
  self.scwin:=NEW x.settext(varlist,NIL,MAX_WLINE)
  IF (fx>=xsize) OR (fy>=ysize) OR (fxs>=xsize) OR (fys>=ysize) OR (fxs<40) OR (fys<20)
    fx:=xsize/8
    fy:=ysize/2
    fxs:=xsize-(xsize/4)
    fys:=ysize/4
  ENDIF
  x.open('Variable View',fx,fy,fxs,fys,scr,IDCMP_MENUPICK OR IDCMP_MOUSEBUTTONS OR IDCMP_RAWKEY,{handlevar})
  IF SetMenuStrip(x.window,menu)=FALSE THEN Raise("MENU")
  vwin:=self
  fx:=fy:=fxs:=fys:=0
ENDPROC

PROC message() OF varwin
  IF self.next THEN self.next.message()
  IF self.scwin.handle() THEN END self
ENDPROC

PROC refresh() OF varwin
  varrefresh(self)
  IF self.next THEN self.next.refresh()
ENDPROC

PROC varrefresh(win:PTR TO varwin)
  constructvars()
  win.scwin.settext(varlist,NIL,MAX_WLINE)
  win.scwin.refreshwindow()
ENDPROC

PROC end() OF varwin
  DEF sc:PTR TO scrolltext
  vwin:=NIL
  sc:=self.scwin
  IF sc.window THEN ClearMenuStrip(sc.window)
  END sc
  SUPER self.end()
ENDPROC

PROC actionvar(y)
  DEF wv:PTR TO wvar,n=0,s[100]:STRING,v,vptr,type,r
  wv:=vars.head
  WHILE wv.succ
    v,vptr,type:=getvarval(wv.v)
    IF type
      IF y=n++
        StringF(s,'Variable "\s" selected.',wv.v)
        r:=request3(s,'_Remove','_Modify','_Cancel',"r","m","c")
        IF r=1
          Remove(wv)
          varrefresh(vwin)
        ELSEIF r=2
          StringF(s, IF (v>4096) OR (v<-4096) THEN '$\h' ELSE '\d',v)
          r:=easyguiA(reqtitle,
            [ROWS,
              [TEXT,'New contents of variable?',NIL,FALSE,3],
              [STR,1,'_Value:',s,100,10,0,0,"v"],
              [COLS,[TEXT,'(Examples: 0,$0,var,{var})',NIL,FALSE,3],[BUTTON,{ehelp},'_Help',0,"h"]],
              [BAR],
              [COLS,
                [BUTTON,1,'_OK',0,"o"],
                [SPACEH],
                [BUTTON,0,'_Cancel',0,"c"]
              ]
            ],
            [EG_SCRN,scr,NIL])
          IF r=1
            r,v:=extval(s)
            IF r
              SELECT 8 OF type
                CASE 3 TO 7
                  frame.regs[type]:=v
                CASE 1,2
                  ^vptr:=v
              ENDSELECT
              varrefresh(vwin)
            ENDIF
          ENDIF
        ENDIF
        RETURN
      ENDIF
    ENDIF
    wv:=wv.succ
  ENDWHILE
ENDPROC

PROC addvar(var,shift=FALSE)
  DEF wv:PTR TO wvar
  IF openvarwin()
    IF shift THEN getvarval(var,TRUE)
    IF findtracedvar(var)
      fastrequest('You''re already watching this variable')
    ELSE
      AddTail(vars,NEW wv)
      wv.v:=StrCopy(String(StrLen(var)),var)
      wv.name:=String(MAX_WLINE)
      IF wv.name=NIL THEN Raise("MEM")
      varrefresh(vwin)
    ENDIF
  ENDIF
ENDPROC

PROC addval(s,v)
  DEF vl:PTR TO LONG,a,c,t[20]:STRING
  IF TypeOfMem(v)
    vl:=v
    StrAdd(s,' [')
    FOR a:=1 TO 4 DO StrAdd(s,StringF(t,'\z\h[8] ',vl[]++))
    StrAdd(s,' \q')
    FOR a:=1 TO 16 DO (c:=v[]++) BUT StrAdd(s,IF (c>32) AND (c<127) THEN [c,0]:CHAR ELSE '.')
    StrAdd(s,'\q]')
  ENDIF
ENDPROC

PROC findtracedvar(n)
  DEF wv:PTR TO wvar
  wv:=vars.head
  WHILE wv.succ
    IF StrCmp(n,wv.v) THEN RETURN wv
    wv:=wv.succ
  ENDWHILE
ENDPROC NIL

PROC constructvars()
  DEF wv:PTR TO wvar,num=0,v,vptr,type,t[30]:STRING
  wv:=vars.head
  WHILE wv.succ
    v,vptr,type:=getvarval(wv.v)
    IF type
      StrCopy(wv.name,wv.v)
      StrAdd(wv.name,StringF(t,' = \d ($\h) ',v,v))
      SELECT 8 OF type
        CASE 3 TO 7
          StrAdd(wv.name,StringF(t,'(local reg D\d)',type))
        CASE 1,2
          StrAdd(wv.name,StringF(t,'(\s at $\z\h[8])',IF type=2 THEN 'global' ELSE 'local',vptr))
      ENDSELECT
      addval(wv.name,v)
      varlist[num++]:=wv.name
    ENDIF
  EXIT num=MAX_WATCH
    wv:=wv.succ
  ENDWHILE
  SetList(varlist,num)
ENDPROC

/*-------------------------------------------------------------------*/

PROC showsrcwin(src:PTR TO e_source,i=NIL)
  DEF w:PTR TO srcwin,n:PTR TO srcwin,sc:PTR TO scrolltext
  w:=dwins
  WHILE IF w THEN (IF w.type=T_SRC THEN w.src<>src ELSE w) ELSE w DO w:=w.next
  IF w=NIL
    NEW n.srcwin(src)
  ELSE
    n:=w
    IF fxs
      ChangeWindowBox(n.scwin.window,fx,fy,fxs,fys)
      fx:=fy:=fxs:=fys:=0
    ENDIF
  ENDIF
  sc:=n.scwin
  IF i
    sc.active(i)
    activewin:=n
  ENDIF
  IF w THEN WindowToFront(sc.window)
ENDPROC

PROC quit()
  DEF a
  a:=request3('Sure to leave the debugged program halfway?','_Quit','_Run','_Oops!',"q","r","o")
  IF a=1
    Raise()
  ELSEIF a=2
    whatstep:=STEP_RUN
  ENDIF
ENDPROC

PROC newmem()
  DEF w:PTR TO memwin,a
  IF (a:=getmem())<>-1 THEN NEW w.memwin(a,T_MEM)
ENDPROC

PROC newreg() IS IF rwin THEN WindowToFront(rwin.scwin.window) ELSE NEW rwin.regwin()
PROC openstackwin() IS IF stackwin=NIL THEN NEW stackwin.memwin(frame.stack,T_STACK) ELSE WindowToFront(stackwin.scwin.window)
PROC openvarwin() IS IF vwin THEN (WindowToFront(vwin.scwin.window) BUT TRUE) ELSE NEW vwin.varwin()
PROC dum(p,q) IS EMPTY
PROC modifyvar() IS request13('You can modify a variable','by clicking on it','in the variable view','_Great!',"g")
PROC watchvar()
  DEF st:PTR TO scrolltext
  DEF varname[100]:STRING
  st:=currentwin.scwin
  IF easyguiA(reqtitle,
      [ROWS,
        [TEXT,'Enter variable name to watch ',NIL,FALSE,3],
        [STR,1,'_Text:',varname,100,10,0,0,"t"],
        [BAR],
        [COLS,
          [BUTTON,1,'_Watch',0,"w"],
          [SPACEH],
          [BUTTON,0,'_Cancel',0,"c"]
        ]
      ],
      [EG_SCRN,scr,NIL])

    addvar(varname,0)
  ENDIF
ENDPROC

PROC breakpoint() IS request13('You can set a breakpoint','by double-clicking on a line','in a source-window','_Great!',"g")

PROC breakpointvar()
  DEF m
  IF (m:=getmem())<>-1 THEN setmembreak(m)
ENDPROC

PROC clearbreakpoints()
  DEF s:PTR TO e_source
  DEF dw:PTR TO dbgwin
  DEF sw:PTR TO srcwin
  
  s:=exe.sources()
  WHILE s
    s.clearbreakpoints(exe)
    s:=s.next()
  ENDWHILE

  dw:=dwins
  WHILE (dw)
    IF dw.type=T_SRC
      sw:=dw
      sw.scwin.refreshwindow()
    ENDIF
    dw:=dw.next
  ENDWHILE

  ->setbreak(NIL)
  setmembreak(NIL)
ENDPROC

PROC raiseexception()
  DEF e[20]:STRING,ei[20]:STRING,ev,eiv,n
  StrCopy(e,'"HALT"')
  StrCopy(ei,'0')
  LOOP
    IF easyguiA(reqtitle,
      [EQROWS,
        [TEXT,'Enter exception values:',NIL,FALSE,3],
        [STR,{dum},'_exception:',e,100,5,0,0,"e"],
        [STR,{dum},'e_xceptioninfo:',ei,100,5,0,0,"x"],
        [COLS,[TEXT,'(Examples: 0,$0,var,{var})',NIL,FALSE,3],[BUTTON,{ehelp},'_Help',0,"h"]],
        [BAR],
        [COLS,
          [BUTTON,1,'_OK',0,"o"],
          [SPACEH],
          [BUTTON,0,'_Cancel',0,"c"]
        ]
      ],
      [EG_SCRN,scr,NIL])
      n,ev:=extval(e)
      IF n
        n,eiv:=extval(ei)
        IF n
          setthrow(ev,eiv)
          whatstep:=STEP_THROW
          RETURN
        ENDIF
      ENDIF
      request1('Illegal value(s)','_Sorry',"s")
    ELSE
      RETURN
    ENDIF
  ENDLOOP
ENDPROC

PROC repeatstep()
  DEF str[20]:STRING,n
  StrCopy(str,'1')
  LOOP
    IF easyguiA(reqtitle,
      [EQROWS,
        [TEXT,'Enter number and type of steps:',NIL,FALSE,3],
        [COLS,
          [STR,{dum},'_Steps:',str,100,5,0,0,"s"],
          [CHECK,{mrepeattype},'Step _Over?',repeatover,TRUE,0,"o"]
        ],
        [COLS,[TEXT,'(Examples: 10,$2F,var,^var)',NIL,FALSE,3],[BUTTON,{ehelp},'_Help',0,"h"]],
        [BAR],
        [COLS,
          [BUTTON,1,'_OK',0,"o"],
          [SPACEH],
          [BUTTON,0,'_Cancel',0,"c"]
        ]
      ],
      [EG_SCRN,scr,NIL])
      n,repeatcount:=extval(str)
      IF n AND (repeatcount>0)
        repeatcount--
        whatstep:=STEP_OVER
        RETURN
      ENDIF
      request1('Illegal value(s)','_Sorry',"s")
    ELSE
      RETURN
    ENDIF
  ENDLOOP
ENDPROC

PROC mrepeattype(p,x) IS repeatover:=x

PROC evalexps()
  DEF r,s[100]:STRING
  easyguiA(reqtitle,
    [EQROWS,
      [TEXT,'Enter E Expression:',NIL,FALSE,3],
      [STR,{evexp},'_Exp:',s,100,10,0,0,"e"],
      r:=[TEXT,s,'Result:',TRUE,1],
      [COLS,[TEXT,'(Examples: 0,$0,var,{var})',NIL,FALSE,3],[BUTTON,{ehelp},'_Help',0,"h"]],
      [BAR],
      [COLS,[SPACEH],[BUTTON,0,'_OK',0,"o"],[SPACEH]]
    ],
    [EG_INFO,r, EG_SCRN,scr, EG_GHVAR,{evgh}, NIL])
ENDPROC

PROC evexp(rgad,s)
  DEF v,r,f[20]:STRING
  r,v:=extval(s)
  IF r
    StringF(f,'\d ($\h)',v,v)
  ELSE
    StrCopy(f,'')
  ENDIF
  settext(evgh,rgad,f)
ENDPROC

PROC ehelp(p)
  easyguiA(reqtitle,
    [ROWS,
      [TEXT,'Values: 123, $ABC, %010101, "FORM"',NIL,FALSE,3],
      [TEXT,'Variables: a, {a}, ^a',NIL,FALSE,3],
      [TEXT,'Operators: +, -, *, /, ()',NIL,FALSE,3],
      [BAR],
      [BUTTON,0,'_OK',0,"o"]
    ],
    [EG_SCRN,scr,NIL])
ENDPROC

PROC search()
  DEF st:PTR TO scrolltext
  st:=currentwin.scwin
  IF easyguiA(reqtitle,
      [ROWS,
        [TEXT,'Enter text to find ',NIL,FALSE,3],
        [STR,1,'_Text:',findstr,100,10,0,0,"t"],
        [CHECK,{mcasesensitive},'Case Sensitive?',casesensitivefind,TRUE,0,"c"],
        [BAR],
        [COLS,
          [BUTTON,1,'_Find',0,"f"],
          [SPACEH],
          [BUTTON,0,'_Cancel',0,"c"]
        ]
      ],
      [EG_SCRN,scr,NIL])

    runsearch(0)    
  ENDIF
ENDPROC

PROC searchnext()
  IF lastfind=-1
    search()
  ELSE
    runsearch(lastfind+1)
  ENDIF
ENDPROC

PROC runsearch(start)
  DEF n,max,r
  DEF lines:PTR TO LONG
  DEF st:PTR TO scrolltext
  
  st:=currentwin.scwin
  n:=start
  max:=ListLen(lines:=currentwin.src.lines())
  lines:=lines+(n*4)
  WHILE n<max
     IF casesensitivefind
       r:=InStr(lines[],findstr,0)<>-1
     ELSE 
       r:=InStr(lines[],findstr,0)<>-1
     ENDIF
	EXIT r
    lines++
    n++
  ENDWHILE
->    IF n THEN st.settop(max-n) ELSE request1('Could not find text','_Hmmm',"h")
  IF n<max
    st.active(n)
    lastfind:=n
  ELSE 
    request1('Could not find text','_Hmmm',"h")
    lastfind:=-1
  ENDIF
ENDPROC

PROC mcasesensitive(p,x) IS casesensitivefind:=x


PROC handlemenu(imsg:PTR TO intuimessage)
  DEF c,menu,item,sub
  c:=imsg.code
  menu:=menunum(c)
  item:=itemnum(c)
  sub:=subnum(c)
  SELECT menu
    CASE 0
      SELECT item
        CASE 0; about()             -> About
        CASE 1; setprefs()          -> Settings...
        CASE 2; saveprefs()         -> Save Settings
        CASE 3; quit()              -> Quit
      ENDSELECT
    CASE 1
      SELECT item
        CASE 0; choose_source()     -> Source
        CASE 1; newreg()            -> Registers
        CASE 2; newmem()            -> Memory
        CASE 3; openstackwin()      -> Stack
        CASE 4; openvarwin()        -> Variables
      ENDSELECT
    CASE 2
      SELECT item
        CASE 0; IF whatstep=STEP_NONE THEN whatstep:=STEP_IN   -> Step In
        CASE 1; IF whatstep=STEP_NONE THEN whatstep:=STEP_OVER -> Step Over
        CASE 2; IF whatstep=STEP_NONE THEN whatstep:=STEP_FOLLOW -> Step Follow
        CASE 3; IF whatstep=STEP_NONE THEN repeatstep()        -> Repeat Step
        CASE 4; IF whatstep<>STEP_NONE THEN stop_executing:=TRUE  -> Pause
        CASE 5; watchvar()          -> Watch Variable
        CASE 6; breakpoint()        -> Set Breakpoint on Sourceline
        CASE 7; breakpointvar()     -> Set Breakpoint on Memory
        CASE 8; clearbreakpoints()  -> Clear all Breakpoints
        CASE 9; IF whatstep=STEP_NONE THEN whatstep:=STEP_RUN  -> Run to Breakpoint
        CASE 10; raiseexception()    -> Raise Exception
      ENDSELECT
    CASE 3
      SELECT item
        CASE 0; evalexps()          -> Eval E Expressions
        CASE 1; modifyvar()         -> Modify Variable
        CASE 2; dwins.refresh()     -> Refresh
        CASE 3; search()            -> Find in Source
        CASE 4; searchnext()        -> Find next
        CASE 5; offset()            -> Locate Offset
      ENDSELECT
    CASE 4
      SELECT item
        CASE 0; exe_arexx_cmd(rxs1)
        CASE 1; exe_arexx_cmd(rxs2)
        CASE 2;	exe_arexx_cmd(rxs3)
      ENDSELECT
  ENDSELECT
ENDPROC

PROC offset()
  DEF v,r,i
  IF easyguiA(reqtitle,
      [ROWS,
        [TEXT,'Enter offset to locate',NIL,FALSE,3],
        [STR,1,'_Offset:',offstr,12,10,0,0,"o"],
        [BAR],
        [COLS,
          [BUTTON,1,'_Locate',0,"l"],
          [SPACEH],
          [BUTTON,0,'_Cancel',0,"c"]
        ]
      ],
      [EG_SCRN,scr,NIL])
    v,r:=Val(offstr)
    IF r
      v,r,i:=exe.findoffset(v)
      IF v
        showsrcwin(v,r)
        IF i THEN Delay(6) BUT request13('This might actually be an',
                                         'E internal function, such',
                                         'as Char() or WriteF()','_Oh',"o")
      ELSE
        request1('No line for this offset','_Oh',"o")
      ENDIF
    ELSE
      request1('Bad offset','_Oh',"o")
    ENDIF
  ENDIF
ENDPROC

PROC handlekey(c)
  IF c=77 THEN whatstep:=STEP_OVER ELSE IF c=78 THEN whatstep:=STEP_IN
ENDPROC

PROC handlesrc(data,imsg:PTR TO intuimessage)
  DEF cl,vx,vy
  IF data THEN currentwin:=data
  IF (cl:=imsg.class)=IDCMP_MENUPICK
    handlemenu(imsg)
  ELSEIF cl=IDCMP_RAWKEY
    handlekey(imsg.code)
  ELSEIF cl=IDCMP_MOUSEBUTTONS
    IF imsg.code=SELECTUP
      vx,vy:=currentwin.scwin.where(imsg.mousex,imsg.mousey)
      IF (DoubleClick(lastsec,lastmic,imsg.seconds,imsg.micros)) OR (vx=0)
        IF vx<>-1 THEN dovar(vx,vy,imsg.qualifier)
      ELSE
        lastsec:=imsg.seconds
        lastmic:=imsg.micros
      ENDIF
    ENDIF
  ENDIF  
ENDPROC

PROC handlevar(imsg:PTR TO intuimessage)
  DEF cl,vx,vy
  IF (cl:=imsg.class)=IDCMP_MENUPICK
    handlemenu(imsg)
  ELSEIF cl=IDCMP_RAWKEY
    handlekey(imsg.code)
  ELSEIF cl=IDCMP_MOUSEBUTTONS
    IF vwin
      vx,vy:=vwin.scwin.where(imsg.mousex,imsg.mousey)
      IF imsg.code=SELECTDOWN
        oldvy:=vy
      ELSEIF imsg.code=SELECTUP
        IF (vx<>-1) AND (oldvy=vy) THEN actionvar(vy)
        oldvy:=-1
      ENDIF
    ENDIF
  ENDIF  
ENDPROC

PROC getvarval(var,send=FALSE)
  DEF isglob,v,vptr,x,type=0,mess[256]:STRING,evar:PTR TO e_var
  IF (x:=activewin.scwin.getactive())<>-1
    evar,isglob:=activewin.src.findvar(var,activewin.src.findproc(x))
    IF evar
      IF type:=evar.regno
        v:=frame.regs[type]
        vptr:=0
      ELSEIF isglob OR evar.offs
        v:=Long(vptr:=frame.regs[IF isglob THEN 12 ELSE 13]+evar.offs)
        type:=IF isglob THEN 2 ELSE 1
      ENDIF
      IF send
        x:=evar.type
        StringF(mess,'[\s] \s',IF isglob THEN 'Global' ELSE 'Local', var)
        IF x
          StrAdd(mess,':PTR TO ')
          StrAdd(mess,x)
        ENDIF
        SelectOutput(NIL)
        IF sendExplorer(v,x,NIL,mess,TRUE)=FALSE
          IF runExplorer()=0
            FOR send:=1 TO 20
              Delay(6)
            EXIT isExplorerRunning()
            ENDFOR
            IF send<=20
              sendExplorer(v,x,NIL,mess,TRUE)
              startExp:=TRUE
            ENDIF
          ENDIF
        ENDIF
        SelectOutput(ocon)
      ENDIF
    ENDIF
  ENDIF
ENDPROC v,vptr,type

PROC runExplorer()
  DEF cmd[256]:STRING
  StrCopy(cmd,IF explorer[] THEN explorer ELSE 'explorer')
  IF pubname[]
    StrAdd(cmd,' SCREEN="')
    StrAdd(cmd,pubname)
    StrAdd(cmd,'"')
  ENDIF
ENDPROC SystemTagList(cmd,[SYS_ASYNCH,TRUE, SYS_INPUT,NIL, SYS_OUTPUT,NIL, NIL])

PROC dovar(vx,vy,qual)
  DEF var[50]:STRING,v,vptr,reg=0
  vy:=currentwin.src.locate(Max(0,vx-1),vy,var)
  IF var[] THEN v,vptr,reg:=getvarval(var)
  IF reg
    addvar(var,qual AND 3)
  ELSEIF vy>=0
    IF vx=0
      currentwin.src.togglebreakpoint(vy,exe)
      currentwin.scwin.refreshwindow()
    ELSE
      v:=request3('Put breakpoint here?','_OK','OK and _Run','_Cancel',"o","r","c")
      IF v>0
        currentwin.src.setbreakpoint(vy,exe)
        currentwin.scwin.refreshwindow()
        ->setbreak(currentwin.src.findpc(vy,exe))
        IF v>1 THEN whatstep:=STEP_RUN
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC makefollow()
  IF followgh=NIL
    followgh:=guiinitA('** EDBG ** Following Execution ** Close Me to Stop! **',
          [SPACEH],
          [EG_LEFT,0, EG_TOP,0, EG_MAXW,TRUE, EG_SCRN,scr,
           EG_WTYPE,WTYPE_NOSIZE, NIL])
  ENDIF
ENDPROC

PROC removefollow()
  IF followgh
    cleangui(followgh)
    followgh:=NIL
  ENDIF
ENDPROC

PROC update(fr:PTR TO stackframe)
  srcmessage()
  IF dwins THEN dwins.message()
  rexxmessage()
  toolmessage()
ENDPROC stop_executing

PROC step(fr:PTR TO stackframe)
  DEF pc,src,i
  IF repeatcount
    repeatcount--
    IF repeatover
      stepover(fr,fr.regs[13])
    ELSE
      stepover()
    ENDIF
  ELSE
    frame:=fr
    IF stackwin THEN stackwin.addr:=fr.stack
    pc:=fr.returnpc-IF (trap1>=0) AND (trap1<=15) AND (trap2>=0) AND (trap2<=15) THEN 2 ELSE 6
    src,i,pc:=exe.findline(pc)
    IF src=NIL
      removefollow()
      request13('Your program caused a guru!',
                'It may not be safe to continue running this program,',
                'you might even need to reboot!',
                '_Oops!',"o")
      -> Try it now with last known PC
      src,i:=exe.findline(pc)
    ENDIF
    IF src THEN showsrcwin(src,i)
    whatstep:=STEP_NONE
    IF dorefresh THEN dwins.refresh()
    IF followgh
      WindowToFront(followgh.wnd)
      ActivateWindow(followgh.wnd)
      Delay(followspeed)
      IF guimessage(followgh)<0
        stepover()
      ELSE
        removefollow()
      ENDIF
    ENDIF
    IF followgh=NIL
      IF first_step_done=FALSE
        unreachablea7:=fr+100000			-> imp! beyond main stack level
        first_step_done:=TRUE
        exe_arexx_cmd('.edbg-startup.rexx')
        IF doabout THEN Delay(6) BUT about()
      ENDIF
      REPEAT
        Wait(-1)
        update(fr)
        ->srcmessage()
        ->IF dwins THEN dwins.message()
        ->rexxmessage()
        ->toolmessage()
      UNTIL whatstep
      stop_executing:=FALSE
      SELECT whatstep
        CASE STEP_IN;    stepover()
        CASE STEP_OVER;  stepover(fr,fr.regs[13])
        CASE STEP_RUN;   stepover(unreachablea7,unreachablea7)
        CASE STEP_THROW; stepover(); RETURN TRUE
        CASE STEP_FOLLOW
          makefollow()
          stepover()
      ENDSELECT
    ENDIF
  ENDIF
ENDPROC FALSE

PROC srcmessage()
  DEF s:PTR TO scrollwin, srcwin:PTR TO srcwin
  WHILE s:=handleIDCMP(srcport)
    srcwin:=s.data
    END srcwin
  ENDWHILE
ENDPROC

/*--------------------------------------------------------------------*/

CONST TOOL_NUM=6,TOOL_ONEH=32,TOOL_W=37,TOOL_SP=2
CONST TOOL_HEIGHT=TOOL_ONEH+TOOL_SP*TOOL_NUM-TOOL_SP
CONST TOOL_SIZE=TOOL_HEIGHT*12

PROC toolmessage()
  DEF imsg:PTR TO intuimessage,cl
  WHILE imsg:=GetMsg(toolwin.userport)
    cl:=imsg.class
    SELECT cl
      CASE IDCMP_MENUPICK
        handlemenu(imsg)
      CASE IDCMP_GADGETUP
        SELECT 7 OF imsg.iaddress::gadget.gadgetid
          CASE 1; whatstep:=STEP_OVER
          CASE 2; whatstep:=STEP_IN
          CASE 3; newmem()
          CASE 4; newreg()
          CASE 5; openvarwin()
          CASE 6; quit()
        ENDSELECT
    ENDSELECT
    ReplyMsg(imsg)
  ENDWHILE
ENDPROC

PROC createtoolbar()
  DEF m,i,a,b=1,gads=NIL:PTR TO gadget,aw,ah,al,at,ab,ar,wpos
  wpos:=font.ysize+scr.wbortop+1
  al:=scr.wborleft+2
  at:=wpos+2
  ab:=scr.wborbottom+2
  ar:=scr.wborright+2
  aw:=al+ar+TOOL_W
  ah:=at+ab+TOOL_HEIGHT
  IF (toolgads:=List(TOOL_NUM))=NIL THEN Raise("MEM")
  SetList(toolgads,TOOL_NUM)
  CopyMem({tooldata},m:=NewM(TOOL_SIZE,2),TOOL_SIZE)
  i:=[0,0,TOOL_W,TOOL_HEIGHT,2,m,%11,0,NIL]:image
  MapList({a},toolgads,toolgads,
      `gads:=NEW [gads,al,b-1*(TOOL_ONEH+TOOL_SP)+at,TOOL_W,TOOL_ONEH,
                  GFLG_GADGHCOMP,GACT_RELVERIFY,GTYP_BOOLGADGET,
                  NIL,NIL,NIL,0,NIL,b++,0]:gadget)
  IF ForAll({a},toolgads,`a)=FALSE THEN Raise("MEM")
  IF (toolwin:=OpenW(0,wpos,aw,Min(ah,ysize-wpos),
    IDCMP_GADGETUP OR IDCMP_MENUPICK,
    6 OR WFLG_NEWLOOKMENUS,'          Toolbar',scr,15,gads))=NIL THEN Raise("WIN")
  DrawImage(toolwin.rport,i,al,at)
  IF SetMenuStrip(toolwin,menu)=FALSE THEN Raise("MENU")
  RefreshWindowFrame(toolwin)
  Dispose(m)
ENDPROC

PROC deletetoolbar()
  IF toolwin THEN ClearMenuStrip(toolwin)
  CloseW(toolwin)
  toolwin:=NIL
ENDPROC

tooldata: INCBIN 'pix/toolbar.raw'

/*-----------------------------------------------------------------*/

aboutdata: INCBIN 'pix/about.raw'

CONST ABOUT_SIZE=7872,ABOUT_HEIGHT=164,ABOUT_WIDTH=182

PROC about()
  DEF m,i,win=NIL:PTR TO window,aw,ah,al,at,ab,ar
  al:=scr.wborleft+2
  at:=font.ysize+scr.wbortop+1+2
  ab:=scr.wborbottom+2
  ar:=scr.wborright+2
  aw:=al+ar+ABOUT_WIDTH
  ah:=at+ab+ABOUT_HEIGHT
  CopyMem({aboutdata},m:=NewM(ABOUT_SIZE,2),ABOUT_SIZE)
  i:=[0,0,ABOUT_WIDTH,ABOUT_HEIGHT,2,m,%11,0,NIL]:image
  IF win:=OpenW(xsize-ABOUT_WIDTH/2,ysize-ABOUT_HEIGHT/2,aw,ah,
      IDCMP_CLOSEWINDOW OR IDCMP_RAWKEY OR IDCMP_MOUSEBUTTONS,$100E,'About...',scr,15,NIL)
    DrawImage(win.rport,i,al,at)
    WaitIMessage(win)
    CloseW(win)
  ENDIF
  Dispose(m)
ENDPROC

/*-----------------------------------------------------------------*/

PROC fastrequest(message)
  DEF window:PTR TO window,screen:PTR TO screen

  window:=currentwin.scwin.window
  screen:=window.wscreen
  SetWindowTitles(window,TRUE,message)
  WaitPort(window.userport)
  SetWindowTitles(window,TRUE,title)
ENDPROC

PROC request1(body,gadget,key) IS easyguiA(reqtitle,[ROWS,[TEXT,body,NIL,FALSE,3],[BAR],[BUTTON,0,gadget,0,key]],[EG_SCRN,scr,NIL])
PROC request13(b1,b2,b3,gadget,key) IS easyguiA(reqtitle,[ROWS,[TEXT,b1,NIL,FALSE,3],[TEXT,b2,NIL,FALSE,3],[TEXT,b3,NIL,FALSE,3],[BAR],[BUTTON,0,gadget,0,key]],[EG_SCRN,scr,NIL])
PROC request3(body,g1,g2,g3,k1,k2,k3) IS easyguiA(reqtitle,[ROWS,[TEXT,body,NIL,FALSE,3],[BAR],[COLS,[BUTTON,1,g1,0,k1],[SPACEH],[BUTTON,2,g2,0,k2],[SPACEH],[BUTTON,0,g3,0,k3]]],[EG_SCRN,scr,NIL])

PROC getmem()
  DEF ok,s[100]:STRING,r,v,p
  REPEAT
    ok:=1
    r:=easyguiA(reqtitle,
      [ROWS,
        [TEXT,'Which memory location?',NIL,FALSE,3],
        [STR,1,'_Addr:',s,100,10,0,0,"a"],
        [COLS,[TEXT,'(Examples: 0,$0,var,{var})',NIL,FALSE,3],[BUTTON,{ehelp},'_Help',0,"h"]],
        [BAR],
        [COLS,
          [BUTTON,1,'_OK',0,"o"],
          [SPACEH],
          [BUTTON,0,'_Cancel',0,"c"]
        ]
      ],
      [EG_SCRN,scr,NIL])
    IF r
      r,v:=extval(s)
      IF r
        IF TypeOfMem(v)=FALSE
          ok:=request3('Not a valid ram-address','_Do it anyway','_Oops','_Cancel',"d","o","c")
        ENDIF
      ELSE
        ok:=2
      ENDIF
    ELSE
      ok:=0
    ENDIF
  UNTIL ok<2
ENDPROC IF ok THEN v AND -2 ELSE -1

PROC extval(s)
  DEF v
  s,v:=exp(s)
  IF s=0 THEN request1('Syntax Error in Expression','_Um',"u")
ENDPROC s,v

PROC exp(s)
  DEF v=0,o,v2
  s,v:=factor(s)
  IF s
    s:=whitesp(s)
    WHILE o:=s[]++
      IF o=")" THEN RETURN s-1,v
      s,v2:=factor(s)
      IF s=0 THEN RETURN 0
      SELECT o
        CASE "+"; v:=v+v2
        CASE "-"; v:=v-v2
        CASE "*"; v:=Mul(v,v2)
        CASE "/"; v:=Div(v,v2)
        DEFAULT; RETURN request1('Missing operator','_Oh',"o")
      ENDSELECT
      s:=whitesp(s)
    ENDWHILE
  ENDIF
ENDPROC s,v

PROC factor(s)
  DEF v,r,c,a,neg=FALSE
  v,r:=Val(s)
  IF r
    s:=s+r
  ELSE
    s:=whitesp(s)
    IF s[]="-"
      s:=whitesp(s+1)
      neg:=TRUE
    ENDIF
    IF s[]="\q"
      s++
      a:=v:=0
      WHILE (c:=s[]++)<>"\q"
        EXIT a++=4
        v:=Shl(v,8)+c
      ENDWHILE
      IF c<>"\q" THEN RETURN request1('Missing "','_Oh',"o")
    ELSEIF s[]="{"
      s++
      s:=whitesp(s)
      s,r,v:=id(s,TRUE)
      IF s
        s:=whitesp(s)
        IF s[]++<>"}" THEN RETURN request1('Missing "}"','_Oh',"o")
      ENDIF
    ELSEIF s[]="^"
      s++
      s:=whitesp(s)
      s,v:=id(s)
      v:=^v
    ELSEIF s[]="("
      s++
      s,v:=exp(s)
      IF s THEN IF s[]++<>")" THEN RETURN request1('Missing ")"','_Oh',"o")
    ELSE
      s,v:=id(s)
    ENDIF
  ENDIF
ENDPROC s,IF neg THEN -v ELSE v

PROC id(s,isaddr=FALSE)
  DEF r,v,t,str[50]:STRING,c
  WHILE (((c:=s[]++)>="a") AND (c<="z")) OR ((c>="A") AND (c<="Z")) OR (c="_") DO StrAdd(str,[c,0]:CHAR)
  s--
  IF str[]=0 THEN RETURN 0
  v,r,t:=getvarval(str)
  IF t=0 THEN RETURN request1('Unknown var','_Oops',"o")
  IF isaddr THEN IF t>=3 THEN RETURN request13('You can''t take the address','of a register variable.','Recompile without OPTI/S or REG/K','_Sure',"s")
ENDPROC s,v,r

PROC whitesp(s)
  WHILE s[]=" " DO s++
ENDPROC s

PROC setprefs()
  easyguiA('EDBG Preferences',
    [ROWS,
      [EQROWS,
        [CHECK,{mdoabout},'_Show "About..." on startup',doabout,TRUE,0,"s"],
        [CHECK,{mdorefresh},'_Refresh views each step',dorefresh,TRUE,0,"r"],
        [CHECK,{mdowins},'Save _current window positions',dosavewindowpos,TRUE,0,"c"],
        [CHECK,{mdovars},'Save _watched variable names',dosavevars,TRUE,0,"w"]
      ],
      [SLIDE,{mspeed},'Follow Delay (0.1sec):    ',FALSE,0,30,followspeed/5,2,'%3ld'],
      [BAR],
      [EQROWS,
        [STR,{dstr},'_Arexx script 1',rxs1,RXSTR_SIZE,4,0,0,"a"],
        [STR,{dstr},'Arexx script 2',rxs2,RXSTR_SIZE,4],
        [STR,{dstr},'Arexx script 3',rxs3,RXSTR_SIZE,4]
      ],
      [BAR],
      [STR,{dstr},'_Explorer',explorer,RXSTR_SIZE,4,0,0,"e"],
      [BAR],
      [BUTTON,0,'_OK',0,"o"]
    ],
    [EG_SCRN,scr,NIL])
ENDPROC

PROC mdoabout(p,x) IS doabout:=x
PROC mdorefresh(p,x) IS dorefresh:=x
PROC mdowins(p,x) IS dosavewindowpos:=x
PROC mdovars(p,x) IS dosavevars:=x
PROC dstr(p,q) IS EMPTY
PROC mspeed(p,x) IS followspeed:=x*5

PROC saveprefs()
  DEF fh,ofh,dw:PTR TO dbgwin,wv:PTR TO wvar,win:PTR TO window
  IF fh:=Open('.edbg-startup.rexx',NEWFILE)
    ofh:=SetStdOut(fh)
    WriteF('/* generated by EDBG */\n\n/* address EDBG */\n\n')
    IF doabout=FALSE THEN WriteF('''noabout''\n')
    IF dorefresh=FALSE THEN WriteF('''norefresh''\n')
    IF dosavewindowpos
      dw:=dwins
      WHILE dw
        IF dw.type=T_VAR
          win:=dw::varwin.scwin.window
          WriteF('''variables \d \d \d \d''\n',win.leftedge,win.topedge,win.width,win.height)
        ELSEIF dw.type=T_MEM
          WriteF('''memory \d''\n',dw::memwin.addr)
        ELSEIF dw.type=T_SRC
          win:=dw::srcwin.scwin.window
          WriteF('''srcwindow \s \d \d \d \d''\n',dw::srcwin.src.name(),win.leftedge,win.topedge,win.width,win.height)
        ENDIF
        dw:=dw.next
      ENDWHILE
    ENDIF
    IF dosavevars
      IF vars.tailpred<>vars
        WriteF('''watch')
        iterate_exec_list({wv},vars,`WriteF(' \s',wv.v))
        WriteF('''\n')
      ENDIF
    ENDIF
    IF explorer[] THEN WriteF('''explorer \s''\n',explorer)
    IF rxs1[] THEN WriteF('''rexx 1 \s''\n',rxs1)
    IF rxs2[] THEN WriteF('''rexx 2 \s''\n',rxs2)
    IF rxs3[] THEN WriteF('''rexx 3 \s''\n',rxs3)
    SetStdOut(ofh)
    Close(fh)
  ELSE
    request1('Unable to write prefs','_Hmmm...',"h")
  ENDIF
ENDPROC

PROC choose_source() HANDLE
  DEF l,s:PTR TO e_source,a=0,num=-1
  s:=exe.sources()
  l:=newlist()
  WHILE s
    AddTail(l,newnode(NIL,s.name()))
    s:=s.next()
  ENDWHILE
  easyguiA(reqtitle,
    [EQROWS,
       [LISTV,{sourcenum},'Select Source:',24,5,l,FALSE,0,0],
       [BAR],
       [COLS,[SPACEH],[BUTTON,0,'_Cancel',0,"c"],[SPACEH]]
    ],
    [EG_INFO,{num}, EG_SCRN,scr, NIL])
EXCEPT DO
  IF num>=0
    s:=exe.sources()
    WHILE s
      EXIT a++=num
      s:=s.next()
    ENDWHILE
    IF s THEN showsrcwin(s)
  ENDIF
ENDPROC

PROC sourcenum(i,n)
  ^i:=n
  Raise()
ENDPROC

PROC rexxmessage()
  DEF mes,rexxstr
  IF rexxport
    WHILE TRUE
      mes,rexxstr:=rx_GetMsg(rexxport)
    EXIT mes=NIL
      rexxcontinue(rexxstr,mes)
    ENDWHILE
  ENDIF
ENDPROC

PROC rexxcontinue(rexxstr,mes) HANDLE	-> called from other spots too
  DEF rc=0,rstr=NIL
  rc,rstr:=processcmd(rexxstr)
EXCEPT DO
  rx_ReplyMsg(mes,rc,rstr)
  ReThrow()
ENDPROC

PROC getword(s,dest)
  DEF b,c
  LOOP
    SELECT 256 OF c:=s[]++
      CASE 0; request1('Argument to Arexx command expected','_Oh',"o"); Raise()
      CASE " ", "\t"
      CASE 33 TO 255
        b:=s-1
        WHILE (s[]>" ") AND (s[]<=255) DO s++
        StrCopy(dest,b,s-b)
        WHILE (s[]=" ") OR (s[]="\t") DO s++
        RETURN s
      DEFAULT
        request1('Garbage in Arexx command','_Oh',"o"); Raise()
    ENDSELECT
  ENDLOOP
ENDPROC

PROC getexp(s)
  DEF v,dest[250]:STRING,sr
  s:=getword(s,dest)
  sr,v:=extval(dest)
  IF sr=NIL THEN Raise()
ENDPROC s,v

PROC processcmd(s)
  DEF rc=0,rstr=NIL,ts[250]:STRING,a,b,esrc=NIL:PTR TO e_source,w:PTR TO memwin,vptr,type
  s:=getword(s,ts)
  UpperStr(ts)
  IF StrCmp(ts,'QUIT')
    quit()
  ELSEIF StrCmp(ts,'RUN')
    whatstep:=STEP_RUN
  ELSEIF StrCmp(ts,'MEMORY')
    s,a:=getexp(s)
    NEW w.memwin(a,T_MEM)
  ELSEIF StrCmp(ts,'EXPLORER')
    s:=getword(s,explorer)
  ELSEIF StrCmp(ts,'REXX')
    s,a:=getexp(s)
    IF a=1
      s:=getword(s,rxs1)
    ELSEIF a=2
      s:=getword(s,rxs2)
    ELSEIF a=3
      s:=getword(s,rxs3)
    ENDIF
  ELSEIF StrCmp(ts,'VARIABLES')
    s,fx:=getexp(s)
    s,fy:=getexp(s)
    s,fxs:=getexp(s)
    s,fys:=getexp(s)
    openvarwin()
  ELSEIF StrCmp(ts,'STEPIN')
    whatstep:=STEP_IN
  ELSEIF StrCmp(ts,'STEPOVER')
    whatstep:=STEP_OVER
  ELSEIF StrCmp(ts,'WATCH')
    WHILE s[]
      s:=getword(s,ts)
      addvar(ts)
    ENDWHILE
  ELSEIF StrCmp(ts,'BREAKPOINT')
    s,a:=getexp(s)
    currentwin.src.setbreakpoint(a,exe)
    ->setbreak(currentwin.src.findpc(a,exe))
  ELSEIF StrCmp(ts,'EVAL')
    s,rc:=getexp(s)
  ELSEIF StrCmp(ts,'MEMORYBREAKPOINT')
    s,a:=getexp(s)
    setmembreak(a)
  ELSEIF StrCmp(ts,'RAISE')
    s,a:=getexp(s)
    s,b:=getexp(s)
    setthrow(a,b)
    whatstep:=STEP_THROW
  ELSEIF StrCmp(ts,'SRCWINDOW')
    s:=getword(s,ts)
    s,fx:=getexp(s)
    s,fy:=getexp(s)
    s,fxs:=getexp(s)
    s,fys:=getexp(s)
    IF esrc:=exe.sources() THEN esrc:=esrc.findsrc(ts)
    IF esrc THEN showsrcwin(esrc)
  ELSEIF StrCmp(ts,'NOABOUT')
    doabout:=FALSE
  ELSEIF StrCmp(ts,'NOREFRESH')
    dorefresh:=FALSE
  ELSEIF StrCmp(ts,'ASSIGN')
    s:=getword(s,ts)
    s,a:=getexp(s)
    b,vptr,type:=getvarval(ts)
    SELECT 8 OF type
      CASE 3 TO 7
        frame.regs[type]:=a
      CASE 1,2
        ^vptr:=a
    ENDSELECT
  ELSE
    request13('Unknown Arexx command:',ts,'received','_Really?',"r")
    s:=''
  ENDIF
  IF s[] THEN request13('Superfluous arguments:',ts,'in Arexx command','_Really?',"r")
ENDPROC rc,rstr

PROC exe_arexx_cmd(cmdstr) HANDLE	-> either a file name or a quoted string
  DEF rexx,rmsg=NIL:PTR TO rexxmsg,rarg=NIL,forb,noreply=TRUE,rrmsg:PTR TO rexxmsg,cstr
  rexxsysbase:=NIL
  Forbid(); forb:=TRUE
  IF (rexx:=FindPort('REXX'))=NIL THEN Raise()
  IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',0))=NIL THEN Raise()
  IF (rmsg:=CreateRexxMsg(rexxport,'rexx',rexxname))=NIL THEN Raise()
  IF (rarg:=CreateArgstring(cmdstr,StrLen(cmdstr)))=NIL THEN Raise()
  rmsg.args[0]:=rarg
  rmsg.action:=RXCOMM
  PutMsg(rexx,rmsg)
  Permit(); forb:=FALSE
  WriteF('executing script \s\n',cmdstr)
  WHILE noreply
    Wait(-1)
    WHILE TRUE
      rrmsg,cstr:=rx_GetMsg(rexxport)
    EXIT rrmsg=NIL
      IF rrmsg::ln.type=NT_REPLYMSG
        WriteF('done with script \s\n',cmdstr)
        noreply:=FALSE
      ELSE
        rexxcontinue(cstr,rrmsg)
      ENDIF
    ENDWHILE
  ENDWHILE
EXCEPT DO
  IF forb THEN Permit()
  IF rarg THEN DeleteArgstring(rarg)
  IF rmsg THEN DeleteRexxMsg(rmsg)
  IF rexxsysbase THEN CloseLibrary(rexxsysbase)
ENDPROC

CHAR 0, '$VER: EDBG 3.6.0-dev', 0, 0
