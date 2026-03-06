Short:        E-VO: Amiga E Evolution
Author:       darren_m_coles@yahoo.co.uk (Darren Coles)
Uploader:     darren_m_coles@yahoo.co.uk (Darren Coles)
Type:         dev/e
Version:      3.9.3
Replaces:     dev/e/evo.lha
Architecture: m68k-amigaos
Distribution: Aminet

E-VO Amiga E Compiler is a derivative of the original Amiga E compiler written
by Wouter van Oortmerssen. It adds many new features, bug fixes and
optimisations including object UNIONs, string merging, non word-aligned
objects and many more.

  Changes in E-VO 3.9.3:

   - fix address error on 68000 due to mis-aligned data causing crash on loading
   - fix code generation error when compiling eg arr[i].bb+=10
   - fix errors when using NEW obj.create() syntax
   - fix error with NOT operator bleeding into next field when using eg
       [0,NOT(0),1]
   - O2M: improved hunk handling
   
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