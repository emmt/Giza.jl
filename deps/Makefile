# The following macro specifies the name or the path to the Giza dynamic
# library to use.  It can be overridden on the command line by:
#
#     make GIZA_JL_DLL="$PATH_TO_GIZA_DLL" ...
#
GIZA_JL_DLL=libgiza.so

all: deps.jl

clean:
	rm -f *~

rebuild:
	rm -f deps.jl
	make GIZA_JL_DLL="$(GIZA_JL_DLL)" deps.jl

deps.jl: build.jl Makefile
	GIZA_JL_DLL="$(GIZA_JL_DLL)" julia -e 'include("build.jl")'

.PHONY: all clean rebuild
