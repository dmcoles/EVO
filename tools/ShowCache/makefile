# Compile ShowCache

options=SHOWFNAME
compiler=evo

all:					ShowCache

debug:        options = DEBUG SHOWFNAME
debug:				ShowCache

ShowCache:		ShowCache.e
							$(compiler) ShowCache $(options)
clean:  			
							-delete ShowCache
