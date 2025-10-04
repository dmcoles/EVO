Short:        E-VO: Amiga E Evolution
Author:       darren_m_coles@yahoo.co.uk (Darren Coles)
Uploader:     darren_m_coles@yahoo.co.uk (Darren Coles)
Type:         dev/e
Version:      3.9.1
Replaces:     dev/e/evo.lha
Architecture: m68k-amigaos
Distribution: Aminet

E-VO Amiga E Compiler is a derivative of the original Amiga E compiler written
by Wouter van Oortmerssen. It adds many new features, bug fixes and
optimisations including object UNIONs, string merging, non word-aligned
objects and many more.

  Changes in E-VO 3.9.1:
   - Fixed issue with TextF function crashing
   - Add cheeck for declaring exported variable that references
     a private object
   - Added support for PTR to imported object types in modules
   - Fixed issue with BYTE and WORD declarations followed by comma
   - Array of char/int/long etc declared in module caused crash
   - Array of object declared in module was not allocated the correct
     amount of stack space
   - Added NOPROGRESS command line switch to disable printing of progress
     line numbers during compilation
   - Updated to module format version 16
   - Added EVO_3_9_1 define
   - FindModule wasn't displaying PTR types correctly in older module
     versions
   - FindModule was showing signed / unsigned types reversed
   - FindModule: Add support for PTR to imported object types 
   - FindModule: updated to more correctly handle private objects and
     private globals
   - ShowModule wasn't displaying PTR types correctly in older module
     versions
   - ShowModule was showing signed / unsigned types reversed
   - ShowModule: Add support for PTR to imported object types 
   - ShowModule: updated to more correctly handle private objects and
     private globals
   - Added version string to FindModule
   - Fixed installer script incorrectly removing assigns

   
E is an object oriented / procedural / unpure functional higher programming
language, mainly influenced by languages such as C++, Ada, Lisp etc.  It is a
general-purpose programming language, and the Amiga implementation is
specifically targeted at programming system applications.

If you want to assemble this code yourself you should use Asm-One or Vasm. The
source is all contained within a single source file and requires no additional
resources.

The program is released into the public domain for anyone to use however they
wish with no restrictions apart from that the program should not be sold for
profit.

Darren Coles