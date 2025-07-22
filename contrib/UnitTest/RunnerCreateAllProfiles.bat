          @echo off
          echo =========================================================
          echo     Welcome to the IccMAX Runner Profile Creation Script
          echo     Copyright (C) 2024-2025 David H Hoyt LLC
          echo     Author: David Hoyt  22-JULY-2025 1500Z
          echo =========================================================
          
          title IccMAX - Runner Profile Creation Script
          
          @echo on
          if exist D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe (
              echo Executable found.
          ) else (
              echo Executable not found. Exiting.
              goto end_Calc
          )
          
          if not "%1"=="clean" goto do_begin
          echo CLEANING!
          :do_begin
          
          cd Calc
          if not "%1"=="clean" goto do_Calc
          del /F/Q *.icc 2>NUL:
          goto end_Calc
          
          :do_Calc
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe CameraModel.xml CameraModel.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe ElevenChanKubelkaMunk.xml ElevenChanKubelkaMunk.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe RGBWProjector.xml RGBWProjector.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe argbCalc.xml argbCalc.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe srgbCalcTest.xml srgbCalcTest.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe srgbCalc++Test.xml srgbCalc++Test.icc
          @echo off
          REM calcImport.xml is not a standalone XML file
          REM calcVars.xml is not a standalone XML file
          :end_Calc
          
          cd ..\CalcTest
          if not "%1"=="clean" goto do_CalcTest
          REM cannot delete *.icc as many are non-XML test files
          REM del /F/Q *.icc 2>NUL:
          goto end_CalcTest
          :do_CalcTest
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe calcCheckInit.xml   calcCheckInit.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe calcExercizeOps.xml calcExercizeOps.icc
          @echo off
          :end_CalcTest
          
          cd ..\CMYK-3DLUTs
          if not "%1"=="clean" goto do_CMYK-3DLUTs
          del /F/Q *.icc 2>NUL:
          goto end_CMYK-3DLUTs
          :do_CMYK-3DLUTs
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe CMYK-3DLUTs.xml  CMYK-3DLUTs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe CMYK-3DLUTs2.xml CMYK-3DLUTs2.icc
          @echo off
          :end_CMYK-3DLUTs
          
          cd ..\Display
          if not "%1"=="clean" goto do_Display
          del /F/Q *.icc 2>NUL:
          goto end_Display
          :do_Display
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe GrayGSDF.xml GrayGSDF.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe LCDDisplay.xml LCDDisplay.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe LaserProjector.xml LaserProjector.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Rec2020rgbColorimetric.xml Rec2020rgbColorimetric.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Rec2020rgbSpectral.xml Rec2020rgbSpectral.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Rec2100HlgFull.xml Rec2100HlgFull.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Rec2100HlgNarrow.xml Rec2100HlgNarrow.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe RgbGSDF.xml RgbGSDF.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe sRGB_D65_MAT-300lx.xml sRGB_D65_MAT-300lx.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe sRGB_D65_MAT-500lx.xml sRGB_D65_MAT-500lx.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe sRGB_D65_MAT.xml       sRGB_D65_MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe sRGB_D65_colorimetric.xml sRGB_D65_colorimetric.icc
          @echo off
          :end_Display
          
          cd ..\Encoding
          if not "%1"=="clean" goto do_Encoding
          del /F/Q *.icc 2>NUL:
          goto end_Encoding
          :do_Encoding
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe ISO22028-Encoded-sRGB.xml ISO22028-Encoded-sRGB.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe ISO22028-Encoded-bg-sRGB.xml ISO22028-Encoded-bg-sRGB.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe sRgbEncoding.xml sRgbEncoding.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe sRgbEncodingOverrides.xml sRgbEncodingOverrides.icc
          @echo off
          :end_Encoding
          
          cd ..\HDR
          
          :: Cleanup mode - Deletes .icc files and exits
          if "%1"=="clean" (
              echo Cleaning HDR directory...
              del /F/Q *.icc 2>NUL:
              goto end_HDR
          )
          
          :do_HDR
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe BT2100HlgFullScene.xml BT2100HlgFullScene.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe BT2100HlgNarrowScene.xml BT2100HlgNarrowScene.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe BT2100HlgFullDisplay.xml BT2100HlgFullDisplay.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe BT2100HlgNarrowDisplay.xml BT2100HlgNarrowDisplay.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe BT2100PQFullScene.xml BT2100PQFullScene.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe BT2100PQNarrowScene.xml BT2100PQNarrowScene.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe BT2100PQFullDisplay.xml BT2100PQFullDisplay.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe BT2100PQNarrowDisplay.xml BT2100PQNarrowDisplay.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe BT2100HlgSceneToDisplayLink.xml BT2100HlgSceneToDisplayLink.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe BT2100PQSceneToDisplayLink.xml BT2100PQSceneToDisplayLink.icc
          @echo off
          
          :end_HDR
          
          cd ..\ICS
          if not "%1"=="clean" goto do_ICS
          del /F/Q *.icc 2>NUL:
          goto end_ICS
          :do_ICS
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Lab_float-D65_2deg-Part1.xml    Lab_float-D65_2deg-Part1.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Lab_float-IllumA_2deg-Part2.xml Lab_float-IllumA_2deg-Part2.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Lab_int-D65_2deg-Part1.xml      Lab_int-D65_2deg-Part1.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Lab_int-IllumA_2deg-Part2.xml   Lab_int-IllumA_2deg-Part2.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Rec2100HlgFull-Part1.xml Rec2100HlgFull-Part1.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Rec2100HlgFull-Part2.xml Rec2100HlgFull-Part2.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Rec2100HlgFull-Part3.xml Rec2100HlgFull-Part3.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D50_2deg-Part1.xml Spec400_10_700-D50_2deg-Part1.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D93_2deg-Part2.xml Spec400_10_700-D93_2deg-Part2.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe XYZ_float-D65_2deg-Part1.xml    XYZ_float-D65_2deg-Part1.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe XYZ_float-IllumA_2deg-Part2.xml XYZ_float-IllumA_2deg-Part2.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe XYZ_int-D65_2deg-Part1.xml      XYZ_int-D65_2deg-Part1.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe XYZ_int-IllumA_2deg-Part2.xml   XYZ_int-IllumA_2deg-Part2.icc
          @echo off
          :end_ICS
          
          cd ..\Named
          if not "%1"=="clean" goto do_Named
          del /F/Q *.icc 2>NUL:
          goto end_Named
          :do_Named
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe FluorescentNamedColor.xml FluorescentNamedColor.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe NamedColor.xml NamedColor.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe SparseMatrixNamedColor.xml SparseMatrixNamedColor.icc
          @echo off
          :end_Named
          
          cd ..\mcs
          if not "%1"=="clean" goto do_mcs
          del /F/Q *.icc 2>NUL:
          goto end_mcs
          :do_mcs
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe 17ChanWithSpots-MVIS.xml 17ChanWithSpots-MVIS.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe 18ChanWithSpots-MVIS.xml 18ChanWithSpots-MVIS.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe 6ChanSelect-MID.xml 6ChanSelect-MID.icc
          @echo off
          :end_mcs
          
          cd ..\Overprint
          if not "%1"=="clean" goto do_Overprint
          del /F/Q *.icc 2>NUL:
          goto end_Overprint
          :do_Overprint
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe 17ChanPart1.xml 17ChanPart1.icc
          @echo off
          :end_Overprint
          
          cd ..\mcs\Flexo-CMYKOGP
          if not "%1"=="clean" goto do_Flexo-CMYKOGP
          del /F/Q *.icc 2>NUL:
          goto end_Flexo-CMYKOGP
          :do_Flexo-CMYKOGP
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe 4ChanSelect-MID.xml 4ChanSelect-MID.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe 7ChanSelect-MID.xml 7ChanSelect-MID.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe CGYK-SelectMID.xml  CGYK-SelectMID.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe CMPK-SelectMID.xml  CMPK-SelectMID.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe CMYK-SelectMID.xml  CMYK-SelectMID.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe CMYKOGP-MVIS-Smooth.xml CMYKOGP-MVIS-Smooth.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe OMYK-SelectMID.xml  OMYK-SelectMID.icc
          @echo off
          :end_Flexo-CMYKOGP
          
          cd ..\..\PCC
          if not "%1"=="clean" goto do_PCC
          del /F/Q *.icc 2>NUL:
          goto end_PCC
          :do_PCC
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Lab_float-D50_2deg.xml Lab_float-D50_2deg.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Lab_float-D93_2deg-MAT.xml Lab_float-D93_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Lab_int-D50_2deg.xml Lab_int-D50_2deg.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Lab_int-D65_2deg-MAT.xml Lab_int-D65_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Lab_int-IllumA_2deg-MAT.xml Lab_int-IllumA_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec380_10_730-D50_2deg.xml Spec380_10_730-D50_2deg.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec380_10_730-D65_2deg-MAT.xml Spec380_10_730-D65_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec380_1_780-D50_2deg.xml Spec380_1_780-D50_2deg.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec380_5_780-D50_2deg.xml Spec380_5_780-D50_2deg.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-B_2deg-Abs.xml Spec400_10_700-B_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-B_2deg-CAM.xml Spec400_10_700-B_2deg-CAM.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-B_2deg-CAT02.xml Spec400_10_700-B_2deg-CAT02.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-B_2deg-MAT.xml Spec400_10_700-B_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D50_10deg-Abs.xml Spec400_10_700-D50_10deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D50_10deg-MAT.xml Spec400_10_700-D50_10deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D50_20yo2deg-MAT.xml Spec400_10_700-D50_20yo2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D50_2deg-Abs.xml Spec400_10_700-D50_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D50_2deg.xml Spec400_10_700-D50_2deg.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D50_40yo2deg-MAT.xml Spec400_10_700-D50_40yo2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D50_60yo2deg-MAT.xml Spec400_10_700-D50_60yo2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D50_80yo2deg-MAT.xml Spec400_10_700-D50_80yo2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D65_10deg-Abs.xml Spec400_10_700-D65_10deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D65_10deg-MAT.xml Spec400_10_700-D65_10deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D65_20yo2deg-MAT.xml Spec400_10_700-D65_20yo2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D65_2deg-Abs.xml Spec400_10_700-D65_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D65_2deg-MAT.xml Spec400_10_700-D65_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D65_40yo2deg-MAT.xml Spec400_10_700-D65_40yo2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D65_60yo2deg-MAT.xml Spec400_10_700-D65_60yo2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D65_80yo2deg-MAT.xml Spec400_10_700-D65_80yo2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D93_10deg-Abs.xml Spec400_10_700-D93_10deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D93_10deg-MAT.xml Spec400_10_700-D93_10deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D93_2deg-Abs.xml Spec400_10_700-D93_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-D93_2deg-MAT.xml Spec400_10_700-D93_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-DB_2deg-Abs.xml Spec400_10_700-DB_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-DB_2deg-CAT02.xml Spec400_10_700-DB_2deg-CAT02.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-DB_2deg-MAT.xml Spec400_10_700-DB_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-DG_2deg-Abs.xml Spec400_10_700-DG_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-DG_2deg-CAT02.xml Spec400_10_700-DG_2deg-CAT02.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-DG_2deg-MAT.xml Spec400_10_700-DG_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-DR_2deg-Abs.xml Spec400_10_700-DR_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-DR_2deg-CAT02.xml Spec400_10_700-DR_2deg-CAT02.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-DR_2deg-MAT.xml Spec400_10_700-DR_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-F11_2deg-CAT.xml Spec400_10_700-F11_2deg-CAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-F11_2deg-MAT.xml Spec400_10_700-F11_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-G_2deg-Abs.xml Spec400_10_700-G_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-G_2deg-CAT02.xml Spec400_10_700-G_2deg-CAT02.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-G_2deg-MAT.xml Spec400_10_700-G_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-IllumA_10deg-Abs.xml Spec400_10_700-IllumA_10deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-IllumA_10deg-MAT.xml Spec400_10_700-IllumA_10deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-IllumA_2deg-Abs.xml Spec400_10_700-IllumA_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-IllumA_2deg-CAT.xml Spec400_10_700-IllumA_2deg-CAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-IllumA_2deg-MAT.xml Spec400_10_700-IllumA_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-N_2deg-Abs.xml Spec400_10_700-N_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-N_2deg-CAT02.xml Spec400_10_700-N_2deg-CAT02.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-N_2deg-MAT.xml Spec400_10_700-N_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-R1_2deg-Abs.xml Spec400_10_700-R1_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-R1_2deg-CAT02.xml Spec400_10_700-R1_2deg-CAT02.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-R1_2deg-MAT.xml Spec400_10_700-R1_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-R2_2deg-Abs.xml Spec400_10_700-R2_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-R2_2deg-CAT02.xml Spec400_10_700-R2_2deg-CAT02.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-R2_2deg-MAT.xml Spec400_10_700-R2_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-Y_2deg-Abs.xml Spec400_10_700-Y_2deg-Abs.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-Y_2deg-CAT02.xml Spec400_10_700-Y_2deg-CAT02.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe Spec400_10_700-Y_2deg-MAT.xml Spec400_10_700-Y_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe XYZ_float-D50_2deg.xml XYZ_float-D50_2deg.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe XYZ_float-D65_2deg-MAT.xml XYZ_float-D65_2deg-MAT.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe XYZ_int-D50_2deg.xml XYZ_int-D50_2deg.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe XYZ_int-D65_2deg-MAT-Lvl2.xml XYZ_int-D65_2deg-MAT-Lvl2.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe XYZ_int-D65_2deg-MAT.xml XYZ_int-D65_2deg-MAT.icc
          @echo off
          :end_PCC
          
          cd ..\SpecRef
          if not "%1"=="clean" goto do_SpecRef
          del /F/Q *.icc 2>NUL:
          goto end_SpecRef
          :do_SpecRef
          @echo on
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe argbRef.xml argbRef.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe SixChanCameraRef.xml SixChanCameraRef.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe SixChanInputRef.xml  SixChanInputRef.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe srgbRef.xml srgbRef.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe RefDecC.xml RefDecC.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe RefDecH.xml RefDecH.icc
          D:\a\PatchIccMAX\PatchIccMAX\PatchIccMAX\Build\Cmake\build\Tools\IccFromXml\Release\iccFromXml.exe RefIncW.xml RefIncW.icc
          @echo off
          REM RefEstimationImport.xml is not a standalone XML file
          :end_SpecRef
          
          cd ..
