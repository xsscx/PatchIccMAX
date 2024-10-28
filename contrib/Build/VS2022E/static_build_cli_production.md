# Production msbuild for DemoIccMAX static linking

This document provides insight for building the **DemoIccMAX** project using a static linking configuration, optimized for performance, security, and best practices. This build is intended for **Windows 11** with **Visual Studio 2022 Enterprise** and uses the MSBuild CLI.

## Overview

The following MSBuild command is used to compile and link the DemoIccMAX project:

```bash
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:CLToolAdditionalOptions="/MT /W4 /GS /Qspectre /GL /std:c++17" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO /DYNAMICBASE /HIGHENTROPYVA /NXCOMPAT /GUARD:CF /GUARD:EH /SAFESEH /FIXED:NO" /p:PreprocessorDefinitions="STATIC_LINK" /p:RuntimeLibrary=MultiThreaded /p:AdditionalLibraryDirectories="F:\test\vcpkg\installed\x64-windows-static\lib" /p:AdditionalDependencies="wxmsw32u_core.lib;wxbase32u.lib;%(AdditionalDependencies)" /t:Clean,Build
```

This command ensures the following:

- **Static Linking**: No dynamic runtime dependencies are introduced.
- **Security Hardened**: Various security flags ensure the executable is resistant to common vulnerabilities.
- **Optimized for Performance**: Whole program optimizations and link-time code generation (LTCG) are enabled for maximum efficiency.

---

## Command Breakdown

### 1. **Parallel Build:**
   ```bash
   /m /maxcpucount
   ```
   - **/m**: Enables parallel building using multiple CPU cores.
   - **/maxcpucount**: Dynamically determines the maximum number of concurrent processes for the build. This ensures faster builds, especially for large projects.

### 2. **Release Configuration:**
   ```bash
   /p:Configuration=Release
   ```
   - Specifies that the build should be optimized for release. In **Release** mode, optimizations are enabled, and debug information is minimized.

### 3. **64-bit Platform:**
   ```bash
   /p:Platform=x64
   ```
   - Targets 64-bit architecture (x64), ensuring compatibility with modern hardware and addressing more memory.

### 4. **Static Linking via vcpkg:**
   ```bash
   /p:VcpkgTriplet=x64-windows-static
   ```
   - Specifies the vcpkg triplet `x64-windows-static`, ensuring that all dependencies are statically linked. This eliminates the need for runtime dynamic libraries.

### 5. **Compiler Settings:**
   ```bash
   /p:CLToolAdditionalOptions="/MT /W4 /GS /Qspectre /GL /std:c++17"
   ```
   - **/MT**: Links the static multithreaded runtime library, ensuring no dependency on dynamic CRT (C Runtime Library).
   - **/W4**: Enables strict warning level 4, encouraging developers to write safer and more reliable code by flagging potential issues.
   - **/GS**: Enables buffer security checks to mitigate stack-based buffer overruns, improving security.
   - **/Qspectre**: Mitigates Spectre speculative execution vulnerabilities.
   - **/GL**: Enables whole program optimization during compilation for better performance.
   - **/std:c++17**: Specifies C++17 standard for modern language features.

### 6. **Linker Settings:**
   ```bash
   /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO /DYNAMICBASE /HIGHENTROPYVA /NXCOMPAT /GUARD:CF /GUARD:EH /SAFESEH /FIXED:NO"
   ```
   - **/NODEFAULTLIB:msvcrt**: Avoids linking to the dynamic C runtime library, ensuring static linking.
   - **/LTCG**: Enables link-time code generation, optimizing the entire program at the linking stage.
   - **/OPT:REF**: Eliminates unreferenced functions and data, reducing the size of the executable.
   - **/INCREMENTAL:NO**: Disables incremental linking to ensure a fully optimized final binary.
   - **/DYNAMICBASE**: Enables Address Space Layout Randomization (ASLR) to make it harder for attackers to predict memory addresses.
   - **/HIGHENTROPYVA**: Extends ASLR to 64-bit address space for better security.
   - **/NXCOMPAT**: Marks the binary as compatible with Data Execution Prevention (DEP), preventing execution of code in non-executable memory regions.
   - **/GUARD:CF**: Enables Control Flow Guard (CF Guard) to mitigate memory corruption vulnerabilities by preventing invalid indirect call targets.
   - **/GUARD:EH**: Enables Guard for Exception Handling, adding another layer of protection against misuse of exceptions.
   - **/SAFESEH**: Ensures that only registered exception handlers can be executed, preventing some types of exploits.
   - **/FIXED:NO**: Allows the executable to be loaded at any address in memory, further supporting ASLR.

