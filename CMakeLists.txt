cmake_minimum_required(VERSION 3.5)
project(wave_propogation CXX C Fortran)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_MODULE_PATH
   ${CMAKE_MODULE_PATH}
   ${PROJECT_SOURCE_DIR}/cmake)

set(CMAKE_CXX_FLAGS "-Ofast")
set(CMAKE_C_FLAGS "-Ofast")
set(CMAKE_Fortran_FLAGS "-Ofast")

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

add_subdirectory(cython)
add_subdirectory(cpp)
add_subdirectory(fortran)
