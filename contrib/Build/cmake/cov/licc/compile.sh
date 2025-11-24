#!/bin/sh
echo "Starting Build"

         g++ \
            -fsanitize=address,undefined \
            -fno-omit-frame-pointer \
            -fno-optimize-sibling-calls \
            -g3 -w -O1 \
            -Wall -Wextra -Wpedantic \
            -Wno-unused-parameter -Wno-type-limits -Wno-overloaded-virtual \
            -I../../../../../IccProfLib \
            -I../../../../../IccXML/IccLibXML \
            -I/usr/local/include \
            -I/usr/include/libxml2 \
            -DPLATFORM_LINUX -DARCH_X64 \
            -o iccScan-v231-beta iccScan-v231-beta.cpp \
            -L/usr/local/lib -L../iccProfLib -L../iccXmlLib \
            -lIccProfLib2 -lIccXML2 -llcms2 -lz -lm

          g++ \
            -fsanitize=address,undefined \
            -fno-omit-frame-pointer \
            -fno-optimize-sibling-calls \
            -g3 -w -O1 \
            -Wall -Wextra -Wpedantic \
            -Wno-unused-parameter -Wno-type-limits -Wno-overloaded-virtual \
            -I../../../../../IccProfLib \
            -I../../../../../IccXML/IccLibXML \
            -I/usr/local/include \
            -I/usr/include/libxml2 \
            -DPLATFORM_LINUX -DARCH_X64 \
            -o licc licc.cpp \
            -L/usr/local/lib -L../iccProfLib -L../iccXmlLib \
            -lIccProfLib2 -lIccXML2 -llcms2 -lz -lm
            
echo "Completed Build"            
            

