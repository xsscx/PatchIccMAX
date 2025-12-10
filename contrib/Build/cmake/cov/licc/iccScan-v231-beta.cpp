/*
#
# Copyright(c) 1998 - 2025 Marti Maria Saguer - LCMS2 & original scan.c code
# Copyright(c) 2003 - 2025 International Color Consortium - iccDEV
# Copyright(c) 1994 - 2025 David H Hoyt LLC - IccSignatureUtils.h - UCI Profiler
#
#
# Compile: g++ -I../../../../IccProfLib/     -I../../../../IccXML/IccLibXML/     -I/usr/local/include     -L/usr/local/lib     -fsanitize=address     -fno-omit-frame-pointer     -g3 -O1     -Wall -Wextra -Wpedantic     -o licc licc.c     -llcms2 -lstdc++ -lz -lm     -Wno-unused-parameter     -Wno-type-limits     -Wno-overloaded-virtual
#
# Last Modified: 24-OCT-2025 0800 EDT David Hoyt
# Latest: Refactor
#
#
# Intent: Demo implementation for IccSignatureUtils.h
# Little ICC Scanner [licc] demonstrates a measurement and analysis toolchain for ICC profiles
# Bug Class: Profile Bleed | https://srd.cx/cve-2022-26730
#
#
#
*/
// ---------------------------
// Standard C / C++ headers
// ---------------------------
#include <cassert>
#include <cstdio>
#include <cstring>
#include <cstdint>
#include <cstddef>
#include <ctime>
#include <cstdlib>
#include <cstdarg>
#include <cctype>
#include <cmath>
#include <cerrno>
#include <string>
#include <vector>
#include <optional>

// Filesystem APIs: guarded for portability
#if defined(__cpp_lib_filesystem) || (__cplusplus >= 201703L)
#include <filesystem>
namespace licc_fs = std::filesystem;
#else
// Fallback: use POSIX APIs already present in the code (opendir/stat)
#endif

// ---------------------------
// Platform / system headers
// ---------------------------
#ifdef _WIN32
#include <io.h>
#include <winsock2.h> // optional future use
#else
#include <dirent.h>   // opendir, readdir
#include <sys/stat.h> // stat
#include <unistd.h>   // access, getopt
#endif

// ---------------------------
// MSVC: suppress "secure" warnings for legacy C APIs
// ---------------------------
#ifdef _MSC_VER
#if (_MSC_VER >= 1400)
#ifndef _CRT_SECURE_NO_DEPRECATE
#define _CRT_SECURE_NO_DEPRECATE
#endif
#ifndef _CRT_SECURE_NO_WARNINGS
#define _CRT_SECURE_NO_WARNINGS
#endif
#endif
#endif

// ---------------------------
// Third-party libraries
// ---------------------------
#include "lcms2.h"

// ---------------------------
// Project headers (iccMAX stack, utilities)
// ---------------------------
#include "IccDefs.h"
#include "IccProfile.h"
#include "IccUtil.h"
#include "IccTagBasic.h"
#include "IccTagMPE.h"
#include "IccTagXml.h"
#include "IccProfLibVer.h"
#include "IccLibXMLVer.h"
#include "IccSignatureUtils.h"

// ---------------------------
// Command-line parsing aliases
// ---------------------------
#ifndef xgetopt
#define xgetopt getopt
#define xoptarg optarg
#define xoptind optind
#define xopterr opterr
#endif

#ifndef SW
#define SW '-'
#endif

#ifdef _MSC_VER
#pragma message("Compiling licc.cpp with MSVC, CRT secure warnings suppressed.")
#elif defined(__clang__)
#pragma message("Compiling licc.cpp with Clang.")
#elif defined(__GNUC__)
#pragma message("Compiling licc.cpp with GCC.")
#endif


// ----------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------
// Small state helpers and safe initialization for global scanner state.
// This file is not thread-safe.
// ----------------------------------------------------------------------------------

#define UNUSED_PARAMETER(x) ((void)(x))
#define cmsmin(a, b) (((a) < (b)) ? (a) : (b))

// Global flags - kept as original types to preserve compatibility with calls elsewhere.
static int Verbose = 0;
static cmsBool PossibleExploit = FALSE;
static cmsBool ErrorState = FALSE;
static cmsBool AlreadyReported = FALSE;
static cmsBool Bypass = FALSE;

// System profiles used for transforms (created in main())
static cmsHPROFILE hsRGB = nullptr;
static cmsHPROFILE hCMYK = nullptr;

// Text that describes the phase currently being exercised by the scanner.
// Use SetTryingPhase() to set this safely (avoids accidental dangling pointers).
static const char* TryingPhase = nullptr;

// ProfileName buffer - explicit fixed-size storage used across the file.
// Always ensure it's zero-terminated before use.
static char ProfileName[cmsMAX_PATH];

// -----------------------------------------------------------------------------
// Helpers: initialization, per-profile reset, and minor setters
// -----------------------------------------------------------------------------
//
// Usage:
//    - Call InitGlobalState() early in main() after you have not yet created
//      hsRGB/hCMYK (it will only clear flags and zero buffers).
//    - Call ResetPerProfileState() before scanning each profile to clear
//      per-profile flags (PossibleExploit, ErrorState, etc).
//    - Use SetProfileName() to copy a path into ProfileName safely.
//    - Use SetTryingPhase() to update the phase description used in logs.
//

static inline void InitGlobalState()
{
  Verbose = 0;
  PossibleExploit = FALSE;
  ErrorState = FALSE;
  AlreadyReported = FALSE;
  Bypass = FALSE;

  hsRGB = nullptr;
  hCMYK = nullptr;

  // Ensure ProfileName starts empty
  if (sizeof(ProfileName) > 0)
    ProfileName[0] = '\0';

  TryingPhase = nullptr;
}

static inline void ResetPerProfileState()
{
  PossibleExploit = FALSE;
  ErrorState = FALSE;
  AlreadyReported = FALSE;
  Bypass = FALSE;

  // Clear phase pointer (caller will set a new phase)
  TryingPhase = nullptr;

  // Zero the ProfileName buffer to avoid accidental reuse of prior path
  memset(ProfileName, 0, sizeof(ProfileName));
}

// Safe setter for ProfileName (null-terminates)
static inline void SetProfileName(const char* path)
{
  if (!path) {
    ProfileName[0] = '\0';
    return;
  }
  // strncpy old behavior: ensure NUL termination
  strncpy(ProfileName, path, sizeof(ProfileName) - 1);
  ProfileName[sizeof(ProfileName) - 1] = '\0';
}

// Set the current phase string (caller must ensure lifetime)
static inline void SetTryingPhase(const char* phase)
{
  TryingPhase = phase;
}

// Convenience setter for verbosity with range checking
static inline void SetVerbose(int v)
{
  if (v < 0) v = 0;
  if (v > 3) v = 3;
  Verbose = v;
}

// ----------------------------------------------------------------------------------
// Print diagnostic and exit
// ----------------------------------------------------------------------------------
[[noreturn]] static void FatalError(const char *fmt, ...) noexcept
{
  va_list args;
  va_start(args, fmt);

  /* Keep output format very close to previous behavior */
  std::fprintf(stderr, "\n** Fatal error - ");
  std::vfprintf(stderr, fmt, args);
  std::fprintf(stderr, "\n");

  va_end(args);

  /* Ensure message is flushed before exiting */
  std::fflush(stderr);

  /* Exit with failure status (matches previous exit(1)) */
  std::exit(EXIT_FAILURE);
}



// ----------------------------------------------------------------------------------
// Show a message on the profile
// ----------------------------------------------------------------------------------
static void Message(const char *fmt, ...) noexcept
{
  va_list args;
  va_start(args, fmt);

  // Keep the original formatting style: newline + tab before message
  std::fprintf(stderr, "\n\t");
  std::vfprintf(stderr, fmt, args);
  std::fprintf(stderr, "\n");

  va_end(args);

  // Flush to guarantee the message appears promptly (useful in CI or fuzz runs)
  std::fflush(stderr);
}




// ----------------------------------------------------------------------------------
// Parse command-line switches.
// Supports:
//   -v <level> or -V <level> : set verbosity level (0–3)
//
// Exits with FatalError() on invalid or unknown options.
// ----------------------------------------------------------------------------------
static void HandleSwitches(int argc, char *argv[]) noexcept
{
  int opt;

  while ((opt = xgetopt(argc, argv, "V:v:")) != EOF)
  {
    switch (opt)
    {
    case 'V':
    case 'v': {
      // Defensive check for missing or non-numeric argument
      int level = 0;
      if (xoptarg != nullptr) {
        level = std::atoi(xoptarg);
      } else {
        FatalError("Missing argument for -v option");
      }

      if (level < 0 || level > 3) {
        FatalError("Invalid verbosity level '%d' (valid range 0–3)", level);
      }

      Verbose = level;
      std::fprintf(stderr, "[INFO] Verbosity set to %d\n", Verbose);
      std::fflush(stderr);
      break;
    }

    default:
      FatalError("Unknown option - run without args to see valid ones.");
    }
  }
}


// ----------------------------------------------------------------------------------
// Print program manual / usage information.
// ----------------------------------------------------------------------------------
static int Help() noexcept
{
  std::fputs(
    "\nLittle ICC Scanner (licc)\n"
    "Demonstrates a toolchain for measurement and analysis of ICC Profiles.\n\n",
    stderr);

  std::fputs("Usage:\n", stderr);
  std::fputs("  licc [flags] <profile>\n\n", stderr);
  std::fputs("Flags:\n", stderr);
  std::fprintf(stderr, "  %cv<level>   Set verbosity level (0–3)\n\n", SW);

  std::fputs(
    "Example:\n"
    "  licc -v2 ../profiles/test.icc\n\n"
    "Description:\n"
    "  The Little ICC Scanner validates ICC and iccMAX profiles for correctness,\n"
    "  performs round-trip transform checks, and reports potential anomalies.\n"
    "\n",
    stderr);

  std::fflush(stderr);
  return 0;
}



// ----------------------------------------------------------------------------------
// Convert a 32-bit ICC signature (icSignature) into a 4-character string.
//
// Example:
//   sig2char(0x434d594b) → "CMYK"
//
// Notes:
//   • Uses an internal static buffer (non-thread-safe, matches original design).
//   • Sanitizer-safe: masks and shifts use unsigned 32-bit type.
//   • Returns pointer to a null-terminated 5-byte string.
// ----------------------------------------------------------------------------------
static char* sig2char(int sig) noexcept
{
  static char str[5];
  const uint32_t u = static_cast<uint32_t>(sig);

  str[0] = static_cast<char>((u >> 24) & 0xFF);
  str[1] = static_cast<char>((u >> 16) & 0xFF);
  str[2] = static_cast<char>((u >> 8)  & 0xFF);
  str[3] = static_cast<char>(u & 0xFF);
  str[4] = '\0';

#if defined(DEBUG) || defined(_DEBUG)
  // Uncomment for local testing
  // fprintf(stderr, "[DEBUG] sig2char(0x%08X) -> '%s'\n", u, str);
#endif

  return str;
}



