# PR `vcpkg install iccdev`

**Last Updated:** 05-August-2025 1100Z by David Hoyt https://github.com/InternationalColorConsortium/DemoIccMAX/issues/153

**tl;dr** CLA required for vcpkg registry PR

## Intent

Prepare a PR for Testing & Submission for `vcpkg install iccdev`. 

The current branch (`vcpkg`) is taken from [PR152](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/152) with modified CMake configuration as a Smoke Test.

## vcpkg PR Submission

Before submitting a pull request to the vcpkg registry, ensure the following:

* Complete a Microsoft Contributor License Agreement (CLA).
* Verify compliance with vcpkg submission guidelines and checklist.

### PR Checklists & CLA Link

* [Adding to vcpkg Registry](https://learn.microsoft.com/en-us/vcpkg/get_started/get-started-adding-to-registry?pivots=shell-powershell)
* [vcpkg PR Review Checklist](https://learn.microsoft.com/en-us/vcpkg/contributing/pr-review-checklist)
* [Microsoft Contributor License Agreement](https://github.com/microsoft/vcpkg/blob/master/CONTRIBUTING.md#legal)

## Steps for Reproduction

### Using vcpkg (Classic Installation)

```
cd ~
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg.exe integrate install
cd ~
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git checkout vcpkg
del vcpkg.json
#
# strict: vcpkg --classic install iccdev --overlay-ports=ports  --clean-after-build
#
vcpkg install --overlay-ports=ports
```

### Expected Output

```
Detecting compiler hash for triplet x64-windows...
Compiler found: C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/Hostx64/x64/cl.exe
All requested packages are currently installed.
Total install time: 622 us
libjpeg-turbo is compatible with built-in implementation-agnostic CMake targets:
...
success
```

## Example Installation

### bin/ — Executable Tools

```
iccApplyToLink
iccDumpProfile
iccFromCube
iccFromXml
iccRoundTrip
iccToXml
iccV5DspObsToV4Dsp
```

### lib/ — Libraries

```
libIccProfLib2.so        -> libIccProfLib2.so.2.2.61
libIccProfLib2.so.2      -> libIccProfLib2.so.2.2.61
libIccProfLib2.so.2.2.61
libIccProfLib2-static.a

libIccXML2.so            -> libIccXML2.so.2.2.61
libIccXML2.so.2          -> libIccXML2.so.2.2.61
libIccXML2.so.2.2.61
libIccXML2-static.a
```

---

### Windows Reproduction

```
          cd \
          mkdir test
          cd test
          git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
          cd DemoIccMAX
          git checkout vcpkg
          Remove-Item -Force vcpkg.json -ErrorAction SilentlyContinue
          cd ..
          git clone https://github.com/microsoft/vcpkg.git
          cd vcpkg
          .\bootstrap-vcpkg.bat
          .\vcpkg integrate install
          cd ..
          .\vcpkg\vcpkg.exe --classic install iccdev --overlay-ports=DemoIccMAX\ports
```

### Windows Expected Output

```
PS C:\test>           git clone https://github.com/microsoft/vcpkg.git
Cloning into 'vcpkg'...
remote: Enumerating objects: 282213, done.
remote: Counting objects: 100% (574/574), done.
remote: Compressing objects: 100% (330/330), done.
remote: Total 282213 (delta 425), reused 244 (delta 244), pack-reused 281639 (from 3)
Receiving objects: 100% (282213/282213), 87.85 MiB | 14.01 MiB/s, done.
Resolving deltas: 100% (188241/188241), done.
Updating files: 100% (12673/12673), done.
PS C:\test>           cd vcpkg
PS C:\test\vcpkg>           .\bootstrap-vcpkg.bat
Downloading https://github.com/microsoft/vcpkg-tool/releases/download/2025-07-21/vcpkg.exe -> C:\test\vcpkg\vcpkg.exe... done.
Validating signature... done.

vcpkg package management program version 2025-07-21-d4b65a2b83ae6c3526acd1c6f3b51aff2a884533
...

PS C:\test\vcpkg> .\vcpkg integrate install
Applied user-wide integration for this vcpkg root.
CMake projects should use: "-DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake"
All MSBuild C++ projects can now #include any installed libraries. Linking will be handled automatically. Installing new libraries will make them instantly available.

PS C:\test\vcpkg> cd ..

PS C:\test> .\vcpkg\vcpkg.exe install iccdev --overlay-ports=DemoIccMAX\ports
Computing installation plan...
A suitable version of cmake was not found (required v3.30.1).
Downloading https://github.com/Kitware/CMake/releases/download/v3.30.1/cmake-3.30.1-windows-i386.zip -> cmake-3.30.1-windows-i386.zip
Successfully downloaded cmake-3.30.1-windows-i386.zip
Extracting cmake...
A suitable version of 7zip was not found (required v24.9.0).
Downloading https://github.com/ip7z/7zip/releases/download/24.09/7z2409.exe -> 7z2409.7z.exe
Successfully downloaded 7z2409.7z.exe
Extracting 7zip...
A suitable version of 7zr was not found (required v24.9.0).
Downloading https://github.com/ip7z/7zip/releases/download/24.09/7zr.exe -> 44d8504a-7zr.exe
Successfully downloaded 44d8504a-7zr.exe
warning: vcpkg appears to be in a Visual Studio prompt targeting x86 but installing for x64-windows. Consider using --triplet x86-windows or --triplet x86-uwp.
The following packages will be built and installed:
  * egl-registry:x64-windows@2024-01-25
  * expat:x64-windows@2.7.1
    iccdev:x64-windows@2.2.61 -- C:\test\DemoIccMAX\ports\iccdev
  * libiconv:x64-windows@1.18#1
  * libjpeg-turbo:x64-windows@3.1.1
  * liblzma:x64-windows@5.8.1
  * libpng:x64-windows@1.6.50
  * libwebp[core,libwebpmux,nearlossless,simd,unicode]:x64-windows@1.6.0
  * libxml2[core,iconv,zlib]:x64-windows@2.13.8#1
  * nanosvg:x64-windows@2023-12-29
  * nlohmann-json:x64-windows@3.12.0
  * opengl:x64-windows@2022-12-04#3
  * opengl-registry:x64-windows@2024-02-10#1
  * pcre2[core,jit,platform-default-features]:x64-windows@10.45
  * tiff[core,jpeg,lzma,zip]:x64-windows@4.7.0
  * vcpkg-cmake:x64-windows@2024-04-23
  * vcpkg-cmake-config:x64-windows@2024-05-23
  * wxwidgets[core,debug-support,sound]:x64-windows@3.3.1
  * zlib:x64-windows@1.3.1
Additional packages (*) will be modified to complete this operation.
Detecting compiler hash for triplet x64-windows...
A suitable version of powershell-core was not found (required v7.2.24).
Downloading https://github.com/PowerShell/PowerShell/releases/download/v7.2.24/PowerShell-7.2.24-win-x64.zip -> PowerShell-7.2.24-win-x64.zip
Successfully downloaded PowerShell-7.2.24-win-x64.zip
Extracting powershell-core...
Compiler found: C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/Hostx64/x64/cl.exe
Restored 19 package(s) from C:\Users\User\AppData\Local\vcpkg\archives in 3.2 s. Use --debug to see more details.
Installing 1/19 egl-registry:x64-windows@2024-01-25...
Elapsed time to handle egl-registry:x64-windows: 10.5 ms
egl-registry:x64-windows package ABI: b22e27bb518f12fac93c868d0e0f73033541226b67110b8b0ecfea6cfe8f2546
Installing 2/19 vcpkg-cmake:x64-windows@2024-04-23...
Elapsed time to handle vcpkg-cmake:x64-windows: 7.1 ms
vcpkg-cmake:x64-windows package ABI: 0d207a6a8569a3a9de6c28f2b10b3fc9cd22d6565f3c73f04f080ae91a9d8b03
Installing 3/19 vcpkg-cmake-config:x64-windows@2024-05-23...
Elapsed time to handle vcpkg-cmake-config:x64-windows: 9.07 ms
vcpkg-cmake-config:x64-windows package ABI: 5f32804c7915d7da1cac54b275b93bfa5a14e4895e3f5fe21dc0d05aa769153f
Installing 4/19 expat:x64-windows@2.7.1...
Elapsed time to handle expat:x64-windows: 14.7 ms
expat:x64-windows package ABI: 4bf7a6a46f8644d16a50e6968df4e858c1096fee3dff868d096b65eac083c1f1
Installing 5/19 libiconv:x64-windows@1.18#1...
Elapsed time to handle libiconv:x64-windows: 11.2 ms
libiconv:x64-windows package ABI: ad1f326dd2d661bb18c0a283c46730c8ce058eb65f6e9dcb1f2762d9f782d8c1
Installing 6/19 libjpeg-turbo:x64-windows@3.1.1...
Elapsed time to handle libjpeg-turbo:x64-windows: 20 ms
libjpeg-turbo:x64-windows package ABI: 389db3dcd78f478fa020d384791136c1a8533a3ef20f1ced45e6c2093053f759
Installing 7/19 zlib:x64-windows@1.3.1...
Elapsed time to handle zlib:x64-windows: 12.8 ms
zlib:x64-windows package ABI: cbf231c7b08d9a8ca69ccc36900c59745d352c9b9d0077108e2ee69c504290ab
Installing 8/19 libpng:x64-windows@1.6.50...
Elapsed time to handle libpng:x64-windows: 16.9 ms
libpng:x64-windows package ABI: 46e4331b8f67e54a87602756303975dbc48694c22e1dfcd00c48a1c68f4d3f3d
Installing 9/19 libxml2[core,iconv,zlib]:x64-windows@2.13.8#1...
Elapsed time to handle libxml2:x64-windows: 34 ms
libxml2:x64-windows package ABI: 7289042ee3d12a0bc6ad488b6f9b36a837c478bc23f309ff2b1ce9947e101282
Installing 10/19 nlohmann-json:x64-windows@3.12.0...
Elapsed time to handle nlohmann-json:x64-windows: 24.8 ms
nlohmann-json:x64-windows package ABI: 6de5ac8945f4765e6bf8f135f7c6cfd93352c96d68cd90e0c5d419f841a30b4c
Installing 11/19 liblzma:x64-windows@5.8.1...
Elapsed time to handle liblzma:x64-windows: 23.5 ms
liblzma:x64-windows package ABI: 482581fd889de6e5e66229f7d2b879b0001af25c39b246219ec3006a6f3e16ff
Installing 12/19 tiff[core,jpeg,lzma,zip]:x64-windows@4.7.0...
Elapsed time to handle tiff:x64-windows: 18.5 ms
tiff:x64-windows package ABI: 26230f0647ddb21009f4143c601c53ceeda7bdf48e5fb11cc260d0336092f20f
Installing 13/19 libwebp[core,libwebpmux,nearlossless,simd,unicode]:x64-windows@1.6.0...
Elapsed time to handle libwebp:x64-windows: 33.8 ms
libwebp:x64-windows package ABI: 20d62139f81238975eb71e09459041d865f6d439be10bfaf39b7d34674ac6b70
Installing 14/19 nanosvg:x64-windows@2023-12-29...
Elapsed time to handle nanosvg:x64-windows: 9.96 ms
nanosvg:x64-windows package ABI: 1efef547d62fe49ffe0e707203f684d13a843c99b06a1b9720294670e26928c6
Installing 15/19 opengl-registry:x64-windows@2024-02-10#1...
Elapsed time to handle opengl-registry:x64-windows: 21 ms
opengl-registry:x64-windows package ABI: f5b7f131c0ca6b43e5346ad569c6a5224a7aea37dc29d34fc64cdddef4ea4044
Installing 16/19 opengl:x64-windows@2022-12-04#3...
Elapsed time to handle opengl:x64-windows: 14.9 ms
opengl:x64-windows package ABI: f89f0ba4a2d6398afe5ad32273867a5cb71e3d4e75bc6cb2c0ea093fe50fcff4
Installing 17/19 pcre2[core,jit,platform-default-features]:x64-windows@10.45...
Elapsed time to handle pcre2:x64-windows: 44.8 ms
pcre2:x64-windows package ABI: 73412e6e30ba80e1a785ee8488a8f1b40be2014c4a054f99566b5334fc2cde4f
Installing 18/19 wxwidgets[core,debug-support,sound]:x64-windows@3.3.1...
Elapsed time to handle wxwidgets:x64-windows: 191 ms
wxwidgets:x64-windows package ABI: b7f9d9c1cf4a63e26aba9b9d509df1a2adf0090c8db6bc3c78756b41b98056ae
Installing 19/19 iccdev:x64-windows@2.2.61...
Elapsed time to handle iccdev:x64-windows: 30.5 ms
iccdev:x64-windows package ABI: ff9eb60b0e94c3b356dd66f7f699698e06fe2ba1aa8d47394e50ffd9cddf26df
Total install time: 578 ms
Installed contents are licensed to you by owners. Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
Some packages did not declare an SPDX license. Check the `copyright` file for each package for more information about their licensing.
Packages installed in this vcpkg installation declare the following licenses:
BSD-3-Clause
LGPL-2.0-or-later WITH WxWindows-exception-3.1
MIT
Zlib
libpng-2.0
libtiff
...
PS C:\test> dir .\vcpkg\packages\iccdev_x64-windows\bin\


    Directory: C:\test\vcpkg\packages\iccdev_x64-windows\bin


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----          8/6/2025   6:01 PM         702464 iccApplyToLink.exe
-a----          8/6/2025   6:01 PM         584704 iccDumpProfile.exe
-a----          8/6/2025   6:01 PM         589824 iccFromCube.exe
-a----          8/6/2025   6:01 PM         990720 iccFromXml.exe
-a----          8/6/2025   6:00 PM          44032 IccProfLib2.dll
-a----          8/6/2025   6:01 PM         681984 iccRoundTrip.exe
-a----          8/6/2025   6:01 PM         975872 iccToXml.exe
-a----          8/6/2025   6:01 PM         586240 iccV5DspObsToV4Dsp.exe
-a----          8/6/2025   6:00 PM          43008 IccXML2.dll
```
      