cmake_minimum_required(VERSION 3.16)

option(TEMPLATE_PROJECT_ENABLE_CUDA "Enable CUDA support for the core package" OFF)
option(TEMPLATE_PROJECT_ENABLE_OPTIX "Enable OptiX support for the core package" OFF)
option(TEMPLATE_PROJECT_PROFILE_CORE "Enable profiler-friendly flags for the core package only" OFF)
option(TEMPLATE_PROJECT_WARNINGS_AS_ERRORS "Treat core package warnings as errors" OFF)
option(TEMPLATE_PROJECT_BUILD_EXAMPLES "Build core example executables" ON)
option(TEMPLATE_PROJECT_BUILD_BENCHMARKS "Build deterministic core benchmark executables" ON)
option(TEMPLATE_PROJECT_BUILD_PYTHON_WRAPPER "Build optional Python wrapper for the core library" OFF)
option(TEMPLATE_PROJECT_BUILD_MATLAB_WRAPPER "Build optional MATLAB wrapper for the core library" OFF)
option(BUILD_SHARED_LIBS "Build core libraries as shared libraries" ON)

if(DEFINED ENABLE_CUDA)
  set(TEMPLATE_PROJECT_ENABLE_CUDA "${ENABLE_CUDA}" CACHE BOOL "Enable CUDA support for the core package" FORCE)
endif()
if(DEFINED ENABLE_OPTIX)
  set(TEMPLATE_PROJECT_ENABLE_OPTIX "${ENABLE_OPTIX}" CACHE BOOL "Enable OptiX support for the core package" FORCE)
endif()
if(TEMPLATE_PROJECT_ENABLE_OPTIX)
  set(TEMPLATE_PROJECT_ENABLE_CUDA ON CACHE BOOL "Enable CUDA support for the core package" FORCE)
endif()

set(_template_project_core_languages CXX)
if(TEMPLATE_PROJECT_ENABLE_CUDA)
  list(APPEND _template_project_core_languages CUDA)
endif()

project(template_project_core VERSION 0.1.0 LANGUAGES ${_template_project_core_languages})

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "Build type" FORCE)
endif()
string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)

find_package(ament_cmake REQUIRED)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(LIB_NAMESPACE "${PROJECT_NAME}")
set(LIB_TARGET_NAME "${PROJECT_NAME}")
set(LIB_COMPILE_TARGET "${LIB_NAMESPACE}_lib_compile_interface")
set(CUDA_COMPILE_TARGET "${LIB_NAMESPACE}_cuda_compile_interface")
set(OPTIX_COMPILE_TARGET "${LIB_NAMESPACE}_optix_compile_interface")
set(SANITIZER_TARGET "${LIB_NAMESPACE}_sanitizer_target_interface")
set(PROFILING_COMPILE_TARGET "${LIB_NAMESPACE}_profiling_interface")

option(NO_OPTIMIZATION "Disable optimization flags" OFF)
option(SANITIZE_BUILD "Enable sanitizers in build" OFF)
set(SANITIZERS "address,undefined,leak" CACHE STRING "Sanitizers to enable when SANITIZE_BUILD is ON")
option(CPU_ENABLE_NATIVE_TUNING "Enable native CPU tuning for optimized native builds" ON)
option(CPU_ENABLE_FMA "Enable CPU FMA instructions" OFF)
option(CPU_ENABLE_SIMD "Enable explicit SIMD ISA flags" OFF)
set(CPU_SIMD_LEVEL "native" CACHE STRING "SIMD ISA when CPU_ENABLE_SIMD=ON")
set(CPU_EXTRA_OPT_FLAGS "" CACHE STRING "Extra CPU optimization flags")
option(CUDA_ENABLE_FMAD "Enable fused multiply-add contraction in NVCC" ON)
option(CUDA_ENABLE_EXTRA_DEVICE_VECTORIZATION "Enable NVCC extra device vectorization" OFF)
option(CUDA_USE_FAST_MATH "Enable NVCC fast math in regular CUDA compilation" OFF)
option(CUDA_PTX_USE_FAST_MATH "Enable NVCC fast math when compiling PTX kernels" ON)
set(CUDA_NVCC_EXTRA_FLAGS "" CACHE STRING "Extra flags passed to NVCC")

if(TEMPLATE_PROJECT_PROFILE_CORE)
  set(ENABLE_PROFILING ON CACHE BOOL "Enable profiling-friendly build flags and valgrind detection" FORCE)
  set(NO_OPTIMIZATION ON CACHE BOOL "Disable optimization flags" FORCE)