// ----------------------------------------------------------------------------------
// Fake CMYK profile parameters.
//
// This structure holds transform handles used during creation of a synthetic
// CMYK profile for testing purposes.
//
//  This profile is not colorimetrically valid — it exists only to exercise
// ICC transform paths safely when no hardware CMYK profile is present.
//
// Note:
//   • These handles are created by CreateFakeCMYK() and released afterward.
//   • The struct is trivially copyable and compatible with legacy C usage.
// ----------------------------------------------------------------------------------
struct FakeCMYKParams
{
  cmsHTRANSFORM hLab2sRGB;  // Transform: Lab -> sRGB
  cmsHTRANSFORM sRGB2Lab;   // Transform: sRGB -> Lab
  cmsHTRANSFORM hIlimit;    // Transform: Ink limiting device link

  // Optional constructor for safety under C++ builds
  FakeCMYKParams() noexcept
    : hLab2sRGB(nullptr),
      sRGB2Lab(nullptr),
      hIlimit(nullptr)
  {
  }
};

// If compiled as C (not C++), provide typedef alias to maintain old symbol
#ifndef __cplusplus
typedef struct FakeCMYKParams FakeCMYKParams;
#endif

// ----------------------------------------------------------------------------------
// Clamp a floating-point value to the range [0.0, 1.0].
//
// Notes:
//   • Maintains double precision (cmsFloat64Number).
//   • Inline for better optimization in tight loops.
//   • UBSan-safe (no undefined behavior from NaN comparison).
// ----------------------------------------------------------------------------------
static inline cmsFloat64Number Clip(cmsFloat64Number v) noexcept
{
  // Handle NaN: comparisons with NaN are false, so force to 0
  if (!(v == v))  // NaN check
    return 0.0;

  if (v < 0.0)
    return 0.0;

  if (v > 1.0)
    return 1.0;

  return v;
}


// ----------------------------------------------------------------------------------
// ForwardSampler()
// Converts Lab input → sRGB → CMYK with coarse ink limiting.
//
// This function is used only for generating a *fake* CMYK profile during tests.
// It is intentionally simplistic and not colorimetrically valid.
//
// Notes:
//   • The "nonsense" comment remains true: this is for exercising transforms.
//   • Input and output are in 16-bit format arrays (as used by LittleCMS).
//   • Returns 1 on success, as required by cmsStageSampleCLut16bit().
// ----------------------------------------------------------------------------------
static cmsInt32Number ForwardSampler(const cmsUInt16Number In[],
                                     cmsUInt16Number Out[],
                                     void* Cargo) noexcept
{
  // Defensive checks: ensure Cargo and transforms are valid
  if (Cargo == nullptr)
    return 0;

  FakeCMYKParams* p = static_cast<FakeCMYKParams*>(Cargo);
  if (!p->hLab2sRGB || !p->hIlimit)
    return 0;

  cmsFloat64Number rgb[3] = {0.0, 0.0, 0.0};
  cmsFloat64Number cmyk[4] = {0.0, 0.0, 0.0, 0.0};

  // Convert Lab → sRGB (input is one pixel)
  cmsDoTransform(p->hLab2sRGB, In, rgb, 1);

  // Convert to subtractive CMY
  cmsFloat64Number c = 1.0 - rgb[0];
  cmsFloat64Number m = 1.0 - rgb[1];
  cmsFloat64Number y = 1.0 - rgb[2];

  // Basic black generation (pick min channel)
  cmsFloat64Number k = (c < m) ? cmsmin(c, y) : cmsmin(m, y);

  // Clamp each component to [0, 1] using Clip() for safety
  cmyk[0] = Clip(c);
  cmyk[1] = Clip(m);
  cmyk[2] = Clip(y);
  cmyk[3] = Clip(k);

#if defined(DEBUG) || defined(_DEBUG)
  std::fprintf(stderr, "[DEBUG] ForwardSampler: c=%.4f m=%.4f y=%.4f k=%.4f\n",
               cmyk[0], cmyk[1], cmyk[2], cmyk[3]);
#endif

  // Apply ink limiting transform (usually to simulate total ink restriction)
  cmsDoTransform(p->hIlimit, cmyk, Out, 1);

  return 1; // required by LCMS sampler API
}


// ----------------------------------------------------------------------------------
// ReverseSampler()
// Converts CMYK input → RGB → Lab using simple subtractive model.
//
// Notes:
//   • Used for generating the reverse transform in the fake CMYK profile.
//   • Not colorimetrically accurate — designed for transform validation only.
//   • Returns 1 on success as required by LCMS sampler API.
// ----------------------------------------------------------------------------------
static cmsInt32Number ReverseSampler(const cmsUInt16Number In[],
                                     cmsUInt16Number Out[],
                                     void* Cargo) noexcept
{
  // Defensive guard: prevent null dereference
  if (Cargo == nullptr)
    return 0;

  FakeCMYKParams* p = static_cast<FakeCMYKParams*>(Cargo);
  if (!p->sRGB2Lab)
    return 0;

  // Convert 16-bit unsigned CMYK values into normalized doubles
  const cmsFloat64Number scale = 1.0 / 65535.0;
  const cmsFloat64Number c = static_cast<cmsFloat64Number>(In[0]) * scale;
  const cmsFloat64Number m = static_cast<cmsFloat64Number>(In[1]) * scale;
  const cmsFloat64Number y = static_cast<cmsFloat64Number>(In[2]) * scale;
  const cmsFloat64Number k = static_cast<cmsFloat64Number>(In[3]) * scale;

  cmsFloat64Number rgb[3] = {0.0, 0.0, 0.0};

  if (k <= 0.0) {
    // Pure CMY to RGB conversion
    rgb[0] = Clip(1.0 - c);
    rgb[1] = Clip(1.0 - m);
    rgb[2] = Clip(1.0 - y);
  }
  else if (k >= 1.0) {
    // Full black ink — output pure black
    rgb[0] = rgb[1] = rgb[2] = 0.0;
  }
  else {
    // Apply simple undercolor removal model
    const cmsFloat64Number ink_factor = 1.0 - k;
    rgb[0] = Clip((1.0 - c) * ink_factor);
    rgb[1] = Clip((1.0 - m) * ink_factor);
    rgb[2] = Clip((1.0 - y) * ink_factor);
  }

#if defined(DEBUG) || defined(_DEBUG)
  std::fprintf(stderr,
               "[DEBUG] ReverseSampler: c=%.4f m=%.4f y=%.4f k=%.4f -> rgb(%.4f, %.4f, %.4f)\n",
               c, m, y, k, rgb[0], rgb[1], rgb[2]);
#endif

  // Perform the final RGB → Lab transform
  cmsDoTransform(p->sRGB2Lab, rgb, Out, 1);

  return 1; // required by LCMS sampler callback signature
}


// ----------------------------------------------------------------------------------
// Replacement for internal LCMS identity curve allocator.
//
// Creates an identity tone-curve stage for a given number of channels.
// Each channel receives a gamma = 1.0 curve, which corresponds to
// an identity mapping in LCMS.
//
// Returns:
//   • Pointer to cmsStage on success.
//   • NULL on allocation or parameter failure.
//
// Notes:
//   • Caller must free the returned cmsStage via cmsStageFree().
//   • Each temporary curve is freed after the stage is constructed.
// ----------------------------------------------------------------------------------
static cmsStage* StageAllocIdentityCurves(int nChannels) noexcept
{
  // Sanity guard
  if (nChannels <= 0 || nChannels > 16) {
#if defined(DEBUG) || defined(_DEBUG)
    std::fprintf(stderr, "[WARN] StageAllocIdentityCurves: invalid nChannels=%d\n", nChannels);
#endif
    return nullptr;
  }

  cmsToneCurve* curves[16] = {nullptr};

  // Build gamma=1.0 curve for each channel
  for (int i = 0; i < nChannels; ++i) {
    curves[i] = cmsBuildGamma(nullptr, 1.0);
    if (!curves[i]) {
#if defined(DEBUG) || defined(_DEBUG)
      std::fprintf(stderr, "[ERROR] cmsBuildGamma() failed for channel %d\n", i);
#endif
      // Clean up any successfully built curves
      for (int j = 0; j < i; ++j)
        cmsFreeToneCurve(curves[j]);
      return nullptr;
    }
  }

  // Allocate tone curve stage
  cmsStage* stage = cmsStageAllocToneCurves(nullptr, nChannels, curves);

  // Free temporary tone curves regardless of success
  for (int i = 0; i < nChannels; ++i) {
    if (curves[i])
      cmsFreeToneCurve(curves[i]);
  }

  if (!stage) {
#if defined(DEBUG) || defined(_DEBUG)
    std::fprintf(stderr, "[ERROR] cmsStageAllocToneCurves() failed for nChannels=%d\n", nChannels);
#endif
  }

  return stage;
}


