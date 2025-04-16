function conv1d_f64(output::Ptr{CBuffer}, input::Ptr{CBuffer}, kernel::Ptr{CBuffer})
	ccall(
		dlsym(libconv_jit_handler[], :conv1d_f64),
		Cint,
		(Ptr{CBuffer}, Ptr{CBuffer}, Ptr{CBuffer}),
		output, input, kernel,
	)
end

function conv1d_f32(output::Ptr{CBuffer}, input::Ptr{CBuffer}, kernel::Ptr{CBuffer})
	ccall(
		dlsym(libconv_jit_handler[], :conv1d_f32),
		Cint,
		(Ptr{CBuffer}, Ptr{CBuffer}, Ptr{CBuffer}),
		output, input, kernel,
	)
end

function conv1d_f64_aot(input::Ptr{CBuffer}, kernel::Ptr{CBuffer}, output::Ptr{CBuffer})
	ccall(
		dlsym(libconv_aot_handler[], :conv1d_f64_aot_wrapper),
		Cint,
		(Ptr{CBuffer}, Ptr{CBuffer}, Ptr{CBuffer}),
		input, kernel, output,
	)
end

function conv1d_f32_aot(input::Ptr{CBuffer}, kernel::Ptr{CBuffer}, output::Ptr{CBuffer})
	ccall(
		dlsym(libconv_aot_handler[], :conv1d_f32_aot_wrapper),
		Cint,
		(Ptr{CBuffer}, Ptr{CBuffer}, Ptr{CBuffer}),
		input, kernel, output,
	)
end

function gradient2d_f64(output::Ptr{CBuffer})
	ccall(
		dlsym(libconv_jit_handler[], :gradient2d_f64),
		Cint,
		(Ptr{CBuffer},),
		output,
	)
end

function gradient2d_f32(output::Ptr{CBuffer})
	ccall(
		dlsym(libconv_jit_handler[], :gradient2d_f32),
		Cint,
		(Ptr{CBuffer},),
		output,
	)
end
