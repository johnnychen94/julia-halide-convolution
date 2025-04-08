module HLConv

module C
    include("cmodules/libconv.jl")
    include("cmodules/buffer.jl")

    using .LibBuffer
    export Buffer, unsafe_wrap_buffer
end

end # module
