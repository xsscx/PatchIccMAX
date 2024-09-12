#!/bin/sh
##
## Assumes "/tmp/test/.DemoIccMAX/Build/Tools/IccFromXml/iccFromXml" is somewhere on $PATH
## Command line option "clean" will remove ICCs only and not regenerate
##

if [ "$1" = "clean" ]
then
	echo CLEANING!
elif [ "$#" -ge 1 ]
then
	echo "Unknown command line options"
	exit 1
elif ! command -v /tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml   # print which executable is being used
then
	exit 1
fi

cd Calc
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml CameraModel.xml CameraModel.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml ElevenChanKubelkaMunk.xml ElevenChanKubelkaMunk.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml RGBWProjector.xml RGBWProjector.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml argbCalc.xml argbCalc.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml srgbCalcTest.xml srgbCalcTest.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml srgbCalc++Test.xml srgbCalc++Test.icc
	# calcImport.xml is not a standalone XML file
	# calcVars.xml is not a standalone XML file
	set -
fi

cd ../CalcTest
if [ "$1" != "clean" ]
then
	set -x
	# cannot delete *.icc as many are non-XML test files
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml calcCheckInit.xml   calcCheckInit.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml calcExercizeOps.xml calcExercizeOps.icc
	set -
fi

cd ../CMYK-3DLUTs
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml CMYK-3DLUTs.xml  CMYK-3DLUTs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml CMYK-3DLUTs2.xml CMYK-3DLUTs2.icc
	set -
fi

cd ../Display
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml GrayGSDF.xml GrayGSDF.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml LCDDisplay.xml LCDDisplay.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml LaserProjector.xml LaserProjector.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Rec2020rgbColorimetric.xml Rec2020rgbColorimetric.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Rec2020rgbSpectral.xml Rec2020rgbSpectral.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Rec2100HlgFull.xml Rec2100HlgFull.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Rec2100HlgNarrow.xml Rec2100HlgNarrow.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml RgbGSDF.xml RgbGSDF.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml sRGB_D65_MAT-300lx.xml sRGB_D65_MAT-300lx.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml sRGB_D65_MAT-500lx.xml sRGB_D65_MAT-500lx.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml sRGB_D65_MAT.xml       sRGB_D65_MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml sRGB_D65_colorimetric.xml sRGB_D65_colorimetric.icc
	set -
fi

cd ../Encoding
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml ISO22028-Encoded-sRGB.xml ISO22028-Encoded-sRGB.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml ISO22028-Encoded-bg-sRGB.xml ISO22028-Encoded-bg-sRGB.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml sRgbEncoding.xml sRgbEncoding.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml sRgbEncodingOverrides.xml sRgbEncodingOverrides.icc
	set -
fi

cd ../ICS
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Lab_float-D65_2deg-Part1.xml    Lab_float-D65_2deg-Part1.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Lab_float-IllumA_2deg-Part2.xml Lab_float-IllumA_2deg-Part2.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Lab_int-D65_2deg-Part1.xml      Lab_int-D65_2deg-Part1.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Lab_int-IllumA_2deg-Part2.xml   Lab_int-IllumA_2deg-Part2.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Rec2100HlgFull-Part1.xml Rec2100HlgFull-Part1.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Rec2100HlgFull-Part2.xml Rec2100HlgFull-Part2.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Rec2100HlgFull-Part3.xml Rec2100HlgFull-Part3.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_2deg-Part1.xml Spec400_10_700-D50_2deg-Part1.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D93_2deg-Part2.xml Spec400_10_700-D93_2deg-Part2.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml XYZ_float-D65_2deg-Part1.xml    XYZ_float-D65_2deg-Part1.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml XYZ_float-IllumA_2deg-Part2.xml XYZ_float-IllumA_2deg-Part2.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml XYZ_int-D65_2deg-Part1.xml      XYZ_int-D65_2deg-Part1.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml XYZ_int-IllumA_2deg-Part2.xml   XYZ_int-IllumA_2deg-Part2.icc
	set -
fi

cd ../Named
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml FluorescentNamedColor.xml FluorescentNamedColor.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml NamedColor.xml NamedColor.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml SparseMatrixNamedColor.xml SparseMatrixNamedColor.icc
	set -
fi

cd ../Overprint
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml 17ChanPart1.xml 17ChanPart1.icc
	set -
fi

cd ../mcs
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml 17ChanWithSpots-MVIS.xml 17ChanWithSpots-MVIS.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml 18ChanWithSpots-MVIS.xml 18ChanWithSpots-MVIS.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml 6ChanSelect-MID.xml 6ChanSelect-MID.icc
	set -
fi

cd Flexo-CMYKOGP
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml 4ChanSelect-MID.xml 4ChanSelect-MID.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml 7ChanSelect-MID.xml 7ChanSelect-MID.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml CGYK-SelectMID.xml  CGYK-SelectMID.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml CMPK-SelectMID.xml  CMPK-SelectMID.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml CMYK-SelectMID.xml  CMYK-SelectMID.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml CMYKOGP-MVIS-Smooth.xml CMYKOGP-MVIS-Smooth.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml OMYK-SelectMID.xml  OMYK-SelectMID.icc
	set -
fi
cd ..

