# libconv (Halide)

## 依赖安装

基于 CMake 进行构建。

基于 pip 安装 Halide 依赖：

```
pip install halide
```

## 构建

### Linux

下述命令会构建所需的动态库，并安装到 `install` 目录下。

```
cmake --preset=linux-x64 -DCMAKE_INSTALL_PREFIX=$PWD/../install
cmake --build build/linux-x64
cmake --install build/linux-x64
```

### Windows

Windows 存在一些已知问题暂未解决
