# Compile FindModule

options=SHOWFNAME
compiler=evo

all:					FindModule

debug:        options = DEBUG SHOWFNAME
debug:				FindModule

FindModule:		FindModule.e
							$(compiler) FindModule $(options)
clean:  			
							-delete FindModule
