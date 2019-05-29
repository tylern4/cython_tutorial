cmake_minimum_required(VERSION 3.5)
## Change the project name and remove any language you don't need
project(my_project C CXX Fortran)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_MODULE_PATH
   ${CMAKE_MODULE_PATH}
   ${PROJECT_SOURCE_DIR}/cmake)

set(CMAKE_C_FLAGS "-Ofast")
set(CMAKE_CXX_FLAGS "-Ofast")
set(CMAKE_Fortran_FLAGS "-Ofast")

find_package(Cython REQUIRED)
find_package(PythonInterp REQUIRED)
find_package(PythonLibs REQUIRED)
find_package(PythonExtensions REQUIRED)
find_package(NumPy REQUIRED)

include_directories(${PROJECT_SOURCE_DIR})

## Add or remove c/cpp/f90 files that you need to the static library
add_library(my_project_static STATIC
  hello.cpp
  hello.f90
)

# Add the project as a cython target
add_cython_target(my_project my_project.pyx CXX PY3 OUTPUT_VAR _my_project)
# Include python and numpy
include_directories(${PYTHON_INCLUDE_DIRS} ${NumPy_INCLUDE_DIR})
# Add the library as a module for python to find
add_library(my_project MODULE ${_my_project})
python_extension_module(my_project)
# Add more 3rd party libraries that are needed to build your c/cpp/f90 files
target_link_libraries(my_project my_project_static ${PYTHON_LIBRARIES})

install(TARGETS my_project LIBRARY DESTINATION ${PROJECT_SOURCE_DIR})
