# Hoyt's Reproduction for Windows ASAN Interceptor Bug

[Bug Report](https://developercommunity.visualstudio.com/t/ASAN-atol_static-interception-failure/10729662?q=asan&fTime=6m&sort=newest)

## Host
```
Microsoft Visual Studio Enterprise 2022
Version 17.12.1
VisualStudio.17.Release/17.12.1+35514.174
Microsoft .NET Framework
Version 4.8.09032
```

## Build

Open Developer Powershell and Paste in the following command to Build with ASAN Logs:

```
set ASAN_OPTIONS=verbosity=1
iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/development/contrib/Build/VS2022C/build_asan.ps1").Content
```

## Expected Output

### ASAN Log

```
Address 0x7ffcda403d50 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcda403d50 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcda3f1f60 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcda3f2ca0 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcd7e7dad0 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcda444dc0 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcd7df0d70 was already intercepted with result: 1. Skipping re-interception.
==28756==AddressSanitizer: failed to intercept 'atoll' in ntdll.dll
==28756==AddressSanitizer: failed to intercept 'strtoll' in ntdll.dll
==28756==AddressSanitizer: libc interceptors initialized
|| `[0x100140300000, 0x7fffffffffff]` || HighMem    ||
|| `[0x020168360000, 0x1001402fffff]` || HighShadow ||
|| `[0x000168360000, 0x02016835ffff]` || ShadowGap  ||
|| `[0x000140300000, 0x00016835ffff]` || LowShadow  ||
|| `[0x000000000000, 0x0001402fffff]` || LowMem     ||
MemToShadow(shadow): 0x000168360000 0x00016d36bfff 0x00416d36c000 0x02016835ffff
redzone=16
max_redzone=2048
quarantine_size_mb=256M
thread_local_quarantine_size_kb=1024K
malloc_context_size=30
SHADOW_SCALE: 3
SHADOW_GRANULARITY: 8
SHADOW_OFFSET: 0x000140300000
Failed to override function _aligned_free_dbg in vcruntime140.dll
Failed to override function _aligned_offset_recalloc_dbg in vcruntime140.dll
Failed to override function _aligned_realloc_dbg in vcruntime140.dll
Failed to override function _aligned_recalloc_dbg in vcruntime140.dll
Failed to override function _expand_dbg in vcruntime140.dll
Failed to override function _free_dbg in vcruntime140.dll
Failed to override function _msize_dbg in vcruntime140.dll
Failed to override function _realloc_dbg in vcruntime140.dll
Failed to override function _recalloc_dbg in vcruntime140.dll
Failed to override function _aligned_free in vcruntime140.dll
Failed to override function _aligned_msize in vcruntime140.dll
Failed to override function _aligned_offset_realloc in vcruntime140.dll
Failed to override function _aligned_offset_recalloc in vcruntime140.dll
Failed to override function _aligned_realloc in vcruntime140.dll
Failed to override function _aligned_recalloc in vcruntime140.dll
Failed to override function _expand in vcruntime140.dll
Failed to override function _expand_base in vcruntime140.dll
Failed to override function _free_base in vcruntime140.dll
Failed to override function _msize in vcruntime140.dll
Failed to override function _msize_base in vcruntime140.dll
Failed to override function realloc in vcruntime140.dll
Failed to override function _realloc_base in vcruntime140.dll
Failed to override function _realloc_crt in vcruntime140.dll
Failed to override function _recalloc in vcruntime140.dll
Failed to override function _recalloc_base in vcruntime140.dll
Failed to override function _recalloc_crt in vcruntime140.dll
Failed to override function free in vcruntime140.dll
Failed to override function _aligned_free_dbg in ucrtbase.dll
Failed to override function _aligned_offset_recalloc_dbg in ucrtbase.dll
Failed to override function _aligned_realloc_dbg in ucrtbase.dll
Failed to override function _aligned_recalloc_dbg in ucrtbase.dll
Failed to override function _expand_dbg in ucrtbase.dll
Failed to override function _free_dbg in ucrtbase.dll
Failed to override function _msize_dbg in ucrtbase.dll
Failed to override function _realloc_dbg in ucrtbase.dll
Failed to override function _recalloc_dbg in ucrtbase.dll
Failed to override function _expand_base in ucrtbase.dll
Failed to override function _msize_base in ucrtbase.dll
Failed to override function _realloc_crt in ucrtbase.dll
Failed to override function _recalloc_base in ucrtbase.dll
Failed to override function _recalloc_crt in ucrtbase.dll
Failed to override function _aligned_free_dbg in ntdll.dll
Failed to override function _aligned_offset_recalloc_dbg in ntdll.dll
Failed to override function _aligned_realloc_dbg in ntdll.dll
Failed to override function _aligned_recalloc_dbg in ntdll.dll
Failed to override function _expand_dbg in ntdll.dll
Failed to override function _free_dbg in ntdll.dll
Failed to override function _msize_dbg in ntdll.dll
Failed to override function _realloc_dbg in ntdll.dll
Failed to override function _recalloc_dbg in ntdll.dll
Failed to override function _aligned_free in ntdll.dll
Failed to override function _aligned_msize in ntdll.dll
Failed to override function _aligned_offset_realloc in ntdll.dll
Failed to override function _aligned_offset_recalloc in ntdll.dll
Failed to override function _aligned_realloc in ntdll.dll
Failed to override function _aligned_recalloc in ntdll.dll
Failed to override function _expand in ntdll.dll
Failed to override function _expand_base in ntdll.dll
Failed to override function _free_base in ntdll.dll
Failed to override function _msize in ntdll.dll
Failed to override function _msize_base in ntdll.dll
Failed to override function realloc in ntdll.dll
Failed to override function _realloc_base in ntdll.dll
Failed to override function _realloc_crt in ntdll.dll
Failed to override function _recalloc in ntdll.dll
Failed to override function _recalloc_base in ntdll.dll
Failed to override function _recalloc_crt in ntdll.dll
Failed to override function free in ntdll.dll
Address 0x7ffcd77a5570 was already intercepted with result: 1. Skipping re-interception.
==28756==SetCurrentThread: 0x0000023a0000 for thread 0x000000007c78
==28756==T0: stack [0x000000050000,0x000000150000) size 0x100000; local=0x00000014ef90
==28756==Using llvm-symbolizer at path: C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.42.34433\bin\HostX64\x64/llvm-symbolizer.exe
==28756==AddressSanitizer Init done
==28756==ERROR: Failed to override local function at '0x0001401ccc40' with sanitizer function '__asan_wrap_atol_static'
AddressSanitizer: CHECK failed: sanitizer_win_interception.cpp:149 "(("Failed to replace local function with sanitizer version." && 0)) != (0)" (0x0, 0x0) (tid=31864)
    #0 0x7ffbe7327f7f in __asan::CheckUnwind D:\a\_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\asan\asan_rtl.cpp:70
    #1 0x7ffbe72df993 in __sanitizer::CheckFailed(char const *, int, char const *, unsigned __int64, unsigned __int64) D:\a\_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_termination.cpp:86
    #2 0x7ffbe72dee15 in __sanitizer_override_function D:\a\_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_win_interception.cpp:149
    #3 0x0001400047cc in main E:\rpppp\PatchIccMAX\Tools\CmdLine\IccDumpProfile\iccDumpProfile.cpp:349
    #4 0x00014000479e in main E:\rpppp\PatchIccMAX\Tools\CmdLine\IccDumpProfile\iccDumpProfile.cpp:348
    #5 0x000140004746 in main E:\rpppp\PatchIccMAX\Tools\CmdLine\IccDumpProfile\iccDumpProfile.cpp:343
    #6 0x7ffcda2fd852  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x18001d852)
    #7 0x7ffcda30380f  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x18002380f)
    #8 0x7ffcda38dcc1  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800adcc1)
    #9 0x7ffcda38bddf  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800abddf)
    #10 0x7ffcda3fefa2  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x18011efa2)
    #11 0x7ffcda3d235d  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800f235d)

```