
# Bug Reporting Guidelines

Thank you for helping to improve the DemoIccMAX project! We encourage contributions through bug reports, but to make them effective, please follow the guidelines below.

## What to Include in a Bug Report

A good bug report should be clear, detailed, and reproducible. Follow this checklist to provide all the necessary information:

### 1. **Summary**
   - **Title**: Provide a short, descriptive title of the issue (e.g., "Crash when applying profile on macOS with Asan enabled").
   - **Brief Description**: Summarize the issue in 1-2 sentences. Include the expected and actual behavior.

### 2. **Steps to Reproduce**
   Clearly list the steps required to reproduce the issue. If it involves specific scripts or commands, include them.

   Example:
   ```bash
   1. Run `CreateAllProfiles.sh`
   2. Apply profile to the test image.
   3. Observe the crash during execution.
   ```

### 3. **Expected Behavior**
   Describe what you expected to happen without the bug.

### 4. **Actual Behavior**
   Describe what actually happened. If applicable, include error messages, stack traces, or logs.

### 5. **Environment Information**
   Provide details about the environment where the bug was observed:
   - **OS**: (e.g., macOS 13.2, Ubuntu 22.04)
   - **Compiler**: (e.g., GCC 11.3.0, Clang 14.0.0)
   - **Sanitizers**: If relevant, specify any memory or undefined behavior sanitizers in use (e.g., AddressSanitizer, UndefinedBehaviorSanitizer).
   - **DemoIccMAX Version**: Specify the version or branch of the project (e.g., `master`, `pr94`, or commit hash `abcd1234`).

### 6. **Logs and Screenshots**
   Attach relevant logs, screenshots, or console outputs to help diagnose the issue. If the issue involves a crash, include a stack trace.

   - Logs: Upload logs in text format.
   - Screenshots: Highlight key issues visually when applicable.

### 7. **Sample Files**
   Provide sample files (e.g., test profiles or scripts) that can be used to reproduce the issue.

### 8. **Additional Information**
   If applicable, provide any additional context that might help the maintainers understand and reproduce the issue, such as:
   - **Recent changes**: Any recent modifications or updates that could be related.
   - **Attempts to fix**: Mention if you've tried troubleshooting or fixing the issue.

## Bug Report Example

**Title**: Crash when using `iccApplyNamedCmm` with D65 illuminant.

**Description**: When applying a profile to an image with the `iccApplyNamedCmm` tool using a D65 illuminant, the tool crashes with a segmentation fault.

**Steps to Reproduce**:
1. Build the `pr94` branch with AddressSanitizer enabled.
2. Run the following command:
   ```bash
   ./iccApplyNamedCmm Named/FluorescentNamedColorTest.txt 2 0 Named/FluorescentNamedColor.icc 3 -pcc PCC/Spec400_10_700-D65_2deg-Abs.icc SpecRef/SixChanCameraRef.icc 1
   ```
3. Observe the segmentation fault during the profile application.

**Expected Behavior**: The profile should be applied without errors, and the tool should output the processed image.

**Actual Behavior**: The tool crashes with a segmentation fault after attempting to apply the profile.

**Environment**:
- **OS**: Ubuntu 22.04
- **Compiler**: Clang 14.0.0
- **Sanitizers**: AddressSanitizer (Asan) enabled
- **DemoIccMAX Version**: pr94 branch, commit `abc1234`

**Logs**:
```
==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x6020000001f0 at pc 0x555555555555 bp 0x7fffffffe090 sp 0x7fffffffe080
```

**Sample File**: 
- `FluorescentNamedColorTest.txt`
- `PCC/Spec400_10_700-D65_2deg-Abs.icc`

## How to Submit

Submit your bug report via:
- **GitHub Issues**: [Submit Issue](https://github.com/InternationalColorConsortium/DemoIccMAX/issues)

---

By following these guidelines, you help maintainers resolve issues faster and keep the project stable and reliable. Thank you for your contribution!
