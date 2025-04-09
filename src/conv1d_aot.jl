function conv1d_aot(X::AbstractArray, Y::AbstractArray)
	out = similar(X, promote_type(eltype(X), eltype(Y)), calculate_conv_out_spec(X, Y))
	return conv1d_aot!(out, X, Y)
end

function conv1d_aot!(out::AbstractArray, X::AbstractArray, Y::AbstractArray)
	dense_out = collect(out)
	conv1d_aot!(dense_out, X, Y)
	out .= dense_out
	return out
end

function conv1d_aot!(out::Array, X::AbstractArray, Y::AbstractArray)
	calculate_conv_out_spec(X, Y) == length(out) || throw(ArgumentError("Output array size does not match the expected size."))
	if ndims(X) != 1 || ndims(Y) != 1
		throw(ArgumentError("Both X and Y must be 1D arrays."))
	end
	if length(X) < length(Y)
		return conv1d_aot!(out, Y, X)
	end

	BT = C.Buffer{eltype(out), 1}
	_conv1d_aot!(convert(BT, out), convert(BT, X), convert(BT, Y))

	# for dense array case, `out` and `convert(BT, out)` shares the same memory
	# so we can return `out` directly
	return out
end

function _conv1d_aot!(out::C.Buffer{T}, X::C.Buffer{T}, K::C.Buffer{T}) where T <: C.HLTypes
	rst = __conv1d_aot!(out, X, K)
	if rst != 0
		throw(ArgumentError("Invalid input data."))
	end
	return out
end

@inline function __conv1d_aot!(out::C.Buffer{Float64}, X::C.Buffer{Float64}, K::C.Buffer{Float64})
	C.libconv.conv1d_f64(out.ptr, X.ptr, K.ptr)
end
@inline function __conv1d_aot!(out::C.Buffer{Float32}, X::C.Buffer{Float32}, K::C.Buffer{Float32})
	C.libconv.conv1d_f32(out.ptr, X.ptr, K.ptr)
end
