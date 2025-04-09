module libconv

using Libdl

const libconv_handler = Ref{Ptr{Cvoid}}(C_NULL)

struct CBuffer end

include("buffer.jl")
include("ops.jl")

const provider = Ref{String}("")
const libdir_name = Sys.iswindows() ? "bin" : "lib"

function load_local_libconv(libcvlib_dir)
	local_libcv_path = normpath(joinpath(libcvlib_dir, libdir_name, "libconv.$(dlext)"))
	if !isfile(local_libcv_path)
		error("libcv not found at $local_libcv_path")
	else
		@debug "Loading libcv from $local_libcv_path"
		libconv_handler[] = dlopen(local_libcv_path)
		@assert libconv_handler[] != C_NULL
	end
end

function getenv(key, default)
	v = get(ENV, key, default)
	return isempty(v) ? default : v
end

function __init__()
	libconv_dir = getenv(
		"LIBCONV_LOCAL_LIBDIR", normpath(joinpath(@__DIR__, "..", "..", "install")),
	)
	load_local_libconv(libconv_dir)
end

end # module
