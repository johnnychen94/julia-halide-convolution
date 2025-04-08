module libconv

using Libdl
using Artifacts

const libconv_handler = Ref{Ptr{Cvoid}}(C_NULL)

struct CBuffer end

"""
    create_halide_buffer_from_bytes_1d(data_ptr, length)

Create a Halide buffer from raw data pointer.
"""
function create_halide_buffer_from_bytes_1d(data_ptr::Ptr{UInt8}, length::Int)
    ccall(
        dlsym(libconv_handler[], :create_halide_buffer_from_bytes_1d),
        Ptr{CBuffer},
        (Ptr{UInt8}, Cint),
        data_ptr, length
    )
end

"""
    destroy_halide_buffer(buffer)

Free resources associated with a Halide buffer.
"""
function destroy_halide_buffer(buffer::Ptr{CBuffer})
    ccall(
        dlsym(libconv_handler[], :destroy_halide_buffer),
        Cvoid,
        (Ptr{CBuffer},),
        buffer
    )
end

end # module
