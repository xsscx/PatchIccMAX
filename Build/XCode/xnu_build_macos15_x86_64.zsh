#!/bin/zsh

config="Debug"

cd ../../IccProfLib
xcodebuild -target IccProfLib-macOS -configuration "$config" -arch x86_64 clean
xcodebuild -target IccProfLib-macOS -configuration "$config" -arch x86_64
cp build/$config/libIccProfLib.a ../Build/XCode/lib

cd ../IccXML/IccLibXML
xcodebuild -target IccLibXML-macOS -configuration "$config" -arch x86_64 clean
xcodebuild -target IccLibXML-macOS -configuration "$config" -arch x86_64 
cp build/$config/libIccLibXML.a ../../Build/XCode/lib

cd ../../Tools/CmdLine/IccApplyNamedCmm
xcodebuild -target IccApplyNamedCMM -configuration "$config" -arch x86_64 clean
xcodebuild -target IccApplyNamedCMM -configuration "$config" -arch x86_64 \
LIBRARY_SEARCH_PATHS="../../../IccProfLib/build/$config/  /usr/local/opt/jpeg/lib /usr/local/opt/libtiff/lib" \
OTHER_LDFLAGS="-lIccProfLib -ljpeg -ltiff -llzma -lz"
cp build/$config/IccApplyNamedCmm ../../../Testing

cd ../IccApplyProfiles
xcodebuild -target iccApplyProfiles -configuration "$config" -arch x86_64 clean
xcodebuild -target iccApplyProfiles -configuration "$config" -arch x86_64 \
LIBRARY_SEARCH_PATHS="../../../IccProfLib/build/$config/  /usr/local/opt/jpeg/lib /usr/local/opt/libtiff/lib" \
OTHER_LDFLAGS="-lIccProfLib -ljpeg -ltiff -llzma -lz"
cp build/$config/IccApplyProfiles ../../../Testing

cd ../IccDumpProfile
xcodebuild -target IccDumpProfile -configuration "$config" -arch x86_64 clean
xcodebuild -target IccDumpProfile -configuration "$config" -arch x86_64 \
LIBRARY_SEARCH_PATHS="../../../IccProfLib/build/$config/  /usr/local/opt/jpeg/lib /usr/local/opt/libtiff/lib" \
OTHER_LDFLAGS="-lIccProfLib -ljpeg -ltiff -llzma -lz"
cp build/$config/IccDumpProfile ../../../Testing

cd ../IccRoundTrip
xcodebuild -target IccRoundTrip -configuration "$config" -arch x86_64 clean
xcodebuild -target IccRoundTrip -configuration "$config" -arch x86_64 \
LIBRARY_SEARCH_PATHS="../../../IccProfLib/build/$config/  /usr/local/opt/jpeg/lib /usr/local/opt/libtiff/lib" \
OTHER_LDFLAGS="-lIccProfLib -ljpeg -ltiff -llzma -lz"
cp build/$config/IccRoundTrip ../../../Testing

cd ../IccSpecSepToTiff
cp ../IccApplyProfiles/TiffImg.* .
xcodebuild -target IccSpecSepToTiff -configuration "$config" -arch x86_64 clean
xcodebuild -target IccSpecSepToTiff -configuration "$config" -arch x86_64 \
LIBRARY_SEARCH_PATHS="../../../IccProfLib/build/$config /usr/local/opt/jpeg/lib /usr/local/opt/libtiff/lib /usr/local/opt/webp/lib /usr/local/opt/zstd/lib" \
OTHER_LDFLAGS="-lIccProfLib -ljpeg -ltiff -lwebp -llzma -lz -lzstd"
cp build/$config/IccSpecSepToTiff ../../../Testing

cd ../IccTiffDump
cp ../IccApplyProfiles/TiffImg.* .
xcodebuild -target IccTiffDump -configuration "$config" -arch x86_64 clean
xcodebuild -target IccTiffDump -configuration "$config" -arch x86_64 \
LIBRARY_SEARCH_PATHS="../../../IccProfLib/build/$config /usr/local/opt/jpeg/lib /usr/local/opt/libtiff/lib /usr/local/opt/webp/lib /usr/local/opt/zstd/lib" \
OTHER_LDFLAGS="-lIccProfLib -ljpeg -ltiff -lwebp -llzma -lz -lzstd"
cp build/$config/IccTiffDump ../../../Testing

cd ../../../IccXML/CmdLine/IccFromXml
xcodebuild -target iccFromXml -configuration "$config" -arch x86_64 clean
xcodebuild -target iccFromXml -configuration "$config" -arch x86_64 -sdk macosx15.0 \
ARCHS="x86_64" VALID_ARCHS="x86_64"
cp build/$config/iccFromXml ../../../Testing

cd ../../../IccXML/CmdLine/IccToXml
xcodebuild -target IccToXml -configuration "$config" -arch x86_64 clean
xcodebuild -target IccToXml -arch x86_64 -sdk macosx15.0 ARCHS="x86_64" -configuration Debug
cp build/$config/iccToXml ../../../Testing
