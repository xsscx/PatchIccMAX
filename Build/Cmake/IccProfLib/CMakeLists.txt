##################################################################################
## IccProfLib2 Project Configuration in Build/Cmake/CMakeLists.txt              ##
##################################################################################
# 
#
# Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
# 
#
# Last Updated: 18-MAR-2025 0936 EDT by David Hoyt
#
# Changes:  Lower Noise Level
#           Fixups for Iconv and Headers
#           PASS: Generators, Code Analysis & Insight, x64-MinSizeRel & x64-Debug
#						
# TODO: Refactor Debug, Release, Asan 
#       Housekeeping, Unix & Windows now Build from Cmake
#       Refactor Base Configs & logging to .mk's 
##################################################################################
## IccProfLib2 Project Configuration in Build/Cmake/CMakeLists.txt              ##
##################################################################################

# Define the target name
set(TARGET_NAME IccProfLib2)

# Ensure all symbols are exported on Windows for shared libraries
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

# Define the root source path
set(SRC_PATH ../../..)

# List all source files
set(CFILES
    ${SRC_PATH}/IccProfLib/IccApplyBPC.cpp
    ${SRC_PATH}/IccProfLib/IccArrayBasic.cpp
    ${SRC_PATH}/IccProfLib/IccArrayFactory.cpp
    ${SRC_PATH}/IccProfLib/IccCAM.cpp
    ${SRC_PATH}/IccProfLib/IccCmm.cpp
    ${SRC_PATH}/IccProfLib/IccConvertUTF.cpp
    ${SRC_PATH}/IccProfLib/IccEncoding.cpp
    ${SRC_PATH}/IccProfLib/IccEnvVar.cpp
    ${SRC_PATH}/IccProfLib/IccEval.cpp
    ${SRC_PATH}/IccProfLib/IccIO.cpp
    ${SRC_PATH}/IccProfLib/IccMatrixMath.cpp
    ${SRC_PATH}/IccProfLib/IccMpeACS.cpp
    ${SRC_PATH}/IccProfLib/IccMpeBasic.cpp
    ${SRC_PATH}/IccProfLib/IccMpeCalc.cpp
    ${SRC_PATH}/IccProfLib/IccMpeFactory.cpp
    ${SRC_PATH}/IccProfLib/IccMpeSpectral.cpp
    ${SRC_PATH}/IccProfLib/IccPrmg.cpp
    ${SRC_PATH}/IccProfLib/IccPcc.cpp
    ${SRC_PATH}/IccProfLib/IccProfile.cpp
    ${SRC_PATH}/IccProfLib/IccSolve.cpp
    ${SRC_PATH}/IccProfLib/IccSparseMatrix.cpp
    ${SRC_PATH}/IccProfLib/IccStructBasic.cpp
    ${SRC_PATH}/IccProfLib/IccStructFactory.cpp
    ${SRC_PATH}/IccProfLib/IccTagBasic.cpp
    ${SRC_PATH}/IccProfLib/IccTagComposite.cpp
    ${SRC_PATH}/IccProfLib/IccTagDict.cpp
    ${SRC_PATH}/IccProfLib/IccTagEmbedIcc.cpp
    ${SRC_PATH}/IccProfLib/IccTagFactory.cpp
    ${SRC_PATH}/IccProfLib/IccTagLut.cpp
    ${SRC_PATH}/IccProfLib/IccTagMPE.cpp
    ${SRC_PATH}/IccProfLib/IccTagProfSeqId.cpp
    ${SRC_PATH}/IccProfLib/IccUtil.cpp
    ${SRC_PATH}/IccProfLib/IccXformFactory.cpp
    ${SRC_PATH}/IccProfLib/IccMD5.cpp
)

