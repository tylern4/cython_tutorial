from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

sourcefiles = ["my_project.pyx"]
# Add more files to the list as needed 'function.c', 'another.pyx'

extensions = [Extension("my_project", sourcefiles, language="c++")]
setup(name="my_project", ext_modules=cythonize(extensions, language_level=3))
