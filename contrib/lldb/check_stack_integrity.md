
# check_stack_integrity.py

## Overview
Checks for potential stack overflows and corruption.

## Purpose
This script is part of the LLDB helper scripts designed to enhance the debugging and profiling experience for the DemoIccMAX project.

## Usage
1. Load the script in LLDB:
    ```bash
    command script import /path/to/contrib/lldb/check_stack_integrity.py
    ```
    
2. Call the appropriate function from the script as needed within the LLDB session.

## Example
```bash
(lldb) check_stack_integrity.py
```