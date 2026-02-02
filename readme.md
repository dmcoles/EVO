E-VO Amiga E Compiler is a derivative of the original Amiga E compiler written
by Wouter van Oortmerssen. It adds many new features, bug fixes and
optimisations including object UNIONs, string merging, non word-aligned
objects and many more.

  Changes in E-VO 3.9.2:

   - fix parsing issue with the : (colon) character could cause errors when
     parsing expressions using the ternery operator (?)
   - fix register corruption causing corruption of module files in some
     scenarios
   - fix casing of CharInstr (changed to CharInStr) and CharInstri (changed to CharInStri)
   - added EVO_3_9_2 constant
   - FindModule: Issue with freezing on some modules
   - ShowModule: Issue with freezing on some modules
   - Updated EVO Language Guide file to fix some errors / inconsistencies
   - Added unittests.e file and set up to run this for each build.
   

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
