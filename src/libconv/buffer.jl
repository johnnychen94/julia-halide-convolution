"""
	create_buffer_from_bytes_1d_f64(data_ptr, length)

Create a Halide buffer from raw data pointer of Float64 type.
"""
function create_buffer_from_bytes_1d_f64(data_ptr::Ptr{UInt8}, length::Int)::Ptr{CBuffer}
	ccall(
		dlsym(libconv_jit_handler[], :create_buffer_from_bytes_1d_f64),
		Ptr{CBuffer},
		(Ptr{UInt8}, Cint),
		data_ptr, length,
	)
end

"""
	create_buffer_from_bytes_1d_f32(data_ptr, length)

Create a Halide buffer from raw data pointer of Float32 type.
"""
function create_buffer_from_bytes_1d_f32(data_ptr::Ptr{UInt8}, length::Int)::Ptr{CBuffer}
	ccall(
		dlsym(libconv_jit_handler[], :create_buffer_from_bytes_1d_f32),
		Ptr{CBuffer},
		(Ptr{UInt8}, Cint),
		data_ptr, length,
	)
end

"""
	create_buffer_from_bytes_2d_f64(data_ptr, rows, cols)

Create a 2D Halide buffer from raw data pointer of Float64 type.
"""
function create_buffer_from_bytes_2d_f64(data_ptr::Ptr{UInt8}, rows::Int, cols::Int)::Ptr{CBuffer}
	ccall(
		dlsym(libconv_jit_handler[], :create_buffer_from_bytes_2d_f64),
		Ptr{CBuffer},
		(Ptr{UInt8}, Cint, Cint),
		data_ptr, rows, cols,
	)
end

"""
	create_buffer_from_bytes_2d_f32(data_ptr, rows, cols)

Create a 2D Halide buffer from raw data pointer of Float32 type.
"""
function create_buffer_from_bytes_2d_f32(data_ptr::Ptr{UInt8}, rows::Int, cols::Int)::Ptr{CBuffer}
	ccall(
		dlsym(libconv_jit_handler[], :create_buffer_from_bytes_2d_f32),
		Ptr{CBuffer},
		(Ptr{UInt8}, Cint, Cint),
		data_ptr, rows, cols,
	)
end

"""
	destroy_buffer(buffer)

Free resources associated with a Halide buffer.
"""
function destroy_buffer(buffer::Ptr{CBuffer})
	ccall(
		dlsym(libconv_jit_handler[], :destroy_buffer),
		Cvoid,
		(Ptr{CBuffer},),
		buffer,
	)
end

"""
	buffer_getindex_1d_f64(buffer, index)

Get a Float64 value at the specified index from the buffer.
"""
function buffer_getindex_1d_f64(buffer::Ptr{CBuffer}, index::Int)::Float64
	ccall(
		dlsym(libconv_jit_handler[], :buffer_getindex_1d_f64),
		Cdouble,
		(Ptr{CBuffer}, Cint),
		buffer, index - 1,
	)
end


"""
	buffer_getindex_1d_f32(buffer, index)

Get a Float32 value at the specified index from the buffer.
"""
function buffer_getindex_1d_f32(buffer::Ptr{CBuffer}, index::Int)::Float32
	ccall(
		dlsym(libconv_jit_handler[], :buffer_getindex_1d_f32),
		Cfloat,
		(Ptr{CBuffer}, Cint),
		buffer, index - 1,
	)
end

"""
	buffer_getindex_2d_f64(buffer, row, col)

Get a Float64 value at the specified row and column from the buffer.
"""
function buffer_getindex_2d_f64(buffer::Ptr{CBuffer}, row::Int, col::Int)::Float64
	ccall(
		dlsym(libconv_jit_handler[], :buffer_getindex_2d_f64),
		Cdouble,
		(Ptr{CBuffer}, Cint, Cint),
		buffer, row - 1, col - 1,
	)
end

"""
	buffer_getindex_2d_f32(buffer, row, col)

Get a Float32 value at the specified row and column from the buffer.
"""
function buffer_getindex_2d_f32(buffer::Ptr{CBuffer}, row::Int, col::Int)::Float32
	ccall(
		dlsym(libconv_jit_handler[], :buffer_getindex_2d_f32),
		Cfloat,
		(Ptr{CBuffer}, Cint, Cint),
		buffer, row - 1, col - 1,
	)
end

"""
	buffer_setindex_1d_f32(buffer, value, index)

Set a Float32 value at the specified index in the buffer.
"""
function buffer_setindex_1d_f64(buffer::Ptr{CBuffer}, value::Float64, index::Int)
	ccall(
		dlsym(libconv_jit_handler[], :buffer_setindex_1d_f64),
		Cvoid,
		(Ptr{CBuffer}, Cdouble, Cint),
		buffer, value, index - 1,
	)
end

"""
	buffer_setindex_1d_f32(buffer, value, index)

Set a Float32 value at the specified index in the buffer.
"""
function buffer_setindex_1d_f32(buffer::Ptr{CBuffer}, value::Float32, index::Int)
	ccall(
		dlsym(libconv_jit_handler[], :buffer_setindex_1d_f32),
		Cvoid,
		(Ptr{CBuffer}, Cfloat, Cint),
		buffer, value, index - 1,
	)
end

"""
	buffer_setindex_2d_f64(buffer, value, row, col)

Set a Float64 value at the specified row and column in the buffer.
"""
function buffer_setindex_2d_f64(buffer::Ptr{CBuffer}, value::Float64, row::Int, col::Int)
	ccall(
		dlsym(libconv_jit_handler[], :buffer_setindex_2d_f64),
		Cvoid,
		(Ptr{CBuffer}, Cdouble, Cint, Cint),
		buffer, value, row - 1, col - 1,
	)
end

"""
	buffer_setindex_2d_f32(buffer, value, row, col)

Set a Float32 value at the specified row and column in the buffer.
"""
function buffer_setindex_2d_f32(buffer::Ptr{CBuffer}, value::Float32, row::Int, col::Int)
	ccall(
		dlsym(libconv_jit_handler[], :buffer_setindex_2d_f32),
		Cvoid,
		(Ptr{CBuffer}, Cfloat, Cint, Cint),
		buffer, value, row - 1, col - 1,
	)
end
