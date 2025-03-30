
# 🧪 ICC Coverage & Unit Testing Sample

## ✅ 1. Tags by Frequency

| Tag                | Occurrences | Notes |
|--------------------|-------------|-------|
| `Curve`            | 2884        | 🔥 Highest frequency — test edge cases (e.g., short/empty/huge curves) |
| `XYZNumber`        | 1237        | 🎯 High occurrence — should be in unit tests for all color conversions |
| `LocalizedText`    | 896         | 📛 Ensure coverage of language variants and unicode edge cases |
| `TableData`        | 699         | 🧮 Exercise large vs small tables |
| `FormulaSegment`   | 642         | 📐 Validate complex function math logic |
| `ParametricCurve`  | 589         | 📈 Must be tested with boundary values and invalid forms |
| `script`           | 568         | ⚠️ Test for execution safety / parser bugs |
| `multiProcessElementType` | 497  | 🧩 Nested elements, should be fuzzed deeply |
| `MatrixElement`    | 463         | ➗ Numerical stability & overflow testing |

---

## 🗂️ 2. High Coverage Files (Tag Count/Uniqueness)

| File                                   | Unique Tags |
|----------------------------------------|-------------|
| `CRPC6-V5-Part2.xml`                   | 72          |
| `Calibrated_A2B_XYZ_Mismatch.xml`     | 66          |
| `APTEC_PC10_CardBoard_2023_v1.xml`    | 64          |
| `calcUnderStack_*.xml` group           | ~60 each    |

🟢 **Recommendation**: Prioritize these in regression test sweeps and coverage fuzzing.

---

## 💥 3. Fragile Files (Failing Inputs)

| Example File                                 |
|---------------------------------------------|
| `calcUnderStack_*` (many variants fail)      |
| `poc-2225.xml` and derivatives               |
| `icPlatformSignature-ubsan-poc.xml` variants |

🔺 **Action**: Build a fuzz target set from failed inputs — great source of edge and malformed cases.

---

## 🔢 4. Hot Files by Tag Density

| File                        | Tag Count |
|-----------------------------|-----------|
| `xyz2PolyEstimateRefV2.xml` | 291       |
| `WebSafeColors.xml`         | 281       |
| `...colorsync...poc-666.xml`| 261       |
| `TestCLT.xml`               | 144       |
| `NamedColor.xml`            | 122       |

📌 **These files are dense**: run code path coverage and targeted validation here.

---

## 🧪 TODO

### ✔️ Add Tests For:
- `Curve`, `XYZNumber`, `LocalizedText`, `script`, `ParametricCurve`, `FormulaSegment`
- `calcUnderStack_*` edge math behavior
- `NamedColor` structure parsing
- `multiProcessElements` nested handling

### 🧼 Remove/Down-prioritize:
- Files with <20 tags and no failures (e.g., `zero-tags.xml`, `error_20231030_204730.xml`)

---

## 📌 Test Suite Targets

| Category                | Representative Tags/Files                            |
|-------------------------|------------------------------------------------------|
| Structural Coverage     | `multiProcessElements`, `Curve`, `MatrixData`        |
| Edge Math               | `calcUnderStack_*`, `ParametricCurve`, `FormulaSegment` |
| Text/Unicode            | `LocalizedText`, `Unicode`, `TextData`               |
| File-Level Integration  | `TestCLT.xml`, `CRPC6-V5-Part2.xml`, `NamedColor.xml` |
| Fragility Regression    | All entries in `failed_inputs.txt`                   |
| Coverage Densification  | Top 10 from `hot-files.txt`                          |
