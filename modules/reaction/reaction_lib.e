  OPT MODULE
  OPT EXPORT
  OPT PREPROCESS

  MODULE 'intuition/intuition',
         'intuition/cghooks',
         'intuition/intuitionbase',
         'gadgets/listbrowser',
         'exec/nodes',
         'utility/tagitem',
         'exec/lists',
         'exec/libraries',
         'amigalib/boopsi',
         'exec/memory',
         'gadgets/clicktab',
         'gadgets/listbrowser',
         'gadgets/chooser',
         'gadgets/radiobutton',
         'clicktab',
         'chooser',
         'listbrowser',
         'radiobutton',
         'amigalib/lists',
         'tools/boopsi',
         'intuition/classes',
         'intuition/classusr',
         'intuition/gadgetclass',
         'utility',
         'layout'

   

/* Used to create a table of libraries to open, passed to open_libs() and
 * close_libs(), a nice easy way to quickly open and close libraries and
 * classes.
 */

EXPORT OBJECT openlib
   libname:    LONG         -> EString holding the name of the library
   libversion: LONG         -> Minimum version required 
   libbase:    PTR TO lib   -> Pointer to the library base pointer.
   flags:      LONG         -> Flags (See below)
ENDOBJECT


EXPORT CONST OLF_REQUIRED = 1      -> Library is required, fail if open fails

EXPORT CONST OLF_OPTIONAL = 2      -> Optional, don't care if open fails,
                                   -> base pointer will be null.

EXPORT CONST OLF_BOOPSI = 4        -> Library is a BOOPSI class.



/*** openClass ***/

EXPORT PROC openClass(name,version)
DEF retval=NIL, buffer[256]:STRING

   IF (retval := OpenLibrary(name, version)) = NIL
      StringF(buffer, 'SYS:Classes/\s', name)
      IF (retval := OpenLibrary(buffer, version)) = NIL
         StringF(buffer, 'Classes/\s', name)
         retval := OpenLibrary(buffer, version)
      ENDIF
   ENDIF
ENDPROC retval


PROC addNodeA(gad:PTR TO gadget, win:PTR TO window,req:PTR TO requester, node:PTR TO ln, tags:PTR TO tagitem)
  DEF msg:lbaddnode

	msg.methodid:=LBM_ADDNODE
	msg.ginfo:=NIL
	msg.node:=node
	msg.nodeattrs:=tags

ENDPROC DoGadgetMethodA(gad, win, req, msg)

->**************************************************************************

PROC editNodeA(gad:PTR TO gadget, win:PTR TO window,req:PTR TO requester, node:PTR TO ln, tags:PTR TO tagitem)
  DEF msg:lbeditnode

	msg.methodid:=LBM_EDITNODE
	msg.ginfo:=NIL
	msg.node:=node
	msg.nodeattrs:=tags
ENDPROC DoGadgetMethodA(gad, win, req, msg)

->**************************************************************************

PROC remNode(gad:PTR TO gadget, win:PTR TO window,req:PTR TO requester, node:PTR TO ln)
  DEF msg:lbremnode

	msg.methodid:=LBM_REMNODE
	msg.ginfo:=NIL
	msg.node:=node
ENDPROC  DoGadgetMethodA(gad, win, req, msg)

->**************************************************************************

PROC clickTabsA(text:PTR TO LONG)
  DEF list:PTR TO lh
  DEF node:PTR TO ln
  DEF i=0

  IF (list:=AllocMem( SIZEOF lh, MEMF_PUBLIC ))
    newList(list)
    
    WHILE (text[])
      IF ((node:=AllocClickTabNodeA([TNA_TEXT, text[]++,
                                      TNA_NUMBER, i++,
                                      TAG_DONE]))=FALSE)
        freeClickTabs(list)
        RETURN NIL
      ENDIF

      AddTail(list,node)
    ENDWHILE
  ENDIF
ENDPROC list

->**************************************************************************

PROC freeClickTabs(list:PTR TO lh)
  DEF node:PTR TO ln
  DEF nextnode:PTR TO ln
  IF list
    node:= list.head
   WHILE (nextnode := node.succ)
      FreeClickTabNode(node)
      node := nextnode
   ENDWHILE
   FreeMem(list,SIZEOF lh)
  ENDIF
