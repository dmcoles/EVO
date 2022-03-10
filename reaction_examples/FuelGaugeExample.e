-> Simple example of a fuelgauge button V0.31 © by DMX 2001

  OPT PREPROCESS,OSVERSION=44

CONST FUELGAUGE_LEVEL=$D0012003
#ifndef EVO_3_5_0
CONST TAG_DONE=0
#endif

MODULE 'dos/dos','exec/ports','intuition/intuition','intuition/gadgetclass',
       'gadgets/layout','gadgets/fuelgauge','images/bevel','images/label','utility/tagitem',
       'classes/window','window','layout','fuelgauge','label','button','reaction/reaction_macros','amigalib/boopsi'

CONST FMIN=0
CONST FMAX=100

ENUM GID_GAUGE=0, GID_DOWN, GID_UP, GID_QUIT, GID_LAST
ENUM WID_MAIN=0, WID_LAST
ENUM OID_MAIN=0, OID_LAST

PROC main()

  DEF appPort:PTR TO mp
  DEF windows[WID_LAST]:ARRAY OF LONG
  DEF gadgets[GID_LAST]:ARRAY OF LONG
  DEF objects[OID_LAST]:ARRAY OF LONG
  DEF i
  DEF wait,signal,app,result
  DEF code,done,r
  DEF gg

  openAll()
  IF (appPort := CreateMsgPort())
    PrintF('AppPort = 0x\z\h[8]\n', appPort) -> Debug
    objects[OID_MAIN]:=WindowObject,
      WA_SCREENTITLE, 'Reaction Example V0.31 by DMX © 2001',
      WA_TITLE, 'Reaction FuelGauge Example',
      WA_ACTIVATE, TRUE,
      WA_DEPTHGADGET, TRUE,
      WA_DRAGBAR, TRUE,
      WA_CLOSEGADGET, TRUE,
      WA_SIZEGADGET, TRUE,
      WINDOW_ICONIFYGADGET, TRUE,
      WINDOW_ICONTITLE, 'FuelGauge',
      WINDOW_APPPORT, appPort,
      WINDOW_POSITION, WPOS_CENTERSCREEN,
      WINDOW_PARENTGROUP, VGroupObject,
        LAYOUT_SPACEOUTER, TRUE,
        LAYOUT_DEFERLAYOUT, TRUE,
        LAYOUT_ADDCHILD, gg:= FuelGaugeObject,
          GA_ID, GID_GAUGE,
          FUELGAUGE_ORIENTATION, FGORIENT_HORIZ,
          FUELGAUGE_MIN, FMIN,
          FUELGAUGE_MAX, FMAX,
          FUELGAUGE_LEVEL, 0,
          FUELGAUGE_PERCENT, TRUE,
          FUELGAUGE_TICKSIZE, 5,
          FUELGAUGE_TICKS, 10,
          FUELGAUGE_SHORTTICKS, TRUE,
        FuelGaugeEnd,
        LAYOUT_ADDCHILD, VGroupObject, 
          LAYOUT_BACKFILL, NIL,
          LAYOUT_SPACEOUTER, TRUE,
          LAYOUT_VERTALIGNMENT, LALIGN_CENTER,
          LAYOUT_HORIZALIGNMENT, LALIGN_CENTER,
          LAYOUT_BEVELSTYLE, BVS_FIELD,
          LAYOUT_ADDIMAGE, LabelObject,
            LABEL_TEXT, 'The fuelgauge supports optional tickmarks as\n',
            LABEL_TEXT, 'well as vertical and horizontal orientation.\n',
            LABEL_TEXT, ' \n',
            LABEL_TEXT, 'You can set the min/max range, as well as\n',
            LABEL_TEXT, 'options such as varargs ascii display,\n',
            LABEL_TEXT, 'percentage display, and custom pen selection.\n',
          LabelEnd,
        LayoutEnd,
        LAYOUT_ADDCHILD, HGroupObject,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_EVENSIZE, TRUE,
          LAYOUT_ADDCHILD, ButtonObject,
            GA_ID, GID_DOWN,
            GA_RELVERIFY, TRUE,
            GA_TEXT,'_Down',
          ButtonEnd,
          LAYOUT_ADDCHILD, ButtonObject,
            GA_ID, GID_UP,
            GA_RELVERIFY, TRUE,
            GA_TEXT,'_Up',
          ButtonEnd,
          LAYOUT_ADDCHILD, ButtonObject,
            GA_ID, GID_QUIT,
            GA_RELVERIFY, TRUE,
            GA_TEXT,'_Quit',
          ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT, 0,
      EndGroup,
    End

    gadgets[GID_GAUGE]:=gg

    IF (objects[OID_MAIN])
      windows[WID_MAIN]:=RA_OpenWindow(objects[OID_MAIN])
      IF (windows[WID_MAIN])
        app:=(Shl(1,appPort.sigbit))
        done:=0

        GetAttr(WINDOW_SIGMASK, objects[OID_MAIN], {signal})
        WHILE done=FALSE
          wait := Wait(signal OR SIGBREAKF_CTRL_C OR app)
          IF (wait AND SIGBREAKF_CTRL_C)
            done := TRUE
          ELSE
            WHILE ((result := RA_HandleInput(objects[OID_MAIN], {code})) = WMHI_LASTMSG)=FALSE
              r:=result AND WMHI_CLASSMASK
              SELECT r
                CASE WMHI_CLOSEWINDOW
                  windows[WID_MAIN] := NIL
                  done := TRUE
                CASE WMHI_GADGETUP
                  r:=result AND WMHI_GADGETMASK
                  SELECT r
                    CASE GID_DOWN
                      SetAttrsA(objects[OID_MAIN], [WA_BUSYPOINTER, TRUE,TAG_DONE])
                      FOR i := FMAX TO FMIN STEP -5
                        SetGadgetAttrsA(gadgets[GID_GAUGE], windows[WID_MAIN], NIL, [FUELGAUGE_LEVEL, i, TAG_DONE])
                        Delay(3)
                      ENDFOR
                      SetAttrsA(objects[OID_MAIN], [WA_BUSYPOINTER, FALSE,TAG_DONE])
                    CASE GID_UP
                      SetAttrsA(objects[OID_MAIN], [WA_BUSYPOINTER, TRUE,TAG_DONE])
                      FOR i := FMIN TO FMAX STEP 5
                        SetGadgetAttrsA(gadgets[GID_GAUGE], windows[WID_MAIN], NIL, [FUELGAUGE_LEVEL, i, TAG_DONE])
                        Delay(3)
                      ENDFOR
                      SetAttrsA(objects[OID_MAIN], [WA_BUSYPOINTER, FALSE, TAG_DONE])
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
  IF (windowbase := OpenLibrary('window.class', 44))=0
    PrintF('Can''t open window.class\n')
    closeAll(10)
  ENDIF
  IF (layoutbase := OpenLibrary('layout.gadget', 44))=0
    PrintF('Can''t open layout.gadget\n')
    closeAll(11)
  ENDIF
  IF (fuelgaugebase := OpenLibrary('gadgets/fuelgauge.gadget', 44))=0
    PrintF('Can''t open fuelgauge.gadget\n')
    closeAll(12)
  ENDIF
  IF (buttonbase := OpenLibrary('gadgets/button.gadget', 44))=0
    PrintF('Can''t open button.gadget\n')
    closeAll(13)
  ENDIF
  IF (labelbase := OpenLibrary('images/label.image', 44))=0
    PrintF('Can''t open label.image\n')
    closeAll(14)
  ENDIF
ENDPROC

PROC closeAll(number)
  IF windowbase
    CloseLibrary(windowbase)
  ENDIF
  IF layoutbase
    CloseLibrary(layoutbase)
  ENDIF
  IF fuelgaugebase
    CloseLibrary(fuelgaugebase)
  ENDIF
  IF buttonbase
    CloseLibrary(buttonbase)
  ENDIF
  IF labelbase
    CloseLibrary(labelbase)
  ENDIF
  Exit(number)
ENDPROC
