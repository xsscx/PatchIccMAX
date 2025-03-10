##############################################################################
## Project Level IccProfLib2Project Configuration in Build/Cmake/CMakeLists.txt ##
##############################################################################
# 
# Top Level Configuration CMakeLists.txt | IccMAX Project
# Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
# 
#
# Last Updated: 10-MAR-2025 1326 EDT by David Hoyt
#
# Changes:  Modified Build/Cmake/CMakelists.txt and others
#           Added to CMakelists.txt: iccPngDump,DemoIccMAXCmm
#           Adjusted Cross Platform Build Args
#						
# TODO: Refactor Debug, Release, Asan 
#       Housekeeping, Unix & Windows now Build from Cmake
#       Refactor Base Configs & logging to .mk's 
##################################################################################
## Project Level IccrRofLb2 Project Configuration in Build/Cmake/CMakeLists.txt ##
##################################################################################


message(STATUS "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
message(STATUS "Entering IccProfLib2 in Project_Root/Build/CmakeIccProfLib/CMakeLists.txt ...................")
message(STATUS "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")


SET( TARGET_NAME IccProfLib2)

SET( SRC_PATH ../../.. )
SET( CFILES
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

IF(ENABLE_INSTALL_RIM)
  SET( HEADERS_PUBLIC
    ${SRC_PATH}/IccProfLib/IccApplyBPC.h
    ${SRC_PATH}/IccProfLib/IccArrayBasic.h
    ${SRC_PATH}/IccProfLib/IccArrayFactory.h
    ${SRC_PATH}/IccProfLib/IccCAM.h
    ${SRC_PATH}/IccProfLib/IccCmm.h
    ${SRC_PATH}/IccProfLib/IccConvertUTF.h
    ${SRC_PATH}/IccProfLib/IccDefs.h
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
    ${SRC_PATH}/IccProfLib/IccPcc.h
    ${SRC_PATH}/IccProfLib/IccPrmg.h
    ${SRC_PATH}/IccProfLib/IccProfile.h
    ${SRC_PATH}/IccProfLib/IccProfLibConf.h
    ${SRC_PATH}/IccProfLib/IccProfLibVer.h
    ${SRC_PATH}/IccProfLib/IccSolve.h
    ${SRC_PATH}/IccProfLib/IccSparseMatrix.h
    ${SRC_PATH}/IccProfLib/IccStructBasic.h
    ${SRC_PATH}/IccProfLib/IccStructFactory.h
    ${SRC_PATH}/IccProfLib/IccTagBasic.h
    ${SRC_PATH}/IccProfLib/IccTagComposite.h
    ${SRC_PATH}/IccProfLib/IccTagDict.h
    ${SRC_PATH}/IccProfLib/IccTagEmbedIcc.h
    ${SRC_PATH}/IccProfLib/IccTagFactory.h
    ${SRC_PATH}/IccProfLib/IccTag.h
    ${SRC_PATH}/IccProfLib/IccTagLut.h
    ${SRC_PATH}/IccProfLib/IccTagMPE.h
    ${SRC_PATH}/IccProfLib/IccTagProfSeqId.h
    ${SRC_PATH}/IccProfLib/IccUtil.h
    ${SRC_PATH}/IccProfLib/IccWrapper.h
    ${SRC_PATH}/IccProfLib/IccXformFactory.h
    ${SRC_PATH}/IccProfLib/icProfileHeader.h
  )
MESSAGE(STATUS "[ENTRY] Installing headers for: ${TARGET_NAME}")

INSTALL(FILES
    ${HEADERS_PUBLIC}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${TARGET_INCLUDE_FOLDER}/${TARGET_NAME}
)

MESSAGE(STATUS "Headers installed to: ${CMAKE_INSTALL_INCLUDEDIR}/${TARGET_INCLUDE_FOLDER}/${TARGET_NAME}")
MESSAGE(STATUS "[EXIT] Finished installing headers for: ${TARGET_NAME}")

ENDIF(ENABLE_INSTALL_RIM)

MESSAGE(STATUS "[ENTRY] Configuring libraries for: ${TARGET_NAME}")

SET(SOURCES ${CFILES})

IF(APPLE)
   MESSAGE(STATUS "Detected Apple system, setting up Carbon and IOKit dependencies...")
   INCLUDE_DIRECTORIES(/Developer/Headers/FlatCarbon)
   FIND_LIBRARY(CARBON_LIBRARY Carbon)
   FIND_LIBRARY(IOKIT_LIBRARY IOKit)
   MARK_AS_ADVANCED(CARBON_LIBRARY)
   MARK_AS_ADVANCED(IOKIT_LIBRARY)
   SET(EXTRA_LIBS_CS ${CARBON_LIBRARY} ${IOKIT_LIBRARY})
   MESSAGE(STATUS "Apple dependencies configured: ${EXTRA_LIBS_CS}")
ENDIF(APPLE)

IF(ENABLE_SHARED_LIBS)
  MESSAGE(STATUS "Creating shared library: ${TARGET_NAME}")
  ADD_LIBRARY(${TARGET_NAME} SHARED ${SOURCES})
  SET_TARGET_PROPERTIES(${TARGET_NAME}
    PROPERTIES VERSION ${${PROJECT_UP_NAME}_VERSION}
               SOVERSION ${${PROJECT_UP_NAME}_MAJOR_VERSION})
  
  TARGET_LINK_LIBRARIES(${TARGET_NAME} ${EXTRA_LIBS} ${EXTRA_LIBS_CS})
  
  IF(ENABLE_INSTALL_RIM)
    MESSAGE(STATUS "Installing shared library: ${TARGET_NAME}")
    INSTALL(TARGETS ${TARGET_NAME}
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
  ENDIF(ENABLE_INSTALL_RIM)
ENDIF(ENABLE_SHARED_LIBS)

IF(ENABLE_STATIC_LIBS)
  MESSAGE(STATUS "Creating static library: ${TARGET_NAME}-static")
  ADD_LIBRARY(${TARGET_NAME}-static STATIC ${SOURCES})
  TARGET_LINK_LIBRARIES(${TARGET_NAME}-static ${EXTRA_LIBS} ${EXTRA_LIBS_CS})

  IF(WIN32)
    ADD_CUSTOM_COMMAND(
      TARGET ${TARGET_NAME}-static POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy
        "$<TARGET_FILE:${TARGET_NAME}-static>"
        "${CMAKE_BINARY_DIR}/IccProfLib/Release/IccProfLib2.lib"
      COMMENT "Renaming IccProfLib2-static.lib to IccProfLib2.lib for Windows"
    )
  ENDIF()

  IF(ENABLE_INSTALL_RIM)
    MESSAGE(STATUS "Installing static library: ${TARGET_NAME}-static")
    INSTALL(TARGETS ${TARGET_NAME}-static
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
  ENDIF(ENABLE_INSTALL_RIM)
ENDIF(ENABLE_STATIC_LIBS)

IF(ENABLE_SHARED_LIBS)
  SET(TARGET_LIB ${TARGET_NAME})
ELSE(ENABLE_SHARED_LIBS)
  SET(TARGET_LIB ${TARGET_NAME}-static)
ENDIF(ENABLE_SHARED_LIBS)

SET(TARGET_LIB ${TARGET_LIB} PARENT_SCOPE)

MESSAGE(STATUS "Final library output:")
MESSAGE(STATUS "  Debug: ${CMAKE_BINARY_DIR}/bin/Debug/${TARGET_LIB}")
MESSAGE(STATUS "  Release: ${CMAKE_BINARY_DIR}/bin/Release/${TARGET_LIB}")
MESSAGE(STATUS "  RelWithDebInfo: ${CMAKE_BINARY_DIR}/bin/RelWithDebInfo/${TARGET_LIB}")
MESSAGE(STATUS "  MinSizeRel: ${CMAKE_BINARY_DIR}/bin/MinSizeRel/${TARGET_LIB}")

MESSAGE(STATUS "[EXIT] Finished configuring libraries for: ${TARGET_NAME}")

message(STATUS "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
message(STATUS "Exiting IccProfLib2 in Project_Root/Build/CmakeIccProfLib/CMakeLists.txt ....................")
message(STATUS "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

