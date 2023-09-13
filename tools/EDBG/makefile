# Compile EDBG

options=SHOWFNAME
compiler=evo

all:					EDBG

debug:        options = DEBUG SHOWFNAME
debug:				EDBG

EDBG:					edbg.e sctext.m screg.m schex.m eexe.m
							$(compiler) EDBG $(options)

sctext.m:			sctext.e
							$(compiler) sctext $(options)

schex.m:			schex.e
							$(compiler) schex $(options)

eexe.m:			  eexe.e
							$(compiler) eexe $(options)

screg.m:			screg.e sctext.m eexe.m
							$(compiler) screg $(options)


clean:  			
							-delete EDBG sctext.m screg.m schex.m eexe.m
