Short:        E-VO: Amiga E Evolution
Author:       darren_m_coles@yahoo.co.uk (Darren Coles)
Uploader:     darren_m_coles@yahoo.co.uk (Darren Coles)
Type:         dev/e
Version:      3.6.1
Replaces:     dev/e/evo.lha
Architecture: m68k-amigaos >= 2.0.4
Distribution: Aminet

E-VO Amiga E Compiler is a derivative of the original Amiga E compiler written
by Wouter van Oortmerssen. It adds many new features, bug fixes and
optimisations including object UNIONs, string merging, non word-aligned
objects and many more.

This version is a minor update which contains the following changes:

  add checks for object going over 64k
  
  fix 020 optimised address calculation for array of object (or ptr to
  object) indexing
  
  added EXENAME and DESTDIR command line arguments to override the output
  file name.
  
  EDBG: Setting breakpoint caused crashes on certain versions of graphics.library
  
  fix casing for IeeeDPFloor and IeeeDPCeil
  
  Extend lists to handle 64k items instead of 32k.
  
  Fix #else preprocessor parsing issues

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