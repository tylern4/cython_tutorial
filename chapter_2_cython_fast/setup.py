from distutils.core import setup
from Cython.Build import cythonize

from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

extensions = [Extension("wave_propogation", ["wave_propogation.pyx"], language="c++")]
setup(name="wave_propogation", ext_modules=cythonize(extensions, language_level=3))
