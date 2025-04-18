"""
    Buffer(length)
    Buffer(size::NTuple{N,Int})

Creates a `Buffer` object with the specified length or size.

The `Buffer` object is a wrapper around the `halide::Buffer` object in Halide.

# Examples

```julia
using HLConv

x = Buffer(10) # creates a 1D buffer of length 10
y = Buffer((3, 4)) # creates a 2D buffer of size (3, 4)
```

```julia
using HLConv

unsafe_wrap_buffer([1, 2, 3, 4]) # creates a Buffer object from a dense array
```

See [`unsafe_wrap_buffer`](@ref) for how to create a `Buffer` object from a dense array.
"""
mutable struct Buffer{T<:HLTypes,N} <: AbstractArray{T,N}
  ptr::Ptr{libconv.CBuffer}
  size::NTuple{N,Int}

  function Buffer{T,N}(ptr::Ptr{libconv.CBuffer}, size::NTuple{N,Int}) where {T<:HLTypes,N}
    if ptr == C_NULL
      throw(ArgumentError("ptr is NULL"))
    end

    obj = new(ptr, size)
    finalizer(obj) do x
      libconv.destroy_buffer(x.ptr)
    end
  end
end

Buffer(n) = Buffer{Float64}(n)
Buffer(sz::NTuple{N,Int}) where {N} = Buffer{Float64}(sz)

Buffer{T}(n::Int) where {T} = Buffer{T}((n,))
function Buffer{T}(sz::NTuple{N,Int}) where {T<:HLTypes,N}
  if N >= 3
    throw(ArgumentError("Unsupported dimension: $N"))
  end
  return unsafe_wrap_buffer(Array{T,N}(undef, sz))
end

@inline Base.copy(b::Buffer{T,N}) where {T,N} = unsafe_wrap_buffer(collect(b))

@inline Base.size(b::Buffer{T,N}) where {T,N} = b.size
@inline Base.eltype(::Buffer{T,N}) where {T,N} = T
@inline Base.ndims(::Buffer{T,N}) where {T,N} = N
@inline Base.length(b::Buffer{T,N}) where {T,N} = prod(b.size)

@inline function Base.convert(::Type{Buffer{T1,N}}, A::AbstractArray{T2,N}) where {T1,T2,N}
  unsafe_wrap_buffer(map(T1, A))
end
@inline function Base.convert(::Type{Buffer{T,N}}, A::AbstractArray{T,N}) where {T,N}
  unsafe_wrap_buffer(collect(A))
end
@inline Base.convert(::Type{Buffer{T,N}}, A::Array{T,N}) where {T,N} = unsafe_wrap_buffer(A)

@inline Base.IndexStyle(::Buffer) = IndexCartesian()

Base.@propagate_inbounds function Base.getindex(b::Buffer{T,1}, i::Int) where {T}
  Base.checkbounds(b, i)
  return libconv.buffer_getindex(T, b.ptr, i)
end

Base.@propagate_inbounds function Base.getindex(
  b::Buffer{T,2}, i::Int, j::Int
) where {T<:HLTypes}
  Base.checkbounds(b, i, j)
  return libconv.buffer_getindex(T, b.ptr, i, j)
end

Base.@propagate_inbounds function Base.setindex!(b::Buffer{T,1}, x::Real, i::Int) where {T}
  Base.checkbounds(b, i)
  libconv.buffer_setindex!(T, b.ptr, convert(T, x), i)
  return x
end

Base.@propagate_inbounds function Base.setindex!(
  b::Buffer{T,2}, x::Real, i::Int, j::Int
) where {T}
  Base.checkbounds(b, i, j)
  libconv.buffer_setindex!(T, b.ptr, convert(T, x), i, j)
  return x
end

"""
    unsafe_wrap_buffer(data::Array)

Wrap a dense array into a `Buffer` object without copying the data.

Typically, this function is used to create a `halide::Buffer` object before calling the C API, e.g.,

```julia
using HLConv

x = [1.0, 2.0, 3.0, 4.0]

x_buf = unsafe_wrap_buffer(x)
```

You need to ensure that the data will not be GC-ed before the `Buffer` object is destroyed.
The common practice is to always create a temporary `Buffer` object in the same scope as the
`ccall` to the C function.

This function as well as the `Buffer` type should not be used by the end user.
"""
function unsafe_wrap_buffer end

function unsafe_wrap_buffer(::AbstractArray)
  throw(
    ArgumentError(
      "Can't convert to Buffer without allocating memory for generic array. If allocating is not a problem, use `unsafe_wrap_buffer(collect(data))` instead.",
    ),
  )
end

function unsafe_wrap_buffer(data::Array{T}) where {T<:Real}
  throw(
    ArgumentError(
      "Can't convert to Buffer without allocating memory for element type $T. If allocating is not a problem, use `unsafe_wrap_buffer(collect(data))` instead.",
    ),
  )
end

function unsafe_wrap_buffer(data::Array{T,N}) where {T<:HLTypes,N}
  if N >= 3
    throw(ArgumentError("Unsupported dimension: $N"))
  end

  ptr = libconv.create_buffer_from_bytes(
    T, convert(Ptr{UInt8}, pointer(data)), size(data)...
  )
  if ptr == C_NULL
    throw(ArgumentError("Failed to create buffer from bytes"))
  end

  return Buffer{T,N}(ptr, size(data))
end