# List public headers for installation
if (ENABLE_INSTALL_RIM)
    set(HEADERS_PUBLIC
        ${SRC_PATH}/IccProfLib/IccApplyBPC.h
        ${SRC_PATH}/IccProfLib/IccArrayBasic.h
        ${SRC_PATH}/IccProfLib/IccArrayFactory.h
        ${SRC_PATH}/IccProfLib/IccCAM.h
        ${SRC_PATH}/IccProfLib/IccCmm.h
        ${SRC_PATH}/IccProfLib/IccConvertUTF.h
        ${SRC_PATH}/IccProfLib/IccEncoding.h
        ${SRC_PATH}/IccProfLib/IccEnvVar.h
        ${SRC_PATH}/IccProfLib/IccEval.h
        ${SRC_PATH}/IccProfLib/IccIO.h
        ${SRC_PATH}/IccProfLib/IccMatrixMath.h
        ${SRC_PATH}/IccProfLib/IccMpeACS.h
        ${SRC_PATH}/IccProfLib/IccMpeBasic.h
        ${SRC_PATH}/IccProfLib/IccMpeCalc.h
        ${SRC_PATH}/IccProfLib/IccMpeFactory.h
        ${SRC_PATH}/IccProfLib/IccMpeSpectral.h
        ${SRC_PATH}/IccProfLib/IccPrmg.h
        ${SRC_PATH}/IccProfLib/IccPcc.h
        ${SRC_PATH}/IccProfLib/IccProfile.h
        ${SRC_PATH}/IccProfLib/IccSolve.h
        ${SRC_PATH}/IccProfLib/IccSparseMatrix.h
        ${SRC_PATH}/IccProfLib/IccStructBasic.h
        ${SRC_PATH}/IccProfLib/IccStructFactory.h
        ${SRC_PATH}/IccProfLib/IccTagBasic.h
        ${SRC_PATH}/IccProfLib/IccTagComposite.h
        ${SRC_PATH}/IccProfLib/IccTagDict.h
        ${SRC_PATH}/IccProfLib/IccTagEmbedIcc.h
        ${SRC_PATH}/IccProfLib/IccTagFactory.h
        ${SRC_PATH}/IccProfLib/IccTagLut.h
        ${SRC_PATH}/IccProfLib/IccTagMPE.h
        ${SRC_PATH}/IccProfLib/IccTagProfSeqId.h
        ${SRC_PATH}/IccProfLib/IccUtil.h
        ${SRC_PATH}/IccProfLib/IccWrapper.h
        ${SRC_PATH}/IccProfLib/IccXformFactory.h
    )
    install(FILES ${HEADERS_PUBLIC} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${TARGET_NAME})
endif()

# Add the sources to the library
set(SOURCES ${CFILES})

# Debug: Print sources list
message(STATUS "Configuring library: ${TARGET_NAME}")
# message(STATUS "Source files included in ${TARGET_NAME}:")
# foreach(SRC_FILE ${SOURCES})
#     message(STATUS "  -> ${SRC_FILE}")
# endforeach()

# Include platform-specific dependencies
if(APPLE)
    include_directories(/Developer/Headers/FlatCarbon)
    find_library(CARBON_LIBRARY Carbon)
    find_library(IOKIT_LIBRARY IOKit)
    mark_as_advanced(CARBON_LIBRARY IOKIT_LIBRARY)
    set(EXTRA_LIBS_CS ${CARBON_LIBRARY} ${IOKIT_LIBRARY})
elseif(WIN32)
    find_library(USER32_LIBRARY User32)
    find_library(GDI32_LIBRARY Gdi32)
    set(EXTRA_LIBS_CS ${USER32_LIBRARY} ${GDI32_LIBRARY})
elseif(UNIX AND NOT APPLE)
    find_package(Threads REQUIRED)
    set(EXTRA_LIBS_CS ${CMAKE_THREAD_LIBS_INIT})
endif()

# Check for vcpkg installation
if(DEFINED ENV{VCPKG_ROOT})
    set(VCPKG_INCLUDE_DIR "$ENV{VCPKG_ROOT}/installed/x64-windows/include")
    message(STATUS "Using vcpkg from: $ENV{VCPKG_ROOT}")
else()
    set(VCPKG_INCLUDE_DIR "")
    message(STATUS "vcpkg not found, falling back to system includes")
endif()

# Find required packages
find_package(Iconv REQUIRED)
find_package(LibXml2 REQUIRED)


