###############################################################
#
## Copyright (©) 2024-2025 David H Hoyt. All rights reserved.
##                 https://srd.cx
##
## Last Updated: 19-NOV-2025 1200Z by David Hoyt
#
## Intent: Cmake remote windows build Asan
#
## TODO: 
#
#
#
# iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/re231/contrib/Build/cmake/remote-windows-asan-build.ps1").Content
#
#
#
#
#
###############################################################
          Write-Host "========= Building pr180 branch ================`n"
          git clone https://github.com/InternationalColorConsortium/iccDEV.git
          cd iccDEV
          git branch
          git status
          Write-Host "========= Fetching Deps... ================`n"
          Start-BitsTransfer -Source "https://xss.cx/2025/11/vcpkg/vcpkg-exported-deps.zip" -Destination "deps.zip"
          Write-Host "========= Extracting Deps... ================`n"
          tar -xf deps.zip
          cd Build/Cmake
          Write-Host "========= Building... ================`n"  
          cmake -S . -B build -G "Visual Studio 17 2022" -A x64 -DCMAKE_TOOLCHAIN_FILE="..\..\scripts\buildsystems\vcpkg.cmake" -DVCPKG_MANIFEST_MODE=OFF -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS="/MD /Zi /fsanitize=address" -DCMAKE_CXX_FLAGS="/MD /Zi /fsanitize=address" -DCMAKE_EXE_LINKER_FLAGS_INIT="/DEBUG:FULL /INCREMENTAL:NO" -DCMAKE_SHARED_LINKER_FLAGS_INIT="/DEBUG:FULL /INCREMENTAL:NO" -Wno-dev
          cmake --build build -- /m /maxcpucount
          $env:PATH = "$env:PATH;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64"
          $exeDirs = Get-ChildItem -Recurse -File -Include *.exe -Path .\build\ |
              Where-Object { $_.FullName -match 'iccdev' -and $_.FullName -notmatch '\\CMakeFiles\\' -and $_.Name -notmatch '^CMake(C|CXX)CompilerId\.exe$' } |
              ForEach-Object { Split-Path $_.FullName -Parent } |
              Sort-Object -Unique
          $env:PATH = ($exeDirs -join ';') + ';' + $env:PATH
          $env:PATH -split ';' | Select-String "icc"
          $toolDirs = Get-ChildItem -Recurse -File -Include *.exe -Path .\Tools\ | ForEach-Object { Split-Path -Parent $_.FullName } | Sort-Object -Unique
          $env:PATH = ($toolDirs -join ';') + ';' + $env:PATH
          $env:PATH -split ';'
          pwd
          cd ..\..\Testing
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
          pwd

          # Collect .icc profile information
          $profiles = Get-ChildItem -Path . -Filter "*.icc" -Recurse -File
          $totalCount = $profiles.Count
          
          # Group profiles by directory
          $groupedProfiles = $profiles | Group-Object { $_.Directory.FullName }
          
          # Generate Summary Report
          Write-Host "`n========================="
          Write-Host " ICC Profile Report"
          Write-Host "========================="
          
          # Print count per subdirectory
          foreach ($group in $groupedProfiles) {
              Write-Host ("{0}: {1} .icc profiles" -f $group.Name, $group.Count)
          }
          
          Write-Host "`nTotal .icc profiles found: $totalCount"
          Write-Host "=========================`n"
          
          Write-Host "All Done!"



