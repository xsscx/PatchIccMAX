# Reproduction Samples


**Last Update:** Wednesday 26-FEB-2025 0900 EST by David Hoyt

**tl;dr**
Progress

## Issue 1 - enum not a valid value for type 'icPlatformSignature'

### UBSan Reproduction Steps

#### 1. Initial Setup
- Ensure the code is compiled with debugging symbols (`-g`) and without optimizations (`-O0`).
- Enable Undefined Behavior Sanitizer (UBSan) to detect runtime issues.
  ```bash
  cd Build/
  cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
  -Wno-dev Cmake/
  make
  ```

#### 2. Download the Test ICC Profile
- Navigate to the `Testing` directory within the DemoIccMAX project:
  ```bash
  cd ../Testing/
  ```
- Download the ICC profile used for this Ubsan repro:
  ```bash
  wget https://github.com/xsscx/PatchIccMAX/raw/development/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc
  ```

#### 3. PoC
- Execute the `iccDumpProfile` tool on the downloaded ICC profile:
  ```bash
  ../Build/Tools/IccDumpProfile/iccDumpProfile icPlatformSignature-ubsan-poc.icc
  ```

#### 4. UBSan Output
- UBSan reports iccDumpProfile.cpp:227:11: runtime error: load of value `2543294359`:

```
Wed Feb 26 09:22:39 EST 2025

Built with IccProfLib version 2.2.5

Profile:            'icPlatformSignature-ubsan-poc.icc'
Profile ID:         Profile ID not calculated.
Size:               504 (0x1f8) bytes

Header
------
Attributes:         Transparency | Matte
Cmm:                Apple
Creation Date:      7/151/2003 (M/D/Y)  38807:38807:38807
Creator:            'appl' = 6170706C
Device Manufacturer:'????' = 97979797
Data Color Space:   RgbData
Flags:              EmbeddedProfileTrue | UseWithEmbeddedDataOnly
PCS Color Space:    LabData
/home/xss/tmp/pr111/gnu/DemoIccMAX/Tools/CmdLine/IccDumpProfile/iccDumpProfile.cpp:227:11: runtime error: load of value 2543294359, which is not a valid value for type 'icPlatformSignature'
Platform:           Unknown '????' = 97979797
Rendering Intent:   Perceptual
Profile Class:      InputClass
Profile SubClass:   Not Defined
Version:            2.20
Illuminant:         X=-26728.4082, Y=1.0000, Z=0.8249
Spectral PCS:       NoSpectralData
Spectral PCS Range: Not Defined
BiSpectral Range:   Not Defined
MCS Color Space:    Not Defined

Profile Tags
------------
                         Tag    ID      Offset      Size             Pad
                        ----  ------    ------      ----             ---
       profileDescriptionTag  'desc'       192       110              42
   Unknown 'dscm' = 6473636D  'dscm'       264        78               2
          mediaWhitePointTag  'wtpt'       344        20               0
      chromaticAdaptationTag  'chad'       364        44              96
                    AToB0Tag  'A2B0'       204       300               0

```

### Observations

#### 1. Invalid `icPlatformSignature` Values
- The UBSan report indicates that the value `2543294359` was loaded as an `icPlatformSignature`, but this value is outside the range of valid values for this type.
- The errors occur in multiple locations within the code, suggesting a systematic issue with how these values are processed or validated.

---

## Issue 2 - iccRoundTrip - Unable to perform round trip on file(s)

### PoC

```
 ../Build/Tools/IccRoundTrip/iccRoundTrip Testing/PCC/Lab_float-D50_2deg.icc
Unable to perform round trip on 'Testing/PCC/Lab_float-D50_2deg.icc'
```

### Observations

#### 1. Unable to perform round trip
- Issue needs more research

---

## Issue 3 - Fixed - Type Confusion in `CIccMpeCalculator::Read`

### PoC

```
cd Testing/
wget https://github.com/xsscx/PatchIccMAX/raw/development/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc
iccToXml icSigMatrixElemType-Read-poc.icc icSigMatrixElemType-Read-poc.xml
```

#### 26-FEB-2025 Output Sample

```
Wed Feb 26 09:22:39 EST 2025

.\iccToXml_d.exe icSigMatrixElemType-Read-poc.icc icSigMatrixElemType-Read-poc.xml

XML successfully created

more icSigMatrixElemType-Read-poc.xml

<?xml version="1.0" encoding="UTF-8"?>
<IccProfile>
  <Header>
    <PreferredCMMType></PreferredCMMType>
    <ProfileVersion>5.00</ProfileVersion>
    <ProfileDeviceClass>scnr</ProfileDeviceClass>
    <DataColourSpace>BCLR</DataColourSpace>
    <PCS></PCS>
    <CreationDateTime>2024-06-23T14:27:09</CreationDateTime>
    <ProfileFlags EmbeddedInFile="true" UseWithEmbeddedDataOnly="false"/>
    <DeviceAttributes ReflectiveOrTransparency="reflective" GlossyOrMatte="glossy" MediaPolarity="negative" MediaColour="colour"/>
    <RenderingIntent>Absolute</RenderingIntent>
    <PCSIlluminant>
      <XYZNumber X="0.964202880859" Y="1.000000000000" Z="0.824905395508"/>
    </PCSIlluminant>
    <ProfileCreator></ProfileCreator>
    <ProfileID>5DE45F06F65F46ABB9EC7B1D6BE190D3</ProfileID>
    <SpectralPCS>rs0024</SpectralPCS>
    <SpectralRange>
     <Wavelengths start="380.00000000" end="730.00000000" steps="36"/>
    </SpectralRange>
  </Header>
...
```

