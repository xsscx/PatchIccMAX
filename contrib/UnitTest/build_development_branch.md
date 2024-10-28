# Hoyt's Development Branch Build Script

This script automates the process of building and testing the DemoIccMAX project using AddressSanitizer (Asan) checks. It is designed to streamline development workflows by performing various steps including repository setup, building, and testing, while logging outputs and capturing critical errors.

## Prerequisites

Before using this script, ensure the following tools are installed on your system:

- **Git**: For cloning and managing the project repository.
- **CMake**: For configuring and generating project build files.
- **Make**: For building the project.
- **AddressSanitizer (Asan)**: For detecting memory issues.
- **Curl**: For downloading test scripts.
- **Bash**: For executing shell commands.

## Script Overview

This script performs the following actions:

1. **Git Configuration**: Sets up the Git user email and name for version control operations.
2. **Repository Cloning**: Clones the DemoIccMAX project from GitHub.
3. **Branch Checkout**: Switches to the `development` branch of the project.
4. **CMake Configuration**: Configures the project with `Debug` build type, enabling AddressSanitizer checks for memory safety.
5. **Build Process**: Compiles the project using `make`.
6. **Running Tests**: Executes a series of unit tests and logs the results, including specific Asan and UBSan checks.
7. **Final Output**: Displays the last 15 lines of logs for review and logs the entire session.

## Usage

### Step 1: Run from Host

```
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/build_development_branch.sh)"
```
