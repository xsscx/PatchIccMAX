# [iccDEV v2.3.1](https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz)

## BREW Package

Last Updated: 08-NOV-2025 0200Z by D Hoyt

```
class Iccdev < Formula
  desc "Libraries and tools for ICC color management profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"

```

### History Sample

| Version / Change | Reference |
|------------------:|:-----------|
| **iccMAX 2.1.26** | [Homebrew PR #221560](https://github.com/Homebrew/homebrew-core/pull/221560) |
| **iccMAX 2.2.50** | [Homebrew PR #232375](https://github.com/Homebrew/homebrew-core/pull/232375) |
| **Renamed Formula** | [Homebrew PR #232435](https://github.com/Homebrew/homebrew-core/pull/232435) |
| **iccDEV 2.3.1** | [Homebrew PR #250463](https://github.com/Homebrew/homebrew-core/pull/250463) |

**HOST**

```
Linux 6.6.87.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun  5 18:30:46 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
Darwin 25.1.0 Darwin Kernel Version 25.1.0: Mon Oct 20 19:32:47 PDT 2025; root:xnu-12377.41.6~2/RELEASE_ARM64_T8103 arm64
Darwin 24.6.0 Darwin Kernel Version 24.6.0: Wed Oct 15 21:12:21 PDT 2025; root:xnu-11417.140.69.703.14~1/RELEASE_X86_64 x86_64
```

## Brew Packaging Reproduction

1. Fork https://github.com/Homebrew/homebrew-core
2. Create branch iccdev-formula
3. Update Formula/i/iccdev.rb

### iccDEV Maintainer Checklist

[Releases](https://github.com/InternationalColorConsortium/iccDEV/releases/tag/v2.3.1) are processed by Homebrew-Core in the normal course of business.  When updating [iccDEV Formula](https://raw.githubusercontent.com/Homebrew/homebrew-core/refs/heads/main/Formula/i/iccdev.rb)  please run these tests on **macOS arm64** prior to opening a [PR](https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request):

**License:** Verify BSD-3-Clause in Formula/i/iccdev.rb

**Content:** [Acceptable Forumla](https://docs.brew.sh/Acceptable-Formulae)

**Checks:** macOS arm64 strict

```
brew update-reset && brew update --force --quiet && \
brew cleanup -s && \
rm -rf "$(brew --cache)/downloads"/*{lz4,giflib,jpeg,libpng,iccdev}* /tmp/*iccdev* "$(brew --prefix)/Cellar/iccdev" 2>/dev/null || true && \
brew uninstall --force iccdev local/iccdev/iccdev 2>/dev/null || true && \
brew list | grep iccdev || echo "iccdev not installed (clean state)" && \
brew style local/iccdev/iccdev && brew audit --strict local/iccdev/iccdev && brew audit --new local/iccdev/iccdev && \
brew deps --tree --annotate --include-build --include-test local/iccdev/iccdev && \
brew fetch --formulae --force --retry cmake giflib jpeg jpeg-turbo libpng libtiff lz4 nlohmann-json pcre2 pkgconf webp wxwidgets xz zstd && \
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source local/iccdev/iccdev && \
brew test --verbose local/iccdev/iccdev && brew info local/iccdev/iccdev && \
brew linkage --cached --test --strict local/iccdev/iccdev && \
brew uninstall --formula --force --ignore-dependencies iccdev && \
brew cleanup -s && \
brew uninstall --formulae --force --ignore-dependencies cmake giflib jpeg jpeg-turbo libpng libtiff lz4 nlohmann-json pcre2 pkgconf webp wxwidgets xz zstd 2>/dev/null || true
```

## Cross Platform Reproduction

### Ubuntu 24

#### Create iccdev.rb

```
cat <<'EOF' > /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
class Iccdev < Formula
  desc "Libraries and tools for ICC color management profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "nlohmann-json"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
EOF
```

### Ubuntu 24

#### Run Checks

```
brew update-reset && brew update --force --quiet
brew uninstall iccdev
brew uninstall --force iccdev 2>/dev/null || true
brew cleanup -s iccdev 2>/dev/null || true
rm -rf "$(brew --cache)/iccdev--*" "$(brew --cache)/downloads/iccdev--*" 2>/dev/null || true
rm -rf /tmp/*iccdev* "$(brew --prefix)/Cellar/iccdev" 2>/dev/null || true
brew list | grep iccdev || echo "iccdev not installed (clean state)"
brew style local/iccdev/iccdev
brew audit --new local/iccdev/iccdev
brew audit --strict local/iccdev/iccdev
brew uninstall --force iccdev 2>/dev/null || true
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source local/iccdev/iccdev
brew style local/iccdev/iccdev
brew audit --strict local/iccdev/iccdev
brew audit --new local/iccdev/iccdev
brew test local/iccdev/iccdev
brew info local/iccdev/iccdev
brew uninstall --force iccdev
brew cleanup -s iccdev
```

### Ubuntu 24

#### Expected Output

```
Uninstalling iccdev... (82 files, 9.5MB)
Removing: /home/xss/.cache/Homebrew/iccdev--2.3.1.tar.gz... (35.5MB)
==> This operation has freed approximately 35.5MB of disk space.
iccdev not installed (clean state)

1 file inspected, no offenses detected
==> Fetching downloads for: iccdev
✔︎ Formula iccdev (2.3.1)
==> Installing iccdev from local/iccdev
==> cmake -S Build/Cmake -B build -DCMAKE_INSTALL_RPATH=/home/linuxbrew/.linuxbrew/opt/iccdev/lib
==> cmake --build build
==> cmake --install build
🍺  /home/linuxbrew/.linuxbrew/Cellar/iccdev/2.3.1: 82 files, 9.5MB, built in 20 seconds
==> Running `brew cleanup iccdev`...
Disable this behaviour by setting `HOMEBREW_NO_INSTALL_CLEANUP=1`.
Hide these hints with `HOMEBREW_NO_ENV_HINTS=1` (see `man brew`).

1 file inspected, no offenses detected
==> Testing local/iccdev/iccdev
==> /home/linuxbrew/.linuxbrew/Cellar/iccdev/2.3.1/bin/iccFromXml /home/linuxbrew/.linuxbrew/Cellar/iccdev/2.3.1/share/iccdev/CameraModel.xml output.icc
==> /home/linuxbrew/.linuxbrew/Cellar/iccdev/2.3.1/bin/iccToXml output.icc output.xml

==> local/iccdev/iccdev: stable 2.3.1
ICC libraries and tools for working with color profiles
https://github.com/InternationalColorConsortium/iccDEV
Installed
/home/linuxbrew/.linuxbrew/Cellar/iccdev/2.3.1 (82 files, 9.5MB) *
  Built from source on 2025-11-07 at 10:21:11
From: /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
License: BSD-3-Clause
==> Dependencies
Build: cmake ✔
Required: jpeg ✔, libpng ✔, libtiff ✔, nlohmann-json ✔, wxwidgets ✔, libxml2 ✔
```

### macOS Reproduction arm64

#### Create iccdev.rb

```
cat <<'EOF' > /opt/homebrew/Homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
class Iccdev < Formula
  desc "Libraries and tools for ICC color management profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"
...
EOF
```

### macOS arm64 - Run Checks

- Run Checks

```
brew update-reset && brew update --force --quiet
brew uninstall iccdev
brew uninstall --force iccdev 2>/dev/null || true
brew cleanup -s iccdev 2>/dev/null || true
rm -rf "$(brew --cache)/iccdev--*" "$(brew --cache)/downloads/iccdev--*" /tmp/*iccdev* "$(brew --prefix)/Cellar/iccdev" 2>/dev/null || true
brew list | grep iccdev || echo "iccdev not installed (clean state)"
brew style local/iccdev/iccdev
brew audit --strict local/iccdev/iccdev
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source local/iccdev/iccdev
brew style local/iccdev/iccdev
brew audit --strict local/iccdev/iccdev
brew test local/iccdev/iccdev
brew info local/iccdev/iccdev
brew uninstall --force iccdev
rm -rf "$(brew --cache)/iccdev--*" "$(brew --cache)/downloads/iccdev--*" /tmp/*iccdev* "$(brew --prefix)/Cellar/iccdev" 2>/dev/null || true
brew cleanup -s iccdev
```

### macOS arm64 -  Expected Output

- Verify Output

```
...
==> Fetching downloads for: iccdev
✔︎ Bottle Manifest jpeg (9f)                    [Downloaded   10.7KB/ 10.7KB]
✔︎ Bottle jpeg (9f)                             [Downloaded  307.8KB/307.8KB]
✔︎ Bottle Manifest wxwidgets (3.3.1)            [Downloaded   46.2KB/ 46.2KB]
✔︎ Bottle wxwidgets (3.3.1)                     [Downloaded    8.6MB/  8.6MB]
✔︎ Formula iccdev (2.3.1)                       [Verifying    35.5MB/ 35.5MB]
==> Installing iccdev from local/iccdev
==> Installing dependencies for local/iccdev/iccdev: jpeg and wxwidgets
==> Installing local/iccdev/iccdev dependency: jpeg
==> Pouring jpeg--9f.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/jpeg/9f: 22 files, 903.4KB
==> Installing local/iccdev/iccdev dependency: wxwidgets
==> Pouring wxwidgets--3.3.1.arm64_tahoe.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/wxwidgets/3.3.1: 870 files, 28.7MB
==> Installing local/iccdev/iccdev
==> cmake -S Build/Cmake -B build -DCMAKE_INSTALL_RPATH=/opt/homebrew/opt/iccdev/lib
==> cmake --build build
==> cmake --install build
🍺  /opt/homebrew/Cellar/iccdev/2.3.1: 82 files, 6.6MB, built in 17 seconds
==> Running `brew cleanup iccdev`...
Disable this behaviour by setting `HOMEBREW_NO_INSTALL_CLEANUP=1`.
Hide these hints with `HOMEBREW_NO_ENV_HINTS=1` (see `man brew`).
/opt/homebrew/Library/Homebrew/vendor/bundle/ruby/3.4.0/bin/bundle
==> Testing local/iccdev/iccdev
==> /opt/homebrew/Cellar/iccdev/2.3.1/bin/iccFromXml /opt/homebrew/Cellar/iccdev/2.3.1/share/iccdev/CameraModel.xml output.icc
Profile parsed and saved correctly

==> /opt/homebrew/Cellar/iccdev/2.3.1/bin/iccToXml output.icc output.xml
XML successfully created
==> local/iccdev/iccdev: stable 2.3.1 (bottled)
Libraries and tools for cross-platform color management systems from the ICC
https://github.com/InternationalColorConsortium/iccDEV
Installed
/opt/homebrew/Cellar/iccdev/2.3.1 (82 files, 6.6MB) *
  Built from source on 2025-11-07 at 16:00:05
From: /opt/homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
License: BSD-3-Clause
==> Dependencies
Build: cmake ✔, nlohmann-json ✔
Required: jpeg ✔, libpng ✔, libtiff ✔, wxwidgets ✔
```

### macOS x64 - Run Checks

#### Create iccdev.rb

```
cat <<'EOF' > /usr/local/Homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
class Iccdev < Formula
  desc "Libraries and tools for ICC color management profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"
...
EOF
```

### macOS x64

#### Run Checks

```
brew update-reset && brew update --force --quiet && \
brew cleanup -s && \
rm -rf "$(brew --cache)/downloads"/*{lz4,giflib,jpeg,libpng,iccdev}* /tmp/*iccdev* "$(brew --prefix)/Cellar/iccdev" 2>/dev/null || true && \
brew uninstall --force iccdev local/iccdev/iccdev 2>/dev/null || true && \
brew list | grep iccdev || echo "iccdev not installed (clean state)" && \
brew style local/iccdev/iccdev && brew audit --strict local/iccdev/iccdev && brew audit --new local/iccdev/iccdev && \
brew deps --tree --annotate --include-build --include-test local/iccdev/iccdev && \
brew fetch --formulae --force --retry cmake giflib jpeg jpeg-turbo libpng libtiff lz4 nlohmann-json pcre2 pkgconf webp wxwidgets xz zstd && \
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source local/iccdev/iccdev && \
brew test --verbose local/iccdev/iccdev && brew info local/iccdev/iccdev && \
brew linkage --cached --test --strict local/iccdev/iccdev && \
brew style local/iccdev/iccdev && \
brew audit --strict local/iccdev/iccdev && \
brew test local/iccdev/iccdev && \
brew info local/iccdev/iccdev && \
brew uninstall --formula --force --ignore-dependencies iccdev && \
brew cleanup -s && \
brew uninstall --formulae --force --ignore-dependencies cmake giflib jpeg jpeg-turbo libpng libtiff lz4 nlohmann-json pcre2 pkgconf webp wxwidgets xz zstd 2>/dev/null || true
```

### macOS x64 

#### Expected Output

```
...
==> Fetching downloads for: iccdev
✔︎ Bottle Manifest pcre2 (10.47)                                                                                                                                               [Downloaded   10.1KB/ 10.1KB]
✔︎ Bottle pcre2 (10.47)                                                                                                                                                        [Downloaded    2.3MB/  2.3MB]
✔︎ Formula iccdev (2.3.1)                                                                                                                                                      [Verifying    35.5MB/ 35.5MB]
==> Installing iccdev from local/iccdev
==> cmake -S Build/Cmake -B build -DCMAKE_INSTALL_RPATH=/usr/local/opt/iccdev/lib
==> cmake --build build
==> cmake --install build
🍺  /usr/local/Cellar/iccdev/2.3.1: 82 files, 6.0MB, built in 1 minute 12 seconds
[2025-11-07 19:59:25]
```

---

## PR Summary

1. Modified [iccdev.rb](https://github.com/InternationalColorConsortium/homebrew-core/commit/4c6790c54c3668024bf430c29331aea3048e3bc2)

**Note:** desc field modified to comply with Brew PR Submission Guidelines.
- Description shouldn't end with a full stop

```
  desc "Developer tools for interacting with and manipulating ICC profiles"
```

2. Minimized Build Args

3. Retested

```
[2025-11-07 20:16:19 EST] 
$ head /usr/local/Homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"

$ brew audit --new --online --strict local/iccdev/iccdev
$ brew style local/iccdev/iccdev

1 file inspected, no offenses detected
```

4. Ready for PR

## TODO

Season the latest **desc field** changes at least 48 hours to allow additional feedback. 

---

## Notes

### Editor Workflow

```
pico "$(brew --repository)/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb"
head "$(brew --repository)/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb"
brew audit --new --online --strict local/iccdev/iccdev
brew style local/iccdev/iccdev
```
