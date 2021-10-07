# Compile ACP and EXPRESS and any dependencies

options=OPTI
compiler=EVO

all:					edbg

edbg:					edbg.e sctext.m screg.m schex.m eexe.m
							$(compiler) edbg $(options)

sctext.m:			sctext.e
							$(compiler) sctext $(options)

schex.m:			schex.e
							$(compiler) schex $(options)

eexe.m:			  eexe.e
							$(compiler) eexe $(options)

screg.m:			screg.e sctext.m eexe.m
							$(compiler) screg $(options)


clean:  			
							delete edbg sctext.m screg.m schex.m eexe.m
