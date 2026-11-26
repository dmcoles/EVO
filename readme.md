E-VO Amiga E Compiler is a derivative of the original Amiga E compiler written
by Wouter van Oortmerssen. It adds many new features, bug fixes and
optimisations including object UNIONs, string merging, non word-aligned
objects and many more.

  Changes in E-VO 3.10.0:

- Improve NOT handling - did not work correctly in some scenarios
   - added OPT CANPOOL which enables memory pools only if OS39 is detected
   - added DEBUGLINENOS command line option which allows system generated run
     time exceptions (eg "MEM" "NIL" "INDX") to know which line number and
     which source file triggered the exception
   - added exceptionsrc variable which contains the source filename
     (requires DEBUGLINENOS to be active)
   - added exceptionline variable which contains the source line number
     where an exception occured (requires DEBUGLINENOS to be active)
   - fix for memory allocation / freeing issues when using OPT POOL
   - changed some compiler flags to byte to save space
   - added OPT ESTRCONST to make all string constants be created as estrings
   - updated module loader to only display warning about opt settings once
   - updated module loader to update newer OPT settings (LEGACYINT AND
     ESTRCONST) correctly when importing a module
   - fix compile error when calling SUPER obj.method() when the method name
     exists as a member of another object
   - improve module import warnings to be more specific about what was changed
   - updated line numbers on warnings to be unsigned word
   - consolidated tabs/spacing in E-VO source
   - EDBG: update to support code files with >32767 lines (new limit is 65535)
   - fix nilcheck triggered incorrectly in PrintF
   - Modules: fix typo in datatypes/pictureclass.m PMODE_V44 =1 should be
     PMODE_V43=1
   - treat line numbers as unsigned
   - EDBG: add goto line menu option
   - EDBG: add checks for selected source window (prevents crash)
   - Added MEMDEBUG command line switch: builds a program that tracks memory
     allocated by New(), NewR(), NewM(), NEW, FastNew(), String() and List()
     with the source line of each allocation and lists blocks never disposed
     when the program exits. Also warns about Dispose(), FastDispose() and
     FastDisposeList() of blocks that are not allocated.
     (Credit: Richard Collier)
   - Added MemDebugReport() function to list undisposed memory on demand
     (returns the number of blocks).
     (Credit: Richard Collier)
   - fix ptr to ptr in PROC parameter was identified as invalid syntax
   - self.m[0][0] where m is a PTR TO PTR TO LONG, the code generated a byte
     read instead of a long read
   - added EVO_3_10_0 define

E is an object oriented / procedural / unpure functional higher programming
language, mainly influenced by languages such as C++, Ada, Lisp etc.  It is a
general-purpose programming language, and the Amiga implementation is
specifically targeted at programming system applications.

If you want to assemble this code yourself you should use Asm-One or Vasm. The
source is all contained within a single source file and requires no additional
resources.

The program is released into the public domain for anyone to use however they
wish with no restrictions apart from that the E-VO program (or related
support programs) should not be sold for profit.

You may use this program to develop any application without restriction however
use of this project is entirely at your own risk. I will not accept responsibilty
for any issues arising from the use of E-VO.

Darren Coles
