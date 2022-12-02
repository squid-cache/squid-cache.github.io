---
categories: ReviewMe
published: false
---
# Guidelines for contributors

  - Use ANSI C.

  - Keep in portability in mind. Test your changes on different
    platforms.

  - Follow the coding style of the rest of the code.

  - Submit diffs with `diff -Nur old new`. It is a good idea to review
    the diff before submission to ensure it contains your changes and no
    unrelated/accidental changes.

  - Squid uses automake, so any makefile changes must be done in
    Makefile.am, NOT Makefile.in.

  - On any changes to Makefile.am files or configure.in, run
    ./bootstrap.sh to regenerate automake/autoconf derived files (see
    also ProgrammingGuide/Bootstrap)

  - Consider hosting your development at devel.squid-cache.org until
    ready to be merged into the main sources

# Guidelines for core developers

Those who commit code to the main cvs.squid-cache.org CVS repository
should also

  - Announce major changes to squid-dev some days before making the
    change to give the other core developers a chance to veto on the
    change.

  - Code MUST be formatted with GNU indent version 1.9.1 and these exact
    options indent -br -ce -i4 -ci4 -l80 -nlp -npcs -npsl -d0 -sc -di0
    -psl

  - DO NOT attempt using any other version of indent or options. The CVS
    server will not accept the code if formatted differently.
