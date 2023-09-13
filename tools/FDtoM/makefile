# Compile FDtoM

options=SHOWFNAME
compiler=evo

all:					FDtoM

debug:        options = DEBUG SHOWFNAME
debug:				FDtoM

FDtoM:  			FDtoM.e
							$(compiler) FDtoM $(options)
clean:  			
							-delete FDtoM
