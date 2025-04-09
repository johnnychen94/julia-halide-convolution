function gradient2d(X::AbstractArray)
	return gradient2d!(copy(X))
end

function gradient2d!(X::AbstractArray)
	OT = eltype(X) <: C.HLTypes ? eltype(X) : Float64
	buf = convert(C.Buffer{OT, 2}, X)
	_gradient2d!(buf)
	X .= buf
	return X
end

function gradient2d!(X::Array{T}) where T <: C.HLTypes
	if ndims(X) != 2
		throw(ArgumentError("X must be a 2D array."))
	end

	_gradient2d!(convert(C.Buffer{T, 2}, X))
	return X
end

function _gradient2d!(out::C.Buffer{T}) where T <: C.HLTypes
	rst = __gradient2d!(out)
	if rst != 0
		throw(ArgumentError("Invalid input data."))
	end
	return out
end

@inline function __gradient2d!(out::C.Buffer{Float64})
	C.libconv.gradient2d_f64(out.ptr)
end

@inline function __gradient2d!(out::C.Buffer{Float32})
	C.libconv.gradient2d_f32(out.ptr)
end