// A fake CMYK just to creater transforms
// ----------------------------------------------------------------------------------
// CreateFakeCMYK()
// Safe C++-compliant version without illegal gotos over initializations.
// ----------------------------------------------------------------------------------
static cmsHPROFILE CreateFakeCMYK(cmsFloat64Number InkLimit) noexcept
{
  cmsHPROFILE hICC = nullptr;
  cmsPipeline* AToB0 = nullptr;
  cmsPipeline* BToA0 = nullptr;
  cmsStage* CLUT = nullptr;
  cmsStage *preLutBToA = nullptr, *postLutBToA = nullptr;
  cmsStage *preLutAToB = nullptr, *postLutAToB = nullptr;

  FakeCMYKParams p{};
  cmsHPROFILE hLab = nullptr;
  cmsHPROFILE hsRGB = nullptr;
  cmsHPROFILE hLimit = nullptr;
  cmsUInt32Number cmykfrm = 0;

  // --- Base profiles ------------------------------------------------------
  hsRGB = cmsCreate_sRGBProfile();
  hLab  = cmsCreateLab4Profile(nullptr);
  hLimit = cmsCreateInkLimitingDeviceLink(cmsSigCmykData, InkLimit);

  if (!hsRGB || !hLab || !hLimit) {
    if (hLab) cmsCloseProfile(hLab);
    if (hsRGB) cmsCloseProfile(hsRGB);
    if (hLimit) cmsCloseProfile(hLimit);
    return nullptr;
  }

  // Channel format: floating CMYK
  cmykfrm = FLOAT_SH(1) | BYTES_SH(0) | CHANNELS_SH(4);

  // Create transform handles
  p.hLab2sRGB = cmsCreateTransform(hLab, TYPE_Lab_16, hsRGB, TYPE_RGB_DBL,
                                   INTENT_PERCEPTUAL, cmsFLAGS_NOOPTIMIZE | cmsFLAGS_NOCACHE);
  p.sRGB2Lab  = cmsCreateTransform(hsRGB, TYPE_RGB_DBL, hLab, TYPE_Lab_16,
                                   INTENT_PERCEPTUAL, cmsFLAGS_NOOPTIMIZE | cmsFLAGS_NOCACHE);
  p.hIlimit   = cmsCreateTransform(hLimit, cmykfrm, nullptr, TYPE_CMYK_16,
                                   INTENT_PERCEPTUAL, cmsFLAGS_NOOPTIMIZE | cmsFLAGS_NOCACHE);

  cmsCloseProfile(hLab);
  cmsCloseProfile(hsRGB);
  cmsCloseProfile(hLimit);

  if (!p.hLab2sRGB || !p.sRGB2Lab || !p.hIlimit) {
    if (p.hLab2sRGB) cmsDeleteTransform(p.hLab2sRGB);
    if (p.sRGB2Lab)  cmsDeleteTransform(p.sRGB2Lab);
    if (p.hIlimit)   cmsDeleteTransform(p.hIlimit);
    return nullptr;
  }

  // --- Create placeholder ICC profile -------------------------------------
  hICC = cmsCreateProfilePlaceholder(nullptr);
  if (!hICC)
    goto cleanup_error;

  cmsSetProfileVersion(hICC, 4.3);
  cmsSetDeviceClass(hICC, cmsSigOutputClass);
  cmsSetColorSpace(hICC, cmsSigCmykData);
  cmsSetPCS(hICC, cmsSigLabData);

  // ----------------------------
  // BToA0 (3→4)
  // ----------------------------
  BToA0 = cmsPipelineAlloc(nullptr, 3, 4);
  if (!BToA0)
    goto cleanup_error;

  CLUT = cmsStageAllocCLut16bit(nullptr, 17, 3, 4, nullptr);
  preLutBToA  = StageAllocIdentityCurves(3);
  postLutBToA = StageAllocIdentityCurves(4);

  if (!CLUT || !preLutBToA || !postLutBToA) {
    if (CLUT) cmsStageFree(CLUT);
    if (preLutBToA) cmsStageFree(preLutBToA);
    if (postLutBToA) cmsStageFree(postLutBToA);
    cmsPipelineFree(BToA0);
    goto cleanup_error;
  }

  if (!cmsStageSampleCLut16bit(CLUT, ForwardSampler, &p, 0)) {
    cmsStageFree(CLUT);
    cmsStageFree(preLutBToA);
    cmsStageFree(postLutBToA);
    cmsPipelineFree(BToA0);
    goto cleanup_error;
  }

  cmsPipelineInsertStage(BToA0, cmsAT_BEGIN, preLutBToA);
  cmsPipelineInsertStage(BToA0, cmsAT_END, CLUT);
  cmsPipelineInsertStage(BToA0, cmsAT_END, postLutBToA);

  if (!cmsWriteTag(hICC, cmsSigBToA0Tag, (void*)BToA0)) {
    cmsPipelineFree(BToA0);
    goto cleanup_error;
  }

  cmsPipelineFree(BToA0);
  BToA0 = nullptr;

  // ----------------------------
  // AToB0 (4→3)
  // ----------------------------
  AToB0 = cmsPipelineAlloc(nullptr, 4, 3);
  if (!AToB0)
    goto cleanup_error;

  CLUT = cmsStageAllocCLut16bit(nullptr, 17, 4, 3, nullptr);
  preLutAToB  = StageAllocIdentityCurves(4);
  postLutAToB = StageAllocIdentityCurves(3);

  if (!CLUT || !preLutAToB || !postLutAToB) {
    if (CLUT) cmsStageFree(CLUT);
    if (preLutAToB) cmsStageFree(preLutAToB);
    if (postLutAToB) cmsStageFree(postLutAToB);
    cmsPipelineFree(AToB0);
    goto cleanup_error;
  }

  if (!cmsStageSampleCLut16bit(CLUT, ReverseSampler, &p, 0)) {
    cmsStageFree(CLUT);
    cmsStageFree(preLutAToB);
    cmsStageFree(postLutAToB);
    cmsPipelineFree(AToB0);
    goto cleanup_error;
  }

  cmsPipelineInsertStage(AToB0, cmsAT_BEGIN, preLutAToB);
  cmsPipelineInsertStage(AToB0, cmsAT_END, CLUT);
  cmsPipelineInsertStage(AToB0, cmsAT_END, postLutAToB);

  if (!cmsWriteTag(hICC, cmsSigAToB0Tag, (void*)AToB0)) {
    cmsPipelineFree(AToB0);
    goto cleanup_error;
  }

  cmsPipelineFree(AToB0);

  // ----------------------------
  // Cleanup transforms
  // ----------------------------
  cmsDeleteTransform(p.hLab2sRGB);
  cmsDeleteTransform(p.sRGB2Lab);
  cmsDeleteTransform(p.hIlimit);

  cmsLinkTag(hICC, cmsSigAToB1Tag, cmsSigAToB0Tag);
  cmsLinkTag(hICC, cmsSigAToB2Tag, cmsSigAToB0Tag);
  cmsLinkTag(hICC, cmsSigBToA1Tag, cmsSigBToA0Tag);
  cmsLinkTag(hICC, cmsSigBToA2Tag, cmsSigBToA0Tag);

  return hICC;

cleanup_error:
  if (hICC) cmsCloseProfile(hICC);
  cmsDeleteTransform(p.hLab2sRGB);
  cmsDeleteTransform(p.sRGB2Lab);
  cmsDeleteTransform(p.hIlimit);
  return nullptr;
}


// ----------------------------------------------------------------------------------
// PrintTimestamp()
// Writes a local timestamp prefix in ISO-like format to the given stream.
//
// Example:
//   [2025-10-25 14:32:09]
//
// Notes:
//   • Thread-safe: uses localtime_r / localtime_s.
//   • No output if stream == nullptr.
//   • Intended for diagnostic logging only.
// ----------------------------------------------------------------------------------
static void PrintTimestamp(FILE* stream) noexcept
{
  if (!stream)
    return;

  const time_t now = time(nullptr);
  struct tm t {};

#if defined(_WIN32)
  // Windows secure version
  if (localtime_s(&t, &now) != 0)
    return;
#else
  // POSIX thread-safe version
  if (localtime_r(&now, &t) == nullptr)
    return;
#endif

  std::fprintf(stream,
               "[%04d-%02d-%02d %02d:%02d:%02d] ",
               t.tm_year + 1900,
               t.tm_mon + 1,
               t.tm_mday,
               t.tm_hour,
               t.tm_min,
               t.tm_sec);
  std::fflush(stream);
}


// ----------------------------------------------------------------------------------
// MyErrorLogHandler()
// Custom LCMS error handler.
//
// Purpose:
//   • Captures LCMS diagnostic messages and re-routes them to stderr.
//   • Marks potential exploit conditions (heuristic corruption triggers).
//
// Behavior:
//   • Sets ErrorState = TRUE on any LCMS error.
//   • Sets PossibleExploit = TRUE if corruption is detected.
//   • Prevents duplicate reporting within one profile scan.
//
// Notes:
//   • Uses PrintTimestamp() for consistent time-stamped log lines.
//   • Thread-safety: relies on global state; safe only in single-threaded scans.
// ----------------------------------------------------------------------------------
static void MyErrorLogHandler(cmsContext ContextID,
                              cmsUInt32Number ErrorCode,
                              const char* Text) noexcept
{
  ErrorState = TRUE;

  // Only report once per profile phase
  if (!AlreadyReported && Verbose > 0)
  {
    PrintTimestamp(stderr);

    if (ErrorCode == cmsERROR_CORRUPTION_DETECTED) {
      std::fprintf(stderr,
                   "[HEURISTIC] Phase='%s' Detail='%s'\n",
                   (TryingPhase ? TryingPhase : "UnknownPhase"),
                   (Text ? Text : "No message"));
      PossibleExploit = TRUE;
    } else {
      std::fprintf(stderr,
                   "[ERROR] Phase='%s' Detail='%s'\n",
                   (TryingPhase ? TryingPhase : "UnknownPhase"),
                   (Text ? Text : "No message"));
    }

    std::fflush(stderr);
    AlreadyReported = TRUE;
  }

  // Optional verbose trace for additional LCMS messages
  if (Verbose > 1) {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[INFO] Phase='%s' Msg='%s'\n",
                 (TryingPhase ? TryingPhase : "UnknownPhase"),
                 (Text ? Text : "No message"));
    std::fflush(stderr);
  }

  UNUSED_PARAMETER(ContextID);
}



// ----------------------------------------------------------------------------------
// CheckTransform()
// Verifies integrity of an LCMS transform by converting it to a device link.
//
// Purpose:
//   • Ensures transform handles are valid before use.
//   • Detects corruption or invalid format codes.
//   • Forces LCMS to evaluate transform logic via cmsTransform2DeviceLink().
//
// Behavior:
//   • Sets ErrorState = TRUE on any failure.
//   • Leaves transform intact unless integrity check fails.
// ----------------------------------------------------------------------------------
static void CheckTransform(cmsHTRANSFORM xform) noexcept
{
  if (!xform) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] CheckTransform() called with null transform\n");
    std::fflush(stderr);

    ErrorState = TRUE;
    AlreadyReported = TRUE;
    return;
  }

  // Validate transform input/output format codes
  const cmsUInt32Number inFmt  = cmsGetTransformInputFormat(xform);
  const cmsUInt32Number outFmt = cmsGetTransformOutputFormat(xform);

  if (inFmt == 0 || outFmt == 0) {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[ERROR] cmsTransform integrity check failed: input=0x%08X, output=0x%08X\n",
                 inFmt, outFmt);
    std::fflush(stderr);

    ErrorState = TRUE;
    AlreadyReported = TRUE;
    cmsDeleteTransform(xform);  // avoid using a broken transform
    return;
  }

  // Force evaluation via temporary device link creation (version 2.1)
  cmsHPROFILE hICC = cmsTransform2DeviceLink(xform, 2.1, 0);
  if (hICC) {
    cmsCloseProfile(hICC);
  } else {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[ERROR] Transform2DeviceLink(2.1) failed (Phase='%s')\n",
                 (TryingPhase ? TryingPhase : "UnknownPhase"));
    std::fflush(stderr);

    ErrorState = TRUE;
    AlreadyReported = TRUE;
  }

  // Repeat with v4.1 link to ensure consistency
  hICC = cmsTransform2DeviceLink(xform, 4.1, 0);
  if (hICC) {
    cmsCloseProfile(hICC);
  } else {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[ERROR] Transform2DeviceLink(4.1) failed (Phase='%s')\n",
                 (TryingPhase ? TryingPhase : "UnknownPhase"));
    std::fflush(stderr);

    ErrorState = TRUE;
    AlreadyReported = TRUE;
  }
}


