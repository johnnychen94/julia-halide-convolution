function calculate_conv_out_spec(X::AbstractArray{T}, K::AbstractArray{T}) where T <: C.HLTypes
	if ndims(X) != 1 || ndims(K) != 1
		throw(ArgumentError("Both X and K must be 1D arrays."))
	end

	return length(X) + length(K) - 1
end
