# Compile all tools

options=
compiler=evo

all:					EDBG FDtoM FindModule FlushCache Pragma2Module ShowCache ShowModule ShowHunk

debug:        options = DEBUG
debug:				EDBG FDtoM FindModule FlushCache Pragma2Module

EDBG:					
							make -C EDBG $(options)
FDtoM:
							make -C FDtoM $(options)
FindModule:
							make -C FindModule $(options)
FlushCache:
							make -C FlushCache $(options)
Pragma2Module:
							make -C Pragma2Module $(options)
ShowCache:
							make -C ShowCache $(options)
ShowModule:
							make -C ShowModule $(options)
ShowHunk:							
							make -C ShowHunk $(options)
							
clean:  			
							make -C EDBG clean
							make -C FDtoM clean
							make -C FindModule clean
							make -C FlushCache clean
							make -C Pragma2Module clean
							make -C ShowCache clean
							make -C ShowModule clean
							make -C ShowHunk clean

.PHONY:				EDBG FDtoM FindModule FlushCache Pragma2Module ShowCache ShowModule ShowHunk
