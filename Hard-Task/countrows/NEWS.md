# GrepReaper News

## GrepReaper 0.1.0 (2023-11-22)

### New Features

* Initial release of GrepReaper with three pattern matching approaches:
  * Easy Task: Implementation using R's native `grep()` function
  * Medium Task: Pattern matching with `data.table::fread()` and command-line grep
  * Hard Task: Full R package (`countrows`) with comprehensive documentation and testing

### Package Structure

* Created complete R package structure with Rd files, tests, and vignettes
* Implemented memory-efficient pattern matching using system commands
* Added support for case-insensitive searching

### Documentation

* Comprehensive README with examples for all three approaches
* Comparison table of approaches by memory usage, performance, and complexity
* Installation and usage instructions for the R package
