echo "Creating Profiles..."
sh ./CreateAllProfiles.sh
sh ./RunTests.sh
echo "cd to CalcTest"
cd CalcTest
sh ./checkInvalidProfiles.sh
sh ./run_tests.sh
echo "cd to HDR"
cd ../HDR
sh ./mkprofiles.sh
echo "cd to Overprint"
cd ../Overprint
sh ./RunTests.sh
echo "cd to Display"
cd ../Display
sh ./RunProtoTests.sh
echo "cd mcs"
cd ../mcs
sh ./updateprevWithBkgd.sh
sh ./updateprev.sh
echo "cd Testing"
cd ../
sh ./testing_summary.sh
echo "done..."
