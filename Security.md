# Security

This document outlines the security information for the `DemoIccMAX` project, including reporting bugs, tracking CVEs, and guidelines for using the reference implementation.

## Reference Implementation

The `DemoIccMAX` reference implementation is intended as a guideline and **should not be considered production-ready code**. If you plan to use this code in a production environment, best practice includes:
- Performing a thorough security review, including static and dynamic analysis tools.
- Applying security patches for known vulnerabilities (see the CVEs listed below).
- Conducting extensive product testing, including fuzzing and performance testing, to ensure stability and security.
  
## Bug Reporting

When you discover a bug or unexpected behavior, please [open an issue](https://github.com/InternationalColorConsortium/DemoIccMAX/issues) with the following details:
1. **Description**: A clear and concise explanation of the issue.
2. **Steps to Reproduce**: A step-by-step guide on how to reproduce the bug.
3. **Expected Behavior**: What you expected to happen.
4. **Actual Behavior**: What actually happened.
5. **Environment**: Information about your environment (OS, version of `DemoIccMAX`, etc.).
6. **Proof of Concept**: If possible, provide a minimal reproducible example or test case.
7. **Severity**: Indicate whether this is a **Bug** or **Bad** issue (see Severity below).
8. **Patch (Optional)**: We encourage contributors to submit a patch along with the report when possible.

### Severity

- **Bug**: If user-controllable input causes a crash or results in unexpected behavior that could be exploited for Denial of Service (DoS).
- **Bad**: If user-controllable input causes arbitrary code execution, privilege escalation, or data corruption.
- **Info Disclosure**: If user-controllable input leads to the unintended exposure of sensitive data (e.g., out-of-bounds reads leading to information leaks).

## CVE Assignments

The following CVEs have been addressed in the `DemoIccMAX` project:

- **[CVE-2023-46602](https://nvd.nist.gov/vuln/detail/CVE-2023-46602):** NIST:NVD CVSS3 Score: 8.8. A Stack-based buffer overflow in the `icFixXml` function in `libIccXML.a`. This issue could lead to arbitrary code execution. The vulnerability was addressed by improving bounds checking and input validation.
- **[CVE-2023-46603](https://nvd.nist.gov/vuln/detail/CVE-2023-46603):** NIST:NVD CVSS3 Score: 8.8. An Out-of-bounds read in the `CIccPRMG::GetChroma` function in `libIccProfLib2.a`. This issue could potentially lead to information disclosure or application crashes. Mitigation involved adjusting memory access patterns to avoid out-of-bounds reads.
- **[CVE-2023-46866](https://nvd.nist.gov/vuln/detail/CVE-2023-46866):** NIST:NVD CVSS3 Score: 6.5. An Out-of-bounds read in the `CIccCLUT::Interp3d` function in `libIccProfLib2.a`. This issue could potentially lead to information disclosure or application crashes. Mitigation involved adjusting memory access patterns to avoid out-of-bounds reads.
- **[CVE-2023-46867](https://nvd.nist.gov/vuln/detail/CVE-2023-46867):** NIST:NVD CVSS3 Score: 6.5. An Out-of-bounds read in the `CIccXformMatrixTRC::GetCurve` function in `libIccProfLib2.a`. This issue could potentially lead to information disclosure or application crashes. Mitigation involved adjusting memory access patterns to avoid out-of-bounds reads.
- **[CVE-2023-47249](https://nvd.nist.gov/vuln/detail/CVE-2023-47249):** NIST:NVD CVSS3 Score: 6.5. An Out-of-bounds read in the `CIccXmlArrayType::ParseText` function in `libIccProfLib2.a`. This issue could potentially lead to information disclosure or application crashes. Mitigation involved adjusting memory access patterns to avoid out-of-bounds reads.
- **[CVE-2023-48736](https://nvd.nist.gov/vuln/detail/CVE-2023-48736):** NIST:NVD CVSS3 Score: 6.5. An Out-of-bounds read in the `CIccCLUT::Interp2d` function in `libIccProfLib2.a`. This issue could potentially lead to information disclosure or application crashes. Mitigation involved adjusting memory access patterns to avoid out-of-bounds reads.
- **[CVE-2024-38427](https://nvd.nist.gov/vuln/detail/CVE-2024-38427):** NIST:NVD ADP:CISA-ADP | CVSS3 Score: 8.8. A Logic Issue in the `CIccTagXmlProfileSequenceId::ParseXml` function in `libIccXML.a`. This issue could lead to arbitrary code execution. Mitigation involved adjusting the unconditional return value to `true`.

### CVE Requests

The `DemoIccMAX Project` will attempt to obtain CVE assignments for security issues. Due to delays, recent assignments have taken up to 90+ days. 
