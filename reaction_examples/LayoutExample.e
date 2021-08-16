/*************************************************************************
 * ClassAct Comprehensive Demo Program
 * Copyright © 1995 Phantom Development Co.
 *
 * Translated from C to E by Eric Sauvageau.
 */


/*
Supply inithook.m with ClassAct?  Or at least its source?  Might be added
  to  classact_lib.m?

*/

OPT PREPROCESS,OSVERSION=37

MODULE 'tools/inithook'

MODULE 'exec/memory','intuition/intuition','exec/ports',
       'intuition/gadgetclass',
       'utility/tagitem','workbench/startup','workbench/workbench',
       'icon',
       'utility/hooks','intuition/classes',
       'exec/lists','exec/nodes','dos/rdargs','dos/dos','amigalib/lists'


MODULE 'reaction/reaction','classes/window','gadgets/listbrowser','listbrowser',
       'reaction/reaction_macros','layout','gadgets/layout','images/bevel',
       'gadgets/chooser','chooser','images/label','label','window',
       'button','reaction/reaction_lib','amigalib/boopsi'

/* a simple button */
#define mButton(a) ButtonObject, GA_TEXT, a, ButtonEnd
#define DButton(a) ButtonObject, GA_TEXT, a, GA_DISABLED, TRUE, ButtonEnd


/**************************************************************************
 * Some label arrays for the gadgets in this demo.
 */

DEF objtypes:PTR TO LONG,
    objnames:PTR TO LONG


/*************************************************************************
 * ReadArgs
 */
 
#define TEMPLATE 'S=SIMPLEREFRESH/S,NC=NOCAREREFRESH/S,ND=NDEFER/S'

ENUM A_SIMPLE, A_NOCARE, A_NODEFER

DEF arguments:PTR TO LONG


-> Must use separate vars because for some reason, EC chokes when you try
-> to assign a value to an indexed array in the middle of a list...  Will
-> have to notify Wouter about that bugger.
-> We will manualy build the list later.

ENUM G_OBJTYPE=1, G_OBJLIST, G_TOP, G_UP, G_DOWN, G_BOTTOM, G_SORT,
     G_NEW, G_EDIT, G_COPY, G_REMOVE, G_HELP, G_SAVE, G_USE, G_TEST,
     G_CANCEL,G_END

DEF gl[18]: ARRAY OF LONG

DEF g_objtype,
    g_objlist,
    g_top,
    g_up,
    g_down,
    g_bottom,
    g_sort,
    g_new,
    g_edit,
    g_copy,
    g_remove,
    g_help,
    g_save,
    g_use,
    g_test,
    g_cancel


PROC init()
   objtypes:=['Exec','Image','Sound','Menu','Icon','Dock','Access',NIL]
   objnames:=['ToolManager','ScreenMode','WBPattern',NIL]

   buttonbase:=OpenLibrary('gadgets/button.gadget',0)
   listbrowserbase:=OpenLibrary('gadgets/listbrowser.gadget',0)
   chooserbase:=OpenLibrary('gadgets/chooser.gadget',0)
   windowbase:=OpenLibrary('window.class',0)
   layoutbase:=OpenLibrary('gadgets/layout.gadget',0)
   labelbase:=OpenLibrary('images/label.image',0)

   iconbase:=OpenLibrary('icon.library',36)

ENDPROC


/*************************************************************************
 * App message hook.
 * Workbench App messages can be caught with a callback hook such as this.
 * We'll not worry about the app message type in this hook. Objects dropped
 * on the window or on the icon (while iconified) will be added to the 
 * listview.
 */


PROC appMsgFunc(hook:PTR TO hook, window:PTR TO object, msg:PTR TO appmessage)
DEF win: PTR TO window, i, arg:PTR TO wbarg, l: PTR TO lh, n:PTR TO ln,
    name[256]:STRING

   i:=msg.numargs
   arg:=msg.arglist
   l:=hook.data
   GetAttr(WINDOW_WINDOW, window, {win} )


