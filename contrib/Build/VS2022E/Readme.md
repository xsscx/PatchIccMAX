# Visual Studio 2022 Enterprise Build Instructions

## Requirements
- Windows 11
- VS2022
- Git for Windows
  
### Automated Windows & Profile Build

- Dynamic Link

```
iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/build_revert_master_branch_release.ps1").Content
```

- Static Link

```
iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022E/static_build_cli_production.ps1").Content
```

## Expected Output

```
 iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022E/remote-static.ps1").Content
============================= Starting DemoIccMAX Static Branch Build =============================
Copyright (c) 2024 The International Color Consortium. All rights reserved.
Author: David Hoyt dhoyt@hoyt.net
Creating 'testing' directory...
    Directory: C:\
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        10/29/2024   8:48 PM                testing
Cloning the vcpkg repository...
Cloning into 'vcpkg'...
remote: Enumerating objects: 252001, done.
remote: Counting objects: 100% (66940/66940), done.
remote: Compressing objects: 100% (6513/6513), done.
remote: Total 252001 (delta 62291), reused 60615 (delta 60426), pack-reused 185061 (from 1)
Receiving objects: 100% (252001/252001), 76.36 MiB | 12.25 MiB/s, done.
Resolving deltas: 100% (168021/168021), done.
Updating files: 100% (11760/11760), done.
Bootstrapping vcpkg...
Downloading https://github.com/microsoft/vcpkg-tool/releases/download/2024-10-18/vcpkg.exe -> C:\testing\vcpkg\vcpkg.exe... done.
Validating signature... done.
...
Integrating vcpkg with Visual Studio...
warning: The vcpkg C:\testing\vcpkg\vcpkg.exe is using detected vcpkg root C:\testing\vcpkg and ignoring mismatched VCPKG_ROOT environment value C:\Program Files\Microsoft Visual Studio\2022\Community\VC\vcpkg. To suppress this message, unset the environment variable or use the --vcpkg-root command line switch.
Applied user-wide integration for this vcpkg root.
CMake projects should use: "-DCMAKE_TOOLCHAIN_FILE=C:/testing/vcpkg/scripts/buildsystems/vcpkg.cmake"
...
All MSBuild C++ projects can now #include any installed libraries. Linking will be handled automatically. Installing new libraries will make them instantly available.
Installing necessary libraries: libxml2, tiff, wxwidgets (static and dynamic)...
warning: The vcpkg C:\testing\vcpkg\vcpkg.exe is using detected vcpkg root C:\testing\vcpkg and ignoring mismatched VCPKG_ROOT environment value C:\Program Files\Microsoft Visual Studio\2022\Community\VC\vcpkg. To suppress this message, unset the environment variable or use the --vcpkg-root command line switch.
Computing installation plan...
A suitable version of cmake was not found (required v3.30.1).
Downloading https://github.com/Kitware/CMake/releases/download/v3.30.1/cmake-3.30.1-windows-i386.zip
Extracting cmake...
A suitable version of 7zip was not found (required v24.8.0).
Downloading https://github.com/ip7z/7zip/releases/download/24.08/7z2408-extra.7z
Extracting 7zip...
A suitable version of 7zr was not found (required v24.8.0).
Downloading https://github.com/ip7z/7zip/releases/download/24.08/7zr.exe
The following packages will be built and installed:
  * egl-registry:x64-windows@2024-01-25
  * egl-registry:x64-windows-static@2024-01-25
  * expat:x64-windows@2.6.3
  * expat:x64-windows-static@2.6.3
  * libiconv:x64-windows@1.17#4
  * libiconv:x64-windows-static@1.17#4
  * libjpeg-turbo:x64-windows@3.0.4
  * libjpeg-turbo:x64-windows-static@3.0.4
  * liblzma:x64-windows@5.6.3
  * liblzma:x64-windows-static@5.6.3
  * libpng:x64-windows@1.6.43#3
  * libpng:x64-windows-static@1.6.43#3
    libxml2[core,iconv,lzma,zlib]:x64-windows@2.11.9
    libxml2[core,iconv,lzma,zlib]:x64-windows-static@2.11.9
  * nanosvg:x64-windows@2023-12-29
  * nanosvg:x64-windows-static@2023-12-29
  * opengl:x64-windows@2022-12-04#3
  * opengl:x64-windows-static@2022-12-04#3
  * opengl-registry:x64-windows@2024-02-10#1
  * opengl-registry:x64-windows-static@2024-02-10#1
  * pcre2[core,jit,platform-default-features]:x64-windows@10.43
  * pcre2[core,jit,platform-default-features]:x64-windows-static@10.43
    tiff[core,jpeg,lzma,zip]:x64-windows@4.7.0
    tiff[core,jpeg,lzma,zip]:x64-windows-static@4.7.0
  * vcpkg-cmake:x64-windows@2024-04-23
  * vcpkg-cmake-config:x64-windows@2024-05-23
    wxwidgets[core,debug-support,sound]:x64-windows@3.2.6
    wxwidgets[core,debug-support,sound]:x64-windows-static@3.2.6
  * zlib:x64-windows@1.3.1
  * zlib:x64-windows-static@1.3.1
Additional packages (*) will be modified to complete this operation.
Detecting compiler hash for triplet x64-windows...
A suitable version of powershell-core was not found (required v7.2.23).
Downloading https://github.com/PowerShell/PowerShell/releases/download/v7.2.23/PowerShell-7.2.23-win-x64.zip
Extracting powershell-core...
Compiler found: C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.41.34120/bin/Hostx64/x64/cl.exe
Detecting compiler hash for triplet x64-windows-static...
Compiler found: C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.41.34120/bin/Hostx64/x64/cl.exe
Restored 30 package(s) from C:\Users\User\AppData\Local\vcpkg\archives in 11 s. Use --debug to see more details.
Installing 1/30 egl-registry:x64-windows@2024-01-25...
Elapsed time to handle egl-registry:x64-windows: 25.8 ms
egl-registry:x64-windows package ABI: a5a82eaa8c440768261d4ad3c3d341ca4eddf115f40c01605069ccd451b560cf
Installing 2/30 egl-registry:x64-windows-static@2024-01-25...
Elapsed time to handle egl-registry:x64-windows-static: 38.5 ms
egl-registry:x64-windows-static package ABI: ed2ade5fc4d80c5a6fb20a7162b5bd8ae4d467a397befc983f743a911bd8097b
Installing 3/30 vcpkg-cmake:x64-windows@2024-04-23...
Elapsed time to handle vcpkg-cmake:x64-windows: 38.2 ms
vcpkg-cmake:x64-windows package ABI: 4a432835fed7e798ca1587a21ecf930c05f8e0e8bfe5166dc964d862ad12c9d1
Installing 4/30 vcpkg-cmake-config:x64-windows@2024-05-23...
Elapsed time to handle vcpkg-cmake-config:x64-windows: 44 ms
vcpkg-cmake-config:x64-windows package ABI: 03271f226303581b1d92c0ec0012f8fcedaae3909eeac080e104367bf8b210f0
Installing 5/30 expat:x64-windows@2.6.3...
Elapsed time to handle expat:x64-windows: 69 ms
expat:x64-windows package ABI: e75e047cda3e4ee8ba6da45952d9d3a9364eb756eec0825ade85ba7c6277370a
Installing 6/30 expat:x64-windows-static@2.6.3...
Elapsed time to handle expat:x64-windows-static: 63.6 ms
expat:x64-windows-static package ABI: 43c53e802a7a00857dd6773492f505586d67c233dbc5ec52417b98489bd503cb
Installing 7/30 libiconv:x64-windows@1.17#4...
Elapsed time to handle libiconv:x64-windows: 60.4 ms
libiconv:x64-windows package ABI: c1851a884cbdd98e64d3ce599a80d79e6c3e355aa2cc25d08bd388ad08bf27de
Installing 8/30 libiconv:x64-windows-static@1.17#4...
Elapsed time to handle libiconv:x64-windows-static: 50.9 ms
libiconv:x64-windows-static package ABI: 08ad336cbdbaf59fc9f3253f740906b8ac44ab3982d5dcae63cd3bb0d1673bc4
Installing 9/30 libjpeg-turbo:x64-windows@3.0.4...
Elapsed time to handle libjpeg-turbo:x64-windows: 68.1 ms
libjpeg-turbo:x64-windows package ABI: 11d9bb715a87926a769674d7d3d45959db902f924c25f0f053bafca5973e2303
Installing 10/30 libjpeg-turbo:x64-windows-static@3.0.4...
Elapsed time to handle libjpeg-turbo:x64-windows-static: 65.3 ms
libjpeg-turbo:x64-windows-static package ABI: 87b511c779f260d1df6036b7b687cba4b2579cdbadf9496d05bd252fdd9323a3
Installing 11/30 liblzma:x64-windows@5.6.3...
Elapsed time to handle liblzma:x64-windows: 74.3 ms
liblzma:x64-windows package ABI: ebbaab9489500c9244a76314fb05b3c679c3b6675b403113aa7b76120ca36190
Installing 12/30 liblzma:x64-windows-static@5.6.3...
Elapsed time to handle liblzma:x64-windows-static: 83.1 ms
liblzma:x64-windows-static package ABI: 2913529f759a936f575d4a9a6be47884e9693e861eb79d7692fbad894624be50
Installing 13/30 zlib:x64-windows@1.3.1...
Elapsed time to handle zlib:x64-windows: 53.1 ms
zlib:x64-windows package ABI: bc9710b27c3a881d0d85855c4f4b2f8667b793c913551844b324a655453b80c8
Installing 14/30 libpng:x64-windows@1.6.43#3...
Elapsed time to handle libpng:x64-windows: 60.6 ms
libpng:x64-windows package ABI: e996d2226e68fb850052d2d96de84dd7497cb9e5cc881c1ef7c15c32cb1969dd
Installing 15/30 zlib:x64-windows-static@1.3.1...
Elapsed time to handle zlib:x64-windows-static: 43.6 ms
zlib:x64-windows-static package ABI: c4b54b20da04822273e1973208eb83d7feded82bc415a47893dcecb2c7386cdd
Installing 16/30 libpng:x64-windows-static@1.6.43#3...
Elapsed time to handle libpng:x64-windows-static: 61.3 ms
libpng:x64-windows-static package ABI: 48fd986a3cc8d060dfab3563c50da36d104874712d069946cf5d16ba41e70d9b
Installing 17/30 libxml2[core,iconv,lzma,zlib]:x64-windows@2.11.9...
Elapsed time to handle libxml2:x64-windows: 118 ms
libxml2:x64-windows package ABI: 40221cfc170fc6f93e5dc1e2b0697f6ee457c8b380ddc90ea0028013e83894e2
Installing 18/30 libxml2[core,iconv,lzma,zlib]:x64-windows-static@2.11.9...
Elapsed time to handle libxml2:x64-windows-static: 144 ms
libxml2:x64-windows-static package ABI: 1cf06648a361340aa3b6ad01f74b52510b54bbc082cb9348a057322f9c6365f8
Installing 19/30 nanosvg:x64-windows@2023-12-29...
Elapsed time to handle nanosvg:x64-windows: 46.8 ms
nanosvg:x64-windows package ABI: b0255691a57aa879125965c7be8909e03abaa948c4697b9172c06942b396f570
Installing 20/30 nanosvg:x64-windows-static@2023-12-29...
Elapsed time to handle nanosvg:x64-windows-static: 48.8 ms
nanosvg:x64-windows-static package ABI: 8dc02b7fb9f7eb7479585af9faa7cd9d0bc1fc54274e2f90c4d91d3a8b2170f2
Installing 21/30 opengl-registry:x64-windows@2024-02-10#1...
Elapsed time to handle opengl-registry:x64-windows: 55.5 ms
opengl-registry:x64-windows package ABI: d7a8a5961789a41db2691caefa236c1fae45149f124494c7d0bb134a1c8bb5df
Installing 22/30 opengl:x64-windows@2022-12-04#3...
Elapsed time to handle opengl:x64-windows: 57.8 ms
opengl:x64-windows package ABI: 5ce99d41800f34018d54a3b825c5600b0f1409c962a53426bea19884d0a71011
Installing 23/30 opengl-registry:x64-windows-static@2024-02-10#1...
Elapsed time to handle opengl-registry:x64-windows-static: 61.1 ms
opengl-registry:x64-windows-static package ABI: 8f882618ebac956e2f4ba15e8a5c6f91911c49dd0fcb4c1de410dcc5b980957d
Installing 24/30 opengl:x64-windows-static@2022-12-04#3...
Elapsed time to handle opengl:x64-windows-static: 42.1 ms
opengl:x64-windows-static package ABI: 9c317288e403935158c62cfc1c36b4c877a1067f3cd026d9ce0504ef37af5fda
Installing 25/30 pcre2[core,jit,platform-default-features]:x64-windows@10.43...
Elapsed time to handle pcre2:x64-windows: 62.7 ms
pcre2:x64-windows package ABI: 1928181ff3654981c7e6287bd9377392f7e841a26adce30f33369ad04d46c924
Installing 26/30 pcre2[core,jit,platform-default-features]:x64-windows-static@10.43...
Elapsed time to handle pcre2:x64-windows-static: 61.4 ms
pcre2:x64-windows-static package ABI: 4994131294bd6add207fa6049cec7ded563e21dd8f76581038ce279dbdd37136
Installing 27/30 tiff[core,jpeg,lzma,zip]:x64-windows@4.7.0...
Elapsed time to handle tiff:x64-windows: 60.5 ms
tiff:x64-windows package ABI: ad7a0f9f868917e8a5723be88073bd001453168642eb56e009f2a3f696164895
Installing 28/30 tiff[core,jpeg,lzma,zip]:x64-windows-static@4.7.0...
Elapsed time to handle tiff:x64-windows-static: 52.2 ms
tiff:x64-windows-static package ABI: 3e47c91574f5e8828fef57f20f493685255342f21743335f29016e9fc869c235
Installing 29/30 wxwidgets[core,debug-support,sound]:x64-windows@3.2.6...
Elapsed time to handle wxwidgets:x64-windows: 1.3 s
wxwidgets:x64-windows package ABI: 17a2b14d9949f6f5de772a03a4d16c9d925ccdefd0b177fb69320e9484a075ed
Installing 30/30 wxwidgets[core,debug-support,sound]:x64-windows-static@3.2.6...
Elapsed time to handle wxwidgets:x64-windows-static: 1.1 s
wxwidgets:x64-windows-static package ABI: e22a8ff97eb45cb59ef2126121c87a85f895efc4a125951b70cf55302b8562a8
Total install time: 4.1 s
The package libxml2 is compatible with built-in CMake targets:

    find_package(LibXml2 REQUIRED)
    target_link_libraries(main PRIVATE LibXml2::LibXml2)

tiff is compatible with built-in CMake targets:

    find_package(TIFF REQUIRED)
    target_link_libraries(main PRIVATE TIFF::TIFF)

tiff provides pkg-config modules:

    #  Tag Image File Format (TIFF) library.
    libtiff-4

The package wxwidgets provides CMake targets:

    find_package(wxWidgets CONFIG REQUIRED)
    target_link_libraries(main PRIVATE wx::core wx::base)

Cloning PatchIccMAX repository...
Cloning into 'PatchIccMAX'...
remote: Enumerating objects: 5437, done.
remote: Counting objects: 100% (842/842), done.
remote: Compressing objects: 100% (386/386), done.
remote: Total 5437 (delta 629), reused 554 (delta 454), pack-reused 4595 (from 1)
Receiving objects: 100% (5437/5437), 26.55 MiB | 11.29 MiB/s, done.
Resolving deltas: 100% (3544/3544), done.
Updating files: 100% (805/805), done.
Checking out the 'static' branch...
branch 'static' set up to track 'origin/static'.
Switched to a new branch 'static'
============================= Starting Build Process =============================
Build succeeded.
============================= DemoIccMAX Build Complete =============================
```
