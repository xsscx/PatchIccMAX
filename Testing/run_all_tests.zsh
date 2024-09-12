echo "Creating Profiles..."
./CreateAllProfiles.sh
./run_tests.zsh
echo "cd to CalcTest"
cd CalcTest
./checkInvalidProfiles.sh
./run_tests.zsh
echo "cd to HDR"
cd ../HDR
./mkprofiles.sh
echo "cd to Overprint"
cd ../Overprint
./RunTests.sh
echo "cd to Display"
cd ../Display
./RunProtoTests.sh
echo "cd mcs"
cd ../mcs
./updateprevWithBkgd.sh
./updateprev.sh
echo "cd Testing"
cd ../
./testing_summary.zsh
echo "done..."