-> Detach the list for modifications.

   SetGadgetAttrsA(g_objlist, win, NIL,[LISTBROWSER_LABELS, Not(0), TAG_END])
		
   WHILE i
      /* Add the name of the icon to the listview. ListBrowser can copy the
       * text into an internal buffer and thus let us not worry about the
       * pointer validity.
       */

      DEC i

      NameFromLock(arg.lock, name, 256)
      AddPart(name,arg.name, 256)
      IF (n:=AllocListBrowserNodeA(1, [LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, name, TAG_END])) THEN AddTail(l, n)

      arg++

   ENDWHILE

-> Reattach the list

   SetGadgetAttrsA(g_objlist, win, NIL, [LISTBROWSER_LABELS, l, TAG_END])
ENDPROC

/*************************************************************************
 * Main Program
 */

PROC main() HANDLE
DEF objlist=NIL:PTR TO lh,
    typelist:PTR TO lh,
    args=NIL:PTR TO rdargs,
    appport: PTR TO mp,
    window=NIL:PTR TO object,
    mainlayout:PTR TO window,
    apphook:hook,
    win:PTR TO window,
    wsig, asig,done=FALSE,
    sig,result,code,
    tmp,tmp2,tmp3,
    ids:PTR TO LONG,
    dis=FALSE,i,
    helptext[40]:STRING


-> Init some lists, and open the required gadgets/libraries.

init()

ids:=[G_TOP, G_UP, G_DOWN, G_BOTTOM, G_EDIT, G_COPY, G_REMOVE, G_END ]

arguments:=[0,0,0]
IF (args:=ReadArgs(TEMPLATE, arguments, NIL))=NIL THEN Raise(20)

