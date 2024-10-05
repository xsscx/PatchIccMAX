# PCS_Refactor Unit Test Script

This script is used to automate unit testing and refactoring for the `PCS_Refactor` branch of the DemoIccMAX project. It applies AddressSanitizer (Asan) checks and performs several build and test steps including reverting commits, resolving conflicts, building the project, and running tests to ensure code stability and correctness.

## Prerequisites

Ensure the following tools are installed and properly configured:

- **Git**: For cloning and managing repositories.
- **CMake**: For building the project.
- **Make**: To compile the project.
- **Curl**: To fetch external test scripts.
- **AddressSanitizer (Asan)**: To detect memory issues like buffer overflows or memory leaks.
- **Bash**: For running shell commands.

## Script Overview

The script performs the following key actions:

1. **Git Configuration**: Sets up Git user details for this session.
2. **Repository Cloning**: Clones the DemoIccMAX project repository.
3. **Branch Checkout**: Checks out the `PCS_Refactor` branch for refactoring.
4. **Commit Revert and Conflict Resolution**: Attempts to revert a specific commit and resolves any conflicts non-interactively.
5. **Build Configuration and Compilation**: Configures and builds the project using CMake and Make, with AddressSanitizer enabled.
6. **Test Execution**: Runs a variety of Asan and UBSan tests, including allocator mismatch checks and profile creation tests.
7. **Cross-check Testing**: Performs cross-profile checks and additional tests to validate profile correctness.

## How to Run

### Step 1: Run from Host

Ensure you are in the appropriate directory before running the script.

```
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/pcs_revert_build_asan_report.sh)"
```
