# Compile ShowHunk

options=SHOWFNAME
compiler=evo

all:					ShowHunk

debug:        options = DEBUG SHOWFNAME
debug:				ShowHunk

ShowHunk:		ShowHunk.e
							$(compiler) ShowHunk $(options)
clean:  			
							-delete ShowHunk
