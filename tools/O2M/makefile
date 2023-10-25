# Compile O2M

options=SHOWFNAME
compiler=evo

all:					o2m

debug:        options = DEBUG SHOWFNAME
debug:				o2m

o2m:  			o2m.e
							$(compiler) o2m $(options)
clean:  			
							-delete o2m