endif()

if(TEMPLATE_PROJECT_BUILD_PYTHON_WRAPPER OR TEMPLATE_PROJECT_BUILD_MATLAB_WRAPPER)
  message(FATAL_ERROR
    "Wrapper options are reserved for the core package, but the ROS2 wrapper "
    "integration is intentionally disabled in this starter scaffold. Port "
    "HandleWrapper.cmake and package metadata after the core ROS2 package "
    "contract is stable.")
endif()

include(HandleCompilerFlags)
include(HandleSanitizers)
include(HandleProfiling)
include(HandleCUDA)

handle_compiler_flags(CXX_STANDARD 20)
handle_sanitizers()
handle_profiling(TARGET ${PROFILING_COMPILE_TARGET})

add_library(${LIB_COMPILE_TARGET} INTERFACE)
target_compile_features(${LIB_COMPILE_TARGET} INTERFACE cxx_std_20)
if(TEMPLATE_PROJECT_WARNINGS_AS_ERRORS)
  target_compile_options(${LIB_COMPILE_TARGET} INTERFACE -Werror)
endif()

if(TEMPLATE_PROJECT_ENABLE_CUDA)
  handle_cuda(TARGET ${CUDA_COMPILE_TARGET} CUDA_TARGET ${CUDA_COMPILE_TARGET})
endif()

add_library(${PROJECT_NAME}
  src/CTemplateAlgorithm.cpp
)
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)

target_include_directories(${PROJECT_NAME}
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)
target_link_libraries(${PROJECT_NAME}
  PUBLIC
    ${LIB_COMPILE_TARGET}
)
target_link_libraries(${PROJECT_NAME}
  PRIVATE
    ${SANITIZER_TARGET}
)
if(TEMPLATE_PROJECT_PROFILE_CORE)
  target_link_libraries(${PROJECT_NAME} PRIVATE ${PROFILING_COMPILE_TARGET})
endif()
if(TEMPLATE_PROJECT_ENABLE_CUDA)
  target_link_libraries(${PROJECT_NAME} PUBLIC ${CUDA_COMPILE_TARGET})
endif()

if(TEMPLATE_PROJECT_BUILD_EXAMPLES)
  add_executable(template_project_core_example apps/template_project_core_example.cpp)
  target_link_libraries(template_project_core_example PRIVATE ${PROJECT_NAME}::${PROJECT_NAME})
endif()

if(TEMPLATE_PROJECT_BUILD_BENCHMARKS)
  add_executable(template_project_core_benchmark benchmarks/template_project_core_benchmark.cpp)
  target_link_libraries(template_project_core_benchmark PRIVATE ${PROJECT_NAME}::${PROJECT_NAME})
endif()

if(BUILD_TESTING)
  find_package(Catch2 3 REQUIRED)
  include(CTest)
  add_executable(test_template_algorithm test/testTemplateAlgorithm.cpp)
  target_link_libraries(test_template_algorithm PRIVATE ${PROJECT_NAME}::${PROJECT_NAME} Catch2::Catch2WithMain)
  add_test(NAME test_template_algorithm COMMAND test_template_algorithm)
endif()

install(DIRECTORY include/
  DESTINATION include
)

set(_template_project_core_install_targets
  ${PROJECT_NAME}
  ${LIB_COMPILE_TARGET}
  ${SANITIZER_TARGET}
)
if(TARGET ${PROFILING_COMPILE_TARGET})
  list(APPEND _template_project_core_install_targets ${PROFILING_COMPILE_TARGET})
endif()
if(TEMPLATE_PROJECT_ENABLE_CUDA AND TARGET ${CUDA_COMPILE_TARGET})
  list(APPEND _template_project_core_install_targets ${CUDA_COMPILE_TARGET})
endif()
if(TEMPLATE_PROJECT_BUILD_EXAMPLES)
  list(APPEND _template_project_core_install_targets template_project_core_example)
endif()
if(TEMPLATE_PROJECT_BUILD_BENCHMARKS)
  list(APPEND _template_project_core_install_targets template_project_core_benchmark)
endif()

install(
  TARGETS ${_template_project_core_install_targets}
  EXPORT ${PROJECT_NAME}Targets
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION lib/${PROJECT_NAME}
)

ament_export_include_directories(include)
ament_export_targets(${PROJECT_NAME}Targets HAS_LIBRARY_TARGET)
ament_package()
