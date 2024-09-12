call checkInvalidProfiles
/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml calcCheckInit.xml calcCheckInit.icc
/tmp/test/DemoIccMAX/Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm -debugcalc rgbExercise8bit.txt 0 1 calcCheckInit.icc 1 >> report.txt
/tmp/test/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml calcExercizeOps.xml calcExercizeOps.icc
/tmp/test/DemoIccMAX/Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm -debugcalc rgbExercise8bit.txt 0 1 calcExercizeOps.icc 1 >> report.txt
