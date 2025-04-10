
# analyze_heap_allocations.py

## Overview
Analyzes heap memory allocations to detect issues like double frees or invalid memory access.

## Purpose
This script is part of the LLDB helper scripts designed to enhance the debugging and profiling experience for the DemoIccMAX project.

## Usage
1. Load the script in LLDB:
    ```bash
    command script import /path/to/contrib/lldb/analyze_heap_allocations.py
    ```
    
2. Call the appropriate function from the script as needed within the LLDB session.

## Example
```bash
(lldb) analyze_heap_allocations.py
```
