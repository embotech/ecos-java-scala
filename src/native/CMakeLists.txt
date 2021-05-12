################################################################
# All settings required by sbt-jni have been marked so, please #
# add/modify/remove settings to build your specific library.   #
################################################################

cmake_minimum_required(VERSION 3.0.0)

# Define project and related variables
# (required by sbt-jni) please use semantic versioning
#
project (ecos)
set(PROJECT_VERSION_MAJOR 0)
set(PROJECT_VERSION_MINOR 0)
set(PROJECT_VERSION_PATCH 1)

# Setup JNI
find_package(JNI REQUIRED)
if (JNI_FOUND)
    message (STATUS "JNI include directories: ${JNI_INCLUDE_DIRS}")
endif()

# Include directories
include_directories(.)
include_directories(include)
include_directories(../../external/SuiteSparse_config)
include_directories(../../external/ldl/include)
include_directories(../../ecos/external/amd/include)
include_directories(../../ecos/include)
include_directories(${JNI_INCLUDE_DIRS})

# Sources
file(GLOB LIB_SRC
  "../../external/ldl/src/ldl.c"
  "../../ecos/external/amd/src/*.c"
  "../../ecos/src/ecos.c"
  "../../ecos/src/kkt.c"
  "../../ecos/src/cone.c"
  "../../ecos/src/spla.c"
  "../../ecos/src/timer.c"
  "../../ecos/src/preproc.c"
  "../../ecos/src/splamm.c"
  "../../ecos/src/ctrlc.c"
  "../../ecos/src/equil.c"
  "../../ecos/src/expcone.c"
  "../../ecos/src/wright_omega.c"
  "*.c"
)

link_libraries("m")
add_compile_options("-Wall" "-DCTRLC=1" "-Wextra" "-DLDL_LONG" "-DDLONG")
add_link_options("-Wall" "-DCTRLC=1" "-Wextra" "-DLDL_LONG" "-DDLONG")

# Setup installation targets
# (required by sbt-jni) major version should always be appended to library name
#
set (LIB_NAME ${PROJECT_NAME}${PROJECT_VERSION_MAJOR})
add_library(${LIB_NAME} SHARED ${LIB_SRC})
install(TARGETS ${LIB_NAME} LIBRARY DESTINATION .)
