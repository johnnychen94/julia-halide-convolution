module LibMat

export Mat, unsafe_wrap_mat

using ..libcv
using Colors, FixedPointNumbers

"""
The `Mat` object is a wrapper around the `cv::Mat` object in OpenCV.

See [`unsafe_wrap_mat`](@ref) for how to create a `Mat` object from a dense array.
"""
mutable struct Mat
    ptr::Ptr{libcv.CMat}

    function Mat(ptr::Ptr{libcv.CMat})
        if ptr == C_NULL
            throw(ArgumentError("ptr is NULL"))
        end

        obj = new(ptr)
        finalizer(obj) do x
            libcv.destroy_cmat(x.ptr)
        end
    end
end

const CVTypes = Union{UInt8,Int8,UInt16,Int16,Int32,Float32,Float64,Float16}

"""
    unsafe_wrap_mat(data::Array)

Wrap an dense array into a `Mat` object without copying the data.

Typically, this function is used to create a `cv::Mat` object before calling the C API, e.g.,

```julia
using TyLibCV, ImageCore

img = rand(RGB{N0f8}, 100, 100)
out = Array{Gray{N0f8}}(100, 100)

img_mat = unsafe_wrap_mat(img)
out_mat = unsafe_wrap_mat(out)
libcv.rgb2gray(out_mat.ptr, in_mat.ptr) # which calls ccall to the C function
```

You need to ensure that the data will not be GC-ed before the `Mat` object is destroyed.
The common practice is to always create a temporary `Mat` object in the same scope as the
`ccall` to the C function.

This function as well as the `Mat` type should not be used by the end user. Instead, end users
should use the types defined in Colors.jl and ImageCore.jl.
"""
function unsafe_wrap_mat end

function unsafe_wrap_mat(::AbstractArray{T}) where {T<:CVTypes}
    throw(ArgumentError("Generic array is not supported. Use `Array` type instead."))
end

function unsafe_wrap_mat(data::Array{T}) where {T<:CVTypes}
    throw(ArgumentError("Unsupported dimension: $(ndims(data))"))
end

function unsafe_wrap_mat(data::Array{T,3}) where {T<:CVTypes}
    c, h, w = size(data)
    d = get_cv_depth(T)
    ptr = libcv.create_cmat_from_bytes(convert(Ptr{UInt8}, pointer(data)), w, h, c, d)
    return Mat(ptr)
end

function unsafe_wrap_mat(data::Array{T,2}) where {T<:CVTypes}
    h, w = size(data)
    d = get_cv_depth(T)
    ptr = libcv.create_cmat_from_bytes(convert(Ptr{UInt8}, pointer(data)), w, h, 1, d)
    return Mat(ptr)
end

function unsafe_wrap_mat(data::Array{T,2}) where {T<:RGB}
    raw_data = reinterpret(reshape, eltype(T), data)
    c, h, w = size(raw_data)
    d = get_cv_depth(eltype(T))

    ptr = libcv.create_cmat_from_bytes(convert(Ptr{UInt8}, pointer(data)), w, h, c, d)

    return Mat(ptr)
end

function unsafe_wrap_mat(data::Array{T,2}) where {T<:Gray}
    raw_data = reinterpret(reshape, eltype(T), data)
    h, w = size(raw_data)
    d = get_cv_depth(eltype(T))

    ptr = libcv.create_cmat_from_bytes(convert(Ptr{UInt8}, pointer(data)), w, h, 1, d)

    return Mat(ptr)
end

# helpers
@inline function get_cv_depth(::Type{T}) where {T<:Normed}
    return get_cv_depth(FixedPointNumbers.rawtype(T))
end
@inline get_cv_depth(::Type{UInt8}) = 0
@inline get_cv_depth(::Type{Int8}) = 1
@inline get_cv_depth(::Type{UInt16}) = 2
@inline get_cv_depth(::Type{Int16}) = 3
@inline get_cv_depth(::Type{Int32}) = 4
@inline get_cv_depth(::Type{Float32}) = 5
@inline get_cv_depth(::Type{Float64}) = 6
@inline get_cv_depth(::Type{Float16}) = 7
@inline get_cv_depth(::Type{T}) where {T} = throw(ArgumentError("Unsupported type: $T"))

end
