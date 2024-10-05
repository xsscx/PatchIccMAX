@echo off

REM Determine the correct full path for iccFromXml_d.exe
set "icc_exe=%~dp0iccFromXml_d.exe"

REM Check if the executable exists
if not exist "%icc_exe%" (
    echo Error: %icc_exe% not found.
    exit /b 1
)

REM Normalize the first parameter to lower case
set "arg=%~1"
set "arg=%arg:clean=clean%"

if "%arg%"=="clean" goto clean_all

goto do_all

:clean_all
echo CLEANING!

REM Clean all relevant folders
call :clean_folder "Calc"
call :clean_folder "CalcTest"
call :clean_folder "CMYK-3DLUTs"
call :clean_folder "Display"
call :clean_folder "Encoding"
call :clean_folder "ICS"
call :clean_folder "Named"
call :clean_folder "mcs"
call :clean_folder "Overprint"
call :clean_folder "mcs\Flexo-CMYKOGP"
call :clean_folder "PCC"
call :clean_folder "SpecRef"

goto end

:do_all
REM Process all relevant files in Calc folder
cd Calc
%icc_exe% CameraModel.xml CameraModel.icc
%icc_exe% ElevenChanKubelkaMunk.xml ElevenChanKubelkaMunk.icc
%icc_exe% RGBWProjector.xml RGBWProjector.icc
%icc_exe% argbCalc.xml argbCalc.icc
%icc_exe% srgbCalcTest.xml srgbCalcTest.icc
%icc_exe% srgbCalc++Test.xml srgbCalc++Test.icc
cd ..

REM Process all relevant files in CalcTest folder
cd CalcTest
%icc_exe% calcCheckInit.xml calcCheckInit.icc
%icc_exe% calcExercizeOps.xml calcExercizeOps.icc
cd ..

REM Process all relevant files in CMYK-3DLUTs folder
cd CMYK-3DLUTs
%icc_exe% CMYK-3DLUTs.xml CMYK-3DLUTs.icc
%icc_exe% CMYK-3DLUTs2.xml CMYK-3DLUTs2.icc
cd ..

REM Process all relevant files in Display folder
cd Display
%icc_exe% GrayGSDF.xml GrayGSDF.icc
%icc_exe% LCDDisplay.xml LCDDisplay.icc
%icc_exe% LaserProjector.xml LaserProjector.icc
%icc_exe% Rec2020rgbColorimetric.xml Rec2020rgbColorimetric.icc
%icc_exe% Rec2020rgbSpectral.xml Rec2020rgbSpectral.icc
%icc_exe% Rec2100HlgFull.xml Rec2100HlgFull.icc
%icc_exe% Rec2100HlgNarrow.xml Rec2100HlgNarrow.icc
%icc_exe% RgbGSDF.xml RgbGSDF.icc
%icc_exe% sRGB_D65_MAT-300lx.xml sRGB_D65_MAT-300lx.icc
%icc_exe% sRGB_D65_MAT-500lx.xml sRGB_D65_MAT-500lx.icc
%icc_exe% sRGB_D65_MAT.xml sRGB_D65_MAT.icc
%icc_exe% sRGB_D65_colorimetric.xml sRGB_D65_colorimetric.icc
cd ..

REM Process all relevant files in Encoding folder
cd Encoding
%icc_exe% ISO22028-Encoded-sRGB.xml ISO22028-Encoded-sRGB.icc
%icc_exe% ISO22028-Encoded-bg-sRGB.xml ISO22028-Encoded-bg-sRGB.icc
%icc_exe% sRgbEncoding.xml sRgbEncoding.icc
%icc_exe% sRgbEncodingOverrides.xml sRgbEncodingOverrides.icc
cd ..

