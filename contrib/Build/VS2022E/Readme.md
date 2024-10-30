# Visual Studio 2022 Enterprise Build Instructions

## Requirements
- Windows 11
- VS2022
- Git for Windows
  
### Automated Windows & Profile Build

- Dynamic Link

```
iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/build_revert_master_branch_release.ps1").Content
```

- Static Link

```
iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022E/static_build_cli_production.ps1").Content
```

## Expected Output

```
09:59:21:813	19>------ Build started: Project: All, Configuration: Debug x64 ------
09:59:21:934	19>"All Done!"
09:59:21:943	========== Build: 19 succeeded, 0 failed, 0 up-to-date, 0 skipped ==========
09:59:21:943	========== Build completed at 9:59 AM and took 28.105 seconds ==========
```
