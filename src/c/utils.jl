function _get_n_suffix(n::Int)::Symbol
  if n == 1
    return Symbol("1d")
  elseif n == 2
    return Symbol("2d")
  else
    error("Unsupported number of dimensions: $n")
  end
end

function _get_type_suffix(::Type{T})::Symbol where {T}
  if T == Float64
    return Symbol("f64")
  elseif T == Float32
    return Symbol("f32")
  elseif T == UInt8
    return Symbol("u8")
  elseif T == UInt16
    return Symbol("u16")
  elseif T == UInt32
    return Symbol("u32")
  elseif T == UInt64
    return Symbol("u64")
  elseif T == Int8
    return Symbol("i8")
  elseif T == Int16
    return Symbol("i16")
  elseif T == Int32
    return Symbol("i32")
  elseif T == Int64
    return Symbol("i64")
  else
    error("Unsupported type: $T")
  end
end
