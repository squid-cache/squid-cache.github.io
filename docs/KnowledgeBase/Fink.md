---
categories: KnowledgeBase
---
# Squid on Fink

## Pre-Built Binary Packages

Packages available in binary or source for Squid on i86 64-bit, i86
32-bit and PowerPC architectures.

Package Information:
<http://pdb.finkproject.org/pdb/package.php/squid-unified>

**Maintainer:** Benjamin Reed

## Compiling

Squid compiles on Mac OS X. However, there are some steps required
before following the general build instructions.

1. **Install Xcode**
    1. From Mac OS X, run the "AppStore" application
    2. Locate "Xcode", Apple's development environment
    3. Install "Xcode"
1. **Install Command-Line Tools**
    1. Launch "Xcode".
    2. Open "Xcode | Preferences".
    3. Bring up the "Downloads" tab.
    4. Under "Components" click the "Install" button for "Command Line
        Tools".
    5. Quit Xcode.
1. **Verify Command-Line Tools**
    1. Launch "Terminal", usually located in the "Utilities" folder
        under "Applications".
    2. Run "gcc --version". Manually verify this produces sane output.
1. From this point, the
    [general build instructions](/SquidFaq/CompilingSquid#How_do_I_compile_Squid.3F)
    should be all you need.

> :warning:
    It is worth noting this platform doesn't support EUI. The
    --enable-eui ./configure will cause build errors.
