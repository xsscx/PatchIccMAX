#!/bin/bash
##
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt
## Date: 12-MAY-2025 2000 EDT
#
# Branch: research
# Intent: GC
# Production: TRUE
# Runner: TRUE
#
#
# Updates:  Makefile for building instrumented Libs + Tools and checking LLVM coverage symbols
#
#
#
#
#
##  Makefile for building instrumented Libs + Tools and checking LLVM coverage symbols

# Runners are manual compile atm, wip

set -e

          echo ""
          echo "Little ICC Scanner v.01 [licc]"
          echo "[Research Branch | v.2.3.0 | -lIccProfLib2 -lIccXML2 -llcms2]"
          echo "Copyright (©) 2022-2025 David H Hoyt LLC. All rights reserved."
          echo "Demonstration measurement and analysis toolchain for ICC profiles."
          echo "Evaluate AToB/BToA transform integrity for RGB and CMYK workflows"
          echo "Detect malformed, corrupted, or heuristics in ICC profiles"
          echo "Log detailed tag structure and potential exploit vectors"
          echo "Bug Class: Profile Bleed | https://srd.cx/cve-2022-26730"
          echo ""

echo "[*] ========== Building Instrumentation Package =========="
echo ""
echo "[*] Building static libraries..."
echo "[*] Building iccProfLib..."
make -C  iccProfLib -f Makefile.iccProfLib clean all AFL=0
echo "[*] Building iccXmlLib..."
make -C iccXmlLib -f Makefile.iccXmlLib clean all AFL=0
# echo "[*] Verifying static lib instrumentation..."
# cd iccProfLib
# ar -x libIccProfLib2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "   [INSTRUMENTED] $f"; done; rm -f *.o
# cd ../iccXmlLib
# ar -x libIccXML2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "   [INSTRUMENTED] $f"; done; rm -f *.o
# cd ..
echo "[*] Building coverage-enabled tools..."
echo "[*] Building iccToXml..."
# make -C iccToXml -f Makefile.iccToXml.asan clean all AFL=0
echo "[*] Building iccFromXml..."
make -C iccFromXml -f Makefile.iccFromXml clean all AFL=0
echo "[*] Building iccDumpProfile..."
# make -C iccDumpProfile -f Makefile.iccDumpProfile clean all AFL=0
cd iccDumpProfile
clang++ -O0 -g -fno-limit-debug-info -fno-inline \
  -fprofile-instr-generate -fcoverage-mapping -fsanitize=address,undefined \
  -fno-omit-frame-pointer \
  -I../../../../../IccXML/IccLibXML \
  -I../../../../../IccProfLib \
  -I/usr/include/libxml2 \
  ../../../../../Tools/CmdLine/IccDumpProfile/iccDumpProfile.cpp \
  -o iccDumpProfile_test \
  -Wl,-force_load,../iccXmlLib/libIccXML2.a \
  -Wl,-force_load,../iccProfLib/libIccProfLib2.a \
  -lxml2
ls
cd ../
echo "[*] Building iccRoundTrip..."
# make -C iccRoundTrip -f Makefile.iccRoundTrip clean all AFL=0
cd iccRoundTrip
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
cd ..
# make -C iccPngDump -f Makefile.iccPngDump clean all AFL=0
# make -C  licc -f Makefile.licc clean all AFL=0
# make -C iccTiffDump -f Makefile.IccTiffDump clean all AFL=0
# make -C iccApplyNamedCmm -f Makefile.iccApplyNamedCmm clean all AFL=0
# make -C iccApplyProfiles -f Makefile.iccApplyProfiles clean all AFL=0
echo "DONE"