cd ../PCC
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Lab_float-D50_2deg.xml Lab_float-D50_2deg.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Lab_float-D93_2deg-MAT.xml Lab_float-D93_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Lab_int-D50_2deg.xml Lab_int-D50_2deg.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Lab_int-D65_2deg-MAT.xml Lab_int-D65_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Lab_int-IllumA_2deg-MAT.xml Lab_int-IllumA_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec380_10_730-D50_2deg.xml Spec380_10_730-D50_2deg.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec380_10_730-D65_2deg-MAT.xml Spec380_10_730-D65_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec380_1_780-D50_2deg.xml Spec380_1_780-D50_2deg.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec380_5_780-D50_2deg.xml Spec380_5_780-D50_2deg.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-B_2deg-Abs.xml Spec400_10_700-B_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-B_2deg-CAM.xml Spec400_10_700-B_2deg-CAM.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-B_2deg-CAT02.xml Spec400_10_700-B_2deg-CAT02.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-B_2deg-MAT.xml Spec400_10_700-B_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_10deg-Abs.xml Spec400_10_700-D50_10deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_10deg-MAT.xml Spec400_10_700-D50_10deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_20yo2deg-MAT.xml Spec400_10_700-D50_20yo2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_2deg-Abs.xml Spec400_10_700-D50_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_2deg.xml Spec400_10_700-D50_2deg.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_40yo2deg-MAT.xml Spec400_10_700-D50_40yo2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_60yo2deg-MAT.xml Spec400_10_700-D50_60yo2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_80yo2deg-MAT.xml Spec400_10_700-D50_80yo2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_10deg-Abs.xml Spec400_10_700-D65_10deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_10deg-MAT.xml Spec400_10_700-D65_10deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_20yo2deg-MAT.xml Spec400_10_700-D65_20yo2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_2deg-Abs.xml Spec400_10_700-D65_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_2deg-MAT.xml Spec400_10_700-D65_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_40yo2deg-MAT.xml Spec400_10_700-D65_40yo2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_60yo2deg-MAT.xml Spec400_10_700-D65_60yo2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_80yo2deg-MAT.xml Spec400_10_700-D65_80yo2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D93_10deg-Abs.xml Spec400_10_700-D93_10deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D93_10deg-MAT.xml Spec400_10_700-D93_10deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D93_2deg-Abs.xml Spec400_10_700-D93_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D93_2deg-MAT.xml Spec400_10_700-D93_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DB_2deg-Abs.xml Spec400_10_700-DB_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DB_2deg-CAT02.xml Spec400_10_700-DB_2deg-CAT02.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DB_2deg-MAT.xml Spec400_10_700-DB_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DG_2deg-Abs.xml Spec400_10_700-DG_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DG_2deg-CAT02.xml Spec400_10_700-DG_2deg-CAT02.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DG_2deg-MAT.xml Spec400_10_700-DG_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DR_2deg-Abs.xml Spec400_10_700-DR_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DR_2deg-CAT02.xml Spec400_10_700-DR_2deg-CAT02.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DR_2deg-MAT.xml Spec400_10_700-DR_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-F11_2deg-CAT.xml Spec400_10_700-F11_2deg-CAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-F11_2deg-MAT.xml Spec400_10_700-F11_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-G_2deg-Abs.xml Spec400_10_700-G_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-G_2deg-CAT02.xml Spec400_10_700-G_2deg-CAT02.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-G_2deg-MAT.xml Spec400_10_700-G_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-IllumA_10deg-Abs.xml Spec400_10_700-IllumA_10deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-IllumA_10deg-MAT.xml Spec400_10_700-IllumA_10deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-IllumA_2deg-Abs.xml Spec400_10_700-IllumA_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-IllumA_2deg-CAT.xml Spec400_10_700-IllumA_2deg-CAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-IllumA_2deg-MAT.xml Spec400_10_700-IllumA_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-N_2deg-Abs.xml Spec400_10_700-N_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-N_2deg-CAT02.xml Spec400_10_700-N_2deg-CAT02.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-N_2deg-MAT.xml Spec400_10_700-N_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R1_2deg-Abs.xml Spec400_10_700-R1_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R1_2deg-CAT02.xml Spec400_10_700-R1_2deg-CAT02.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R1_2deg-MAT.xml Spec400_10_700-R1_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R2_2deg-Abs.xml Spec400_10_700-R2_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R2_2deg-CAT02.xml Spec400_10_700-R2_2deg-CAT02.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R2_2deg-MAT.xml Spec400_10_700-R2_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-Y_2deg-Abs.xml Spec400_10_700-Y_2deg-Abs.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-Y_2deg-CAT02.xml Spec400_10_700-Y_2deg-CAT02.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml Spec400_10_700-Y_2deg-MAT.xml Spec400_10_700-Y_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml XYZ_float-D50_2deg.xml XYZ_float-D50_2deg.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml XYZ_float-D65_2deg-MAT.xml XYZ_float-D65_2deg-MAT.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml XYZ_int-D50_2deg.xml XYZ_int-D50_2deg.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml XYZ_int-D65_2deg-MAT-Lvl2.xml XYZ_int-D65_2deg-MAT-Lvl2.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml XYZ_int-D65_2deg-MAT.xml XYZ_int-D65_2deg-MAT.icc
	set -
fi

cd ../SpecRef
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml argbRef.xml argbRef.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml SixChanCameraRef.xml SixChanCameraRef.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml SixChanInputRef.xml  SixChanInputRef.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml srgbRef.xml srgbRef.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml RefDecC.xml RefDecC.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml RefDecH.xml RefDecH.icc
	/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml RefIncW.xml RefIncW.icc
	# RefEstimationImport.xml is not a standalone XML file
	set -
fi
cd ..

# Count number of ICCs that exist to confirm
if [ "$1" != "clean" ]
then
	echo -n "Should be 207 ICC files: "
	find . -iname "*.icc" | wc -l
else
	echo -n "Should be 80 ICC files after a clean: "
	find . -iname "*.icc" | wc -l
fi