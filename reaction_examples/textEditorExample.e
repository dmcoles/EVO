-> Simple example of integer buttons V0.11 © by DMX 2001

  OPT PREPROCESS,OSVERSION=44

  MODULE 'dos/dos','exec/ports','intuition/intuition','intuition/gadgetclass','intuition/imageclass',
       'gadgets/layout','gadgets/texteditor','images/bevel','images/label','utility/tagitem',
       'classes/window','window','layout','texteditor','label','button','bevel','reaction/reaction_macros','amigalib/lists','amigalib/boopsi'

#define TextEditorObject          NewObjectA( TextEditor_GetClass(), NIL,[TAG_IGNORE,0
#define TextEditorEnd           End

ENUM GID_MAIN=0, GID_LAYER1, GID_TEXT1, GID_DOWN, GID_UP, GID_QUIT, GID_LAST
ENUM WID_MAIN=0, WID_LAST
ENUM OID_MAIN=0, OID_LAST

PROC main()
  DEF appPort:PTR TO mp
  DEF windows[WID_LAST]:ARRAY OF LONG
  DEF gadgets[GID_LAST]:ARRAY OF LONG
  DEF objects[OID_LAST]:ARRAY OF LONG
  DEF wait,signal,app,done=0,result,code,r
  DEF gmain,glayer1,gtext1
  DEF buffer[100]:STRING
  openAll()
  
  StrCopy(buffer,'one\ntwo\nthree\n')
  
  IF (appPort := CreateMsgPort())
->    PrintF('appPort = 0x\z\h[8]\n', appPort) -> Debug
    objects[OID_MAIN]:=WindowObject,
      WA_SCREENTITLE, 'Reaction Example',
      WA_TITLE, 'Reaction Text Editor Example',
      WA_ACTIVATE, TRUE,
      WA_DEPTHGADGET, TRUE,
      WA_DRAGBAR, TRUE,
      WA_CLOSEGADGET, TRUE,
      WA_SIZEGADGET, TRUE,
      WA_RMBTRAP, TRUE,
      WA_AUTOADJUST, TRUE,
      WA_IDCMP, IDCMP_GADGETDOWN OR IDCMP_GADGETUP OR IDCMP_GADGETHELP OR IDCMP_MENUPICK OR IDCMP_MENUHELP OR IDCMP_CLOSEWINDOW OR IDCMP_ACTIVEWINDOW OR IDCMP_INACTIVEWINDOW OR IDCMP_RAWKEY OR IDCMP_VANILLAKEY OR IDCMP_MOUSEBUTTONS OR IDCMP_MOUSEMOVE OR IDCMP_NEWSIZE OR IDCMP_CHANGEWINDOW OR IDCMP_SIZEVERIFY OR IDCMP_REFRESHWINDOW OR IDCMP_INTUITICKS,
      WINDOW_GADGETHELP, TRUE,
      WINDOW_ICONIFYGADGET, TRUE,
      WINDOW_ICONTITLE, 'Text Editor',
      WINDOW_APPPORT, appPort,
      WINDOW_POSITION, WPOS_CENTERSCREEN,
      WINDOW_PARENTGROUP, gmain := VGroupObject,
        LAYOUT_SPACEOUTER, TRUE,
        LAYOUT_DEFERLAYOUT, TRUE,

        LAYOUT_ADDCHILD, glayer1 := LayoutObject,
        GA_ID, GID_LAYER1,
        GA_RELVERIFY, TRUE,
        GA_GADGETHELP, TRUE,
        LAYOUT_LABEL, 'Text Editor',
        LAYOUT_ORIENTATION, 1,
        LAYOUT_LEFTSPACING, 1,
        LAYOUT_TOPSPACING, 1,
        LAYOUT_BOTTOMSPACING, 1,
        LAYOUT_RIGHTSPACING, 1,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_LABELPLACE, BVJ_TOP_CENTER,
        LAYOUT_BEVELSTATE, IDS_NORMAL,
        LAYOUT_BEVELSTYLE, 2,
        LAYOUT_SHRINKWRAP, TRUE,

          LAYOUT_ADDCHILD, gtext1 := TextEditorObject,
            GA_ID, GID_TEXT1,
            GA_RELVERIFY, TRUE,
            GA_GADGETHELP, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXTEDITOR_SHOWLINENUMBERS, TRUE,
            $45038,1,
          TextEditorEnd,
          CHILD_NOMINALSIZE, TRUE,

          LAYOUT_ADDCHILD, ButtonObject,
            GA_ID, GID_QUIT,
            GA_RELVERIFY, TRUE,
            GA_TEXT,'_Quit',
          ButtonEnd,
          CHILD_WEIGHTEDHEIGHT, 0,
        LayoutEnd,
      EndGroup,
    EndWindow
    
    gadgets[GID_MAIN]:=gmain
    gadgets[GID_LAYER1]:=glayer1
    gadgets[GID_TEXT1]:=gtext1

    ->Sets(gtext1,$45019,-1)
      Sets(gtext1,$45002,buffer)
        Sets(gtext1,$45038,1)
    
    IF (objects[OID_MAIN])
      windows[WID_MAIN]:=RA_OpenWindow(objects[OID_MAIN])
      IF (windows[WID_MAIN])
        app:=(Shl(1,appPort.sigbit))
        done:=0
        GetAttr(WINDOW_SIGMASK, objects[OID_MAIN], {signal})
        ActivateLayoutGadget( gadgets[GID_MAIN], windows[WID_MAIN], NIL, gadgets[GID_TEXT1])
        WHILE done=FALSE
          wait := Wait(signal OR SIGBREAKF_CTRL_C OR app)
          IF (wait AND SIGBREAKF_CTRL_C)
            done := TRUE
          ELSE
            WHILE ((result := RA_HandleInput(objects[OID_MAIN], {code})) = WMHI_LASTMSG)=FALSE
              r:=(result AND WMHI_CLASSMASK)
              SELECT r
                CASE WMHI_CLOSEWINDOW
                  windows[WID_MAIN] := NIL
                  done := TRUE
                CASE WMHI_GADGETUP
                  r:=(result AND WMHI_GADGETMASK)
                  SELECT r
                    CASE GID_QUIT
                      done := TRUE
                  ENDSELECT
                CASE WMHI_ICONIFY
                  RA_Iconify(objects[OID_MAIN])
                  windows[WID_MAIN] := NIL
                CASE WMHI_UNICONIFY
                  windows[WID_MAIN] := RA_OpenWindow(objects[OID_MAIN])
                  IF (windows[WID_MAIN])
                    GetAttr(WINDOW_SIGMASK, objects[OID_MAIN], {signal})
                  ELSE
                    done := TRUE
                  ENDIF
              ENDSELECT
            ENDWHILE
          ENDIF
        ENDWHILE
      ELSE
        PrintF('Can''t RA_OpenWindow()\n') -> Debug
      ENDIF
      DisposeObject(objects[OID_MAIN])
    ELSE
      PrintF('Can''t find objects[]\n') -> Debug
