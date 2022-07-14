# Compile ShowModule

options=SHOWFNAME
compiler=evo

all:					ShowModule

debug:        options = DEBUG SHOWFNAME
debug:				ShowModule

ShowModule:		ShowModule.e
							$(compiler) ShowModule $(options)
clean:  			
							-delete ShowModule
