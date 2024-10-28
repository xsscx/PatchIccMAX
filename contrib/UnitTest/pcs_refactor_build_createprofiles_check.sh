#!/bin/sh
##
## Unit Test for PCS_Refactor
## Asan Checks for CreateAllProfiles.sh
##
## David Hoyt for DemoIccMAX Project
## Date: 27-Sept-24
##

echo "Step 1: Configuring Git user for this session"
git config --global user.email "github-actions@github.com" || { echo "Error: Git config failed. Exiting."; exit 1; }
git config --global user.name "GitHub Actions" || { echo "Error: Git config failed. Exiting."; exit 1; }
echo "Git user configuration done."

echo "Step 2: Cloning DemoIccMAX repository"
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git || { echo "Error: Git clone failed. Exiting."; exit 1; }
cd DemoIccMAX/ || { echo "Error: Failed to change directory to DemoIccMAX. Exiting."; exit 1; }
echo "Repository cloned and switched to DemoIccMAX directory."

echo "Step 3: Checking out PCS_Refactor branch"
git checkout PCS_Refactor || { echo "Error: Git checkout PCS_Refactor failed. Exiting."; exit 1; }
echo "PCS_Refactor branch checked out."

echo "Step 4: Attempting to revert commit b90ac3933da99179df26351c39d8d9d706ac1cc6 non-interactively"
# Perform the revert non-interactively, skip conflicts, and use the current branch's version.
git revert --no-edit b90ac3933da99179df26351c39d8d9d706ac1cc6 || { echo "Revert conflict detected. Attempting to resolve conflicts automatically."; }

# Check if there are conflicts
if [ $(git ls-files -u | wc -l) -gt 0 ]; then
    echo "Conflicts found. Resolving conflicts automatically by using the current branch version."
    git ls-files -u | awk '{print $4}' | xargs git add

    echo "Continuing the revert after resolving conflicts"
    git revert --continue --no-edit || { echo "Error: Git revert --continue failed. Exiting."; exit 1; }
else
    echo "No conflicts detected. Revert completed successfully."
fi

echo "Step 5: Changing to Build directory"
cd Build/ || { echo "Error: Directory change to Build/ failed. Exiting."; exit 1; }
echo "Changed to Build directory."

echo "Step 6: Configuring the build with CMake"
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
      -Wno-dev Cmake/ || { echo "Error: CMake configuration failed. Exiting."; exit 1; }
echo "CMake configuration completed."

echo "Step 7: Building the PCS_Refactor code with make"
make -j$(nproc) || { echo "Error: Build failed. Exiting."; exit 1; }
echo "Build completed successfully."

# Optionally, uncomment and adjust the test step if required
echo "Step 8: Running the initial asan tests"
cd ../Testing || { echo "Error: Directory change to Testing failed. Exiting."; exit 1; }
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/pcs_refactor_create_profiles.sh)" > CreateAllProfiles.log 2>&1
echo "Asan Tests completed. Logs saved in CreateAllProfiles.log. Here is 50 Lines... "
tail -n 50 CreateAllProfiles.log

# Step 9: Running some asan tests
echo "Step 9: Running the iccApplyNamedCmm allocator mismatch check"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/iccApplyNamedCmm_allocator_mismatch_check.sh)" > asan-checks.log 2>&1
tail -n 50 asan-checks.log

# Step 10: Running last asan test
echo "Step 10: Running ubsan icPlatformSignature check"
/bin/bash -c 'curl -fsSL -o iccProfile.icc https://github.com/xsscx/PatchIccMAX/raw/development/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc && ../Build/Tools/IccDumpProfile/iccDumpProfile 100 iccProfile.icc ALL'

# Step 11: Running last overflow test
echo "Step 11: Running last overflow Check"
cd Overprint/
cp  Spot-OSIM/Spot11-offsetXYZ.txt  Spot-OSIM/Spot11-scaleXYZ.txt
../../Build/Tools/IccFromXml/iccFromXml 17ChanPart1.xml 17Chan.icc
cd ..
pwd

# Step 12: Running last set of asan tests
echo "Step 12: Running the Profile Cross Check"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/CreateAllProfiles_cross_check.sh)"

echo "All steps completed successfully."
