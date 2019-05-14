from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

sourcefiles = ["wave_propogation.pyx", "wp.cpp"]
extensions = [Extension("wave_propogation", sourcefiles, language="c++")]
setup(ext_modules=cythonize(extensions, language_level=3))
