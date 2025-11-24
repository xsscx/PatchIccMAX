#!/bin/zsh
# =============================================================================
# iccDEV Build Helper for zsh
# Author: xsscx (DHoyt) Copyright (C) 2023-2025
# Use: source iccdev.zsh
#      or
#      chmod +x iccdev.zsh
#      ./iccdev.zsh
#
#
#      Detected platform: linux
#      iccDEV Build Helper (zsh)
#      Usage: help_menu <task>
#      Available tasks:
#                clone_repo          Clone iccDEV repo
#                build_ubuntu_gnu    Build iccDEV (GNU toolchain, Ubuntu)
#                build_debug_asan    Configure Debug/ASAN build
#                build_macos_clang   Build iccDEV (macOS Clang)
#                unix_add_tools_path Add Build/Tools/* to PATH
#                run_unix_tests      Run ICC test suite across submodules
#
#                Example:
#                        source .iccdev.zsh
#                        run_unix_tests
#
#
#
#
#
# =============================================================================

autoload -U colors && colors

log() { print -- "%B%F{blue}[+]%f%b $*"; }
err() { print -- "%B%F{red}[!]%f%b $*" >&2; }

export PATCH_ICCDEV_HOME="$HOME/src/"
mkdir -p "$PATCH_ICCDEV_HOME"

case "$(uname -s)" in
  Darwin) PLATFORM="macos" ;;
  Linux)  PLATFORM="linux" ;;
  *)      PLATFORM="unknown" ;;
esac
log "Detected platform: $PLATFORM"

# ===========================================================
# TASKS
# ===========================================================

clone_repo() {
  log "Cloning iccDEV repo..."
  cd "$PATCH_ICCDEV_HOME" || return 1
  git clone https://github.com/InternationalColorConsortium/iccDEV.git || err "Clone failed"
  pwd
}

build_ubuntu_gnu() {
  if [[ "$PLATFORM" != "linux" ]]; then
    err "This task is intended for Linux (Ubuntu)."
    return 1
  fi

  log "Building iccDEV under Ubuntu GNU toolchain..."
  export CXX=g++
  sudo apt update
  sudo apt install -y libpng-dev libjpeg-dev libwxgtk3.2-dev \
    libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers \
    libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev \
    nlohmann-json3-dev build-essential

  git clone https://github.com/InternationalColorConsortium/iccDEV.git
  cd iccDEV/Build || return 1
  cmake Cmake
  make -j"$(nproc)"
  cd ../../
}

build_debug_asan() {
  log "Configuring Debug + ASAN build..."
  cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer" \
        -DENABLE_TOOLS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_SHARED_LIBS=ON \
        -Wno-dev Cmake/
  make -j"$(nproc 2>/dev/null || sysctl -n hw.ncpu)"
  cd ../../
  pwd
}

build_macos_clang() {
  if [[ "$PLATFORM" != "macos" ]]; then
    err "This task is intended for macOS."
    return 1
  fi

  log "Building iccDEV under macOS Clang toolchain..."
  export CXX=clang++
  brew install libpng nlohmann-json libxml2 wxwidgets libtiff jpeg
  git clone https://github.com/InternationalColorConsortium/iccDEV.git
  cd iccDEV || return 1
  cmake -G "Xcode" Build/Cmake
  xcodebuild -project RefIccMAX.xcodeproj
  open RefIccMAX.xcodeproj
  cd ../../
  pwd
}

# ===========================================================
# UNIX TESTING / TOOL PATH SETUP
# ===========================================================
unix_add_tools_path() {
  pwd
  log "=== Updating PATH with Build/Tools directories ==="
  cd Testing 2>/dev/null || { err "Missing Testing directory"; return 1; }

  for d in ../Build/Tools/*; do
    [[ -d "$d" ]] && export PATH="$(realpath "$d"):$PATH"
  done

  log "PATH updated."
  cd ../
}

run_unix_tests() {
  log "========= BEGIN INSIDE STUB ========="
  cd Testing 2>/dev/null || { err "Testing directory not found"; return 1; }

  log "=== Updating PATH ==="
  for d in ../Build/Tools/*; do
    [[ -d "$d" ]] && export PATH="$(realpath "$d"):$PATH"
  done

  log "Executing ICC profile test suites..."
  sh CreateAllProfiles.sh || err "CreateAllProfiles failed"
  sh RunTests.sh || err "RunTests failed"

  # Sequential subdir test runs
  for sub in HDR hybrid CalcTest mcs; do
    log "Entering $sub ..."
    cd "$sub" 2>/dev/null || { err "Missing $sub directory"; continue; }
    case "$sub" in
      HDR)
        sh mkprofiles.sh || err "mkprofiles.sh failed"
        ;;
      hybrid)
        sh BuildAndTest.sh || err "BuildAndTest failed"
        ;;
      CalcTest)
        sh checkInvalidProfiles.sh || err "checkInvalidProfiles failed"
        ;;
      mcs)
        sh updateprev.sh || err "updateprev failed"
        sh updateprevWithBkgd.sh || err "updateprevWithBkgd failed"
        ;;
    esac
    cd .. || return 1
  done
  log "========= END TEST STUB ========="
  cd ../
}

# ===========================================================
# Menu
# ===========================================================
help_menu() {
  cat <<EOF

iccDEV Build Helper (zsh)

Usage: $0 <task>

Available tasks:
  clone_repo          Clone iccDEV repo
  build_ubuntu_gnu    Build iccDEV (GNU toolchain, Ubuntu)
  build_debug_asan    Configure Debug/ASAN build
  build_macos_clang   Build iccDEV (macOS Clang)
  unix_add_tools_path Add Build/Tools/* to PATH
  run_unix_tests      Run ICC test suite across submodules

Example:
    source .iccdev.zsh
    run_unix_tests

EOF
}

# Entry
if [[ -z "$1" ]]; then
  help_menu
else
  case "$1" in
    test_repo|build_ubuntu_gnu|build_debug_asan|build_macos_clang|unix_add_tools_path|run_unix_tests)
      "$1"
      ;;
    *)
      err "Unknown task: $1"
      help_menu
      ;;
  esac
fi
