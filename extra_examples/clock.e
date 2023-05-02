/*
  clock.e

  Author: Horst Schumann
          Helmstedter Str. 18
          39167 Irxleben
          Germany

          e-mail: hschuman@cs.uni-magdeburg.de (until June, 1996)


  A little clock program written with Amiga E
  -------------------------------------------

  Thanks to Wouter van Oortmerssen for the programming environment
  of Amiga E (and for the release of version 3.2a with which my
  code for the timer.device finally worked).

  This is just an example for an analogue clock. I tried to do it
  as system friendly as possible, but a few calculations are still
  in there that take some time, so the system is getting slower,
  if the program is running more than 10 times simultaneously.
  That might be due to some trigonometric calculations. (I did not
  want to put in a look-up table to keep the program small.)

  As stated before, this is a simple clock program. I wrote it in
  E just to try the language and to have a clock I can customize
  to my personal preferences. These personal things are not in
  this release, it is just a simple clock written in E for
  the E-community to work with.

  Copyright: Use it as best as you can. It is public domain.

  "Bug": - might be possible to optimize further

*/

OPT OSVERSION=37

MODULE 'intuition/screens',
       'devices/timer',
       'intuition/intuition',
       'exec/ports',
       'exec/io'

DEF  pi_div_6=0.52359,            -> value for PI/6 (for speed)
     pi_div_30=0.10471,           -> value for PI/30 (for speed)
     hl=0.5,                      -> \
     ml=0.8,                      ->  > relative length of hands
     sl=0.9,                      -> /
     hlenx,hleny,                 -> \
     mlenx,mleny,                 ->  > absolute length of hands
     slenx,sleny,                 -> /
     win:PTR TO window,           -> pointer to window structure
     hour,minute,second,micro,    -> time values
     oldhour=0,                   -> \
     oldminute=0,                 ->  > time of last get_time
     oldsecond=0,                 -> /
     midx,midy,                   -> center of window x and y
     radx,rady,                   -> length from center to border
     hrad,mrad,srad               -> radians for hour, minute and second

PROC main()
DEF screen:PTR TO screen,         -> pointer to screen structure
    tr:PTR TO timerequest,        -> timerequest structure
    imess:PTR TO intuimessage,    -> intuition message dtructure
    msg:PTR TO mp,                -> pointer to message port
    quit=FALSE,                   -> flag for main loop
    sig,intui_sig,timer_sig,      -> space for signal bits
    class                         -> message class

  IF msg:=CreateMsgPort()    -> create port for timer
    IF tr:=CreateIORequest(msg,SIZEOF timerequest)
      IF OpenDevice('timer.device',UNIT_MICROHZ,tr,0)=0
        IF screen:=(LockPubScreen(NIL))
          IF win:=OpenWindowTagList(NIL,
                                   [WA_TOP,         screen.height/2,
                                    WA_LEFT,        screen.width/2,
                                    WA_WIDTH,       screen.width/6,
                                    WA_HEIGHT,      screen.height/4,
                                    WA_CLOSEGADGET, TRUE,
                                    WA_ACTIVATE,    TRUE,
                                    WA_DRAGBAR,     TRUE,
                                    WA_DEPTHGADGET, TRUE,
                                    WA_SIZEBBOTTOM, TRUE,
                                    WA_SIZEGADGET,  TRUE,
                                    WA_MINHEIGHT,   50,
                                    WA_MINWIDTH,    65,
                                    WA_MAXHEIGHT,   -1,
                                    WA_MAXWIDTH,    -1,
                                    WA_IDCMP,       IDCMP_CLOSEWINDOW OR
                                                    IDCMP_CHANGEWINDOW,
                                    WA_TITLE,       'Simple E Clock',
                                    0,0])
            SetStdRast(win.rport)
            /*
              calculate the center of the window and the distance
              from there to the borders
            */
            intui_sig:=Shl(1,win.userport.sigbit)
            timer_sig:=Shl(1,msg.sigbit)
            radx:=win.width-win.borderleft-win.borderright/2-1
            midx:=radx+win.borderleft
            rady:=win.height-win.bordertop-win.borderbottom/2-1
            midy:=rady+win.bordertop       -> set center and radius
            hlenx:=(radx)!*hl!             ->
            mlenx:=(radx)!*ml!              ->
            slenx:=(radx)!*sl!               -> set length of hands
            hleny:=(rady)!*hl!               ->
            mleny:=(rady)!*ml!              ->
            sleny:=(rady)!*sl!             ->
            CurrentTime({second},{micro})                ->
            second:=second-Mul(Div(second,86400),86400) ->
            hour:=Div(second,3600)                      ->
            oldhour:=hour                              ->
            second:=second-Mul(hour,3600)             -> init time values
            minute:=Div(second,60)                     ->
            oldminute:=minute                           ->
            second:=second-Mul(minute,60)                ->
            oldsecond:=second                            ->
            dialplate()
            tr.io.command:=TR_ADDREQUEST     ->
            tr.time.secs:=0                   -> set timer request
            tr.time.micro:=1000000-micro     ->
            SendIO(tr)                       -> send the request
            sig:=0                           -> reset signal bits
            WHILE quit=FALSE
              class:=NIL
              IF sig AND intui_sig                -> message from Intuition
                WHILE imess:=GetMsg(win.userport) -> get message(s)
                  class:=imess.class
                  IF class=IDCMP_CHANGEWINDOW     -> user changed window
                    RefreshWindowFrame(win)       -> redraw window frame
                    radx:=win.width-win.borderleft-win.borderright/2-1
                    midx:=radx+win.borderleft
                    rady:=win.height-win.bordertop-win.borderbottom/2-1
                    midy:=rady+win.bordertop      -> update center and radius
                    hlenx:=(radx)!*hl!        ->
                    mlenx:=(radx)!*ml!         ->
                    slenx:=(radx)!*sl!          -> change length of hands
                    hleny:=(rady)!*hl!          ->
                    mleny:=(rady)!*ml!         ->
                    sleny:=(rady)!*sl!        ->
                    dialplate()            -> clear window and draw clock
                  ELSEIF class=IDCMP_CLOSEWINDOW  -> user clicked close gadget
                    quit:=TRUE
                  ENDIF
                  ReplyMsg(imess)
                ENDWHILE
              ENDIF  -> no 'ELSEIF', because both events might have occured
              IF sig AND timer_sig               -> timer event
                WHILE GetMsg(msg)=tr
                  get_time()
                  tr.time.secs:=0
                  tr.time.micro:=1000000-micro   -> wait for next second
                  SendIO(tr)                     -> send timer request
                  clock()                        -> update clock
                ENDWHILE
              ENDIF
                IF quit                  -> in case, user wants to quit
                  AbortIO(tr)            -> end the last timer request
                  WaitIO(tr)             -> wait for it to end
                ELSE
                  sig:=Wait(timer_sig OR intui_sig)  -> wait for next event
                ENDIF
            ENDWHILE   -> quit=FALSE
            CloseWindow(win)
          ELSE
            WriteF('Could not open window!')
          ENDIF -> if OpenWindow
          UnlockPubScreen(NIL,screen)
        ELSE
          WriteF('Could not lock public screen!')
        ENDIF   -> if LockPubScreen
        CloseDevice(tr)
      ELSE
        WriteF('Could not open timer.device!')
      ENDIF -> if OpenDevice
      DeleteIORequest(tr)
    ELSE
      WriteF('Could not create IO request!')
    ENDIF -> if CreateIORequest
    DeleteMsgPort(msg)
  ELSE
    WriteF('Could not create message port!')
  ENDIF     -> if CreateMsgPort
