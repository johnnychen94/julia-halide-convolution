"""
    create_buffer_from_bytes(T, data_ptr, length)
    create_buffer_from_bytes(T, data_ptr, rows, cols)

Create a Halide buffer from a pointer to raw data.

The data pointer should point to a contiguous block of memory
of the specified type `T`. The function will return a pointer to
a `CBuffer` object that represents the Halide buffer.
"""
function create_buffer_from_bytes end

for T in HLTypesList
  func_1d_sym = "create_buffer_from_bytes_1d_$(_get_type_suffix(T))"
  func_2d_sym = "create_buffer_from_bytes_2d_$(_get_type_suffix(T))"
  @eval begin
    @inline function create_buffer_from_bytes(
      ::Type{$T}, data_ptr::Ptr{UInt8}, length::Int
    )::Ptr{CBuffer}
      func_ptr = dlsym(libconv_handler[], Symbol($(func_1d_sym)))
      return ccall(func_ptr, Ptr{CBuffer}, (Ptr{UInt8}, Cint), data_ptr, length)
    end

    @inline function create_buffer_from_bytes(
      ::Type{$T}, data_ptr::Ptr{UInt8}, rows::Int, cols::Int
    )::Ptr{CBuffer}
      func_ptr = dlsym(libconv_handler[], Symbol($(func_2d_sym)))
      return ccall(func_ptr, Ptr{CBuffer}, (Ptr{UInt8}, Cint, Cint), data_ptr, rows, cols)
    end
  end
end

"""
    buffer_getindex(T, buffer, index)
    buffer_getindex(T, buffer, row, col)

Get the value at the specified index from the Halide buffer.

The function will return the value of type `T` at the specified
index. The index can be a single index for 1D buffers or
a tuple of indices for 2D buffers.

!!! warning index
    The index is 1-based, meaning that the first element
    is at index 1, not 0.

See also [`buffer_setindex!`](@ref) for setting values.
"""
function buffer_getindex end

for T in HLTypesList
  func_1d_sym = "buffer_getindex_1d_$(_get_type_suffix(T))"
  func_2d_sym = "buffer_getindex_2d_$(_get_type_suffix(T))"
  @eval begin
    @inline function buffer_getindex(::Type{$T}, buffer::Ptr{CBuffer}, index::Int)::$T
      func_ptr = dlsym(libconv_handler[], Symbol($(func_1d_sym)))
      return ccall(func_ptr, $T, (Ptr{CBuffer}, Cint), buffer, index-1)
    end

    @inline function buffer_getindex(
      ::Type{$T}, buffer::Ptr{CBuffer}, row::Int, col::Int
    )::$T
      func_ptr = dlsym(libconv_handler[], Symbol($(func_2d_sym)))
      return ccall(func_ptr, $T, (Ptr{CBuffer}, Cint, Cint), buffer, row-1, col-1)
    end
  end
end

"""
    buffer_setindex!(T, buffer, value, index)
    buffer_setindex!(T, buffer, value, row, col)

Set the value at the specified index in the Halide buffer.

The function will set the value of type `T` at the specified
index. The index can be a single index for 1D buffers or
a tuple of indices for 2D buffers.

!!! warning index
    The index is 1-based, meaning that the first element
    is at index 1, not 0.

See also [`buffer_getindex`](@ref) for getting values.
"""
function buffer_setindex! end

for T in HLTypesList
  func_1d_sym = "buffer_setindex_1d_$(_get_type_suffix(T))"
  func_2d_sym = "buffer_setindex_2d_$(_get_type_suffix(T))"
  @eval begin
    @inline function buffer_setindex!(
      ::Type{$T}, buffer::Ptr{CBuffer}, value::$T, index::Int...
    )::$T
      func_ptr = dlsym(libconv_handler[], Symbol($(func_1d_sym)))
      ccall(func_ptr, Cvoid, (Ptr{CBuffer}, $T, Cint), buffer, value, index[1]-1)
      return value
    end

    @inline function buffer_setindex!(
      ::Type{$T}, buffer::Ptr{CBuffer}, value::$T, row::Int, col::Int
    )::$T
      func_ptr = dlsym(libconv_handler[], Symbol($(func_2d_sym)))
      ccall(func_ptr, Cvoid, (Ptr{CBuffer}, $T, Cint, Cint), buffer, value, row-1, col-1)
      return value
    end
  end
end

"""
    destroy_buffer(buffer)

Free resources associated with a Halide buffer.
"""
function destroy_buffer(buffer::Ptr{CBuffer})
  ccall(dlsym(libconv_handler[], :destroy_buffer), Cvoid, (Ptr{CBuffer},), buffer)
end
