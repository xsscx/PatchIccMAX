# 🛠️ iccFromXml Instrumentation Repro

This directory contains a standalone instrumentation + profiling harness for the `IccFromXml` tool in the IccMAX project.

## 📄 Description

`iccFromXml` converts XML to ICC binary profiles format. This harness builds the tool with Clang instrumentation to enable LLVM coverage analysis.

---

## ✅ Build

```bash
make -f Makefile.iccFromXml
```

## ▶️ Run (generate `.profraw`)

```bash
make -f Makefile.iccFromXml run
```

## 📊 Generate Coverage Report

```bash
make -f Makefile.iccFromXml report
```

Resulting report will be saved in `coverage_fromxml.txt`.

---

## 📁 Dependencies

- LLVM toolchain (`clang++`, `llvm-profdata`, `llvm-cov`)
- `libxml2-dev`
- Profiling `.a` libs from:
  - `../iccxml/libIccXML2.a`
  - `../iccproflib/libIccProfLib2.a`

---

## 🧪 Inputs

- Input ICC: `../../TestProfiles/sample.xml`
- Output XML: `out.icc` (temporary)

---
