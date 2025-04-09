module libconv

using Libdl

const libconv_runtime_handler = Ref{Ptr{Cvoid}}(C_NULL)
const libconv_jit_handler = Ref{Ptr{Cvoid}}(C_NULL)
const libconv_aot_handler = Ref{Ptr{Cvoid}}(C_NULL)

struct CBuffer end

include("buffer.jl")
include("ops.jl")

const provider = Ref{String}("")
const libdir_name = Sys.iswindows() ? "bin" : "lib"

function load_local_libconv(libcvlib_dir)
	local_libconv_runtime_path = normpath(joinpath(libcvlib_dir, libdir_name, "libconv_runtime.$(dlext)"))
	local_libconv_jit_path = normpath(joinpath(libcvlib_dir, libdir_name, "libconv_jit.$(dlext)"))
	local_libconv_aot_path = normpath(joinpath(libcvlib_dir, libdir_name, "libconv_aot.$(dlext)"))
	if !isfile(local_libconv_runtime_path)
		error("libconv_runtime not found at $local_libconv_runtime_path")
	else
		@debug "Loading libconv_runtime from $local_libconv_runtime_path"
		libconv_runtime_handler[] = dlopen(local_libconv_runtime_path)
		@assert libconv_runtime_handler[] != C_NULL
	end
	if !isfile(local_libconv_jit_path)
		error("libconv_jit not found at $local_libconv_jit_path")
	else
		@debug "Loading libconv_jit from $local_libconv_jit_path"
		libconv_jit_handler[] = dlopen(local_libconv_jit_path)
		@assert libconv_jit_handler[] != C_NULL
	end
	if !isfile(local_libconv_aot_path)
		error("libconv_aot not found at $local_libconv_aot_path")
	else
		@debug "Loading libconv_aot from $local_libconv_aot_path"
		libconv_aot_handler[] = dlopen(local_libconv_aot_path)
		@assert libconv_aot_handler[] != C_NULL
	end
end

function getenv(key, default)
	v = get(ENV, key, default)
	return isempty(v) ? default : v
end

function __init__()
	libconv_dir = getenv(
		"LIBCONV_LOCAL_LIBDIR", normpath(joinpath(@__DIR__, "..", "..", "dist")),
	)
	load_local_libconv(libconv_dir)
end

end # module
