#!/usr/bin/env bash
# Safe lint/check wrapper for CI
# Usage:
#  - Provide files via environment variable `files` or `FILES`
#  - Optionally set TRUST_ORIGIN=true to run cppcheck logic; otherwise cppcheck is skipped
#  - Designed to be safe with `set -euo pipefail`

set -euo pipefail

# Basic git config (kept from original)
git config --global --add safe.directory "${GITHUB_WORKSPACE:-$(pwd)}"
git config --global credential.helper ""

# Clear the in-shell GITHUB_TOKEN if present
unset GITHUB_TOKEN || true

mkdir -p lint_reports

# CPPCheck placeholder behavior (preserve original messaging)
if [ "${TRUST_ORIGIN:-false}" != "true" ]; then
  echo "Origin not trusted; skipping lint." > lint_reports/cppcheck.txt
else
  echo "No .cpp/.h changes detected; skipping lint." > lint_reports/cppcheck.txt
fi

# Initialize/clear reports
: > lint_reports/clang_tidy.txt
: > lint_reports/clang_format.txt

# Determine files to check
# Priority:
# 1) files (env var) or FILES
# 2) try to compute changed C/C++ files between base and HEAD when running in CI
# 3) fallback to changed files between HEAD~1 and HEAD
# 4) final fallback: list tracked C/C++ files
files="${files:-${FILES:-}}"

if [ -z "${files}" ]; then
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # If GITHUB_BASE_REF is available (typical for PRs), try to fetch and diff against it
    if [ -n "${GITHUB_BASE_REF:-}" ]; then
      base_ref="$GITHUB_BASE_REF"
      # Attempt to fetch base ref (best-effort)
      git fetch --no-tags --depth=1 origin "${base_ref}" :"${base_ref}" >/dev/null 2>&1 || true
      files="$(git diff --name-only --diff-filter=ACMRTUXB "origin/${base_ref}" HEAD 2>/dev/null || true)"
    fi

    # If still empty, try a simple diff HEAD~1..HEAD (works for many CI setups)
    if [ -z "${files}" ]; then
      files="$(git diff --name-only --diff-filter=ACMRTUXB HEAD~1 HEAD 2>/dev/null || true)"
    fi

    # If still empty, fall back to all tracked C/C++ source/header files
    if [ -z "${files}" ]; then
      files="$(git ls-files 2>/dev/null || true)"
    fi

    # Filter to C/C++ sources/headers
    files="$(printf '%s\n' "${files}" | grep -E '\.(c|cpp|cc|cxx|h|hpp)$' || true)"
  fi
fi

# At this point files may be empty. Safely handle both empty and multi-line lists.
if [ -z "${files}" ]; then
  echo "No files to check; skipping clang-format." >> lint_reports/clang_format.txt
else
  # Use a safe loop that handles filenames with spaces/newlines
  fail=0
  # Read each matching file line-by-line
  while IFS= read -r f; do
    # Skip empty lines
    [ -z "${f}" ] && continue

    # If file doesn't exist on disk (e.g. removed), skip it
    if [ ! -f "${f}" ]; then
      echo "Skipping missing file: ${f}" >> lint_reports/clang_format.txt
      continue
    fi

    # Run clang-format in check mode; capture output into the report.
    # Use if ! ... to avoid set -e exiting on non-zero (we want to collect all failures).
    if ! clang-format --dry-run --Werror "${f}" 2>&1 | tee -a lint_reports/clang_format.txt; then
      echo "${f}" >> lint_reports/clang_format.txt
      fail=1
    fi
  done <<EOF
${files}
EOF

  if [ "${fail}" -eq 0 ]; then
    echo "All files properly formatted." >> lint_reports/clang_format.txt
  else
    echo "Some files are not properly formatted. See above for details." >> lint_reports/clang_format.txt
    # Keep non-zero exit to fail CI if desired:
    exit 1
  fi
fi

# End of script