---
categories: ReviewMe
published: false
---
# Obsolete Operating Systems

  - **Goal**: Remove support for operating systems whose last release
    was a LONG time ago.

  - **Status**: *Ongoing*

  - **Version**: 4.1

  - **ETA**: unknown

  - **Developer**:
    [FrancescoChemolli](/FrancescoChemolli)

# Details

Squid supports some operating systems whose last release was a LONG time
ago. It may be sensible to clean up the codebase a bit and drop support
for them

Removed in
[Squid-4](/Releases/Squid-4)
:

  - BSDi

  - SunOs \<4 (last release 1995)

  - Ultrix

Candidates for obsolescence are:

  - NextStep (last release 1994)
    
      - QNX is a current OS apparently based on
        [NextStep](/NextStep)
        and needs checking to see whether it still relies on Next
        specific code.

[CategoryFeature](/CategoryFeature)
