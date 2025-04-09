function conv1d(X::AbstractArray, Y::AbstractArray)
	out = similar(X, promote_type(eltype(X), eltype(Y)), _cal_conv_outsize(X, Y))
	return conv1d!(out, X, Y)
end

function conv1d!(out::AbstractArray, X::AbstractArray, Y::AbstractArray)
	dense_out = collect(out)
	conv1d!(dense_out, X, Y)
	out .= dense_out
	return out
end

function conv1d!(out::Array, X::AbstractArray, Y::AbstractArray)
	_cal_conv_outsize(X, Y) == length(out) || throw(ArgumentError("Output array size does not match the expected size."))
	if ndims(X) != 1 || ndims(Y) != 1
		throw(ArgumentError("Both X and Y must be 1D arrays."))
	end
	if length(X) < length(Y)
		return conv1d!(out, Y, X)
	end

	BT = C.Buffer{eltype(out), 1}
	_conv1d!(convert(BT, out), convert(BT, X), convert(BT, Y))

	# for dense array case, `out` and `convert(BT, out)` shares the same memory
	# so we can return `out` directly
	return out
end

function _cal_conv_outsize(X::AbstractArray{T}, K::AbstractArray{T}) where T <: C.HLTypes
	if ndims(X) != 1 || ndims(K) != 1
		throw(ArgumentError("Both X and K must be 1D arrays."))
	end

	return length(X) + length(K) - 1
end

function _conv1d!(out::C.Buffer{T}, X::C.Buffer{T}, K::C.Buffer{T}) where T <: C.HLTypes
	rst = __conv1d!(out, X, K)
	if rst != 0
		throw(ArgumentError("Invalid input data."))
	end
	return out
end

@inline function __conv1d!(out::C.Buffer{Float64}, X::C.Buffer{Float64}, K::C.Buffer{Float64})
	C.libconv.conv1d_f64(out.ptr, X.ptr, K.ptr)
end
@inline function __conv1d!(out::C.Buffer{Float32}, X::C.Buffer{Float32}, K::C.Buffer{Float32})
	C.libconv.conv1d_f32(out.ptr, X.ptr, K.ptr)
end
