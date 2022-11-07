# Squid-2 Roadmap

## Overview

This document outlines the timeline for Squid-2.

|          |                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| today    | Squid-2.x is **CONSIDERED DANGEROUS** as the security people say. Due to unfixed vulnerabilities **[CVE-2014-7141](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-7142](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-6270](http://www.squid-cache.org/Advisories/SQUID-2014_3.txt), [CVE-2009-0801](http://www.squid-cache.org/Advisories/SQUID-2011_1.txt)** and any other recently discovered issues. |
| Aug 2012 | the Squid-2.7 series became **OBSOLETE** with the release of [Squid-3.2](/Squid-3.2#) features                                                                                                                                                                                                                                                                                             |
| Aug 2011 | Henrik announced end of Squid-2.x support and **DEPRECATED** Squid-2.7                                                                                                                                                                                                                                                                                                                                                                            |
| May 2008 | the active Squid developers are now concentrating all new features and developments at Squid-3 or later. If those versions do not meet your requirements please contact squid-dev about the missing features. The list [to be ported](http://www.squid-cache.org/Versions/v3/3.5/RELEASENOTES.html#s5) is quite small and shrinking.                                                                                                              |

## Release Map

The remaining Squid-2 plans are now planned for implementation later in
the
[RoadMap](/RoadMap#).

  - Restructure the data paths:
    
      - Server -\> Store buffer referencing **(Complete; not
        integrated)**

  - **BEGUN (3.5+)** Restructure HTTP request and reply paths to take
    advantage of buffer referencing

  - **BEGUN (3.1+)** Break out some code into separate library modules,
    including documentation and some unit testing
    
      - **BEGUN (3.5+)** memory management
    
      - debugging
    
      - **BEGUN (3.5+)** buffers
    
      - **BEGUN (3.5+)** strings
    
      - **BEGUN (4.0+)** http request parsing
    
      - **BEGUN (3.6+)** http reply construction

  - **BEGUN (3.2+)** Separate out client-side server-side code from
    caching logic

  - Split storage index lookup code to be fully asynchronous

  - Look at supporting sparse objects efficiently

[CategoryFeature](/CategoryFeature#)
