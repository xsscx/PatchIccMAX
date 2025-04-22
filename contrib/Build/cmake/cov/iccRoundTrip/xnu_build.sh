clang++ -O0 -g -fno-limit-debug-info -fno-inline \
  -fprofile-instr-generate -fcoverage-mapping -fsanitize=address,undefined \
  -fno-omit-frame-pointer \
  -I../../../../../IccXML/IccLibXML \
  -I../../../../../IccProfLib \
  -I../../../../../IccXML/CmdLine/IccToXml \
  -I/usr/include/libxml2 \
  ../../../../../Tools/CmdLine/IccRoundTrip/iccRoundTrip.cpp \
  -o iccRoundTrip_test \
  -Wl,-force_load,../iccXmlLib/libIccXML2.a \
  -Wl,-force_load,../iccProfLib/libIccProfLib2.a \
  -lxml2