ENDPROC

->**************************************************************************

PROC browserNodesA(text:PTR TO LONG)
  DEF list:PTR TO lh
  DEF node:PTR TO ln
 
  IF (list:=AllocMem(SIZEOF lh,MEMF_PUBLIC))
		newList(list)

		WHILE( text[] )
      node:=AllocListBrowserNodeA( 1,[LBNCA_TEXT,text[]++,0])
			IF(node=FALSE)
				freeBrowserNodes( list )
				RETURN NIL
			ENDIF

			AddTail( list, node )
		ENDWHILE
	ENDIF

ENDPROC list

->**************************************************************************

PROC freeBrowserNodes(list:PTR TO lh)
	IF(list)
		FreeListBrowserList(list)
		FreeMem( list, SIZEOF lh )
	ENDIF
ENDPROC

->**************************************************************************

PROC chooserLabelsA(text:PTR TO LONG)
  DEF list:PTR TO lh
  DEF node:PTR TO ln

	IF(list:=AllocMem( SIZEOF lh, MEMF_PUBLIC ) )
	
		newList( list )

		WHILE( text[] )
		
			IF ((node:=AllocChooserNodeA([CNA_TEXT, text[]++,TAG_DONE]))=FALSE)
				freeChooserLabels( list )
				RETURN NIL
			ENDIF

			AddTail( list, node );
		ENDWHILE
	ENDIF
ENDPROC list

->**************************************************************************

PROC freeChooserLabels(list:PTR TO lh)  
  DEF node:PTR TO ln
  DEF nextnode:PTR TO ln
  IF list
    node:= list.head

   WHILE (nextnode := node.succ)
     FreeChooserNode(node)
     node := nextnode
   ENDWHILE
   FreeMem(list,SIZEOF lh)
  ENDIF
ENDPROC

->**************************************************************************

PROC radioButtonsA(text:PTR TO LONG)
  DEF list:PTR TO lh
  DEF node:PTR TO ln
  DEF i=0

	IF(list:=AllocMem( SIZEOF lh, MEMF_PUBLIC ) )
	
		newList( list )

		WHILE( text[] )
			IF ((node:=AllocRadioButtonNodeA(i++,[RBNA_LABELS, text[]++, TAG_DONE]))=FALSE)
				freeRadioButtons( list )
				RETURN NIL
			ENDIF

			AddTail( list, node );
		ENDWHILE
	ENDIF
ENDPROC list

->**************************************************************************

PROC freeRadioButtons(list:PTR TO lh)  
  DEF node:PTR TO ln
  DEF nextnode:PTR TO ln
  IF list
    node:= list.head

   WHILE (nextnode := node.succ)
     FreeRadioButtonNode(node)
     node := nextnode
   ENDWHILE
   FreeMem(list,SIZEOF lh)
  ENDIF
ENDPROC

->**************************************************************************

PROC getAttrsA(o:PTR TO object, tags:PTR TO tagitem)  
  DEF tlist:PTR TO tagitem
  DEF ti:PTR TO tagitem
  DEF cnt=0
  
  tlist:=tags
  WHILE ti= NextTagItem(tlist)
    cnt:=cnt+GetAttr(ti.tag,o,ti.data)
  ENDWHILE
ENDPROC cnt

->**************************************************************************

PROC refreshSetGadgetAttrsA(g:PTR TO gadget,w:PTR TO window,r:PTR TO requester, tags:PTR TO tagitem)
  DEF disabledTag:PTR TO tagitem
  IF w
    IF (disabledTag:=FindTagItem(GA_DISABLED,tags))
      IF (((disabledTag.data = FALSE) AND ((g.flags AND GFLG_DISABLED)=0)) OR
			   ((disabledTag.data<>FALSE) AND (g.flags AND GFLG_DISABLED)))
				disabledTag.tag:=TAG_IGNORE
			ELSE
				disabledTag:=NIL
      ENDIF
    ENDIF
  ELSE
    disabledTag:=NIL
  ENDIF
  
  IF SetGadgetAttrsA(g,w,r,tags)
    RefreshGList(g,w,r,1)
  ENDIF
  
  IF disabledTag THEN disabledTag.tag:=GA_DISABLED
ENDPROC

