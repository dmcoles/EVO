  OPT MODULE
  OPT EXPORT

  MODULE 'intuition/intuition',
         'gadgets/listbrowser',
         'exec/nodes',
         'utility/tagitem',
         'exec/lists',
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
         'intuition/classes',
         'intuition/gadgetclass',
         'utility',
         'layout'

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
   WHILE (nextnode = node.succ)
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

   WHILE (nextnode = node.succ)
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

   WHILE (nextnode = node.succ)
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

->**************************************************************************

