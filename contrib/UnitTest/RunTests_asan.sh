#!/bin/sh
## Copyright (c) 2024-2025 David H Hoyt LLC. All rights reserved.
## Intent: Unit Test of RunTests.sh for Asan Builds
##
## Written by David Hoyt for ICC color.org & DemoIccMAX Project
## Date: 27-FEB-2025 2215 EST
##

if ! command -v ../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm   # print which executable is being used
then
        exit 1
fi

echo "==========================================================================="
echo "Test CalcElement Operations return of zero's indicates that something bad happened"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Calc/srgbCalcTest.txt 2 0 Calc/srgbCalcTest.icc 3 sRGB_v4_ICC_preference.icc 3

echo "==========================================================================="
echo "Test NamedColor"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 sRGB_v4_ICC_preference.icc 1

echo "==========================================================================="
echo "Test NamedColor with D93 2degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D93 10degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D65 2degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D65 10degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D65_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D50 2degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D50 10degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D50_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with Illuminant A 2degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-IllumA_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with Illuminant A 10degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-IllumA_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test Grayscale GSDF Display link profile with ambient luminance of 20cd/m^2"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Display/GrayTest.txt 3 0 -ENV:ambL 20 Display/GrayGSDF.icc 0

echo "==========================================================================="
echo "Test RGB GSDF Display link profile with ambient luminant of 30cd/m^2"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Display/RgbTest.txt 3 0 -ENV:ambL 30 Display/RgbGSDF.icc 0