->**************************************************************************

PROC refreshSetPageGadgetAttrsA(g:PTR TO gadget,p:PTR TO object, w:PTR TO window,r:PTR TO requester, tags:PTR TO tagitem)
  DEF disabledTag:PTR TO tagitem
  IF w
    IF (disabledTag:=FindTagItem(GA_DISABLED,tags))
      IF (((disabledTag.data = FALSE) AND ((g.flags AND GFLG_DISABLED)=0)) OR
			   ((disabledTag.data<>FALSE) AND (g.flags AND GFLG_DISABLED)))
				disabledTag.tag:=TAG_IGNORE
			ELSE
				disabledTag:=NIL
      ENDIF
    ENDIF
  ELSE
    disabledTag:=NIL
  ENDIF
  
  IF SetPageGadgetAttrsA(g,p,w,r,tags)
    RefreshPageGadget(g,p,w,r)
  ENDIF
  
  IF disabledTag THEN disabledTag.tag:=GA_DISABLED
ENDPROC

/*** openlibs ***/

EXPORT PROC openLibs(libs: PTR TO openlib)
DEF i=0

   WHILE (libs[i].libname <> NIL)

      IF (libs[i].flags AND OLF_BOOPSI)
         libs[i].libbase := openClass(libs[i].libname,libs[i].libversion)
      ELSE
         libs[i].libbase := OpenLibrary(libs[i].libname, libs[i].libversion)
      ENDIF

      IF ((libs[i].flags AND OLF_REQUIRED) AND ((libs[i].libbase) = NIL)) THEN RETURN libs[i].libname
   INC i
	ENDWHILE
ENDPROC


EXPORT PROC closeLibs(libs:PTR TO openlib)
DEF i=0

   WHILE (libs[i].libname <> NIL)
      IF (libs[i].libbase) THEN CloseLibrary(libs[i].libbase)
      INC i
   ENDWHILE
ENDPROC


/*** DoGadgetMethod ***/

EXPORT PROC libDoGadgetMethodA(g:PTR TO gadget, w:PTR TO window, r:PTR TO requester,m:PTR TO msg)
DEF ibase: PTR TO intuitionbase,
    gi=NIL:PTR TO gadgetinfo,
    ret, tmp

   IF g THEN RETURN

   gi:=New(SIZEOF gadgetinfo)

   IF gi
      gi.requester := r
			
      IF w
         gi.screen := w.wscreen
         gi.window := w
            
         gi.rastport := w.rport
         gi.layer := w.wlayer
            
         IF (g.gadgettype AND GTYP_SCRGADGET)
            gi.window := NIL
            gi.domain.left := 0
            gi.domain.top :=0
            gi.domain.width := w.wscreen.width
            gi.domain.height := w.wscreen.height
         ELSEIF (g.gadgettype AND GTYP_GZZGADGET)
            gi.domain.left := w.borderleft
            gi.domain.top := w.bordertop
            gi.domain.width := (w.width - w.borderleft - w.borderright)
            gi.domain.height := (w.height - w.bordertop - w.borderbottom)
         ELSEIF (g.gadgettype AND GTYP_REQGADGET)
            gi.domain.left := r.leftedge
            gi.domain.top := r.topedge
            gi.domain.width := r.width
            gi.domain.height := r.height
         ELSE
            gi.domain.left := 0
            gi.domain.top := 0
            gi.domain.width := w.width
            gi.domain.height := w.height
         ENDIF
		
         gi.detailpen := w.detailpen
         gi.blockpen := w.blockpen

         gi.drinfo := GetScreenDrawInfo(gi.screen)
      ENDIF
   ENDIF
		
   tmp := m.methodid

   SELECT tmp
      CASE OM_NEW ; m::opset.ginfo := gi
      CASE OM_SET ; m::opset.ginfo := gi
      CASE OM_NOTIFY ; m::opset.ginfo := gi
      CASE OM_UPDATE ; m::opset.ginfo := gi
      DEFAULT        ; m::gphittest.ginfo := gi
   ENDSELECT

   ret := domethod(g, m)

   IF gi
      IF (gi.drinfo) THEN FreeScreenDrawInfo(gi.screen, gi.drinfo)
      Dispose(gi)
   ENDIF

ENDPROC ret

