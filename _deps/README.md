# libconv (Halide)

## 依赖安装

基于 CMake 进行构建。

基于 pip 安装 Halide 依赖：

```
pip install halide
```

## 构建

### Linux

下述命令会构建所需的动态库，并安装到 `dist` 目录下。

```
cmake --preset=linux-x64 -DCMAKE_INSTALL_PREFIX=$PWD/../dist
cmake --build build/linux-x64
cmake --install build/linux-x64
```

构建后的动态库可以直接被 Julia 加载，例如：

```julia
julia> using Libdl

julia> libconv = dlopen("dist/lib/libconv.so") # 动态库指针
Ptr{Nothing} @0x0000000015368e80

julia> dlsym(libconv, :conv1d_f64) # 函数指针
Ptr{Nothing} @0x00007a739a3e3819
```

### Windows

Windows 存在一些已知问题暂未解决
