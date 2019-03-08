if haskey(ENV, "GIZA_JL_DLL") && ENV["GIZA_JL_DLL"] != ""
    _GIZALIB = ENV["GIZA_JL_DLL"]
else
    _GIZALIB = "libgiza.so"
end
open(joinpath(@__DIR__, "deps.jl"), "w") do io
    write(io, "const _GIZALIB = \"$_GIZALIB\"\n")
end
nothing
