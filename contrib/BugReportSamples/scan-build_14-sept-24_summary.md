# Scan-build Report Comparison (Q4|2023-Q3|2024)

Last Updated: 12 September 2024

| **Category**                               | **Q4 2023** | **Q2 2024** | **Sep 12, 2024** | **Change** | **Comments**                                                                                                                                  |
|--------------------------------------------|-------------|-------------|-----------------|------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| **All Bugs**                               | 113         | 118         | 111             | -7         | Overall bug count reduced in the latest report, showing improvement in the codebase.                                                          |
| **API**                                    | -           | -           | 5               | +5         | New category detecting API misuse (null passed where non-null is expected).                                                                  |
| **Logic Errors**                           |             |             |                 |            |                                                                                                                                               |
| Assigned value is garbage or undefined     | 2           | 1           | 1               | No change  | The assigned value garbage issue remains consistent across the last two reports.                                                              |
| Called C++ object pointer is null          | 3           | 2           | 2               | No change  | No change between Sep 2024 and the latest report, suggesting stability in handling null pointers.                                              |
| Dereference of null pointer                | 13          | 14          | 14              | No change  | Null pointer dereference issues remained the same between the last two reports.                                                               |
| Garbage return value                       | 1           | 1           | -               | N/A        | No longer reported in the most recent data.                                                                                                   |
| Result of operation is garbage or undefined| 4           | 4           | -               | N/A        | No longer reported in the most recent data.                                                                                                   |
| Uninitialized argument value               | 6           | 3           | 3               | No change  | Uninitialized arguments remain the same as in the last report.                                                                                 |
| Unix API                                   | 4           | 4           | -               | N/A        | Unix API errors are not mentioned in the latest report.                                                                                        |
| **Memory Errors**                          |             |             |                 |            |                                                                                                                                               |
| Bad deallocator                            | 7           | 6           | 4               | -2         | Significant improvement in deallocation handling in the latest report.                                                                        |
| Double free                                | 2           | 2           | 2               | No change  | Double free issues remain consistent across all reports.                                                                                      |
| Memory leak                                | 10          | 13          | 13              | No change  | Memory leaks persist in both Sep 2024 and the latest report, requiring attention.                                                             |
| Use-after-free                             | 8           | 9           | 9               | No change  | No new use-after-free errors introduced in the most recent report.                                                                             |
| Use of zero allocated                      | -           | 1           | 1               | No change  | New issue introduced in the Sep 2024 report persists in the latest data.                                                                      |
| **Unix API (Memory)**                      |             |             |                 |            |                                                                                                                                               |
| Allocator sizeof operand mismatch          | 1           | 1           | 1               | No change  | No change, suggesting this edge case issue is still unresolved.                                                                               |
| **Unused Code**                            |             |             |                 |            |                                                                                                                                               |
| Dead assignment                            | 28          | 30          | 30              | No change  | Dead assignments remain unchanged since the Sep 2024 report.                                                                                  |
| Dead increment                             | 3           | 4           | 4               | No change  | No change between Sep 2024 and the latest report.                                                                                             |
| Dead initialization                        | 20          | 22          | 21              | -1         | One dead initialization issue was resolved between the Sep 2024 and latest report.                                                            |
| Dead nested assignment                     | 1           | 1           | 1               | No change  | The dead nested assignment issue remains consistent across all reports.                                                                       |

### Summary of Key Differences:
1. **Overall Bug Count**: The number of bugs has decreased from 118 in Sep 2024 to 111 in the latest report, showing an improvement in code quality.
2. **New API Issues**: 5 instances of API misuse (`nonnull` attributes passed null) were detected in the latest report.
3. **Memory Errors**: Significant reduction in **bad deallocator** issues, but **memory leaks** and **use-after-free** errors persist.
4. **Dead Code**: Dead assignments, increments, and nested assignments remain consistent, with only minor improvements in dead initialization.

