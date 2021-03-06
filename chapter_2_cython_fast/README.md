## More Speedup

By adding simple type annotations like `cdef int` and `cdef float` we can start to get some improvement in speed. More improvement comes when using C style arrays and turning off some pythonic features with the function decorators.

## Building and using cython modules

In each folder there are setup.py and CMake build scripts to build the example.

To build using setup.py:
```bash
python setup.py build_ext --inplace
```

To build using CMake:
```bash
mkdir build
cd build
cmake ..
make
```

To use module the shared library which is built (`wave_propogation.cpython-{PYVER}-{PLATROM}.so`) it should either be in your current directory, or in a directory accessible by your `$PYTHON_PATH`. It can also be in a sub folder such as build by using `.`'s in place of `/`.

```python
import build.wave_propogation as wave_propogation
```
