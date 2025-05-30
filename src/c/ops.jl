"""
    conv1d(T, input::Ptr{CBuffer}, kernel::Ptr{CBuffer}, output::Ptr{CBuffer})::Int

Calculate the conv1d by calling the C backend generated by Halide.

The function will return an integer indicating the success or failure of
the operation. A return value of 0 indicates success, while a non-zero
value indicates failure.
"""
function conv1d end

for T in HLTypesList
  func_sym = "conv1d_$(_get_type_suffix(T))"
  @eval begin
    @inline function conv1d(
      ::Type{$T}, input::Ptr{CBuffer}, kernel::Ptr{CBuffer}, output::Ptr{CBuffer}
    )::Int
      func_ptr = dlsym(libconv_handler[], Symbol($(func_sym)))
      return ccall(
        func_ptr, Cint, (Ptr{CBuffer}, Ptr{CBuffer}, Ptr{CBuffer}), input, kernel, output
      )
    end
  end
end
