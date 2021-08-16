/* ClassAct Inter-Connection Notification Example
   Ported to E by Eric Sauvageau.
*/

OPT PREPROCESS,OSVERSION=37

MODULE 'exec/nodes','intuition','graphics','intuition/intuition',
       'intuition/gadgetclass','intuition/imageclass',
       'intuition/intuitionbase','intuition/classusr',
       'intuition/gadgetclass','intuition/cghooks','intuition/icclass',
       'intuition/classes'

MODULE 'libraries/gadtools','intuition/icclass','dos','dos/dos',
       'graphics','intuition','intuition/intuition','utility/tagitem'


MODULE 'window','classes/window','layout','gadgets/layout','gadgets/palette',
       'gadgets/button','images/bevel','palette','images/label','label',
       'classes/window','reaction/reaction_macros','button','amigalib/boopsi'


CONST ID_BUTTON = 1
CONST ID_FOREGROUND = 2
CONST ID_BACKGROUND = 3


PROC main()

DEF window:PTR TO window,
    but_object:PTR TO object,
    win_object:PTR TO object,
    mapfg2button, mapbg2button,
    tmpres1,tmpres2

DEF wait, signal, result, done=FALSE, code


   mapfg2button := [PALETTE_COLOR, BUTTON_TEXTPEN, TAG_END]
   mapbg2button := [PALETTE_COLOR, BUTTON_BACKGROUNDPEN, TAG_END]

   windowbase  := OpenLibrary('window.class',0)
   layoutbase  := OpenLibrary('gadgets/layout.gadget',0)
   buttonbase  := OpenLibrary('gadgets/button.gadget',0)
   palettebase := OpenLibrary('gadgets/palette.gadget',0)
   labelbase   := OpenLibrary('images/label.image',0)

   IF (windowbase AND layoutbase AND buttonbase AND palettebase AND labelbase)

-> Create the window object.

      win_object := WindowObject,
                        WA_SCREENTITLE, 'ClassAct Copyright 1995, Phantom Development LLC.',
                        WA_TITLE, 'ClassAct Example',
                        WA_SIZEGADGET, TRUE,
                        WA_LEFT, 40,
                        WA_TOP, 30,
                        WA_DEPTHGADGET, TRUE,
                        WA_DRAGBAR, TRUE,
                        WA_CLOSEGADGET, TRUE,
                        WA_ACTIVATE, TRUE,
                        WA_SMARTREFRESH, TRUE,

                        WINDOW_PARENTGROUP, VLayoutObject,
                           LAYOUT_SPACEOUTER, TRUE,
                           LAYOUT_DEFERLAYOUT, TRUE,
                           LAYOUT_BEVELSTYLE, GroupFrame,
                           LAYOUT_LABEL, 'InterConnection',

                           StartMember, but_object := ButtonObject,
                              GA_TEXT, '_Inter-Connection Example',
                              GA_ID, ID_BUTTON,
                           EndMember,
                           CHILD_WEIGHTEDHEIGHT, 0,

                           StartMember, HLayoutObject,
                              LAYOUT_SPACEOUTER, FALSE,

                              StartMember, PaletteObject,
                                 GA_ID, ID_FOREGROUND,
                                 PALETTE_NUMCOLORS, 8,
                                 PALETTE_COLOR, 1,
                                 ICA_TARGET, but_object, /* object to connect to */
                                 ICA_MAP, mapfg2button, /* tag mapping array */
                              EndMember,
                              CHILD_LABEL, LabelObject, LABEL_TEXT, '_ForeGround', LabelEnd,
                              CHILD_MINWIDTH, 90,
                              CHILD_MINHEIGHT, 20,

                              StartMember, PaletteObject,
                                 GA_ID, ID_BACKGROUND,
                                 PALETTE_NUMCOLORS, 8,
                                 PALETTE_COLOR, 0,
                                 ICA_TARGET, but_object, /* object to connect to */
                                 ICA_MAP, mapbg2button, /* tag mapping array */
                             EndMember,
                             CHILD_LABEL, LabelObject,  LABEL_TEXT, '_BackGround', LabelEnd,
                             CHILD_MINWIDTH, 90,
                             CHILD_MINHEIGHT, 20,
                          EndMember,
                       EndMember,
                    EndWindow

-> Object creation sucessful?

      IF win_object

-> Open the window.

         IF (window := RA_OpenWindow(win_object))

-> Obtain the window wait signal mask.

            GetAttr(WINDOW_SIGMASK, win_object, {signal})

-> Input Event Loop

            WHILE (done = FALSE)
               wait := Wait(signal OR SIGBREAKF_CTRL_C)
					
               IF (wait AND SIGBREAKF_CTRL_C)
                  done := TRUE

               ELSE

                  WHILE ((result := RA_HandleInput(win_object,{code})) <> WMHI_LASTMSG)

                     tmpres1 := (result AND WMHI_CLASSMASK)

                     SELECT tmpres1

                        CASE WMHI_CLOSEWINDOW ; done := TRUE

                        CASE WMHI_GADGETUP
                           tmpres2 := (result AND WMHI_GADGETMASK)

                           SELECT tmpres2
                             CASE ID_BUTTON ; NOP
                           ENDSELECT

                     ENDSELECT

                  ENDWHILE
               ENDIF
            ENDWHILE
         ENDIF

         /* Disposing of the window object will
          * also close the window if it is
          * already opened and it will dispose of
          * all objects attached to it.
          */
        DisposeObject(win_object )
      ENDIF
   ENDIF

-> Close the classes.

   IF labelbase   THEN CloseLibrary(labelbase)
   IF palettebase THEN CloseLibrary(palettebase)
   IF buttonbase  THEN CloseLibrary(buttonbase)
   IF layoutbase  THEN CloseLibrary(layoutbase)
   IF windowbase  THEN CloseLibrary(windowbase)

ENDPROC
