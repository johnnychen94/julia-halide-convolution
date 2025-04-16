# compile

```bash
LIBCONV_ROOT=$HOME/tongyuan/syslab/julia-halide-convolution

gcc -o gradient gradient.c -I$LIBCONV_ROOT/install/include -L$LIBCONV_ROOT/install/lib -lconv -lpthread

LD_LIBRARY_PATH=$LIBCONV_ROOT/install/lib ./gradient
```
