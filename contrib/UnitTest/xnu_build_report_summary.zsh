#!/bin/zsh
#
## Copyright (©) 2024 David H Hoyt. All rights reserved.
## 
## Last Updated: 02-DEC-2024 by David Hoyt (©)
#
## Intent: Create a Build Report Summary for XNU Xcode Build Outputs
#
## TODO: Refactor CMake:CMakeLists.txt Configs 
#       Refactor for CI:CD Build Pilelines Azure:Github
#       Add Logging
#       Add to Post-Build Processing in Xcode
#       Fiddle with Cmake Configuration Args
#
#

git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
git checkout xnu
cd Build/XCode
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON  -Wno-dev ../Cmake/ -G "Xcode" -DCMAKE_VERBOSE_MAKEFILE=ON -Wdev -Werror=dev -DENABLE_STATIC_LIBS=ON -DCMAKE_VERBOSE_MAKEFILE=ON
xcodebuild -target ALL_BUILD -configuration "Release"
