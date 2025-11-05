###############################################################
#
## Copyright (©) 2024-2025 David H Hoyt. All rights reserved.
##                 https://srd.cx
##
## Last Updated: 04-NOV-2025 1200Z by David Hoyt
#
## Intent: Cmake remote windows build
#
## TODO: 
#
#
#
#
#
#
#
#
#
###############################################################

git clone https://github.com/InternationalColorConsortium/iccDEV.git
cd iccDEV
vcpkg integrate install
vcpkg install
cmake --preset vs2022-x64 -B . -S Build/Cmake
cmake --build . -- /m /maxcpucount
$toolDirs = Get-ChildItem -Recurse -File -Include *.exe -Path .\Tools\ | ForEach-Object { Split-Path -Parent $_.FullName } | Sort-Object -Unique
$env:PATH = ($toolDirs -join ';') + ';' + $env:PATH
$env:PATH -split ';'
cd Testing
.\CreateAllProfiles.bat
.\RunTests.bat
cd CalcTest\
.\checkInvalidProfiles.bat
.\runtests.bat
cd ..\Display
.\RunProtoTests.bat
cd ..\HDR
.\mkprofiles.bat
cd ..\mcs\
.\updateprev.bat
.\updateprevWithBkgd.bat
cd ..\Overprint
.\RunTests.bat
cd ..
cd hybrid
.\BuildAndTest.bat
cd ..
cd ..
iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/research/contrib/UnitTest/windows-build-report.ps1").Content
