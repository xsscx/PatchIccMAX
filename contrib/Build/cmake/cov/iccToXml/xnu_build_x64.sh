#/bin/bash
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 15-APRIL-2025 0900 EDT
#
# Branch: research
# Intent: TESTING Runner Builds with xnu_build_x64.sh
# Production: TRUE
# Runner: TRUE
#
#
# Updates:  Coverage Scope
#          
#
# 
# 
## Builds instrumented iccToXml binary with AFL++ and generates AFL++ coverage data


clang++ -O0 -g -fno-limit-debug-info -fno-inline \
  -fprofile-instr-generate -fcoverage-mapping -fsanitize=address,undefined \
  -fno-omit-frame-pointer \
  -I../../../../../IccXML/IccLibXML \
  -I../../../../../IccProfLib \
  -I../../../../../IccXML/CmdLine/IccToXml \
  -I/usr/include/libxml2 \
  ../../../../../IccXML/CmdLine/IccToXml/IccToXml.cpp \
  -o iccToXml_test \
  -Wl,-force_load,../iccXmlLib/libIccXML2.a \
  -Wl,-force_load,../iccProfLib/libIccProfLib2.a \
  -lxml2