ENDPROC


PROC get_time()            -> puts the current time into global variables
                           -> hour, minute, second and updates
                           -> oldhour, oldminute, oldsecond

DEF curtime                -> space for current time

  CurrentTime({curtime},{micro})
  oldsecond:=second                             -> save last value
  second:=curtime-Mul(Div(curtime,86400),86400) -> take days out of number
  oldhour:=hour                                 -> save last value
  hour:=Div(second,3600)                        -> calculate hours of day
  second:=second-Mul(hour,3600)                 -> take hours out
  oldminute:=minute                             -> save last value
  minute:=Div(second,60)                        -> get the mins of the hour
  second:=second-Mul(minute,60)                 -> take mins out leave secs
ENDPROC


PROC clock()               -> erase old display, if necessary
                           -> and redraw with new values

DEF xoff,yoff              -> x and y offsets from center

  /*
    erase changed hands, if necessary
  */
  IF second<>oldsecond
    xoff:=slenx!*Fcos(srad)!
    yoff:=sleny!*Fsin(srad)!
    Line(midx,midy,midx+xoff,midy+yoff,0)
  ENDIF
  IF minute<>oldminute
    xoff:=mlenx!*Fcos(mrad)!
    yoff:=mleny!*Fsin(mrad)!
    Line(midx,midy,midx+xoff,midy+yoff,0)
  ENDIF
  IF hour<>oldhour OR minute<>oldminute
    xoff:=hlenx!*Fcos(hrad)!
    yoff:=hleny!*Fsin(hrad)!
    Line(midx,midy,midx+xoff,midy+yoff,0)
  ENDIF

  /*
    convert to radians (minus 1.57... to normalize)
  */
  srad:=second!*pi_div_30-1.57075
  hrad:=hour!+(minute!/60.0)*pi_div_6-1.57075
  mrad:=minute!*pi_div_30-1.57075

  /*
    redraw hands
  */
  xoff:=slenx!*Fcos(srad)!
  yoff:=sleny!*Fsin(srad)!
  Line(midx,midy,midx+xoff,midy+yoff,3)    -> second hand
  xoff:=mlenx!*Fcos(mrad)!
  yoff:=mleny!*Fsin(mrad)!
  Line(midx,midy,midx+xoff,midy+yoff,2)    -> minute hand
  xoff:=hlenx!*Fcos(hrad)!
  yoff:=hleny!*Fsin(hrad)!
  Line(midx,midy,midx+xoff,midy+yoff,1)    -> hour hand
ENDPROC


PROC dialplate()           -> clear window and draw dialpate

DEF xoff,yoff,xoff2,yoff2, -> x and y offsets from center
    marks,                 -> counter variable
    angle                  -> angle in radians

  /*
    erase window contents
  */
  SetAPen(win.rport,0)
  RectFill(win.rport,win.borderleft,
                     win.bordertop,
                     win.width-win.borderright-1,
                     win.height-win.borderbottom-1)

  /*
    draw hour marks as dialplate
  */
  FOR marks:=1 TO 12
    angle:=marks!*pi_div_6-1.57075
    xoff:=(radx)!*0.95*Fcos(angle)!
    yoff:=(rady)!*0.95*Fsin(angle)!
    xoff2:=(radx)!*Fcos(angle)!
    yoff2:=(rady)!*Fsin(angle)!
    Line(midx+xoff,midy+yoff,midx+xoff2,midy+yoff2,1)
  ENDFOR
  get_time()
  clock()
ENDPROC