REM Process all relevant files in ICS folder
cd ICS
%icc_exe% Lab_float-D65_2deg-Part1.xml Lab_float-D65_2deg-Part1.icc
%icc_exe% Lab_float-IllumA_2deg-Part2.xml Lab_float-IllumA_2deg-Part2.icc
%icc_exe% Lab_int-D65_2deg-Part1.xml Lab_int-D65_2deg-Part1.icc
%icc_exe% Lab_int-IllumA_2deg-Part2.xml Lab_int-IllumA_2deg-Part2.icc
%icc_exe% Rec2100HlgFull-Part1.xml Rec2100HlgFull-Part1.icc
%icc_exe% Rec2100HlgFull-Part2.xml Rec2100HlgFull-Part2.icc
%icc_exe% Rec2100HlgFull-Part3.xml Rec2100HlgFull-Part3.icc
%icc_exe% Spec400_10_700-D50_2deg-Part1.xml Spec400_10_700-D50_2deg-Part1.icc
%icc_exe% Spec400_10_700-D93_2deg-Part2.xml Spec400_10_700-D93_2deg-Part2.icc
%icc_exe% XYZ_float-D65_2deg-Part1.xml XYZ_float-D65_2deg-Part1.icc
%icc_exe% XYZ_float-IllumA_2deg-Part2.xml XYZ_float-IllumA_2deg-Part2.icc
%icc_exe% XYZ_int-D65_2deg-Part1.xml XYZ_int-D65_2deg-Part1.icc
%icc_exe% XYZ_int-IllumA_2deg-Part2.xml XYZ_int-IllumA_2deg-Part2.icc
cd ..

REM Process all relevant files in Named folder
cd Named
%icc_exe% FluorescentNamedColor.xml FluorescentNamedColor.icc
%icc_exe% NamedColor.xml NamedColor.icc
%icc_exe% SparseMatrixNamedColor.xml SparseMatrixNamedColor.icc
cd ..

REM Process all relevant files in mcs folder
cd mcs
%icc_exe% 17ChanWithSpots-MVIS.xml 17ChanWithSpots-MVIS.icc
%icc_exe% 18ChanWithSpots-MVIS.xml 18ChanWithSpots-MVIS.icc
%icc_exe% 6ChanSelect-MID.xml 6ChanSelect-MID.icc
cd ..

REM Process all relevant files in Overprint folder
cd Overprint
%icc_exe% 17ChanPart1.xml 17ChanPart1.icc
cd ..

REM Process all relevant files in Flexo-CMYKOGP folder
cd mcs\Flexo-CMYKOGP
%icc_exe% 4ChanSelect-MID.xml 4ChanSelect-MID.icc
%icc_exe% 7ChanSelect-MID.xml 7ChanSelect-MID.icc
%icc_exe% CGYK-SelectMID.xml CGYK-SelectMID.icc
%icc_exe% CMPK-SelectMID.xml CMPK-SelectMID.icc
%icc_exe% CMYK-SelectMID.xml CMYK-SelectMID.icc
%icc_exe% CMYKOGP-MVIS-Smooth.xml CMYKOGP-MVIS-Smooth.icc
%icc_exe% OMYK-SelectMID.xml OMYK-SelectMID.icc
cd ..\..\

REM Process all relevant files in PCC folder
cd PCC
%icc_exe% Lab_float-D50_2deg.xml Lab_float-D50_2deg.icc
%icc_exe% Lab_float-D93_2deg-MAT.xml Lab_float-D93_2deg-MAT.icc
%icc_exe% Lab_int-D50_2deg.xml Lab_int-D50_2deg.icc
%icc_exe% Lab_int-D65_2deg-MAT.xml Lab_int-D65_2deg-MAT.icc
%icc_exe% Lab_int-IllumA_2deg-MAT.xml Lab_int-IllumA_2deg-MAT.icc
%icc_exe% Spec380_10_730-D50_2deg.xml Spec380_10_730-D50_2deg.icc
%icc_exe% Spec380_10_730-D65_2deg-MAT.xml Spec380_10_730-D65_2deg-MAT.icc
%icc_exe% Spec380_1_780-D50_2deg.xml Spec380_1_780-D50_2deg.icc
%icc_exe% Spec380_5_780-D50_2deg.xml Spec380_5_780-D50_2deg.icc
%icc_exe% Spec400_10_700-B_2deg-Abs.xml Spec400_10_700-B_2deg-Abs.icc
%icc_exe% Spec400_10_700-B_2deg-CAM.xml Spec400_10_700-B_2deg-CAM.icc
cd ..

REM Process all relevant files in SpecRef folder
cd SpecRef
%icc_exe% argbRef.xml argbRef.icc
%icc_exe% SixChanCameraRef.xml SixChanCameraRef.icc
%icc_exe% SixChanInputRef.xml SixChanInputRef.icc
%icc_exe% srgbRef.xml srgbRef.icc
%icc_exe% RefDecC.xml RefDecC.icc
%icc_exe% RefDecH.xml RefDecH.icc
%icc_exe% RefIncW.xml RefIncW.icc
cd ..

:end
@echo on
