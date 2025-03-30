
## ✅ Verified Static Libraries with Coverage Instrumentation

Both key static libraries have been built and verified to contain `__llvm_prf_data` instrumentation symbols.

### 🔧 libIccProfLib2.a (Static, Instrumented)

```
cd Build/iccproflib
make -f Makefile.proflib
ar -x libIccProfLib2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "  → [INSTRUMENTED] $f"; done; rm -f *.o
```

✅ Output:
```
  → [INSTRUMENTED] IccApplyBPC.o
  → [INSTRUMENTED] IccArrayBasic.o
  → ...
  → [INSTRUMENTED] IccXformFactory.o
```

---

### 🔧 libIccXML2.a (Static, Instrumented)

```
cd Build/iccxml
make -f Makefile.iccxml check-prof
```

✅ Output:
```
[CHECK] Extracting and checking instrumentation in libIccXML2.a
  → [INSTRUMENTED] IccIoXml.o
  → ...
  → [INSTRUMENTED] IccUtilXml.o
✅ Instrumentation detected.
```

---

These verified `.a` files are now ready for linking into profiled tools (e.g., `iccToXml`, `iccFromXml`) to generate runtime coverage.