->      PrintF('Objects[] = 0x\z\h[8]\n', objects) -> Debug
    ENDIF
    DeleteMsgPort(appPort)
  ELSE
    PrintF('Can''t create MsgPort\n') -> Debug
  ENDIF

  closeAll(0)
ENDPROC

PROC openAll()
  IF (windowbase := OpenLibrary('window.class', 44))=NIL; PrintF('Can''t open window.class\n'); closeAll(10); ENDIF
  IF (bevelbase := OpenLibrary('images/bevel.image', 44))=NIL; PrintF('Can''t open bevel.image\n'); closeAll(11); ENDIF
  IF (layoutbase := OpenLibrary('layout.gadget', 44))=NIL; PrintF('Can''t open layout.gadget\n'); closeAll(12); ENDIF
  IF (textfieldbase := OpenLibrary('gadgets/texteditor.gadget', 44))=NIL; PrintF('Can''t open text editor.gadget\n'); closeAll(13); ENDIF
  IF (buttonbase := OpenLibrary('gadgets/button.gadget', 44))=NIL; PrintF('Can''t open button.gadget\n'); closeAll(15); ENDIF
  IF (labelbase := OpenLibrary('images/label.image', 44))=NIL; PrintF('Can''t open label.image\n'); closeAll(16); ENDIF
ENDPROC

PROC closeAll(number)
  IF windowbase; CloseLibrary(windowbase); ENDIF
  IF bevelbase; CloseLibrary(bevelbase); ENDIF
  IF layoutbase; CloseLibrary(layoutbase); ENDIF
  IF textfieldbase; CloseLibrary(textfieldbase); ENDIF
  IF buttonbase; CloseLibrary(buttonbase); ENDIF
  IF labelbase; CloseLibrary(labelbase); ENDIF
  Exit(number)
ENDPROC
