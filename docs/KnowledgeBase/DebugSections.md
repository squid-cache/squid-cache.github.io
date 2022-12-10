---
categories: KnowledgeBase
---
# What Debug Sections and debug_options in squid.conf are all about

## Synopsis

Sometimes people need to see more than just the fatal or critical
problems occurring within Squid.

Squid contains its own debugging system broken into sections and levels.

- **Section** means a component within squid that does some particular
    operation.
- **Level** means the amount of information needed about any given
    section.

They are configured in squid.conf with the
[debug_options](http://www.squid-cache.org/Doc/config/debug_options)
setting as a list of Section,Level pairs. Each pair is set
left-to-right. If a section is mentioned twice the last mentioned level
is used.

Generally only ALL,0 is used, to display any major issues in need of
urgent fix. These are problems fatal to squid and if your squid is
crashing the problem is mentioned in cache.log at level 0.

Administrators may also set
**[debug_options](http://www.squid-cache.org/Doc/config/debug_options) ALL,1**
to get a report of issues which are not causing critical
problems to squid, but which may be fatal to certain client requests.
These messages usually also indicate network issues the admin should be
looking at fixing.

Higher debugging levels are available if an issue needs tracking
step-by-step through the code. They go up to 9, though 6 contain most
information needed by the developers to debug.

## What the Levels mean

**level 0**
- Critical issues only. No debug information at all.
- Always displayed
- These are problems fatal to squid and if your squid is crashing
    the problem is mentioned in cache.log at level 0.
> :information_source:
    currently Startup, Shutdown and Reconfigure do produce output at
    this level.

**level 1**
- Important issues.
- Default Squid behaviour is to log at this level unless
    otherwise configured
- These messages usually indicate network issues the admin should
    be looking at fixing.

**level 2**
- Protocol Traffic. Generally used only by the high-level
    protocol sections (eg. sections 9-12).

**level 3-4** 
- Legacy debugs
- Section specific info a developer once thought to be important
    enough to highlight for troubleshooting.

**level 5** 
- Most useful debug information is displayed at this level.

**level 6
- More detail of debug information, if level-5 is not
    displaying enough about a specific problem.

**level 7-8** 
- Some section specific debug information not commonly
    useful. (eg lock counting).

**level 9**
- Raw I/O data. May contain privacy or security sensitive
    information. Guaranteed to generate very large cache.log.

## What the Section numbers mean

We take great pains to keep debug sections consistent across releases.
The current catalog of debug sections is at
<https://github.com/squid-cache/squid/blob/master/doc/debug-sections.txt>
