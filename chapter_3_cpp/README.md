## Using C++

This example is for someone who is either given C++ code or knows C++ and wants to integrate it with python.

We write the function in C++ and then returning the answer to python allowing us to plot it or use it as a calculation for anther python function.

## Building and using cython modules

In each folder there are setup.py and CMake build scripts to build the example.

I recommend using cmake to build with C++ because a lot of 3rd party C++ libraries support cmake allowing you to more easily incorporate 3rd party tools. 

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
