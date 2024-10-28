#!/bin/sh
##
## Unit Test for PCS_Refactor
## Asan Checks for CreateAllProfiles.sh
##
## David Hoyt for DemoIccMAX Project
## Date: 27-Sept-24
##
##
## Run: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/pcs_asan_test_CreateAllProfiles.sh)"
##
##

## setup tmp space
cd /tmp
mkdir test
cd test

## Grab the Code

wget https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/heads/PCS_Refactor.zip

## Unzip the Code
unzip PCS_Refactor.zip

## Change CWD
cd DemoIccMAX-PCS_Refactor/Build/

## Configure the Code
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/

## Build the Code
make

## Test the Code

cd ../Testing

wget https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/pcs_refactor_create_profiles.sh
chmod +x pcs_refactor_create_profiles.sh
./pcs_refactor_create_profiles.sh > build.log 2>&1
tail -n 50 build.log



