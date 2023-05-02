/*
    NodeMaster_Sort.e - V1.00

    Written By Andrea Galimberti

    This source demonstates how to create
    sort a list of "objects". In this case
    our "object" will be called "stuff" and
    will contain just one field called "avg".

    Our comparison routine will take as parameters
    two "Stuff" items and the info param (which will be
    ignored).

    This source shows also the version() method.


    This source is Public Domain.

    NodeMaster is part of the Amiga Foundation Classes
    See:
          http://www.intercom.it/~fsoft/afc.html

    for more info and more modules.
*/

MODULE 'afc/nodemaster',
       'afc/explain_exception'

CONST MAX_ELEM = 50  -> Change this value TO increase/decrease no. of items TO sort

OBJECT stuff
  avg
ENDOBJECT

/*
    This is our comparison routine.
    look:

        a and b are two "stuff" objects.

    Their ".avt" field just contains a number:
    by sub a.avg-b.avg will have a value < or > or = to 0
    That we'll return as result.

    This is a simple example, but you can create better
    and more complex ones.
*/
PROC cpstuff(a:PTR TO stuff,b:PTR TO stuff, info) IS a.avg - b.avg


PROC main() HANDLE
  DEF k
  DEF num:PTR TO nodemaster, l:PTR TO stuff
  DEF v,r

  NEW num.nodemaster()

  -> Here we fill the list with random numbers
  Rnd(-RndQ($FFA354B2))
  FOR k:=0 TO MAX_ELEM-1
    NEW l
    l.avg:=Rnd(1000)
    num.add(l)
  ENDFOR

  WriteF('Now sorting...')

  -> and here we sort it!!!
  num.sort({cpstuff})

  WriteF('Done!\n')

  -> Let's see the result
  l:=num.first()
  REPEAT
    WriteF('\d\n',l.avg)
  UNTIL (l:=num.succ())=FALSE


  -> Good: which version of NodeMaster is this?
  v,r := num.version()

  WriteF('NodeMaster V\d.\d \n', v,r)

EXCEPT DO
  explain_exception()

  IF (l:=num.first())<>FALSE
    REPEAT
      Dispose(l)
    UNTIL (l:=num.succ())=FALSE
  ENDIF
  END num
  CleanUp(0)
ENDPROC

