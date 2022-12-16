---
---
# bootstrap.sh
The **bootstrap.sh** script runs a number of autotools to prepare
./configure and related magic. See [DeveloperResources](/DeveloperResources)
for the tools required by this script.

It doesn't always work. Here are some errors and solutions:

## Common problems

### possibly undefined macro: AC_LTDL_DLLIB

This sometimes happens on Debian based systems:

*Problem*

```
    configure.in:34 error: possibly undefined macro: AC_LTDL_DLLIB
          If this token and others are legitimate, please use m4_pattern_allow.
          See the Autoconf documentation.
```

*Solution*

- install libltdl3-dev or libltdl7-dev

### 'ltdl.m4' not found in '/usr/share/aclocal'

This sometimes happens on Debian based systems:

*Problem*

```
    libtoolize: 'ltdl.m4' not found in '/usr/share/aclocal'
    libtoolize failed
    Autotool bootstrapping failed. You will need to investigate and correct
    before you can develop on this source tree
```

*Solution*

  - install libltdl7-dev
