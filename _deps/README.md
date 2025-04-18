# libconv (Halide)

## 依赖安装

基于 CMake 进行构建。

基于 pip 安装 Halide 依赖：

```console
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

## 高级配置

可以修改 `CMakePresets.json` 中的参数来调整编译选项。

| 参数 | 说明 | 默认值 |
| --- | --- | --- |
| `AOT_VERBOSE` | 是否在 AOT 编译阶段打印详细信息 | `OFF` |

## VSCode 配置

如果你不是使用 anaconda 提供的 Python 来安装 Halide 依赖，则需要手动配置 VSCode 的 `c_cpp_properties.json` 文件。

安装 `halide` 后找到 Halide 的目录，并添加到 `c_cpp_properties.json` 的 `includePath` 中，
从而确保编译器能够找到 Halide 的头文件和库文件。