## Issue 4 - Overflow in CIccTagNamedColor2::CIccTagNamedColor2

An overflow occurs leading to an out-of-bounds read. 

### PoC
```
./iccFromXml WebSafeColors.xml WebSafeColors.icc
```

#### Curent Output

```
Wed Feb 26 09:22:39 EST 2025

../Build/Tools/IccFromXml/iccFromXml WebSafeColors.xml WebSafeColors.icc
=================================================================
==9654==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x504000001900 at pc 0x7fab8afcdec8 bp 0x7ffe66f8db20 sp 0x7ffe66f8db10
READ of size 4 at 0x504000001900 thread T0
    #0 0x7fab8afcdec7 in CIccTagNamedColor2::SetSize(unsigned int, int) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccTagBasic.cpp:2826
    #1 0x7fab8c7365c7 in CIccTagXmlNamedColor2::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/IccLibXML/IccTagXml.cpp:748
    #2 0x7fab8c712d6e in CIccProfileXml::ParseTag(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:663
    #3 0x7fab8c71831d in CIccProfileXml::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:820
    #4 0x7fab8c7187e1 in CIccProfileXml::LoadXml(char const*, char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >*) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:877
    #5 0x56366de8f573 in main /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/CmdLine/IccFromXml/IccFromXml.cpp:68
    #6 0x7fab890461c9  (/lib/x86_64-linux-gnu/libc.so.6+0x2a1c9) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #7 0x7fab8904628a in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x2a28a) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #8 0x56366de8e864 in _start (/home/xss/tmp/pr111/gnu/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml+0x9864) (BuildId: c82ede304d3a80cc91c76061c1a80460930039ef)

0x504000001900 is located 0 bytes after 48-byte region [0x5040000018d0,0x504000001900)
allocated by thread T0 here:
    #0 0x7fab8cd29340 in calloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:77
    #1 0x7fab8afc8d3c in CIccTagNamedColor2::CIccTagNamedColor2(int, int) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccTagBasic.cpp:2694
    #2 0x7fab8c7f3ae7 in CIccTagXmlNamedColor2::CIccTagXmlNamedColor2() /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/IccLibXML/IccTagXml.h:216
    #3 0x7fab8c7ee4f9 in CIccTagXmlFactory::CreateTag(icTagTypeSignature) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/IccLibXML/IccTagXmlFactory.cpp:152
    #4 0x7fab8b16c583 in CIccTagCreator::DoCreateTag(icTagTypeSignature) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccTagFactory.cpp:556
    #5 0x7fab8b093c6c in CIccTagCreator::CreateTag(icTagTypeSignature) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccTagFactory.h:280
    #6 0x7fab8af9559a in CIccTag::Create(icTagTypeSignature) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccTagBasic.cpp:145
    #7 0x7fab8c712619 in CIccProfileXml::ParseTag(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:656
    #8 0x7fab8c71831d in CIccProfileXml::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:820
    #9 0x7fab8c7187e1 in CIccProfileXml::LoadXml(char const*, char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >*) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:877
    #10 0x56366de8f573 in main /home/xss/tmp/pr111/gnu/DemoIccMAX/IccXML/CmdLine/IccFromXml/IccFromXml.cpp:68
    #11 0x7fab890461c9  (/lib/x86_64-linux-gnu/libc.so.6+0x2a1c9) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #12 0x7fab8904628a in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x2a28a) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #13 0x56366de8e864 in _start (/home/xss/tmp/pr111/gnu/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml+0x9864) (BuildId: c82ede304d3a80cc91c76061c1a80460930039ef)

SUMMARY: AddressSanitizer: heap-buffer-overflow /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccTagBasic.cpp:2826 in CIccTagNamedColor2::SetSize(unsigned int, int)
Shadow bytes around the buggy address:
  0x504000001680: fa fa fd fd fd fd fd fd fa fa fd fd fd fd fd fd
  0x504000001700: fa fa 00 00 00 00 00 fa fa fa fd fd fd fd fd fa
  0x504000001780: fa fa fd fd fd fd fd fa fa fa 00 00 00 00 00 fa
  0x504000001800: fa fa 00 00 00 00 00 fa fa fa fd fd fd fd fd fa
  0x504000001880: fa fa fd fd fd fd fd fa fa fa 00 00 00 00 00 00
=>0x504000001900:[fa]fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x504000001980: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x504000001a00: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x504000001a80: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x504000001b00: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x504000001b80: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
==9654==ABORTING
```