IF ((iconbase<>NIL) AND (buttonbase<>NIL) AND (listbrowserbase<>NIL) AND (chooserbase<>NIL) AND (windowbase<>NIL) AND (layoutbase<>NIL) AND (labelbase<>NIL))

   WriteF('\seferred \s refresh \s\n', (IF arguments[A_NODEFER] THEN 'Non-d' ELSE 'D'), (IF arguments[A_SIMPLE] THEN 'Simple' ELSE 'Smart'), (IF arguments[A_NOCARE] THEN '(NoCare)' ELSE ''))

   objlist:=browserNodesA(objnames)
   typelist:=chooserLabelsA(objtypes)

   /* By providing a message port you enable windowclass to handle iconification
    * and appwindows. This port can shared by all the windows of your application.
    */

   appport:=CreateMsgPort()

   IF (objlist AND typelist AND appport)
      inithook(apphook,{appMsgFunc},objlist)

      /* Create a Window object with a Layout. When Window is asked to open itself,
       * it will calculate how much space the Layout needs and size itself accordingly.
       */


      window:=WindowObject,
                   WA_IDCMP, IDCMP_RAWKEY,
                   WA_TOP, 20,
                   WA_LEFT, 20,
                   WA_SIZEGADGET, TRUE,
                   WA_DEPTHGADGET, TRUE,
                   WA_DRAGBAR, TRUE,
                   WA_CLOSEGADGET, TRUE,
                   WA_ACTIVATE, TRUE,

                   /* About window refreshes:
                    * Because WindowClass and LayoutClass can, when used together, change the
                    * normal Intuition practise of refreshing gadgets in the input.device context,
                    * some rules about the refresh system change.
                    * Deferred refresh works in both smart and simple refresh windows, but
                    * if nocarerefresh is used, Intuition does not retain the damage regions
                    * and any window damage will force the whole window to be refreshed.
                    * This demo allows you to try combinations of refresh types.
                    * In the normal case you can ignore this and let WindowClass and the user
                    * decide what kind of refreshes they want. Nocare refresh can be
                    * combined with smart refresh to provide a fast, but somewhat more memory
                    * hungry refresh method. Simple refresh can save some memory but it's
                    * slower.
                    */

                   WA_SIMPLEREFRESH, arguments[A_SIMPLE],
                   WA_NOCAREREFRESH, arguments[A_NOCARE],	
                   WA_SMARTREFRESH, Not(arguments[A_SIMPLE]),
				
                   WA_TITLE, 'ClassAct layout.gadget Example (ToolManager preferences mockup)',
                   WA_SCREENTITLE, 'ClassAct Copyright 1995 Phantom Development LLC.',
				
                   /* Turn on gadget help in the window 
                    */
				
                   WINDOW_GADGETHELP, TRUE,
				
                   /* Add an iconification gadget. If you have this, you must listen to
                    * WMHI_ICONIFY.
                    */
				 
                   WINDOW_ICONIFYGADGET, TRUE,
	
                   /* This message port lets windowclass handle the icon and appwindow.
                    */
				 
                   WINDOW_APPPORT, appport,
                   WINDOW_APPWINDOW, TRUE,
                   WINDOW_APPMSGHOOK, apphook,
				
                   /* The windowclass will automatically free the DiskObject used when
                    * iconifying the window. If you do not provide a valid DiskObject,
                    * windowclass will try to use env:sys/def_window.info or the default
                    * project icon.
                    */
				
                   WINDOW_ICON, GetDiskObject( 'LayoutExample' ),
                   WINDOW_ICONTITLE, 'ClassAct Example',
			
                   /* Below is the layout of the window 
                    */
			
                   WINDOW_PARENTGROUP, mainlayout:=VGroupObject,
                      LAYOUT_SPACEOUTER, TRUE,
                      LAYOUT_BEVELSTYLE, BVS_THIN,

                      /* this tag instructs layout.gadget to defer GM_LAYOUT and GM_RENDER and ask
                       * the windowclass to do them. This lessens the load on input.device 
                       */

                      LAYOUT_DEFERLAYOUT, Not(arguments[A_NODEFER]),

                      /* A 1-of-n chooser using the labels list we made from the label array earlier 
                       */

                      StartMember, g_objtype:=ChooserObject,
                         CHOOSER_LABELS, typelist,
                      EndMember,
                      MemberLabel('_Object Type'),

                      /* Objects can be given arbitary weights within groups, and layout.gadget
                       * will distribute space relative to the total weight of the group.
                       * Here we set the button column to 0 weight which means minimum space.
                       * Thus the listview gets all available extra space.
                       */
					
                      StartHGroup, BAligned,

                         StartMember, g_objlist:=ListBrowserObject,
                            LISTBROWSER_LABELS, objlist,
                            LISTBROWSER_SHOWSELECTED, TRUE,
                          EndMember,

                          StartVGroup,
                             StartMember, g_top:=DButton('Top'),
                             StartMember, g_up:=DButton('Up'),
                             StartMember, g_down:=DButton('Down'),
                             StartMember, g_bottom:=DButton('Bottom'),
                             StartMember, g_sort:=mButton('So_rt'),
                          EndGroup,
                          CHILD_WEIGHTEDWIDTH, 0,

                          /* One way to keep the buttons constant size is to set the
                           * group to stay at minimum size with a weight of 0. We could
                           * also set the weight of each of the buttons to 0. That way
                           * extra space would be distributed between the buttons
                           * instead of all below. This looks better.
                           */
						
                           CHILD_WEIGHTEDHEIGHT, 0,
                        EndGroup,
				
                        /* two rows of buttons. EvenSized instructs layout.gadget that it
                         * should make sure the minimum size of each matches, so that we
                         * get four neat columns.
                         * Again the weight is set to 0. When the window is resized, all
                         * space is given to the listview.
                         */
				

                         StartHGroup, EvenSized,
                            StartMember, g_new:=mButton('_New...'),
                            StartMember, g_edit:=DButton('_Edit...'),
                            StartMember, g_copy:=DButton('Co_py'),
                            StartMember, g_remove:=DButton('Remove'),
                         EndGroup,
                         CHILD_WEIGHTEDHEIGHT, 0,
			
                         StartHGroup, EvenSized,
                         StartMember, g_save:=mButton('_Save'),
                         StartMember, g_use:=mButton('_Use'),
                         StartMember, g_test:=mButton('_Test'),
                         StartMember, g_cancel:=mButton('_Cancel'),
                      EndGroup,
                      CHILD_WEIGHTEDHEIGHT, 0,


                      StartMember, g_help:=ButtonObject,
                         GA_READONLY, TRUE,
                         GA_TEXT, 'Welcome to ClassAct demo!',
                      EndMember,
                      CHILD_WEIGHTEDHEIGHT, 0,

                   EndGroup,
                EndWindow

      IF window

         /* Finish the gadgetarray initialisation. Set gadget IDs and release verify. 
          * This is one way of avoiding boring repetition in the layout description
          * taglist itself.
          */

