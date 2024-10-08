
# DemoIccMAX XNU Build Script for macOS

**tl;dr:**

Copy and Paste the folowing Command into your Terminal to Build the DemoIccMAX Project:

   ```
   cd /tmp
   /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/cmake/xnu_build_master_branch.zsh)"
   ```

## Overview
This script automates the build process for the DemoIccMAX project, which is part of the International Color Consortium's (ICC) open-source initiatives. It sets up the development environment, installs dependencies, reverts a specific commit, and builds the project using `cmake` and `make`. It also runs additional profile creation tests using a provided script.

## Prerequisites
Before running the script, ensure the following requirements are met:

- **Operating System**: macOS with Homebrew installed.
- **Required Tools**:
  - `git`
  - `brew`
  - `curl`
  - `cmake`
  - `clang`
  - `wxmac`
  - `libxml2`
  - `libtiff`

### Dependencies Installation
The script automatically installs the following dependencies using Homebrew:
- `curl`
- `git`
- `cmake`
- `clang`
- `wxmac`
- `libxml2`
- `libtiff`

Ensure Homebrew is installed and functional on your system for smooth execution of this step.

## Script Breakdown
The script performs the following actions:

### 1. Logging Setup
A log file is created to record all stdout and stderr output. The log file name is timestamped for clarity and traceability.

### 2. Git Configuration
The script configures `git` with a predefined user and email (used for GitHub Actions automation):
- User: GitHub Actions
- Email: `github-actions@github.com`

### 3. Cloning the Repository
The script clones the `DemoIccMAX` repository from the master branch into the current working directory.

### 4. Reverting a Commit
It reverts a specific bad commit (`6ac1cc6`) in the repository.

### 5. Installing Dependencies
The necessary packages for building the project are installed using Homebrew.

### 6. Building the Project
The build process involves the following steps:
- **CMake Configuration**: Configures the project build with debugging options and sanitizers enabled.
- **Make Build**: Runs the `make` command using all available CPU cores.

### 7. Listing Built Files
After a successful build, the script lists all executable files, libraries (`.a`, `.so`, `.dylib`), and any files created within the last 24 hours.

### 8. Testing and Profile Creation
The script moves into the `Testing` directory and runs a provided script to create ICC profiles for testing purposes using a remote script fetched from the project's repository.

### 9. Elapsed Time Calculation
The script calculates and prints the total time taken for the entire build process.

## How to Use

### Step 1: Clone and Run
Clone the repository that contains this script or download it directly.

```bash
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
```

### Step 2: Execute the Script
Make the script executable and run it:

```bash
chmod +x build.sh
./build.sh
```

### Step 3: Follow the Logs
The script logs all its actions to a file with a name format similar to `build_log_YYYY-MM-DD_HH-MM-SS.log`, which is created in the current directory. You can follow along with the real-time logs or refer to the log file after the script completes.

### Step 4: Verify the Build
After the script completes successfully, verify the built files by checking the list printed at the end of the script.

## Error Handling
The script terminates if any command fails, displaying an error message. It checks for errors during:
- Git configuration
- Repository cloning
- Commit reversion
- CMake configuration
- Build process
- Profile creation

Ensure all prerequisites are installed and properly configured before running the script to avoid interruptions.