# Build shared library (target creation should be inside the conditional, but properties are already set)
if (ENABLE_SHARED_LIBS)
    message(STATUS "Configuring SHARED library: ${TARGET_NAME}")
    
    add_library(${TARGET_NAME} SHARED ${SOURCES})

    set_target_properties(${TARGET_NAME} PROPERTIES
        VERSION ${${PROJECT_UP_NAME}_VERSION}
        SOVERSION ${${PROJECT_UP_NAME}_MAJOR_VERSION}
    )

# Ensure the target is defined before adding include directories
target_include_directories(IccProfLib2 PRIVATE
    "$ENV{VCPKG_ROOT}/installed/x64-windows/include"
    "$ENV{VCPKG_ROOT}/installed/x64-windows/include/libxml2"
    "$ENV{VCPKG_ROOT}/installed/x64-windows/include/libxml"
)

    message(STATUS "[DEBUG] Shared Library Output Properties:")
    message(STATUS "  RUNTIME: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
    message(STATUS "  LIBRARY: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
    message(STATUS "  ARCHIVE: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")

    target_link_libraries(${TARGET_NAME} ${EXTRA_LIBS} ${EXTRA_LIBS_CS})

    if (ENABLE_INSTALL_RIM)
        install(TARGETS ${TARGET_NAME}
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        )
        message(STATUS "Installed SHARED library: ${TARGET_NAME}")
    endif()
else()
    message(STATUS "SHARED library disabled (ENABLE_SHARED_LIBS is OFF)")
endif()

# Build static library
if(ENABLE_STATIC_LIBS)
    message(STATUS "Configuring STATIC library: ${TARGET_NAME}-static")
    
    add_library(${TARGET_NAME}-static STATIC ${SOURCES})
    
    target_include_directories(${TARGET_NAME}-static PRIVATE
        ${VCPKG_INCLUDE_DIR}
        /usr/include
        /usr/local/include
        /opt/homebrew/include
    )
    
    message(STATUS "[DEBUG] Static Library Output Properties:")
    message(STATUS "  RUNTIME: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
    message(STATUS "  LIBRARY: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
    message(STATUS "  ARCHIVE: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")

find_library(LIBICONV_LIBRARY NAMES iconv libiconv PATHS "${VCPKG_ROOT}/installed/x64-windows/lib")
find_path(LIBICONV_INCLUDE_DIR NAMES iconv.h PATHS "${VCPKG_ROOT}/installed/x64-windows/include")

if (LIBICONV_LIBRARY AND LIBICONV_INCLUDE_DIR)
    message(STATUS "Found libiconv: ${LIBICONV_LIBRARY}, includes at ${LIBICONV_INCLUDE_DIR}")
else()
    message(FATAL_ERROR "libiconv not found! Ensure vcpkg is installed correctly.")
endif()

target_include_directories(${TARGET_NAME} PRIVATE ${LIBICONV_INCLUDE_DIR})
# target_link_libraries(${TARGET_NAME} PRIVATE ${LIBICONV_LIBRARY})


    target_link_libraries(${TARGET_NAME}-static ${EXTRA_LIBS} ${EXTRA_LIBS_CS} Iconv::Iconv LibXml2::LibXml2)
    
    if(ENABLE_INSTALL_RIM)
        install(TARGETS ${TARGET_NAME}-static
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        )
        message(STATUS "Installed STATIC library: ${TARGET_NAME}-static")
    endif()
else()
    message(STATUS "STATIC library disabled (ENABLE_STATIC_LIBS is OFF)")
endif()

# Set the library name for other projects
if(ENABLE_SHARED_LIBS)
    set(TARGET_LIB ${TARGET_NAME})
    message(STATUS "[DEBUG] Using SHARED library target: ${TARGET_NAME}")
else()
    set(TARGET_LIB ${TARGET_NAME}-static)
    message(STATUS "[DEBUG] Using STATIC library target: ${TARGET_NAME}-static")
endif()
set(TARGET_LIB ${TARGET_LIB} PARENT_SCOPE)

message(STATUS "Added executable target: ${TARGET_NAME}")
message(STATUS "Using explicit absolute path for ICCPROFLIB_PATH: ${ICCPROFLIB_PATH}")
message(STATUS "Added linker options for library path.")
message(STATUS "")
