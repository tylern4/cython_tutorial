## Using Fortran

This example is for someone who is either given Fortran code or knows Fortran and wants to integrate it with python.

We write the function in Fortran and then returning the answer to python allowing us to plot it or use it as a calculation for anther python function.

## Building and using cython modules
To build using CMake:
```bash
mkdir build
cd build
cmake ..
make
```

To use module the shared library which is built (`wave_propogation.cpython-{PYVER}-{PLATROM}.so`) it should either be in your current directory, or in a directory accessible by your `$PYTHON_PATH`. It can also be in a sub folder such as build by using `.`'s in place of `/`.
