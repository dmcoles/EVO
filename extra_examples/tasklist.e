-> tasklist.e - Snapshots and prints the ExecBase task list

MODULE 'amigalib/lists',
       'exec/execbase',
       'exec/lists',
       'exec/nodes',
       'exec/tasks'

CONST NAMELEN=32

-> Use extended structure to hold task information
OBJECT taskNode
  ln:ln
  taskaddress
  sigalloc
  sigwait
  name[NAMELEN]:ARRAY
ENDOBJECT

PROC main() HANDLE
  DEF ourtasklist:PTR TO lh, task:PTR TO tc, node:PTR TO taskNode,
      tnode:PTR TO taskNode, rnode, exec:PTR TO execbase
  -> E-Note: get the right type for execbase
  exec:=execbase

  -> Allocate memory for out list
  NEW ourtasklist
  -> Initialise list structure (ala newList())
  -> E-Note: so why not use newList()!?!
  newList(ourtasklist)

  -> Make sure tasks won't switch lists or go away
  Disable()

  -> Snapshot task WAIT list
  snapshot(exec.taskwait, ourtasklist)

  -> Snapshot task READY list
  -> E-Note: rnode will be first READY task
  rnode:=snapshot(exec.taskready, ourtasklist)

  -> Re-enable interrupts and taskswitching
  Enable()

  -> Print now (printing above would have defeated a Forbid or Disable)
  WriteF('Pri Address    SigAlloc   SigWait    Taskname\n')

  node:=ourtasklist.head
  WriteF('\nWAITING:\n')
  WHILE tnode:=node.ln.succ
    IF tnode=rnode THEN WriteF('\nREADY:\n')  -> We set rnode above
    WriteF('\z\d[2]  \z$\h[8]  \z$\h[8]  \z$\h[8]  \s\n',
           node.ln.pri, node.taskaddress, node.sigalloc,
           node.sigwait, node.name)
    -> E-Note: ignore the messy clean up - see exception handler
    node:=tnode
  ENDWHILE

  -> Say who we are
  WriteF('\nTHIS TASK:\n')
  task:=FindTask(NIL)
  WriteF('\z\d[2]  \z$\h[8]  \z$\h[8]  \z$\h[8]  \s\n',
         task.ln.pri, task, task.sigalloc, task.sigwait, task.ln.name)

EXCEPT DO
  IF ourtasklist
    -> E-Note: none of this is necessary, since the program is terminating
    node:=ourtasklist.head
    WHILE tnode:=node.ln.succ
      END node
      node:=tnode
    ENDWHILE
    END ourtasklist
  ENDIF
  SELECT exception
  CASE "MEM";  WriteF('Error: Ran out of memory\n')
  ENDSELECT
ENDPROC

-> E-Note: having a separate procedure avoids repeating all this code as well
->         as localising any exception from NEW 
PROC snapshot(from:PTR TO lh, to:PTR TO lh) HANDLE
  -> E-Note: we are really dealing with "tc" (task) nodes not "ln" nodes
  DEF exectask:PTR TO tc, tnode:PTR TO taskNode, first=NIL
  exectask:=from.head
  WHILE exectask.ln.succ
    NEW tnode
    -> Save task information we want to print
    -> E-Note: copy *safely* to tnode.name
    AstrCopy(tnode.name, exectask.ln.name, NAMELEN)
    tnode.ln.pri:=exectask.ln.pri
    tnode.taskaddress:=exectask
    tnode.sigalloc:=exectask.sigalloc
    tnode.sigwait:=exectask.sigwait
    AddTail(to, tnode)
    IF first=NIL THEN first:=tnode  -> E-Note: first task copied
    exectask:=exectask.ln.succ
  ENDWHILE
EXCEPT DO
ENDPROC first

versTag: CHAR 0, '$VER: tasklist 37.2 (31.3.92)', 0
