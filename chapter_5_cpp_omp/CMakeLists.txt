cmake_minimum_required(VERSION 3.5)
project(wave_propogation C CXX)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_MODULE_PATH
   ${CMAKE_MODULE_PATH}
   ${PROJECT_SOURCE_DIR}/cmake)

set(CMAKE_C_FLAGS "-Ofast")
set(CMAKE_CXX_FLAGS "-Ofast")

find_package(Cython REQUIRED)
find_package(PythonInterp REQUIRED)
find_package(PythonLibs REQUIRED)
find_package(PythonExtensions REQUIRED)
find_package(NumPy REQUIRED)
if(APPLE)
      add_definitions(-D__APPLE__)
else()
    find_package(OpenMP REQUIRED)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()


include_directories(${PROJECT_SOURCE_DIR})


add_library(wave_propogation_static STATIC wp.cpp)

add_cython_target(wave_propogation wave_propogation.pyx CXX PY3 OUTPUT_VAR _wave_propogation)
include_directories(${PYTHON_INCLUDE_DIRS} ${NumPy_INCLUDE_DIR})
add_library(wave_propogation MODULE ${_wave_propogation})
python_extension_module(wave_propogation)
target_link_libraries(wave_propogation wave_propogation_static ${PYTHON_LIBRARIES})

install(TARGETS wave_propogation LIBRARY DESTINATION .)