### 7. **Preprocessor Definitions:**
   ```bash
   /p:PreprocessorDefinitions="STATIC_LINK"
   ```
   - Defines `STATIC_LINK` as a preprocessor macro, signaling that the project is being built with static linkage.

### 8. **Runtime Library:**
   ```bash
   /p:RuntimeLibrary=MultiThreaded
   ```
   - Ensures the multithreaded runtime library is statically linked, consistent with `/MT`.

### 9. **Library Directories:**
   ```bash
   /p:AdditionalLibraryDirectories="F:\test\vcpkg\installed\x64-windows-static\lib"
   ```
   - Adds an additional path to search for libraries, pointing to vcpkg-installed libraries.

### 10. **Additional Dependencies:**
   ```bash
   /p:AdditionalDependencies="wxmsw32u_core.lib;wxbase32u.lib;%(AdditionalDependencies)"
   ```
   - Explicitly links the wxWidgets libraries and other dependencies specified in the project file.

### 11. **Target Tasks:**
   ```bash
   /t:Clean,Build
   ```
   - **Clean**: Cleans all previous build outputs to ensure a fresh build.
   - **Build**: Builds the solution using the specified configuration.

---

## Best Practices and Security Recommendations

### 1. **Consistent Static Linking**:
   - Ensure that all libraries (including third-party dependencies) are linked statically to avoid dynamic library conflicts and reduce runtime dependencies. Using `/MT` and specifying static libraries from vcpkg helps achieve this.

### 2. **Security Features**:
   - Utilize `/GS`, `/Qspectre`, `/GUARD:CF`, and `/SAFESEH` to prevent common security vulnerabilities such as buffer overflows, speculative execution attacks, and control flow hijacking.
   - Enabling `/DYNAMICBASE` and `/HIGHENTROPYVA` ensures compatibility with modern operating system protections like ASLR.
   - **Tip**: Regularly audit the security flags used in the build process to ensure they align with current best practices.

### 3. **Optimization**:
   - **Whole Program Optimization (WPO)**: Using `/GL` and `/LTCG` ensures that the entire program is optimized during linking, leading to better performance.
   - **Function Elimination**: Use `/OPT:REF` to remove unused code, reducing the final binary size and attack surface.

### 4. **Warnings as Errors**:
   - Consider enabling `/WX` (Treat Warnings as Errors) to enforce stricter coding standards during development and catch potential issues early.

---

## Developer Education and Resources

Developers working on this project should familiarize themselves with:

- **MSBuild Documentation**: [MSBuild Reference](https://learn.microsoft.com/en-us/visualstudio/msbuild/msbuild?view=vs-2022)
- **Security Flags Overview**: Understanding the purpose of security flags like `/GS`, `/Qspectre`, `/GUARD:CF`, and more.
- **C++17 Features**: Since the project enforces C++17, developers should be aware of new language features and optimizations available in this standard.

By following this build configuration and adhering to the guidelines provided here, developers can ensure that the DemoIccMAX project is built securely, efficiently, and with best practices in mind.

---

## Further Reading

- [ICC Color Profiles and Standards](https://www.color.org/)
- [Visual Studio 2022 Enterprise Documentation](https://docs.microsoft.com/en-us/visualstudio/?view=vs-2022)
