Short:        E-VO: Amiga E Evolution
Author:       darren_m_coles@yahoo.co.uk (Darren Coles)
Uploader:     darren_m_coles@yahoo.co.uk (Darren Coles)
Type:         dev/e
Version:      3.9.0
Replaces:     dev/e/evo.lha
Architecture: m68k-amigaos
Distribution: Aminet

E-VO Amiga E Compiler is a derivative of the original Amiga E compiler written
by Wouter van Oortmerssen. It adds many new features, bug fixes and
optimisations including object UNIONs, string merging, non word-aligned
objects and many more.

  Changes in E-VO 3.9.0:
   - FindModule: fix division by 0 error
   - FindModule: updated to handle module format version 15
   - EDBG: fix issues loading files generated with E-VO 3.8.x
   - O2M: Added support for symbol hunks
   - ShowModule: Updated to handle module format version 15
   - Warnings are now displayed when encountered rather than at the
     end of the compile
   - Add "assign of ARRAY/STRING/LIST variable" warning
   - Allow objects to be constructed using NEW objectname as well as
     NEW objectvar
   - When using OPT POOL, all memory allocation/free via NEW, String(),
     List(), New(), FastNew(), NewR(), END, Dispose(), FastDispose(),
     FastDisposeList() will be done from the pool
   - Added CharInStr(str,char) function to search for a char in a string
   - Added CharInStri(str,char) function, as CharInStr but case insensitive
   - Added MemCompare(mem1,mem2,len) function to compare two memory areas,
     returns -1 (mem1 contents less),1 (mem2 contents less) or 0
     (both equal)
   - Optimised WriteF, PrintF, PutF, TextF to skip the formatting part if no
     additional parameters are passed after the format string
   - Add NILCHECK variants of many E functions that raise a "NIL" exception
   - Small changes to ASTRCLONE and STRREM to remove unnecessary instructions
   - Exception raising code reworked to remove some code duplication
   - Global variables with default values now allowed in modules
   - Global array of object variables now allowed in modules
   - Added STACKCHECK command line option to add code to each PROC to check
     for enough stack space
   - Fix astrclone to always clear first byte of result if the length is 0
   - Updated module format version to 15
   - Added STACKCHECK procedure modifier to enable stack checking for a
     particular procedure
   - Added GETA4 procedure modifier to restore A4 at the start of the
     procedure
   - Replaced all CLR <reg> to MOVEQ #x,<reg> or EOR as appropriate
   - add PROC x() MODSETUP and PROC x() MODCLEANUP - from creative but with
     name changed from SETUP/CLEANUP due to naming clashes
   - Fix memory corruption issue during parsing
   - fix error generating HUNK_DREL32SHORT hunk causing corrupt exe
   - fix legacy mode memory corruption creating corrupt module
   - increase fixed buffer sizes
   - fix assembler error with MULS.L and DIVSL.L commands generating
     incorrect opcodes
   - PTR indexes are now 32 bit so can be >65535 and <0
   - indexed ptr to object code generation optimised for 68020
     (to use MULS.L) and to generate add/shift/subtract combinations
     instead of MULS where appropriate
   - Fix for obj.prop+=2 which was broken due to register value not
     being preserved.
   - Add NIL test in Free()
   - disable 020 JSR to BSR.L optimisation when multiple sections in
     use (which was causing invalid code generation)
   - Add compile time array bounds checking (for constant array indexes)
   - Add ARRAYCHECK command line parameter to add code to each array access
     to check array bounds
   - Fix symbol hunks being generated incorrectly when multiple sections
     in use
   - added EVO_3_9_0 define
   - added newer version of cybergraphics module

   
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