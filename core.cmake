# This file is designed to be included to get access to its functions.
# This is part of the cmake-meta repository.

# x86/x86_64; common hack.
set(SIZEOF_VOIDP ${CMAKE_SIZEOF_VOID_P})

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(PROCESSOR_ARCH "X86_64")
else()
  set(PROCESSOR_ARCH "x86")
endif()

# Plaform detection.
if(WIN32)
  if(NOT WINDOWS)
    set(WINDOWS TRUE)
    set(PLATFORM_STORAGE "windows")
  endif()
elseif(APPLE)
  set(APPLE TRUE)
  set(PLATFORM_STORAGE "apple")
elseif(UNIX AND NOT APPLE)
  if(CMAKE_SYSTEM_NAME MATCHES ".*Linux")
    set(LINUX TRUE)
    set(PLATFORM_STORAGE "linux")
  endif()
endif()

# I use this to forward it, update as needed.
# All projects in the chain should share this, as it keeps things sane.
list(APPEND CMAKE_PREFIX_PATH ${CMAKEMETA_CMAKE_PREFIX_PATH})
set(CMAKE_INSTALL_PREFIX ${CMAKEMETA_CMAKE_INSTALL_PREFIX})

# C++20 (for now)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(WINDOWS)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std:c++latest /experimental:module")
else()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++20")
endif()

# Used to generate a flat set.
macro(generate_flat_set project src listname name)
  string(TOUPPER ${name} UPPER)
  file(GLOB GENERATED_${UPPER}_INCLUDES
    ${src}/*.h
    ${src}/common/*.h
    ${src}/${PLATFORM_STORAGE}/*.h)
  file(GLOB GENERATED_${UPPER}_SOURCES
    ${src}/*.c
    ${src}/*/*.c
    ${src}/*.cc
    ${src}/*.cpp
    ${src}/common/*.cc
    ${src}/${PLATFORM_STORAGE}/*.cc)
  file(GLOB GENERATED_${UPPER}_MODULES
    ${src}/*.ixx
    ${src}/${PLATFORM_STORAGE}/*.ixx)
  source_group("${project}\\${name}\\include" FILES ${GENERATED_${UPPER}_INCLUDES})
  source_group("${project}\\${name}\\sources" FILES ${GENERATED_${UPPER}_SOURCES})
  source_group("${project}\\${name}\\modules" FILES ${GENERATED_${UPPER}_MODULES})
  list(APPEND ${listname}
    ${GENERATED_${UPPER}_INCLUDES}
    ${GENERATED_${UPPER}_SOURCES}
    ${GENERATED_${UPPER}_MODULES})
endmacro()

# Used to generate a set.
macro(generate_set project src listname name)
  string(TOUPPER ${name} UPPER)
  file(GLOB GENERATED_${UPPER}_INCLUDES
    ${src}/${name}/*.h
    ${src}/${name}/common/*.h
    ${src}/${name}/${PLATFORM_STORAGE}/*.h)
  file(GLOB GENERATED_${UPPER}_SOURCES
    ${src}/${name}/*.c
    ${src}/${name}/*/*.c
    ${src}/${name}/*.cc
    ${src}/${name}/*.cpp
    ${src}/${name}/common/*.cc
    ${src}/${name}/${PLATFORM_STORAGE}/*.cc)
  file(GLOB GENERATED_${UPPER}_MODULES
    ${src}/${name}/*.ixx
    ${src}/${name}/${PLATFORM_STORAGE}/*.ixx)
  source_group("${project}\\${name}\\include" FILES ${GENERATED_${UPPER}_INCLUDES})
  source_group("${project}\\${name}\\sources" FILES ${GENERATED_${UPPER}_SOURCES})
  source_group("${project}\\${name}\\modules" FILES ${GENERATED_${UPPER}_MODULES})
  list(APPEND ${listname}
    ${GENERATED_${UPPER}_INCLUDES}
    ${GENERATED_${UPPER}_SOURCES}
    ${GENERATED_${UPPER}_MODULES})
endmacro()

# Appends a source set of a given `name`, from a given `dir`, to `listname`.
# e.g. get_set("bookend", "lzma", SOURCES)
macro(get_set dir name listname)
  string(TOUPPER ${name} UPPER)
  get_directory_property(
    ${GENERATED_${UPPER}_INCLUDES}
    DIRECTORY "${dir}"
    DEFINITION ${GENERATED_${UPPER}_INCLUDES}
  )
  get_directory_property(
    ${GENERATED_${UPPER}_SOURCES}
    DIRECTORY "${dir}"
    DEFINITION ${GENERATED_${UPPER}_SOURCES}
  )
  get_directory_property(
    ${GENERATED_${UPPER}_MODULES}
    DIRECTORY "${dir}"
    DEFINITION ${GENERATED_${UPPER}_MODULES}
  )
  list(APPEND ${listname}
    ${GENERATED_${UPPER}_INCLUDES}
    ${GENERATED_${UPPER}_SOURCES}
    ${GENERATED_${UPPER}_MODULES})
endmacro()