// ----------------------------------------------------------------------------------
// checkOneIntentRGB()
// Validates RGB transforms for a given rendering intent (both AToB and BToA).
//
// Purpose:
//   • Checks existence and readability of corresponding AToB/BToA tags.
//   • Verifies transform integrity by creating and forcing evaluation.
//   • Logs heuristic issues and sets global ErrorState on failures.
//
// Notes:
//   • Requires global hsRGB to be initialized (e.g. cmsCreate_sRGBProfile()).
//   • Does not modify the profile; purely diagnostic.
// ----------------------------------------------------------------------------------
static void checkOneIntentRGB(cmsHPROFILE hProfile, cmsUInt32Number intent) noexcept
{
  cmsHTRANSFORM xform = nullptr;

  static const char* ForwardTextPhase[] = {
    "input perceptual RGB (AtoB0)",
    "input rel.col RGB (AtoB1)",
    "input saturation RGB (AtoB2)"
  };

  static const char* ReverseTextPhase[] = {
    "output perceptual RGB (BtoA0)",
    "output rel.col RGB (BtoA1)",
    "output saturation RGB (BtoA2)"
  };

  static const cmsTagSignature AToBTags[] = {
    cmsSigAToB0Tag, cmsSigAToB1Tag, cmsSigAToB2Tag
  };

  static const cmsTagSignature BToATags[] = {
    cmsSigBToA0Tag, cmsSigBToA1Tag, cmsSigBToA2Tag
  };

  if (intent < INTENT_PERCEPTUAL || intent > INTENT_SATURATION) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[WARN] Unsupported rendering intent: %u\n", intent);
    std::fflush(stderr);
    return;
  }

  // ---------------------------------------------------------------------
  // FORWARD TRANSFORM (Profile → sRGB)
  // ---------------------------------------------------------------------
  TryingPhase = ForwardTextPhase[intent];

  CIccProfile iccParsed;
  CIccFileIO io;

  const bool hasAToB = cmsIsTag(hProfile, AToBTags[intent]);
  const bool iccParsedOK = io.Open(ProfileName, "rb") && iccParsed.Read(&io);
  const bool hasAToB_ICC = iccParsedOK && (iccParsed.FindTag(AToBTags[intent]) != nullptr);
  io.Close();

  if (!hasAToB || !hasAToB_ICC) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[INFO] Skipping forward transform: missing/unparseable tag '%s'\n",
                 sig2char(AToBTags[intent]));
    std::fflush(stderr);
  } else {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[DEBUG] Creating forward RGB transform: intent=%u [%s]\n",
                 intent, TryingPhase);
    std::fflush(stderr);

    const cmsColorSpaceSignature cs = cmsGetColorSpace(hProfile);
    if (cs != cmsSigRgbData) {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "[ERROR] Profile ColorSpace='%s' does not support RGB transform\n",
                   sig2char(cs));
      std::fflush(stderr);
      ErrorState = TRUE;
      AlreadyReported = TRUE;
      return;
    }

    xform = cmsCreateTransform(hProfile, TYPE_RGB_16, hsRGB, TYPE_RGB_16,
                               intent, cmsFLAGS_KEEP_SEQUENCE);

    if (xform) {
      const cmsUInt32Number inFmt  = cmsGetTransformInputFormat(xform);
      const cmsUInt32Number outFmt = cmsGetTransformOutputFormat(xform);

      if (inFmt && outFmt) {
        CheckTransform(xform);
      } else {
        PrintTimestamp(stderr);
        std::fprintf(stderr,
                     "[ERROR] cmsCreateTransform() returned corrupted forward transform "
                     "(intent=%u): inFmt=0x%08X outFmt=0x%08X\n",
                     intent, inFmt, outFmt);
        std::fflush(stderr);
        ErrorState = TRUE;
        AlreadyReported = TRUE;
      }

      cmsDeleteTransform(xform);
    } else {
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[ERROR] Forward RGB transform creation failed (intent=%u, tag=%s)\n",
                   intent, sig2char(AToBTags[intent]));
      std::fflush(stderr);
      ErrorState = TRUE;
      AlreadyReported = TRUE;
    }
  }

  // ---------------------------------------------------------------------
  // REVERSE TRANSFORM (sRGB → Profile)
  // ---------------------------------------------------------------------
  TryingPhase = ReverseTextPhase[intent];

  const bool hasBToA = cmsIsTag(hProfile, BToATags[intent]);
  const bool hasBToA_ICC = iccParsedOK && (iccParsed.FindTag(BToATags[intent]) != nullptr);

  if (!hasBToA || !hasBToA_ICC) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[INFO] Skipping reverse transform: missing/unparseable tag '%s'\n",
                 sig2char(BToATags[intent]));
    std::fflush(stderr);
  } else {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[DEBUG] Creating reverse RGB transform: intent=%u [%s]\n",
                 intent, TryingPhase);
    std::fflush(stderr);

    xform = cmsCreateTransform(hsRGB, TYPE_RGB_16, hProfile, TYPE_RGB_16,
                               intent, cmsFLAGS_KEEP_SEQUENCE);

    if (!xform) {
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[ERROR] Reverse RGB transform creation failed (intent=%u, tag=%s)\n",
                   intent, sig2char(BToATags[intent]));
      std::fflush(stderr);
      ErrorState = TRUE;
      AlreadyReported = TRUE;
      return;
    }

    const cmsUInt32Number inFmt  = cmsGetTransformInputFormat(xform);
    const cmsUInt32Number outFmt = cmsGetTransformOutputFormat(xform);

    if (!inFmt || !outFmt || ((inFmt & 0xFFFF) == 0) || ((outFmt & 0xFFFF) == 0)) {
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[ERROR] cmsCreateTransform() returned unusable reverse transform: "
                   "inFmt=0x%08X, outFmt=0x%08X\n",
                   inFmt, outFmt);
      std::fflush(stderr);
      ErrorState = TRUE;
      AlreadyReported = TRUE;
    } else {
      CheckTransform(xform);
    }

    cmsDeleteTransform(xform);
  }
}


// ----------------------------------------------------------------------------------
// checkOneIntentCMYK()
// Validates CMYK transforms for a given rendering intent (both AToB and BToA).
//
// Purpose:
//   • Checks if a profile correctly supports CMYK transforms for each intent.
//   • Creates and verifies forward (AtoB) and reverse (BtoA) transform pairs.
//   • Invokes CheckTransform() for integrity validation.
//
// Notes:
//   • Uses global hCMYK and TryingPhase.
//   • Sets ErrorState/AlreadyReported on serious issues.
//   • Diagnostic output is time-stamped and flushed immediately.
// ----------------------------------------------------------------------------------
static void checkOneIntentCMYK(cmsHPROFILE hProfile, cmsUInt32Number intent) noexcept
{
  cmsHTRANSFORM xform = nullptr;

  static const char* ForwardTextPhase[] = {
    "input perceptual CMYK (AtoB0)",
    "input rel.col CMYK (AtoB1)",
    "input saturation CMYK (AtoB2)"
  };

  static const char* ReverseTextPhase[] = {
    "output perceptual CMYK (BtoA0)",
    "output rel.col CMYK (BtoA1)",
    "output saturation CMYK (BtoA2)"
  };

  if (intent < INTENT_PERCEPTUAL || intent > INTENT_SATURATION) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[WARN] Unsupported rendering intent: %u\n", intent);
    std::fflush(stderr);
    return;
  }

  // ---------------------------------------------------------------------
  // FORWARD TRANSFORM (Profile → CMYK)
  // ---------------------------------------------------------------------
  TryingPhase = ForwardTextPhase[intent];

  PrintTimestamp(stderr);
  std::fprintf(stderr, "[DEBUG] Creating forward CMYK transform: intent=%u [%s]\n",
               intent, TryingPhase);
  std::fflush(stderr);

  xform = cmsCreateTransform(hProfile, TYPE_CMYK_16,
                             hCMYK, TYPE_CMYK_16,
                             intent, cmsFLAGS_KEEP_SEQUENCE);

  if (xform) {
    CheckTransform(xform);
    cmsDeleteTransform(xform);
  } else {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[WARN] Forward CMYK transform creation failed (intent=%u)\n", intent);
    std::fflush(stderr);
    ErrorState = TRUE;
    AlreadyReported = TRUE;
  }

  // ---------------------------------------------------------------------
  // REVERSE TRANSFORM (CMYK → Profile)
  // ---------------------------------------------------------------------
  TryingPhase = ReverseTextPhase[intent];

  PrintTimestamp(stderr);
  std::fprintf(stderr, "[DEBUG] Creating reverse CMYK transform: intent=%u [%s]\n",
               intent, TryingPhase);
  std::fflush(stderr);

  xform = cmsCreateTransform(hCMYK, TYPE_CMYK_16,
                             hProfile, TYPE_CMYK_16,
                             intent, cmsFLAGS_KEEP_SEQUENCE);

  if (xform) {
    CheckTransform(xform);
    cmsDeleteTransform(xform);
  } else {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[WARN] Reverse CMYK transform creation failed (intent=%u)\n", intent);
    std::fflush(stderr);
    ErrorState = TRUE;
    AlreadyReported = TRUE;
  }
}


// ----------------------------------------------------------------------------------
// checkAllIntents()
// Determine profile class + color space and dispatch to the appropriate intent
// checks (RGB or CMYK). Preserve behavior: set Bypass on unsupported classes,
// call per-intent checkers, and report heuristic / error results.
// ----------------------------------------------------------------------------------
static void checkAllIntents(cmsHPROFILE hProfile) noexcept
{
  if (!hProfile) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] checkAllIntents(): null profile handle\n");
    std::fflush(stderr);
    ErrorState = TRUE;
    AlreadyReported = TRUE;
    return;
  }

  const cmsColorSpaceSignature cs = cmsGetColorSpace(hProfile);
  const cmsProfileClassSignature dc = cmsGetDeviceClass(hProfile);
  const char* cs_str = sig2char(static_cast<int>(cs));
  const char* dc_str = sig2char(static_cast<int>(dc));

  // Log basic profile metadata
  PrintTimestamp(stderr);
  std::fprintf(stderr, "[INFO] DeviceClass='%s' ColorSpace='%s'\n", dc_str, cs_str);
  std::fflush(stderr);

  // Check if device class is supported
  if (!(dc == cmsSigInputClass ||
        dc == cmsSigDisplayClass ||
        dc == cmsSigOutputClass ||
        dc == cmsSigColorSpaceClass))
  {
    Bypass = TRUE;
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[WARN] Skipping unsupported DeviceClass='%s'\n", dc_str);
    std::fflush(stderr);

    Message("*** Bypassing this profile because unsupported device class '%s'\n", dc_str);
    return;
  }

  // Route to appropriate intent tester
  if (cs == cmsSigRgbData) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[DEBUG] Dispatching to RGB transform checks\n");
    std::fflush(stderr);

    checkOneIntentRGB(hProfile, INTENT_PERCEPTUAL);
    checkOneIntentRGB(hProfile, INTENT_RELATIVE_COLORIMETRIC);
    checkOneIntentRGB(hProfile, INTENT_SATURATION);
  }
  else if (cs == cmsSigCmykData) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[DEBUG] Dispatching to CMYK transform checks\n");
    std::fflush(stderr);

    checkOneIntentCMYK(hProfile, INTENT_PERCEPTUAL);
    checkOneIntentCMYK(hProfile, INTENT_RELATIVE_COLORIMETRIC);
    checkOneIntentCMYK(hProfile, INTENT_SATURATION);
  }
  else {
    Bypass = TRUE;
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[WARN] Skipping unsupported ColorSpace='%s'\n", cs_str);
    std::fflush(stderr);

    Message("*** Bypassing this profile because unsupported Color Space '%s'\n", cs_str);
    return;
  }

  // Report scan result: heuristics first, then generic error
  if (PossibleExploit) {
    Message("*** WARNING: Profile may contain matching heuristics\n");
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[WARN] Heuristic match indicator flagged\n");
    std::fflush(stderr);
  }
  else if (ErrorState) {
    Message("*** WARNING: Profile has errors\n");
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[WARN] Profile failed validation with known errors\n");
    std::fflush(stderr);
  }
}


