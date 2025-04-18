module libconv

using Libdl

const libconv_handler = Ref{Ptr{Cvoid}}(C_NULL)

struct CBuffer end

"""Halide Primitive Types"""
const HLTypes = Union{UInt8,UInt16,UInt32,UInt64,Int8,Int16,Int32,Int64,Float32,Float64}
const HLTypesList = (
  UInt8, UInt16, UInt32, UInt64, Int8, Int16, Int32, Int64, Float32, Float64
)

include("utils.jl")
include("buffer.jl")
include("ops.jl")

const provider = Ref{String}("")
const libdir_name = Sys.iswindows() ? "bin" : "lib"

function load_local_libconv(libcvlib_dir)
  local_libconv_path = normpath(joinpath(libcvlib_dir, libdir_name, "libconv.$(dlext)"))
  if !isfile(local_libconv_path)
    error("libconv not found at $local_libconv_path")
  else
    @debug "Loading libconv from $local_libconv_path"
    libconv_handler[] = dlopen(local_libconv_path)
    @assert libconv_handler[] != C_NULL
  end
end

function getenv(key, default)
  v = get(ENV, key, default)
  return isempty(v) ? default : v
end

function __init__()
  libconv_dir = getenv(
    "LIBCONV_LOCAL_LIBDIR", normpath(joinpath(@__DIR__, "..", "..", "dist"))
  )
  load_local_libconv(libconv_dir)
end

export HLTypes

end # module
