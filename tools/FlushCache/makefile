# Compile FlushCache

options=SHOWFNAME
compiler=evo

all:					FlushCache

debug:        options = DEBUG SHOWFNAME
debug:				FlushCache

FlushCache:		FlushCache.e
							$(compiler) FlushCache $(options)
clean:  			
							-delete FlushCache
