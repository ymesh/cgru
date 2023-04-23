cmake_minimum_required ( VERSION 3.0.0 )
cmake_policy ( SET CMP0048 NEW )  # Allow VERSION specifier in project()

set ( CGRU_VERSION $ENV{CGRU_VERSION} )

project ( cgru VERSION ${CGRU_VERSION} LANGUAGES CXX )

set (PROJ_NAME cgru)
set (cgru_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set (cgru_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set (cgru_VERSION_PATCH ${PROJECT_VERSION_PATCH})

message ( STATUS "CMake version is ${CMAKE_VERSION}")
option ( VERBOSE "Print lots of messages while compiling" ON )

cmake_policy ( SET CMP0017 NEW )  # Prefer files from the CMake module directory when including from there.
cmake_policy ( SET CMP0025 NEW )  # Detect AppleClang for new CMake
#cmake_policy (SET CMP0046 OLD)  # Don't error on non-existent dependency in add_dependencies.
set ( CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE ) 
if ( NOT CMAKE_BUILD_TYPE )
  set ( CMAKE_BUILD_TYPE "Release" )
endif ()
if ( CMAKE_BUILD_TYPE STREQUAL "Debug" ) 
  set ( DEBUGMODE ON )
endif ()

option ( CMAKE_USE_FOLDERS "Use the FOLDER target property to organize targets into folders." ON)
mark_as_advanced ( CMAKE_USE_FOLDERS )
if ( CMAKE_USE_FOLDERS )
  set_property ( GLOBAL PROPERTY USE_FOLDERS ON )
endif ()
#include (GNUInstallDirs)

set ( CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" )
include ( platform )

set (CMAKE_BINARY_DIR "${CMAKE_BINARY_DIR}/${platform}")

message ( " * PROJ_NAME = " ${PROJ_NAME} )
message ( " * PPROJECT_VERSION = " ${PROJECT_VERSION} )
message ( " * CMAKE_INSTALL_PREFIX = " ${CMAKE_INSTALL_PREFIX} )
message ( " * CMAKE_BINARY_DIR = " ${CMAKE_BINARY_DIR} )

#message ( " * PROJECT_SOURCE_DIR = " ${PROJECT_SOURCE_DIR} )
#message ( " * CMAKE_MODULE_PATH = " ${CMAKE_MODULE_PATH} )
#message ( " * MAYA_CGRU_LOCATION = " $ENV{MAYA_CGRU_LOCATION} )

set ( MAYA_LOCATION $ENV{MAYA_LOCATION} )
set ( MAYA_VERSION $ENV{MAYA_VERSION} )

find_package ( Maya REQUIRED ) # REQUIRED

file ( GLOB_RECURSE src RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp" )
file ( GLOB_RECURSE inc RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h" )

#message ( "* src = " ${src})
#message ( "* inc = " ${inc})

include_directories ( ${MAYA_INCLUDE_DIR} )
link_directories ( ${MAYA_LIBRARY_DIRS} )

set ( MAYA_LIBS "-lFoundation -lOpenMaya -lOpenMayaFX -lOpenMayaAnim -lOpenMayaUI -lOpenMayaRender" )

add_library ( cgru MODULE ${src} ${inc} )

MAYA_SET_PLUGIN_PROPERTIES ( cgru )
set_target_properties ( cgru PROPERTIES OUTPUT_NAME "cgru_${MAYA_VERSION}-x64" )
target_link_libraries ( cgru ${MAYA_LIBS} )
# ${CMAKE_INSTALL_PREFIX} = ${ MAYA_CGRU_LOCATION}/mll
install (TARGETS cgru DESTINATION ${CMAKE_INSTALL_PREFIX})