-> Let's also generate the array of gadget pointers.  We couldn't generate it
-> while we created gadgets because some bug (?) in EC prevents the use of
-> an array in the middle of a list.
-> Fortunately, it's a breeze to do using E lists.

         gl:=[NIL,
              g_objtype,
              g_objlist,
              g_top,
              g_up,
              g_down,
              g_bottom,
              g_sort,
              g_new,
              g_edit,
              g_copy,
              g_remove,
              g_help,
              g_save,
              g_use,
              g_test,
              g_cancel,
              NIL]

         i:=1

         REPEAT
            SetAttrsA(gl[i], [GA_ID, i, GA_RELVERIFY, TRUE, TAG_END])
            INC i
         UNTIL (i = G_END)

         IF (win:=RA_OpenWindow(window))
            asig:=Shl(1,appport.sigbit)

            /* Now that the window has been opened, we can get the signal mask
             * of its user port. If the program supported iconification and didn't
             * use a shared IDCMP port between all windows, this signal bit
             * would have to be re-queried before each Wait().
             */
				
            GetAttr( WINDOW_SIGMASK, window, {wsig} )
	
            WHILE (done = FALSE)
               sig:=Wait(wsig OR asig OR SIGBREAKF_CTRL_C)

               IF (sig AND (wsig OR asig))

                  /* Messages waiting at the window's IDCMP port. Loop at WM_HANDLEINPUT
                   * until all have been processed.
                   */

                  WHILE ((result:=RA_HandleInput(window,{code})) <> WMHI_LASTMSG)

                    /* The return code of this method is two-part. The upper word describes the
                     * class of the message (gadgetup, menupick, closewindow, iconify, etc),
                     * and the lower word is a class-defined ID, currently in use in the
                     * gadgetup and menupick return codes.
                     * Switch on the class, then on the ID.
                     */
						
                     tmp:=(result AND WMHI_CLASSMASK)

                     SELECT tmp

                        CASE WMHI_GADGETUP
                             /* OK, got a gadgetup from something. Lets find out what the something is.
                              * The code WORD to which a pointer was passed to WM_HANDLEINPUT has been
                              * set to the Code value from the IDCMP_GADGETUP, in case we need it.
                              */
							
                             tmp2:=(result AND WMHI_GADGETMASK)
                             SELECT tmp2

                                CASE G_OBJLIST
                                     /* User clicked on the listview 
                                      */
                                     IF (code = Not(0)) THEN dis:=TRUE /* no node was selected */

                                     i:=0
                                     REPEAT
                                        SetGadgetAttrsA( gl[ids[i]], win, NIL, [GA_DISABLED, dis, TAG_END])
                                        RefreshGList( gl[ids[i]], win, NIL, 1 )
                                        INC i
                                     UNTIL (ids[i] = G_END)
                             ENDSELECT
					
                        CASE WMHI_GADGETHELP

                             /* A gadget help message informs the application about the gadget
                              * under the mouse pointer. The code WORD is set to the value the
                              * gadget returned. Result code contains the ID of the gadget, 
                              * or NULL (not in the window) or WMHI_GADGETMASK (not over a gadget).
                              */
								
                             tmp3:=(result AND WMHI_GADGETMASK)

                             SELECT tmp3

                                CASE G_OBJTYPE
                                  StrCopy(helptext,'Choose object type')
                                CASE G_OBJLIST
                                  StrCopy(helptext,'Choose object to modify')
                                CASE G_TOP     
                                  StrCopy(helptext,'Move object to top')
                                CASE G_UP      
                                  StrCopy(helptext,'Move object upwards')
                                CASE G_DOWN    
                                  StrCopy(helptext,'Move object downwards')
                                CASE G_BOTTOM  
                                  StrCopy(helptext,'Move object to bottom')
                                CASE G_SORT    
                                  StrCopy(helptext,'Sort object list')
                                CASE G_NEW     
                                  StrCopy(helptext,'Create new object')
                                CASE G_EDIT    
                                  StrCopy(helptext,'Edit object')
                                CASE G_COPY    
                                  StrCopy(helptext,'Make a new copy of object')
                                CASE G_REMOVE  
                                  StrCopy(helptext,'Delete the object')
                                CASE G_HELP    
                                  StrCopy(helptext,'Hey there ;)')
                                CASE G_SAVE    
                                  StrCopy(helptext,'Save settings')
                                CASE G_USE     
                                  StrCopy(helptext,'Use these settings')
                                CASE G_TEST    
                                  StrCopy(helptext,'Test these settings')
                                CASE G_CANCEL  
                                  StrCopy(helptext,'Cancel changes')
                                DEFAULT        
                                  StrCopy(helptext,'')
                             ENDSELECT

                             IF (SetGadgetAttrsA(gl[G_HELP], win, NIL, [GA_TEXT, helptext, TAG_END] )) THEN RefreshGList(gl[G_HELP], win, NIL, 1)

                        CASE WMHI_CLOSEWINDOW
                             /* The window close gadget was hit. Time to die...
                              */
                             done:=TRUE

                        CASE WMHI_ICONIFY
                             /* Window requests that it be iconified. Handle this event as
                              * soon as possible. The window is not iconified automatically to
                              * give you a chance to make note that the window pointer will be 
                              * invalid before the window closes. It also allows you to free
                              * resources only needed when the window is open, if you wish to.
                              */
                             IF (RA_Iconify( window )) THEN win:=NIL
								 
                        CASE WMHI_UNICONIFY
                             /* The window should be reopened. If you had free'd something
                              * on iconify, now is the time to re-allocate it, before calling
                              * CA_OpenWindow.
                              */
                             win:=RA_OpenWindow( window )

                     ENDSELECT
                  ENDWHILE

               ELSEIF (sig AND SIGBREAKF_CTRL_C)
                  done:=TRUE
               ENDIF

            ENDWHILE

            /* Close the window and dispose of all attached gadgets 
             */
            DisposeObject( window )
         ENDIF
      ENDIF
   ENDIF

   IF appport THEN DeleteMsgPort(appport)

   /* NIL is valid input for these helper functions, so no need to check.
    */
   freeChooserLabels( typelist )
   freeBrowserNodes( objlist )

   FreeArgs(args)
ENDIF

EXCEPT DO

   IF buttonbase THEN CloseLibrary(buttonbase)
   IF listbrowserbase THEN CloseLibrary(listbrowserbase)
   IF chooserbase THEN CloseLibrary(chooserbase)
   IF windowbase THEN CloseLibrary(windowbase)
   IF layoutbase THEN CloseLibrary(layoutbase)
   IF labelbase THEN CloseLibrary(labelbase)
   IF iconbase THEN CloseLibrary(iconbase)
ENDPROC
