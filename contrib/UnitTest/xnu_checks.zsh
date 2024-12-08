#!/bin/zsh
#
## Copyright (©) 2024 David H Hoyt. All rights reserved.
## 
## Last Updated: 02-DEC-2024 by David Hoyt (©)
#
## Intent: Poll the Device and Report
#
## TODO: Refactor for all XNU Device Reporting
#
#


        sysctl -a | grep kern.version
        sysctl -a | grep kern.osversion
        sysctl -a | grep kern.iossupportversion
        sysctl -a | grep kern.osproductversion
        sysctl -a | grep machdep.cpu.brand_string
        csrutil status
        xcrun --show-sdk-path
        xcode-select -p
        clang -v
        clang -### -c test.c 2>&1 | grep -i 'cc1args'
        ld -v
        lldb --version
        env | grep -i xcode
        env | grep -i sdk
        env | grep -i clang
        env | grep -i cflags
        env | grep -i ldflags
        env | grep -i CC
        env | grep -i C++
        brew list --versions
        ls -l /usr/lib/dyld
        df -h
        which make
        which ninja
        which cmake
        which lldb
        which cc
        which gcc
        which clang++
        lldb --version
        sips --version
