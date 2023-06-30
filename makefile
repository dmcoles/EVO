# Assemble E-VO and tools

options=
compiler=vasmm68k_mot

all:					EVO tools

debug:				options=-Ddebug
debug:				EVO

tools:
							make -C tools

modules:
							cd modules
							build from .build
							cd /

EVO:					E-VO.S
							$(compiler) -Fhunkexe $(options) E-VO.S
clean:
							-delete ram:emods all
							-delete EVO
							make -C tools clean

dist:					EVO tools modules
							-delete Rel ALL FORCE
							makedir Rel
							makedir Rel/Bin
							makedir Rel/Docs
							makedir Rel/Modules
							makedir Rel/Src
              makedir Rel/Rexx
							Copy EVO Rel/Bin/EVO
							Copy Tools/EDBG/EDBG Rel/Bin/
							Copy Tools/FDtoM/FDtoM Rel/Bin/
							Copy Tools/FindModule/FindModule Rel/Bin/
							Copy Tools/FlushCache/FlushCache Rel/Bin/
							Copy Tools/ShowCache/ShowCache Rel/Bin/
							Copy Tools/Pragma2Module/Pragma2Module Rel/Bin/
							Copy Tools/ShowCache/ShowCache Rel/Bin/
							Copy Tools/ShowHunk/ShowHunk Rel/Bin/
							Copy Tools/ShowModule/ShowModule Rel/Bin/
              Copy Rexx/#? Rel/Rexx/
							Copy file_id.diz Rel/
							Copy readme.txt Rel/
							Copy readme.txt Rel/evo.readme
							Copy E-VO.guide Rel/Docs/
							Copy Updates.txt Rel/Docs/
							Copy Ram:EMODS Rel/Modules ALL
							Copy reaction_examples Rel/Src/reaction_examples ALL
							Copy extra_examples Rel/Src ALL
							Copy Technical_info.txt Rel/Docs/

.PHONY:			tools modules