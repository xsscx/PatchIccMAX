# Security Policy

This document outlines the security practices for the `DemoIccMAX` project, including reporting vulnerabilities, tracking CVEs, and guidelines for using the reference implementation.

# Reference Implementation
The DemoIccMAX reference implementation is intended as a guideline and should not be considered production-ready code.
Any code intended for production use should undergo thorough security reviews and extensive product testing to ensure it meets the necessary standards.

## Reporting a Bug

When you discover a bug, please open an Issue with all relevant details and a proof of concept. Including a patch is highly encouraged.

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
