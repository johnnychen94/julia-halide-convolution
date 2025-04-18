using BenchmarkTools
using HLConv

struct TestRecord
	version::String
	size::Int
	eltype::String
	time::Float64
end

# 定义测试向量大小
sizes = [32, 64, 128, 256, 512, 1024, 2048, 4001, 4096, 8001, 8192]
results = TestRecord[]

# 执行基准测试
for n in sizes
	x = rand(Float32, n)
	h = rand(Float32, n)

	# 使用@btime测量卷积运算时间
	t = 1000 * 1000 * @belapsed HLConv.conv1d_aot($x, $h)
	push!(results, TestRecord("aot", n, "Float64", t))

	println("Vector size: $n, Time: $(t) μs")
end

# 保存结果
open("julia_conv_results.csv", "w") do f
	println(f, "version, size, eltype, time")
	for result in results
		println(f, "$(result.version), $(result.size), $(result.eltype), $(result.time)")
	end
end