// ----------------------------------------------------------------------------------
// checkInfo()
// Reads and validates text metadata from an ICC profile.
//
// Purpose:
//   • Retrieves ASCII fields (Description, Manufacturer, Model, Copyright).
//   • Detects anomalously large strings (>10 KiB) as heuristic exploit indicators.
//   • Logs relevant information when Verbose > 1.
//
// Notes:
//   • Sets PossibleExploit = TRUE if suspicious data length found.
//   • Sets ErrorState = TRUE on allocation or retrieval failures.
//   • Thread-unsafe (uses globals); intended for sequential scanning only.
// ----------------------------------------------------------------------------------
static void checkInfo(cmsHPROFILE h, cmsInfoType Info) noexcept
{
  if (!h) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] checkInfo() called with null profile handle\n");
    std::fflush(stderr);
    ErrorState = TRUE;
    return;
  }

  const char* label = "Unknown";
  switch (Info) {
  case cmsInfoDescription:
    label = "Description";
    break;
  case cmsInfoManufacturer:
    label = "Manufacturer";
    break;
  case cmsInfoModel:
    label = "Model";
    break;
  case cmsInfoCopyright:
    label = "Copyright";
    break;
  default:
    label = "Unknown";
    break;
  }

  TryingPhase = label;

  // First query to determine buffer size
  const int len = cmsGetProfileInfoASCII(h, Info, "en", "US", nullptr, 0);
  if (len <= 0)
    return; // No text or error (not critical)

  // Heuristic: unusually long strings are suspicious
  if (len > 10 * 1024) {
    PossibleExploit = TRUE;
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[HEURISTIC] Phase='Info[%s]' Detail='Excessive text length (%d bytes)'\n",
                 label, len);
    std::fflush(stderr);
    return;
  }

  // Allocate a temporary buffer (ensure +1 for NUL)
  char* text = static_cast<char*>(std::malloc(static_cast<size_t>(len) + 1));
  if (!text) {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[ERROR] Phase='Info[%s]' Detail='malloc failed for %d bytes'\n",
                 label, len);
    std::fflush(stderr);
    ErrorState = TRUE;
    return;
  }

  // Second query to actually read the string
  const int bytesRead = cmsGetProfileInfoASCII(h, Info, "en", "US", text, len);
  if (bytesRead > 0) {
    text[len - 1] = '\0'; // Defensive NUL termination
    if (Verbose > 1) {
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[INFO] Phase='Info[%s]' Value='%s'\n", label, text);
      std::fflush(stderr);
    }
  } else {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[WARN] Phase='Info[%s]' Detail='Failed to read profile info'\n", label);
    std::fflush(stderr);
    ErrorState = TRUE;
  }

  std::free(text);
}


// ----------------------------------------------------------------------------------
// checkColorantTable()
//  - Detects unusually large named-color lists (heuristic exploit indicator)
//  - Logs individual named-color entries when Verbose > 1
//  - Uses RAII and clearer error flow
// ----------------------------------------------------------------------------------
static void checkColorantTable(cmsHPROFILE hInput, cmsTagSignature Sig, const char* Title) noexcept
{
  if (!hInput || !Title) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[WARN] checkColorantTable: invalid parameters (hInput=%p, Title=%p)\n", (void*)hInput, (void*)Title);
    std::fflush(stderr);
    ErrorState = TRUE;
    return;
  }

  if (!cmsIsTag(hInput, Sig)) {
    if (Verbose > 2) {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "[DEBUG] checkColorantTable: tag '%s' not present\n", Title);
      std::fflush(stderr);
    }
    return;
  }

  TryingPhase = Title;

  // Ensure tag read is cleaned up automatically
  std::unique_ptr<cmsNAMEDCOLORLIST, decltype(&cmsFreeNamedColorList)>
  list(static_cast<cmsNAMEDCOLORLIST*>(cmsReadTag(hInput, Sig)), cmsFreeNamedColorList);

  if (!list) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] Phase='ColorantTable[%s]' Detail='cmsReadTag returned NULL'\n", Title);
    std::fflush(stderr);
    ErrorState = TRUE;
    return;
  }

  const int count = cmsNamedColorCount(list.get());
  if (count < 0) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] Phase='ColorantTable[%s]' Detail='Negative color count'\n", Title);
    std::fflush(stderr);
    ErrorState = TRUE;
    return;
  }

  if (count > 15) {
    PossibleExploit = TRUE;
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[HEURISTIC] Phase='ColorantTable[%s]' Detail='Excessive named-color count (%d)'\n",
                 Title, count);
    std::fflush(stderr);
    return;
  }

  // Iterate and optionally log individual colorant names
  for (int i = 0; i < count; ++i) {
    char name[cmsMAX_PATH] = {0};
    cmsNamedColorInfo(list.get(), i, name, nullptr, nullptr, nullptr, nullptr);
    name[sizeof(name) - 1] = '\0';

    if (Verbose > 1) {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "[INFO] Colorant[%d] '%s'\n", i, name[0] ? name : "(empty)");
      std::fflush(stderr);
    }
  }

  if (Verbose > 0 && count > 0) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[DEBUG] ColorantTable[%s]: validated %d entries\n", Title, count);
    std::fflush(stderr);
  }
}


// ----------------------------------------------------------------------------------
// checkProfileInformation()  [segment: header parse + metadata log]
// Refactored for consistent logging, defensive validation, and safer string handling
// ----------------------------------------------------------------------------------
static void checkProfileInformation(cmsHPROFILE h)
{
  if (!h) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] checkProfileInformation(): null cmsHPROFILE handle\n");
    std::fflush(stderr);
    ErrorState = TRUE;
    return;
  }

  cmsCIEXYZ* wp = nullptr;
  const cmsUInt32Number version = cmsGetProfileVersion(h);
  const cmsUInt32Number intent  = cmsGetHeaderRenderingIntent(h);
  cmsUInt8Number id[16] = {0};

  cmsGetHeaderProfileID(h, id);

  PrintTimestamp(stderr);
  std::fprintf(stderr, "[DEBUG] Entering checkProfileInformation() for '%s'\n", ProfileName);
  std::fprintf(stderr, "[INFO] LCMS Version: %.2f, Profile Version Raw: 0x%08X\n",
               LCMS_VERSION / 1000.0, version);
  std::fflush(stderr);

  CIccInfo Fmt;
  CIccProfile icc;
  CIccFileIO file;

  if (!file.Open(ProfileName, "rb") || !icc.Read(&file)) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] Failed to open ICC profile (iccMAX stack): '%s'\n", ProfileName);
    std::fflush(stderr);
    ErrorState = TRUE;
    return;
  }

  icHeader* pHdr = &icc.m_Header;
  if (!pHdr) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] ICC header pointer is null after read: '%s'\n", ProfileName);
    std::fflush(stderr);
    ErrorState = TRUE;
    return;
  }

  char buf[64] = {0};

  // --- Profile ID ---
  if (Fmt.IsProfileIDCalculated(&pHdr->profileID)) {
    const char* pid = Fmt.GetProfileID(&pHdr->profileID);
    PrintTimestamp(stderr);
    std::fprintf(stderr, "Profile ID:         %s\n", pid ? pid : "(null)");
  } else {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "Profile ID:         Profile ID not calculated.\n");
  }

  // --- Size field sanity ---
  const uint32_t sz = static_cast<uint32_t>(pHdr->size);
  if (sz == 0 || sz > (1u << 30)) { // flag sizes >1 GiB as suspicious
    PossibleExploit = TRUE;
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[HEURISTIC] Abnormal ICC profile size field: %u bytes (Profile='%s')\n",
                 sz, ProfileName);
  }

  std::fprintf(stderr, "Size:               %u (0x%X) bytes\n", sz, sz);
  std::fprintf(stderr, "\nHeader\n------\n");

  // --- Attributes ---
  const char* attrName = Fmt.GetDeviceAttrName(pHdr->attributes);
  if (!attrName)
    attrName = "(unavailable)";
  PrintTimestamp(stderr);
  std::fprintf(stderr, "Attributes:         %s\n", attrName);
  std::fflush(stderr);

// -------------------------------
// CMM Signature Check
// -------------------------------
  if (pHdr->cmmId >= 0x20202020 && pHdr->cmmId <= 0x7A7A7A7A) {
    printf("Cmm:                %s\n", Fmt.GetCmmSigName((icCmmSignature)pHdr->cmmId));
  } else {
    printf("Cmm:                InvalidCmm (0x%08X)\n", (unsigned)pHdr->cmmId);
  }

// -------------------------------
// Date
// -------------------------------
  printf("Creation Date:      %d/%d/%d (M/D/Y)  %02u:%02u:%02u\n",
         pHdr->date.month, pHdr->date.day, pHdr->date.year,
         pHdr->date.hours, pHdr->date.minutes, pHdr->date.seconds);

// -------------------------------
// Creator / Manufacturer Tags
// -------------------------------

// NOTE: Reuse existing 'buf' declared earlier in checkProfileInformation()
//       to avoid redefinition errors under GCC/Clang.

std::memset(buf, 0, sizeof(buf));
const char* creatorSig =
    icGetSig(buf, sizeof(buf), pHdr->creator);   // FIXED: added sizeof(buf)

PrintTimestamp(stderr);
std::fprintf(stderr,
             "Creator:            %s\n",
             creatorSig ? creatorSig : "(none)");

std::memset(buf, 0, sizeof(buf));
const char* manufSig =
    icGetSig(buf, sizeof(buf), pHdr->manufacturer);   // FIXED: added sizeof(buf)

PrintTimestamp(stderr);
std::fprintf(stderr,
             "Device Manufacturer:%s\n",
             manufSig ? manufSig : "(none)");

std::fflush(stderr);


// ------------------------------
// ICC HEADER FUZZ DIAGNOSTICS (Hardened + Timestamped)
// ------------------------------
  PrintTimestamp(stderr);
  std::fprintf(stderr, "[DEBUG] Starting ICC header fuzz diagnostics...\n");
  std::fflush(stderr);

// Defensive guard: avoid null or unaligned header dereference
  if (!pHdr) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] ICC header pointer null before fuzz diagnostics\n");
    std::fflush(stderr);
    ErrorState = TRUE;
    return;
  }

// Initialize sentinel region to detect unexpected writes during macro operations
  uint8_t sentinelBlock[32];
  std::memset(sentinelBlock, 0xEE, sizeof(sentinelBlock)); // Fill sentinel pattern

// --- Trace key header fields ---
  ICC_TRACE_INPUT_FIELD("cmmId", offsetof(icHeader, cmmId), &pHdr->cmmId, sizeof(pHdr->cmmId));

