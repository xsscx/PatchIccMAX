# 
# IccProfLib2 Configuration CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 04-DEC-2024 by David Hoyt
#
#
#
#
#
#
#
#

message(STATUS "#######################################################################")
message(STATUS "## Configuring the IccProfLib2 in Build/Cmake/IccProfLib/CMakelists.txt")

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

# Platform-specific settings for macOS
if (APPLE)
    include_directories(/Developer/Headers/FlatCarbon)
    find_library(CARBON_LIBRARY Carbon)
    find_library(IOKIT_LIBRARY IOKit)
    mark_as_advanced(CARBON_LIBRARY IOKIT_LIBRARY)
    set(EXTRA_LIBS_CS ${CARBON_LIBRARY} ${IOKIT_LIBRARY})
endif()

# Build shared library
if (ENABLE_SHARED_LIBS)
    add_library(${TARGET_NAME} SHARED ${SOURCES})
    set_target_properties(${TARGET_NAME}
        PROPERTIES VERSION ${${PROJECT_UP_NAME}_VERSION}
                   SOVERSION ${${PROJECT_UP_NAME}_MAJOR_VERSION}
    )
    target_link_libraries(${TARGET_NAME} ${EXTRA_LIBS} ${EXTRA_LIBS_CS})
    if (ENABLE_INSTALL_RIM)
        install(TARGETS ${TARGET_NAME}
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        )
    endif()
endif()

# Build static library
if (ENABLE_STATIC_LIBS)
    add_library(${TARGET_NAME}-static STATIC ${SOURCES})
    target_link_libraries(${TARGET_NAME}-static ${EXTRA_LIBS} ${EXTRA_LIBS_CS})
    if (ENABLE_INSTALL_RIM)
        install(TARGETS ${TARGET_NAME}-static
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        )
    endif()
endif()

# Set the library name for other projects
if (ENABLE_SHARED_LIBS)
    set(TARGET_LIB ${TARGET_NAME})
else()
    set(TARGET_LIB ${TARGET_NAME}-static)
endif()
set(TARGET_LIB ${TARGET_LIB} PARENT_SCOPE)

message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")
message(STATUS "CMAKE_SOURCE_DIR resolved as: ${CMAKE_SOURCE_DIR}")
message(STATUS "SRC_PATH resolved as: ${SRC_PATH}")
message(STATUS "Resolved source file paths:")
string(REPLACE ";" "\n" SOURCES_PRETTY_PRINTED "${SOURCES}")
foreach(SOURCE_FILE IN LISTS SOURCES)
    message(STATUS "  ${SOURCE_FILE}")
endforeach()


message(STATUS "Added executable target: ${TARGET_NAME}")
message(STATUS "Using explicit absolute path for ICCPROFLIB_PATH: ${ICCPROFLIB_PATH}")
message(STATUS "Added linker options for library path.")

message(STATUS "## Exiting the IccProfLib2 Project in Build/Cmake/IccProfLib/CMakelists.txt")
message(STATUS "###########################################################################")
