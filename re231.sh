#!/usr/bin/env bash
##
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt
## Date: 23-OCT-2025 2000 EDT
#
# Branch: re231
# Intent: Build all Libs & Tools
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

set +e  # keep forgiving behavior
LOG_FILE="iccmax_repro_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== START PatchIccMAX REPRO ====="
date

#
git clone https://github.com/xsscx/PatchIccMAX.git || true
cd PatchIccMAX/Build || exit 1
git checkout re231
cmake Cmake
echo "===== Starting Build ====="
make -j"$(nproc)" 2>&1 | grep -E "error|Error|ERROR"
echo "===== Finished Build ====="
cd ../Testing || exit 1
echo "=== Updating PATH ==="
for d in ../Build/Tools/*; do
  [ -d "$d" ] && export PATH="$(realpath "$d"):$PATH"
done

echo "========= BEGIN INSIDE STUB ========="

cd ../Testing/
echo "=== Updating PATH ==="
for d in ../Build/Tools/*; do
  [ -d "$d" ] && export PATH="$(realpath "$d"):$PATH"
done

# External CI/CD test harness
sh CreateAllProfiles.sh

# Unit tests
sh RunTests.sh

# HDR profiles
(cd HDR && sh mkprofiles.sh)

# Hybrid builds/tests
(cd hybrid && sh BuildAndTest.sh)

# CalcTest invalid profile checks
(cd CalcTest && sh checkInvalidProfiles.sh)

# MCS tests
(cd mcs && sh updateprev.sh && sh updateprevWithBkgd.sh)

# Round-trip validation
../Build/Tools/IccRoundTrip/iccRoundTrip PCC/Lab_float-D50_2deg.icc

# Profile dump validation
# bash -c "$(curl -fsSL \
#   https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/research/contrib/UnitTest/iccDumpProfile_checks.zsh)"

# CMM apply validation
cd ../Build
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/research/contrib/CalcTest/test_icc_apply_named_cmm.sh)"
cd ..

cd contrib/Build/cmake/cov
bash build.sh
cd licc
bash compile.sh
ls -la
./licc
./iccScan-v231-beta
cd ../../../../../

# Report Summary
bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/re231/contrib/UnitTest/ubu-alt-summary.sh)"

echo "===== END PatchIccMAX REPRO ====="
echo "Logs saved to $LOG_FILE"