// --- Verify 'acsp' Magic Signature at offset 0x24 ---
  constexpr size_t magicOffset = 0x24;
  constexpr size_t magicSize   = 4;
  if (sizeof(icHeader) >= magicOffset + magicSize) {
    ICC_TRACE_INPUT_FIELD("magic", magicOffset,
                          reinterpret_cast<uint8_t*>(pHdr) + magicOffset, magicSize);

    const uint8_t expectedMagic[magicSize] = {'a', 'c', 's', 'p'};
    ICC_IIB_TAG_GUARD("Profile Magic",
                      reinterpret_cast<uint8_t*>(pHdr) + magicOffset,
                      magicSize, expectedMagic);

    // Manual verify and log anomaly if bytes differ
    const uint8_t* hdrMagic = reinterpret_cast<const uint8_t*>(pHdr) + magicOffset;
    if (std::memcmp(hdrMagic, expectedMagic, magicSize) != 0) {
      PossibleExploit = TRUE;
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[HEURISTIC] Phase='HeaderMagic' Detail='Invalid magic bytes (expected \"acsp\")'\n");
      std::fflush(stderr);
    }
  } else {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[WARN] Header too small for ICC magic check (size=%zu)\n", sizeof(icHeader));
    std::fflush(stderr);
    ErrorState = TRUE;
  }

// --- Dirty Write Detection: verify pad region after header ---
  if (sizeof(icHeader) >= 0x50 + sizeof(sentinelBlock)) {
    std::memcpy(sentinelBlock,
                reinterpret_cast<const uint8_t*>(pHdr) + 0x50,
                sizeof(sentinelBlock));
    for (size_t idx = 0; idx < sizeof(sentinelBlock); ++idx) {
      ICC_DIRTY_WRITE_CHECK("HeaderPad", sentinelBlock, idx, sizeof(sentinelBlock), 0xEE);
    }
  } else {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[WARN] Header too small for dirty write pad check (size=%zu)\n", sizeof(icHeader));
    std::fflush(stderr);
  }

// --- Manufacturer field trace ---
  ICC_TRACE_INPUT_FIELD("manufacturer",
                        offsetof(icHeader, manufacturer),
                        &pHdr->manufacturer,
                        sizeof(pHdr->manufacturer));

// --- Color Space Signature Sanity ---
  const uint32_t sigTest = pHdr->colorSpace;
  PrintTimestamp(stderr);
  std::fprintf(stderr, "[DEBUG] Evaluating ColorSpace signature 0x%08X...\n", sigTest);
  std::fflush(stderr);

// Defensive: reject reserved or null signatures
  if (sigTest == 0 || sigTest == 0xFFFFFFFF) {
    PossibleExploit = TRUE;
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[HEURISTIC] Phase='ColorSpace' Detail='Invalid or null color space signature'\n");
    std::fflush(stderr);
  }

  DebugColorSpaceMeta(sigTest);          // Macro logs structured signature metadata
  ICC_SANITY_CHECK_SIGNATURE(sigTest, "colorSpaceSignature");

  if (Verbose > 2) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[TRACE] Header fuzz diagnostics completed.\n");
    std::fflush(stderr);
  }


// -------------------------------
// PCS Color Space (Hardened Logging + Validation)
// -------------------------------
  if (!pHdr) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] PCS Color Space check: null header pointer\n");
    std::fflush(stderr);
    ErrorState = TRUE;
  } else {
    const icColorSpaceSignature pcsSig = pHdr->pcs;

    PrintTimestamp(stderr);
    std::fprintf(stderr, "[DEBUG] Evaluating PCS Color Space signature: 0x%08X\n",
                 static_cast<unsigned>(pcsSig));
    std::fflush(stderr);

    switch (pcsSig) {
    case icSigLabData:
    case icSigXYZData: {
      const char* pcsName = Fmt.GetColorSpaceSigName(pcsSig);
      PrintTimestamp(stderr);
      std::fprintf(stderr, "PCS Color Space:    %s\n",
                   pcsName ? pcsName : "(unknown)");
      std::fflush(stderr);
      break;
    }

    default: {
      PossibleExploit = TRUE;
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[HEURISTIC] Phase='PCS Color Space' Detail='Invalid or unknown PCS signature (0x%08X)'\n",
                   static_cast<unsigned>(pcsSig));
      std::fprintf(stderr,
                   "PCS Color Space:    InvalidPCS (0x%08X)\n",
                   static_cast<unsigned>(pcsSig));
      std::fflush(stderr);
      break;
    }
    }
  }


// -------------------------------
// Data Color Space (Hardened Validation + Logging)
// -------------------------------
  if (!pHdr) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] Data Color Space check: null header pointer\n");
    std::fflush(stderr);
    ErrorState = TRUE;
  } else {
    const icColorSpaceSignature csSig = pHdr->colorSpace;

    PrintTimestamp(stderr);
    std::fprintf(stderr, "[DEBUG] Evaluating Data Color Space signature: 0x%08X\n",
                 static_cast<unsigned>(csSig));
    std::fflush(stderr);

// Defensive heuristic: null or unrecognized color space signature
    const uint32_t csVal = static_cast<uint32_t>(csSig);
    if (csVal == 0u || csVal == 0xFFFFFFFFu || csVal == 0x20202020u) {
      PossibleExploit = TRUE;
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[HEURISTIC] Phase='Data Color Space' Detail='Invalid or null colorSpace signature (0x%08X)'\n",
                   csVal);
      std::fflush(stderr);
    }

    // Retrieve name safely
    const char* csName = Fmt.GetColorSpaceSigName(csSig);
    if (csName && std::strlen(csName) > 0) {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "Data Color Space:   %s\n", csName);
    } else {
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "Data Color Space:   Unknown or unsupported signature (0x%08X)\n",
                   static_cast<unsigned>(csSig));
      PossibleExploit = TRUE;
    }
    std::fflush(stderr);
  }

// -------------------------------
// Profile Flags + Platform Signature (Hardened Logging & Enum Validation)
// -------------------------------
  if (!pHdr) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] Profile Flags/Platform check: null header pointer\n");
    std::fflush(stderr);
    ErrorState = TRUE;
  } else {
    // ---- Profile Flags ----
    const char* flagsName = Fmt.GetProfileFlagsName(pHdr->flags);
    PrintTimestamp(stderr);
    std::fprintf(stderr, "Flags:              %s\n", flagsName ? flagsName : "(unavailable)");
    std::fflush(stderr);

    // ---- Platform Signature ----
    icUInt32Number platformValue = 0;
    std::memcpy(&platformValue, &pHdr->platform, sizeof(platformValue));

    PrintTimestamp(stderr);
    std::fprintf(stderr, "Raw Platform Value: 0x%08X\n", platformValue);
    std::fflush(stderr);

    const char* platformName = nullptr;

    switch (platformValue) {
    case 0x4150504C:  // 'APPL'
      platformName = "Macintosh";
      break;
    case 0x4D534654:  // 'MSFT'
      platformName = "Microsoft";
      break;
    case 0x53554E20:  // 'SUN '
      platformName = "Solaris";
      break;
    case 0x53474920:  // 'SGI '
      platformName = "SGI";
      break;
    case 0x54474C20:  // 'TGL '
      platformName = "Taligent";
      break;
    case 0x00000000:  // icSigUnknownPlatform
      platformName = "Unknown";
      break;
    default:
      // Flag unrecognized platform codes for heuristic review
      PossibleExploit = TRUE;
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[HEURISTIC] Phase='Platform Signature' Detail='Unrecognized platform code 0x%08X'\n",
                   platformValue);
      std::fflush(stderr);
      break;
    }

    PrintTimestamp(stderr);
    if (platformName)
      std::fprintf(stderr, "Platform:           %s\n", platformName);
    else
      std::fprintf(stderr, "Platform:           UnknownPlatformSig (0x%08X)\n", platformValue);
    std::fflush(stderr);
  }

// -------------------------------
// Rendering Intent + Profile Class/Subclass (Hardened Validation)
// -------------------------------
  if (!pHdr) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] Rendering Intent/Profile Class check: null header pointer\n");
    std::fflush(stderr);
    ErrorState = TRUE;
  } else {
    // ---- Rendering Intent ----
    const icUInt32Number ri = pHdr->renderingIntent;
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[DEBUG] Evaluating Rendering Intent: %u\n", static_cast<unsigned>(ri));
    std::fflush(stderr);

    if (ri <= icAbsoluteColorimetric) {
      const char* riName = Fmt.GetRenderingIntentName(static_cast<icRenderingIntent>(ri));
      PrintTimestamp(stderr);
      std::fprintf(stderr, "Rendering Intent:   %s\n", riName ? riName : "(unknown)");
    } else {
      PossibleExploit = TRUE;
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[HEURISTIC] Phase='RenderingIntent' Detail='Out-of-range value (%u)'\n",
                   static_cast<unsigned>(ri));
      std::fprintf(stderr, "Rendering Intent:   InvalidIntent (%u)\n", static_cast<unsigned>(ri));
    }
    std::fflush(stderr);

    // ---- Profile Class ----
    const icProfileClassSignature devClass = pHdr->deviceClass;
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[DEBUG] Evaluating Profile Class signature: 0x%08X\n",
                 static_cast<unsigned>(devClass));
    std::fflush(stderr);

    const char* className = Fmt.GetProfileClassSigName(devClass);
    if (className) {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "Profile Class:      %s\n", className);
    } else {
      PossibleExploit = TRUE;
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[HEURISTIC] Phase='ProfileClass' Detail='Unknown device class 0x%08X'\n",
                   static_cast<unsigned>(devClass));
      std::fprintf(stderr, "Profile Class:      Unknown (0x%08X)\n",
                   static_cast<unsigned>(devClass));
    }
    std::fflush(stderr);

   // ---- Subclass ----
if (pHdr->deviceSubClass != 0) {
    std::memset(buf, 0, sizeof(buf));

    const char* subSig =
        icGetSig(buf, sizeof(buf), pHdr->deviceSubClass);   // FIXED

    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "Profile SubClass:   %s\n",
                 subSig ? subSig : "(invalid)");
}
else {
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "Profile SubClass:   Not Defined\n");
}

std::fflush(stderr);


    // ---- Version ----
    const char* verName = Fmt.GetVersionName(pHdr->version);
    PrintTimestamp(stderr);
    std::fprintf(stderr, "Version:            %s\n", verName ? verName : "(unknown)");
    std::fflush(stderr);

    // ---- SubClass Version ----
    if (pHdr->version >= icVersionNumberV5 && pHdr->deviceSubClass != 0) {
      const char* subVerName = Fmt.GetSubClassVersionName(pHdr->version);
      PrintTimestamp(stderr);
      std::fprintf(stderr, "SubClass Version:   %s\n",
                   subVerName ? subVerName : "(undefined)");
      std::fflush(stderr);
    }

    // ---- Illuminant ----
    const double X = icFtoD(pHdr->illuminant.X);
    const double Y = icFtoD(pHdr->illuminant.Y);
    const double Z = icFtoD(pHdr->illuminant.Z);

    // Detect non-physical illuminant values
    if (X < 0.0 || Y < 0.0 || Z < 0.0 || X > 5.0 || Y > 5.0 || Z > 5.0) {
      PossibleExploit = TRUE;
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[HEURISTIC] Phase='Illuminant' Detail='Out-of-range XYZ values: X=%.4lf Y=%.4lf Z=%.4lf'\n",
                   X, Y, Z);
    }

    PrintTimestamp(stderr);
    std::fprintf(stderr, "Illuminant:         X=%.4lf, Y=%.4lf, Z=%.4lf\n", X, Y, Z);
    std::fflush(stderr);
  }


