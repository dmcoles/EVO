OPT OSVERSION=37

MODULE 'intuition/classes','reaction/reaction_macros','intuition/screens','intuition/intuition','window','classes/window','gadgets/layout','images/led','intuition/imageclass','layout','amigalib/boopsi','dos/dos','devices/inputevent','exec/libraries'

DEF winObject:PTR TO object
DEF ledbase=NIL:PTR TO lib

PROC anykey()
  DEF going = TRUE
  DEF code:PTR TO INT,qual:PTR TO LONG,result,thesignal

  GetAttr(WINDOW_SIGMASK, winObject, {thesignal})
  WHILE(going)
    IF ((Wait(thesignal OR SIGBREAKF_CTRL_C)) AND SIGBREAKF_CTRL_C) THEN going:=FALSE

    WHILE(((result:=DoMethod(winObject, WM_HANDLEINPUT, code:=[0]:INT))) <> WMHI_LASTMSG)
      SELECT (result AND WMHI_CLASSMASK)
        CASE WMHI_CLOSEWINDOW
          going:=FALSE
        CASE WMHI_RAWKEY
          GetAttr(WINDOW_QUALIFIER, winObject, qual:=[0]:LONG)
          IF ((code[] < 128) AND ((qual[] AND IEQUALIFIER_REPEAT)=0)) THEN going:=FALSE
      ENDSELECT
    ENDWHILE
  ENDWHILE
ENDPROC

PROC main()
  DEF drawInfoPtr: PTR TO drawinfo
  DEF screenPtr:PTR TO screen
  DEF win:PTR TO window
  DEF im:PTR TO image
  DEF ledvalues:PTR TO LONG
  DEF lvals
  
  ledvalues:= [[26,50,44,89,12,34,56,78]:INT,
              [$DE,$AD,$BE, $EF,$C0,$DE,$DB,$AD]:INT,
              [0,$C,$5F37,$3700,$7676,$F1F,$6D00,0]:INT,
              [$776B,$5B5D,$2F,$F02,$E7B,$2F,$5F7B,$12]:INT]

  IF ((windowbase:=OpenLibrary('window.class',47)) AND (layoutbase:=OpenLibrary('gadgets/layout.gadget',37)) AND
     (ledbase:=OpenLibrary('images/led.image',37)))
     
    IF ((winObject:=WindowObject,
            WA_PUBSCREEN,                 NIL,
            WA_TITLE,                     'Press any key',
            WA_ACTIVATE,                  TRUE,
            WA_DEPTHGADGET,               TRUE,
            WA_DRAGBAR,                   TRUE,
            WA_CLOSEGADGET,               TRUE,
            WA_SIZEGADGET,                TRUE,
            WA_IDCMP,                     IDCMP_NEWSIZE,
            WINDOW_POSITION,              WPOS_CENTERMOUSE,
            WINDOW_PARENTGROUP,
            VLayoutObject,
                LAYOUT_ADDIMAGE,
                im:=LedObject,
                    IA_FGPEN,             1,
                    IA_BGPEN,             0,
                    LED_PAIRS,            8,
                    LED_SIGNED,           TRUE,
                    LED_NEGATIVE,         TRUE,
                    LED_TIME,             FALSE,
                    LED_COLON,            FALSE,
                    LED_RAW,              FALSE,
                    LED_VALUES,           ledvalues[0],
                LedEnd,
                CHILD_MINWIDTH,           288,
                CHILD_MINHEIGHT,          64,
            LayoutEnd,
        WindowEnd))

      IF (win:=RA_OpenWindow(winObject))
        screenPtr:=LockPubScreen(NIL)
        drawInfoPtr:=GetScreenDrawInfo(screenPtr)
        UnlockPubScreen(NIL,screenPtr)
        anykey()

        IF (ledbase.version >  47) OR ((ledbase.version = 47) AND (ledbase.revision >= 3))

          SetAttrsA(im,[LED_NEGATIVE,FALSE,LED_HEXADECIMAL,TRUE,LED_VALUES,ledvalues[1],TAG_DONE])
          DrawImageState(win.rport, im, 0, 0, IDS_NORMAL, drawInfoPtr)
          anykey();

          SetAttrsA(im,[LED_RAW,TRUE,LED_VALUES,ledvalues[2],TAG_DONE])
          DrawImageState(win.rport, im, 0, 0, IDS_NORMAL, drawInfoPtr)
          anykey()

          SetAttrsA(im,[LED_VALUES,ledvalues[3],TAG_DONE])
          DrawImageState(win.rport, im, 0, 0, IDS_NORMAL, drawInfoPtr)
          anykey()

          DisposeObject(winObject)
        ENDIF
      ENDIF
    ENDIF
  ENDIF

  CloseLibrary(ledbase);
  CloseLibrary(layoutbase);
  CloseLibrary(windowbase); 
ENDPROC
