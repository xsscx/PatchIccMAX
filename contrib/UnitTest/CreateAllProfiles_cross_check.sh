#!/bin/sh
##
## Copyright (c) 2024 The International Color Consortium. All rights reserved.
##
## Unit Test for Profile Creation
## Cross Check with Report
##
## Written by David Hoyt for DemoIccMAX Project
## Date: 28-Sept-24
##
echo "Creating Profiles..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/Testing/CreateAllProfiles.sh)" > profile-checks.log 2>&1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/Testing/RunTests.sh)" >> profile-checks.log 2>&1
echo "cd to CalcTest"
cd CalcTest
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/Testing/CalcTest/runtests.sh)" >> ../profile-checks.log 2>&1
echo "cd to HDR"
cd ../HDR
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/Testing/HDR/mkprofiles.sh)" >> ../profile-checks.log 2>&1
echo "cd to Overprint"
cd ../Overprint
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/Testing/Overprint/RunTests.sh)" >> ../profile-checks.log 2>&1
echo "cd mcs"
cd ../mcs
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/Testing/mcs/updateprevWithBkgd.sh)" >> ../profile-checks.log 2>&1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/Testing/mcs/updateprev.sh)" >> ../profile-checks.log 2>&1
echo "cd Testing"
cd ../
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/Testing/testing_summary.sh)" >> ../profile-checks.log 2>&1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/Testing/testing_summary.sh)"
echo "Cross-Check for CreateAllProfiles Done!"