// -------------------------------
// Spectral PCS / Ranges / MCS Color Space (Hardened & Type-Safe)
// -------------------------------
  if (!pHdr) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] Spectral PCS block: null header pointer\n");
    std::fflush(stderr);
    ErrorState = TRUE;
  } else {
    // ---- Spectral PCS ----
    const char* spcsName = Fmt.GetSpectralColorSigName(pHdr->spectralPCS);
    PrintTimestamp(stderr);
    std::fprintf(stderr, "Spectral PCS:       %s\n", spcsName ? spcsName : "(unknown)");
    std::fflush(stderr);

    // ---- Spectral PCS Range ----
    const float spStart = icF16toF(pHdr->spectralRange.start);
    const float spEnd   = icF16toF(pHdr->spectralRange.end);
    const int   spSteps = pHdr->spectralRange.steps;

    if (spStart || spEnd || spSteps) {
      if (spStart > spEnd || spStart < 200.0f || spEnd > 2500.0f || spSteps <= 0) {
        PossibleExploit = TRUE;
        PrintTimestamp(stderr);
        std::fprintf(stderr,
                     "[HEURISTIC] Phase='SpectralRange' Detail='Suspicious range: start=%.1fnm end=%.1fnm steps=%d'\n",
                     spStart, spEnd, spSteps);
      }
      PrintTimestamp(stderr);
      std::fprintf(stderr, "Spectral PCS Range: start=%.1fnm, end=%.1fnm, steps=%d\n",
                   spStart, spEnd, spSteps);
    } else {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "Spectral PCS Range: Not Defined\n");
    }
    std::fflush(stderr);

    // ---- BiSpectral Range ----
    const float biStart = icF16toF(pHdr->biSpectralRange.start);
    const float biEnd   = icF16toF(pHdr->biSpectralRange.end);
    const int   biSteps = pHdr->biSpectralRange.steps;

    if (biStart || biEnd || biSteps) {
      if (biStart > biEnd || biStart < 200.0f || biEnd > 2500.0f || biSteps <= 0) {
        PossibleExploit = TRUE;
        PrintTimestamp(stderr);
        std::fprintf(stderr,
                     "[HEURISTIC] Phase='BiSpectralRange' Detail='Suspicious range: start=%.1fnm end=%.1fnm steps=%d'\n",
                     biStart, biEnd, biSteps);
      }
      PrintTimestamp(stderr);
      std::fprintf(stderr, "BiSpectral Range:   start=%.1fnm, end=%.1fnm, steps=%d\n",
                   biStart, biEnd, biSteps);
    } else {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "BiSpectral Range:   Not Defined\n");
    }
    std::fflush(stderr);

    // ---- MCS Color Space ----
    const icMaterialColorSignature mcsSig = pHdr->mcs;
    if (mcsSig != 0) {
      const char* mcsName = Fmt.GetColorSpaceSigName(
                              static_cast<icColorSpaceSignature>(mcsSig)); // safe cast for name lookup
      PrintTimestamp(stderr);
      std::fprintf(stderr, "MCS Color Space:    %s\n", mcsName ? mcsName : "(unknown)");
    } else {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "MCS Color Space:    Not Defined\n");
    }
    std::fflush(stderr);
  }


// -------------------------------
// iccMAX Profile Tags + LittleCMS Outputs (Hardened)
// -------------------------------
  PrintTimestamp(stderr);
  std::fprintf(stderr, "\niccMAX Profile Tags\n");
  std::fprintf(stderr, "------------\n");
  std::fprintf(stderr, "%28s    ID    %8s\t%8s\t%8s\n", "Tag", "Offset", "Size", "Pad");
  std::fprintf(stderr, "%28s  ------  %8s\t%8s\t%8s\n", "----", "------", "----", "---");
  std::fprintf(stderr, "------------\n");
  std::fflush(stderr);

// ---- LCMS Output Section ----
  PrintTimestamp(stderr);
  std::fprintf(stderr, "\nLittle CMS Outputs\n");
  std::fprintf(stderr, "Version:            %d.%02d\n",
               (version >> 16) & 0xFF, (version >> 8) & 0xFF);
  std::fflush(stderr);

// ---- Rendering Intent Summary ----
  const char* riStr = nullptr;
  switch (intent) {
  case INTENT_PERCEPTUAL:
    riStr = "Perceptual";
    break;
  case INTENT_RELATIVE_COLORIMETRIC:
    riStr = "Relative Colorimetric";
    break;
  case INTENT_SATURATION:
    riStr = "Saturation";
    break;
  case INTENT_ABSOLUTE_COLORIMETRIC:
    riStr = "Absolute Colorimetric";
    break;
  default:
    riStr = "Unknown";
    PossibleExploit = TRUE;
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[HEURISTIC] Phase='LCMS RenderingIntent' Detail='Unrecognized value (%u)'\n",
                 static_cast<unsigned>(intent));
    break;
  }

  PrintTimestamp(stderr);
  std::fprintf(stderr, "Rendering Intent:   %s\n", riStr);
  std::fflush(stderr);

// ---- Optional White Point Tag ----
  if (cmsIsTag(h, cmsSigMediaWhitePointTag)) {
    wp = static_cast<cmsCIEXYZ*>(cmsReadTag(h, cmsSigMediaWhitePointTag));
    if (wp) {
      if ((wp->X < 0.0 || wp->Y < 0.0 || wp->Z < 0.0) ||
          (wp->X > 5.0 || wp->Y > 5.0 || wp->Z > 5.0)) {
        PossibleExploit = TRUE;
        PrintTimestamp(stderr);
        std::fprintf(stderr,
                     "[HEURISTIC] Phase='MediaWhitePoint' Detail='Non-physical XYZ values: X=%.4f Y=%.4f Z=%.4f'\n",
                     wp->X, wp->Y, wp->Z);
      }
      PrintTimestamp(stderr);
      std::fprintf(stderr, "Media White Point:  X=%.4f Y=%.4f Z=%.4f\n",
                   wp->X, wp->Y, wp->Z);
      std::fflush(stderr);
    } else {
      PrintTimestamp(stderr);
      std::fprintf(stderr,
                   "[WARN] MediaWhitePoint tag present but cmsReadTag returned NULL\n");
      std::fflush(stderr);
    }
  } else {
    if (Verbose > 1) {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "[INFO] MediaWhitePoint tag not present in profile\n");
      std::fflush(stderr);
    }
  }


// -------------------------------
// Profile Tags Enumeration + Metadata/Colorant Checks (Hardened)
// -------------------------------
  PrintTimestamp(stderr);
  std::fprintf(stderr, "\nProfile Tags\n");
  std::fprintf(stderr, "------------\n");
  std::fprintf(stderr, "%28s    ID    %8s\t%8s\t%8s\n", "Tag", "Offset", "Size", "Pad");
  std::fprintf(stderr, "%28s  ------  %8s\t%8s\t%8s\n", "----", "------", "----", "---");
  std::fflush(stderr);

// ---- Enumerate Tags (LCMS does not expose offset/size/pad directly) ----
  const int tagCount = cmsGetTagCount(h);
  if (tagCount < 0 || tagCount > 2048) { // heuristic sanity limit
    PossibleExploit = TRUE;
    PrintTimestamp(stderr);
    std::fprintf(stderr,
                 "[HEURISTIC] Phase='TagEnumeration' Detail='Unrealistic tag count (%d)'\n",
                 tagCount);
    std::fflush(stderr);
  } else {
    for (int i = 0; i < tagCount; ++i) {
      cmsTagSignature sig = cmsGetTagSignature(h, i);
      const char* tagSigStr = sig2char(sig);
      PrintTimestamp(stderr);
      std::fprintf(stderr, "%28s  %s  %8s\t%8s\t%8s\n",
                   tagSigStr ? tagSigStr : "(null)",
                   tagSigStr ? tagSigStr : "(null)",
                   "-", "-", "-");
      std::fflush(stderr);
    }
  }

  PrintTimestamp(stderr);
  std::fprintf(stderr, "\n");
  std::fflush(stderr);

// -------------------------------
// Dump Known Textual Fields (Exploit-Aware Logging)
// -------------------------------
  PrintTimestamp(stderr);
  std::fprintf(stderr, "[DEBUG] Extracting textual info tags...\n");
  std::fflush(stderr);

  checkInfo(h, cmsInfoDescription);
  checkInfo(h, cmsInfoManufacturer);
  checkInfo(h, cmsInfoModel);
  checkInfo(h, cmsInfoCopyright);

// -------------------------------
// Colorant Table Checks (Heuristic & Structural)
// -------------------------------
  PrintTimestamp(stderr);
  std::fprintf(stderr, "[DEBUG] Verifying colorant tables...\n");
  std::fflush(stderr);

  checkColorantTable(h, cmsSigColorantTableTag,     "Input colorant table");
  checkColorantTable(h, cmsSigColorantTableOutTag,  "Output colorant table");

  PrintTimestamp(stderr);
  std::fprintf(stderr, "[INFO] checkProfileInformation(): Completed successfully.\n");
  std::fflush(stderr);
}

static
void checkDir(const char* dir)
{
  if (!dir || dir[0] == '\0') {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] checkDir(): invalid directory path\n");
    std::fflush(stderr);
    return;
  }

  DIR* d = opendir(dir);
  if (!d) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] Cannot open directory: %s\n", dir);
    std::fflush(stderr);
    Message("Cannot open directory: %s", dir);
    return;
  }

  struct dirent* entry;
  char fullpath[PATH_MAX];
  char subdir[PATH_MAX];
  struct stat st;

  while ((entry = readdir(d)) != NULL) {
    // Skip '.' and '..'
    if (entry->d_name[0] == '.' &&
        (entry->d_name[1] == '\0' ||
         (entry->d_name[1] == '.' && entry->d_name[2] == '\0')))
    {
      continue;
    }

    bool is_dir = false;

    // Prefer d_type when available
#ifdef DT_DIR
    if (entry->d_type == DT_DIR) {
      is_dir = true;
    } else if (entry->d_type == DT_UNKNOWN) {
      // fall through to stat below
      is_dir = false;
    } else {
      is_dir = false;
    }
#endif

    // If d_type is unavailable or unknown, use stat() to detect directories
    if (entry->d_type == DT_UNKNOWN) {
      // Build candidate path
      if (snprintf(subdir, sizeof(subdir), "%s/%s", dir, entry->d_name) < 0) {
        // snprintf error (shouldn't happen); skip this entry
        continue;
      }
      subdir[sizeof(subdir) - 1] = '\0';
      if (stat(subdir, &st) == 0) {
        if (S_ISDIR(st.st_mode))
          is_dir = true;
        else
          is_dir = false;
      } else {
        // Could not stat — skip noisy entry
        continue;
      }
    }

    if (is_dir) {
      // Recurse into subdirectory
      if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
        if (snprintf(subdir, sizeof(subdir), "%s/%s", dir, entry->d_name) < 0)
          continue;
        subdir[sizeof(subdir) - 1] = '\0';
        checkDir(subdir);
      }
      continue;
    }

    // For regular files, do a case-insensitive check for .icc or .icm
    // Create a lowercase copy of filename (small, bounded stack buffer)
    char name_lc[PATH_MAX];
    size_t nlen = strlen(entry->d_name);
    if (nlen >= sizeof(name_lc)) {
      // name too long — skip
      continue;
    }
    for (size_t i = 0; i <= nlen; ++i) {
      name_lc[i] = static_cast<char>(std::tolower(static_cast<unsigned char>(entry->d_name[i])));
    }

    if (strstr(name_lc, ".icc") == nullptr && strstr(name_lc, ".icm") == nullptr) {
      continue; // not a profile file we care about
    }

    // Reset per-profile state before each file
    ResetPerProfileState();

    // Build full path and copy safely into ProfileName
    if (snprintf(fullpath, sizeof(fullpath), "%s/%s", dir, entry->d_name) < 0)
      continue;
    fullpath[sizeof(fullpath) - 1] = '\0';

    // Use safe copy into global ProfileName buffer
    strncpy(ProfileName, fullpath, sizeof(ProfileName) - 1);
    ProfileName[sizeof(ProfileName) - 1] = '\0';

    TryingPhase = "parsing profile";
    PrintTimestamp(stderr);
    std::fprintf(stderr, "\n============================\n");
    std::fprintf(stderr, "Profile:           '%s'\n", ProfileName);
    std::fflush(stderr);

    cmsHPROFILE hProfile = cmsOpenProfileFromFile(ProfileName, "r");
    if (hProfile != NULL) {
      checkProfileInformation(hProfile);
      checkAllIntents(hProfile);
      cmsCloseProfile(hProfile);
    } else {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "[WARN] This file is not recognized as a valid ICC profile: %s\n", ProfileName);
      std::fflush(stderr);
      Message("This file is not recognized as a valid ICC profile");
    }

    if (!ErrorState && !Bypass) {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "Validation Result: Ok\n\n");
      std::fflush(stderr);
    } else {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "\nValidation Result: Issues detected\n\n");
      std::fflush(stderr);
    }
  }

  closedir(d);
}

