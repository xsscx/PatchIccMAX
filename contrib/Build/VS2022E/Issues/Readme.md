## ASAN VS2022E Details

## Host

```
Microsoft Visual Studio Enterprise 2022
Version 17.11.2
VisualStudio.17.Release/17.11.2+35222.181
Microsoft .NET Framework
Version 4.8.09032
Installed Version: Enterprise
```

## Error Sample

```
ERROR: Failed to override local function at ‘0x0001404564d0’ with sanitizer function ‘__asan_wrap_atol_static’
AddressSanitizer: CHECK failed: sanitizer_win_interception.cpp:143 “((“Failed to replace local function with sanitizer version.” && 0)) != (0)” (0x0, 0x0) (tid=27128)
#0 0x7ffb8f25087f in __asan::CheckUnwind D:\a_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\asan\asan_rtl.cpp:69
#1 0x7ffb8f20f613 in __sanitizer::CheckFailed(char const *, int, char const *, unsigned __int64, unsigned __int64) D:\a_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_termination.cpp:86
#2 0x7ffb8f20ea95 in __sanitizer_override_function D:\a_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_win_interception.cpp:143
#3 0x14002ce3c in __sanitizer::override_function(char const *, unsigned __int64) D:\a_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_win_thunk_interception.cpp:29
#4 0x14002ce0e in __sanitizer::initialize_thunks(int (__cdecl *const *)(void), int (__cdecl *const *)(void)) D:\a_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_win_thunk_interception.cpp:48
#5 0x14002cdb6 in __sanitizer_thunk_init D:\a_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_win_thunk_interception.cpp:82
#6 0x7ffc3f14bfe9 (C:\WINDOWS\SYSTEM32\ntdll.dll+0x18007bfe9)
#7 0x7ffc3f0f8b7e (C:\WINDOWS\SYSTEM32\ntdll.dll+0x180028b7e)
#8 0x7ffc3f0f9808 (C:\WINDOWS\SYSTEM32\ntdll.dll+0x180029808)
#9 0x7ffc3f1aee5c (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800dee5c)
#10 0x7ffc3f19aa19 (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800caa19)
#11 0x7ffc3f1443c2 (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800743c2)
#12 0x7ffc3f1442ed (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800742ed)
```
