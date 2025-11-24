###############################################################
#
## Copyright (©) 2024-2025 David H Hoyt. All rights reserved.
##                 https://srd.cx
##
## Last Updated: 19-NOV-2025 1200Z by David Hoyt
#
## Intent: Cmake remote windows build
#
## TODO: 
#
#
#
# iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/re231/contrib/Build/cmake/pr210-remote-windows-build.ps1").Content
#
#
#
#
#
###############################################################

          git clone https://github.com/InternationalColorConsortium/iccDEV.git
          cd iccDEV
          git fetch origin pull/210/head:pr-210
          git checkout pr-210
          git branch
          git status
          Write-Host "========= Fetching Deps... ================`n"
          Start-BitsTransfer -Source "https://xss.cx/2025/11/vcpkg/vcpkg-exported-deps.zip" -Destination "deps.zip"
          Write-Host "========= Extracting Deps... ================`n"
          tar -xf deps.zip
          cd Build/Cmake
          Write-Host "========= Building... ================`n"  
          cmake  -B build -S . -DCMAKE_TOOLCHAIN_FILE="..\..\scripts\buildsystems\vcpkg.cmake" -DVCPKG_MANIFEST_MODE=OFF -DCMAKE_BUILD_TYPE=Debug  -Wno-dev
          cmake --build build -- /m /maxcpucount
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