// -----------------------------------------------------------------------------
// IsRoundTripable()
// Verifies whether a profile supports symmetric AToB/BToA or DToB/BToD tag pairs
// suitable for round-trip validation.
//
// Improvements:
//  • Defensive null-checks for pIcc and header
//  • Structured, timestamped logging with phase tracking
//  • Reduced redundancy via small helper lambdas
//  • Hardened against malformed profiles or partial tag maps
//  • Preserves ABI and return type (cmsBool)
//
// Returns:
//   TRUE  → Profile is round-trip capable
//   FALSE → Missing tag pairs or unsupported device class
// -----------------------------------------------------------------------------
static cmsBool IsRoundTripable(CIccProfile* pIcc) noexcept
{
  if (!pIcc) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] IsRoundTripable(): null CIccProfile pointer\n");
    std::fflush(stderr);
    return FALSE;
  }

  icHeader* pHdr = &pIcc->m_Header;
  if (!pHdr) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[ERROR] IsRoundTripable(): missing profile header\n");
    std::fflush(stderr);
    return FALSE;
  }

  ICC_LOG_INFO("IsRoundTripable(): Entry point reached.");
  ICC_LOG_INFO("IsRoundTripable(): Checking profile with deviceClass=0x%08X", pHdr->deviceClass);

  if (pHdr->deviceClass == icSigLinkClass) {
    ICC_LOG_INFO("IsRoundTripable(): DeviceLink profile — not roundtripable.");
    return FALSE;
  }

  // --- Local lambda for tag presence ---
  auto hasTag = [pIcc](icTagSignature sig) -> cmsBool {
    return (pIcc->FindTag(sig) != nullptr) ? TRUE : FALSE;
  };

  // --- Core tag pair evaluation ---
  const cmsBool hasAToB0 = hasTag(icSigAToB0Tag);
  const cmsBool hasBToA0 = hasTag(icSigBToA0Tag);
  const cmsBool hasAToB1 = hasTag(icSigAToB1Tag);
  const cmsBool hasBToA1 = hasTag(icSigBToA1Tag);
  const cmsBool hasAToB2 = hasTag(icSigAToB2Tag);
  const cmsBool hasBToA2 = hasTag(icSigBToA2Tag);

  const cmsBool hasDToB0 = hasTag(icSigDToB0Tag);
  const cmsBool hasBToD0 = hasTag(icSigBToD0Tag);
  const cmsBool hasDToB1 = hasTag(icSigDToB1Tag);
  const cmsBool hasBToD1 = hasTag(icSigBToD1Tag);
  const cmsBool hasDToB2 = hasTag(icSigDToB2Tag);
  const cmsBool hasBToD2 = hasTag(icSigBToD2Tag);

  const cmsBool hasMatrix =
    hasTag(icSigRedMatrixColumnTag)  &&
    hasTag(icSigGreenMatrixColumnTag) &&
    hasTag(icSigBlueMatrixColumnTag)  &&
    hasTag(icSigRedTRCTag) &&
    hasTag(icSigGreenTRCTag) &&
    hasTag(icSigBlueTRCTag);

  // --- Summarized diagnostics ---
  PrintTimestamp(stderr);
  std::fprintf(stderr,
               "[INFO] Tag pairs AToB/BToA: %d %d %d | DToB/BToD: %d %d %d | Matrix/TRC: %d\n",
               (hasAToB0 && hasBToA0),
               (hasAToB1 && hasBToA1),
               (hasAToB2 && hasBToA2),
               (hasDToB0 && hasBToD0),
               (hasDToB1 && hasBToD1),
               (hasDToB2 && hasBToD2),
               hasMatrix);
  std::fflush(stderr);

  // --- Round-trip condition evaluation ---
  const cmsBool roundTripable =
    (hasAToB0 && hasBToA0) ||
    (hasAToB1 && hasBToA1) ||
    (hasAToB2 && hasBToA2) ||
    (hasDToB0 && hasBToD0) ||
    (hasDToB1 && hasBToD1) ||
    (hasDToB2 && hasBToD2) ||
    hasMatrix;

  if (roundTripable) {
    ICC_LOG_INFO("IsRoundTripable(): Profile meets round-trip conditions.");
    return TRUE;
  }

  ICC_LOG_WARNING("IsRoundTripable(): No qualifying tag pairs found — not roundtripable.");
  return FALSE;
}



int main(int argc, char* argv[])
{
  int nargs = 0;
  int exitCode = EXIT_SUCCESS;
  struct stat path_stat {};
  const char* inputPath = nullptr;

  // ---- Version & attribution banner ----
  std::fprintf(stderr,
               "\n"
               "iccScan v0.2 [LittleCMS %.2f, IccProfLib %s, IccLibXML %s]\n"
               "Copyright (c) 2022-2025 David H Hoyt LLC - iccScan Source & IccSignatureUtilities.h\n"
               "Copyright (c) 1998-2015 Marti Maria Saguer - Little CMS2 Library\n"
               "Copyright (c) 2003-2025 International Color Consortium - iccMAX Library\n"
               "\n",
               LCMS_VERSION / 1000.0,
               ICCPROFLIBVER,
               ICCLIBXMLVER);

  // ---- Initialize global state ----
  InitGlobalState();
  PrintTimestamp(stderr);
  std::fprintf(stderr, "[INIT] Global state initialized.\n");
  std::fflush(stderr);

  // ---- Register LCMS error handler ----
  cmsSetLogErrorHandler(MyErrorLogHandler);
  ICC_LOG_INFO("Logger initialized. Starting argument parse.");

  // ---- Parse command line switches ----
  HandleSwitches(argc, argv);
  nargs = argc - xoptind;

  if (nargs < 1) {
    PrintTimestamp(stderr);
    std::fprintf(stderr, "[USAGE] No input provided.\n");
    std::fflush(stderr);
    return Help();
  }

  inputPath = argv[xoptind];
  ICC_LOG_INFO("Input path: %s", inputPath);

  // ---- Validate input path pointer ----
  if (!inputPath || inputPath[0] == '\0') {
    ICC_LOG_ERROR("Invalid input path (null or empty).");
    Message("Invalid input path.");
    return EXIT_FAILURE;
  }

  // ---- Create system profiles ----
  hsRGB = cmsCreate_sRGBProfile();
  hCMYK = CreateFakeCMYK(350.0);
  if (!hsRGB || !hCMYK) {
    ICC_LOG_ERROR("System profile creation failed.");
    FatalError("Failed to initialize base profiles (sRGB or CMYK).");
  }

  // ---- Validate input path existence ----
  if (stat(inputPath, &path_stat) != 0) {
    PrintTimestamp(stderr);
    std::perror("stat failed");
    ICC_LOG_ERROR("stat() failed for path: %s", inputPath);
    Message("Unable to access path: %s", inputPath);
    exitCode = EXIT_FAILURE;
    goto cleanup;
  }

  // ---- Dispatch: Directory or File ----
  if (S_ISDIR(path_stat.st_mode)) {
    ICC_LOG_INFO("Input is a directory. Beginning recursive scan.");
    checkDir(inputPath);
  } else {
    // ---- Single file scan path ----
    ResetPerProfileState();
    SetProfileName(inputPath);
    TryingPhase = "profile open";

    PrintTimestamp(stderr);
    std::fprintf(stderr, "\n============================\n");
    std::fprintf(stderr, "Profile:           '%s'\n", ProfileName);
    std::fflush(stderr);

    cmsHPROFILE hProfile = cmsOpenProfileFromFile(ProfileName, "r");
    if (!hProfile) {
      ICC_LOG_WARNING("Profile not valid ICC: %s", ProfileName);
      Message("This file is not recognized as a valid ICC profile");
      exitCode = 3;
      goto cleanup;
    }

    // ---- Round-trip test using refactored IsRoundTripable() ----
    {
      CIccProfile iccMax;
      CIccFileIO fileIO;
      if (fileIO.Open(ProfileName, "rb") && iccMax.Read(&fileIO)) {
        cmsBool roundTripable = IsRoundTripable(&iccMax);
        if (roundTripable)
          ICC_LOG_INFO("Round-trip check: PASS");
        else
          ICC_LOG_WARNING("Round-trip check: FAIL");
        fileIO.Close();
      } else {
        ICC_LOG_WARNING("CIccProfile::Read() failed for %s", ProfileName);
      }
    }

    ICC_LOG_INFO("Profile opened successfully.");
    checkProfileInformation(hProfile);
    checkAllIntents(hProfile);
    cmsCloseProfile(hProfile);

    if (!ErrorState && !Bypass) {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "Validation Result: Ok\n\n");
      ICC_LOG_INFO("Validation passed.");
    } else {
      PrintTimestamp(stderr);
      std::fprintf(stderr, "Validation Result: Issues detected\n\n");
      ICC_LOG_WARNING("Validation issues present in profile.");
      exitCode = EXIT_FAILURE;
    }
  }

cleanup:
  // ---- Resource cleanup ----
  if (hsRGB) {
    cmsCloseProfile(hsRGB);
    hsRGB = nullptr;
  }
  if (hCMYK) {
    cmsCloseProfile(hCMYK);
    hCMYK = nullptr;
  }

  ICC_LOG_INFO("Execution complete with exitCode=%d", exitCode);
  std::fflush(stderr);
  return exitCode;
}
