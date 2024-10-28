# Set up source path and target name
SET( SRC_PATH ../../../.. )
SET( SOURCES  ${SRC_PATH}/Tools/wxWidget/wxProfileDump/wxProfileDump.cpp )
SET( TARGET_NAME iccDumpProfileGui )

# Set the wxWidgets configuration
SET(wxWidgets_CONFIGURATION mswu)

# Add the wxProfileDump executable
ADD_EXECUTABLE( ${TARGET_NAME} ${SOURCES} )

# Handle platform-specific adjustments
if(WIN32)
  # On Windows, link against the pre-built IccProfLib
  SET(ICCPROFLIB_PATH ${CMAKE_SOURCE_DIR}/../../IccProfLib/x64/Debug)

  # Add include directories specific to wxWidgets and IccProfLib on Windows
  include_directories(
    ${CMAKE_SOURCE_DIR}/WXWidgets/wxWidgets-3.2.0/include
    ${CMAKE_SOURCE_DIR}/WXWidgets/wxWidgets-3.2.0/lib/x64/vc_lib/mswd
    ${CMAKE_SOURCE_DIR}/../../IccProfLib
  )

  # Link against pre-built IccProfLib and wxWidgets on Windows
  target_link_libraries(${TARGET_NAME}
    ${ICCPROFLIB_PATH}/IccProfLib.lib  # Pre-built IccProfLib
    ${wxWidgets_LIBRARIES}             # wxWidgets libraries
    kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib
    shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib
  )
else()
  # For non-Windows systems, link normally
  TARGET_LINK_LIBRARIES(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB} ${wxWidgets_LIBRARIES})
endif()

# Optional installation
IF(ENABLE_INSTALL_RIM)
  INSTALL(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
ENDIF()
