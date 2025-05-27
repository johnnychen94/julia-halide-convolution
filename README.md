# Julia Halide Convolution

This is a demo project that demonstrates how to write an operator in Halide and then utilize it in Julia.

## Performance

The purpose of this package is to provide a high-speed implementation of a convolution operator.
We use Halide because it's not an easy task to implement that in Julia: Julia's LoopVectorization
doesn't support the reduced dimension, and it doesn't support AOT compilation.

## conv1d

The benchmark time is in μs.

### Float64

| size | MATLAB | TyHalideConv |
|------|--------|------|
| 32  | 4.63   | 0.57 |
| 64  | 8.64   | 0.83 |
| 128 | 19.33  | 2.00 |
| 256 | 16.79  | 5.30 |
| 512 | 28.95  | 18.31 |
| 1024| 199.42 | 37.32 |
| 2048| 523.78 | 103.87 |
| 4001| 1238.98| 358.70 |
| 4096| 1368.78| 360.94 |
| 8001| 3097.98| 1141.08 |
| 8192| 3436.08| 1176.96 |

### Float32

| size  | MATLAB | TyHalideConv |
|------|--------|------|
| 32  | 0.95   | 0.51 |
| 64  | 1.43   | 0.71 |
| 128 | 3.11   | 1.47 |
| 256 | 14.45  | 4.55 |
| 512 | 15.87  | 14.98 |
| 1024| 57.98  | 32.47 |
| 2048| 216.72 | 83.09 |
| 4001| 606.48 | 277.81 |
| 4096| 745.98 | 272.62 |
| 8001| 1773.38| 827.30 |
| 8192| 1724.58| 868.16 |

### UInt8

| size | MATLAB | TyHalideConv |
|------|--------|------|
| 32  | 4.82   | 0.53 |
| 64  | 8.67   | 0.70 |
| 128 | 16.15  | 1.27 |
| 256 | 13.11  | 3.45 |
| 512 | 25.65  | 11.91 |
| 1024| 184.51 | 26.73 |
| 2048| 464.84 | 78.70 |
| 4001| 1115.47| 222.98 |
| 4096| 1112.17| 249.15 |
| 8001| 2443.07| 788.66 |
| 8192| 2577.77| 862.67 |

## MATLAB differences

This function is not strictly compatible with MATLAB's conv function.

### overflow

We don't handle overflow issues, and this is not a bug.

For example, `conv1d([1, 255], [1, 255])` will be `[1, 510, 65025]` but `conv1d(UInt8[1, 255], UInt8[1, 255])` will be `UInt8[1, 254, 1]`.

This is not a bug, because if you want to handle overflow, you can manually convert the inputs to `Int` or `Float64` types.
However, if we force the addition of this conversion, people who know the data won't overflow will lose the opportunity for a performance boost.


