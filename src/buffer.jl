module LibBuffer

export Buffer, unsafe_wrap_buffer, HLTypes

using ..libconv

const HLTypes = Union{Float32,Float64}

"""
The `Buffer` object is a wrapper around the `halide::Buffer` object in Halide.

See [`unsafe_wrap_buffer`](@ref) for how to create a `Buffer` object from a dense array.
"""
mutable struct Buffer{T,N} <: AbstractArray{T,N}
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
Buffer(sz::NTuple{N,Int}) where N = Buffer{Float64}(sz)

Buffer{T}(n::Int) where T = Buffer{T}((n,))
function Buffer{T}(sz::NTuple{N,Int}) where {T<:HLTypes,N}
    if N >= 3
        throw(ArgumentError("Unsupported dimension: $N"))
    end
    return unsafe_wrap_buffer(Array{T,N}(undef, sz))
end

Base.copy(b::Buffer{T,N}) where {T,N} = unsafe_wrap_buffer(collect(b))

Base.size(b::Buffer{T,N}) where {T,N} = b.size
Base.eltype(::Buffer{T,N}) where {T,N} = T
Base.ndims(::Buffer{T,N}) where {T,N} = N
Base.length(b::Buffer{T,N}) where {T,N} = prod(b.size)

Base.convert(::Type{Buffer{T1,N}}, A::AbstractArray{T2,N}) where {T1,T2,N} = unsafe_wrap_buffer(T1.(A))
Base.convert(::Type{Buffer{T,N}}, A::AbstractArray{T,N}) where {T,N} = unsafe_wrap_buffer(collect(A))
Base.convert(::Type{Buffer{T,N}}, A::Array{T,N}) where {T,N} = unsafe_wrap_buffer(A)

Base.IndexStyle(::Buffer) = IndexCartesian()

Base.@propagate_inbounds function Base.getindex(b::Buffer{Float64,1}, i::Int)
    Base.checkbounds(b, i)
    return libconv.buffer_getindex_1d_f64(b.ptr, i)
end

Base.@propagate_inbounds function Base.getindex(b::Buffer{Float32,1}, i::Int)
    Base.checkbounds(b, i)
    return libconv.buffer_getindex_1d_f32(b.ptr, i)
end

Base.@propagate_inbounds function Base.getindex(b::Buffer{Float64,2}, i::Int, j::Int)
    Base.checkbounds(b, i, j)
    return libconv.buffer_getindex_2d_f64(b.ptr, i, j)
end
Base.@propagate_inbounds function Base.getindex(b::Buffer{Float32,2}, i::Int, j::Int)
    Base.checkbounds(b, i, j)
    return libconv.buffer_getindex_2d_f32(b.ptr, i, j)
end

Base.@propagate_inbounds function Base.setindex!(b::Buffer{Float64,1}, x::Float64, i::Int)
    Base.checkbounds(b, i)
    libconv.buffer_setindex_1d_f64(b.ptr, x, i)
    return x
end

Base.@propagate_inbounds function Base.setindex!(b::Buffer{Float32,1}, x::Float32, i::Int)
    Base.checkbounds(b, i)
    libconv.buffer_setindex_1d_f32(b.ptr, x, i)
    return x
end

Base.@propagate_inbounds function Base.setindex!(b::Buffer{Float64,2}, x::Float64, i::Int, j::Int)
    Base.checkbounds(b, i, j)
    libconv.buffer_setindex_2d_f64(b.ptr, x, i, j)
    return x
end

Base.@propagate_inbounds function Base.setindex!(b::Buffer{Float32,2}, x::Float32, i::Int, j::Int)
    Base.checkbounds(b, i, j)
    libconv.buffer_setindex_2d_f32(b.ptr, x, i, j)
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
    throw(ArgumentError("AbstractArray is not supported. Use concrete array types instead."))
end

function unsafe_wrap_buffer(data::Array{T}) where {T<:HLTypes}
    throw(ArgumentError("Unsupported dimension: $(ndims(data))"))
end

unsafe_wrap_buffer(data::Array{T}) where {T<:Real} = unsafe_wrap_buffer(convert(Array{Float64}, data))

function unsafe_wrap_buffer(data::Array{Float64,1})
    c = length(data)
    ptr = libconv.create_buffer_from_bytes_1d_f64(convert(Ptr{UInt8}, pointer(data)), c)
    return Buffer{Float64,1}(ptr, (c,))
end

function unsafe_wrap_buffer(data::Array{Float32,1})
    c = length(data)
    ptr = libconv.create_buffer_from_bytes_1d_f32(convert(Ptr{UInt8}, pointer(data)), c)
    return Buffer{Float32,1}(ptr, (c,))
end

function unsafe_wrap_buffer(data::Array{Float64,2})
    r, c = size(data)
    ptr = libconv.create_buffer_from_bytes_2d_f64(convert(Ptr{UInt8}, pointer(data)), c, r)
    return Buffer{Float64,2}(ptr, (r, c))
end

function unsafe_wrap_buffer(data::Array{Float32,2})
    r, c = size(data)
    ptr = libconv.create_buffer_from_bytes_2d_f32(convert(Ptr{UInt8}, pointer(data)), c, r)
    return Buffer{Float32,2}(ptr, (r, c))
end

end # module
