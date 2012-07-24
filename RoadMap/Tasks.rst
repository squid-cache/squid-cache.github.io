#format wiki
#language en

= Tasks To Be Done =

This page accumulates the tasks which need to be done in Squid but are too minor to require a feature write-up on their own.

Feel free to jump in and try any of these tasks. Most can be done in small steps. Any contributions are welcome.

=== Incremental Tasks:  ===

Tasks in this section need to be done in a rough order to make the changes easy. These may look large in full, but any small incremental part you can do is a lot of help. Check with squid-dev mailing list to see what we are up to and how you can assist the move forward on these.

 * Document the source code with Doxygen format
  1. src/Store.* and related
  2. src/comm.* and related
  3. src/DelayPools.* and related

 * Migration to smart Pointer framework
  1. update a HttpRequest raw pointer to a HttpRequest::Pointer. Including all code performing locking on it
  1. update a HttpReply raw pointer to a HttpReply::Pointer. Including all code performing locking on it
  1. update a HttpMsg raw pointer to a HttpMsg::Pointer. Including all code performing locking on it
  1. update a CBDATA raw pointer to a CbcPointer. Including all code performing validation tests and locking on it.

 * Migration to the STUB.h framework
  1. update existing stub_ files to use src/tests/STUB.h
  2. create a src/tests/stub_libX.cc for each convenience library API using src/tests/STUB.h
  3. find unit tests which can be linked to the stub instead of the library and update the makefiles
  4. find unit tests with unnecessary linkages and remove (mostly in src/Makefile.am)

 * Add unit tests for each class, API method and function already in existence to improve code quality and speedup future testing.
  1. src/acl/*
  2. src/ip/*

 * Removing useless includes.
  1. Pick a system .h listed in compat/types.h and drop all other places with #include by src/* and includes/* files.
  2. going through each .h file and minimizing the other .h it includes, using class pre-defines where possible. (This is being done during Features/SourceLayout somewhat so contact squid-dev before attempting).

 * Check external Copyrights are up-to-date in CREDITS
  1. Go through the helper/* files and check ~/CREDITS contains one copy of each copyright for any files with header-copyright present.
  1. Go through the lib/* files and check ~/CREDITS contains one copy of each copyright for any files with header-copyright present.
  1. highlight any non-GPLv2 compatible copyrights found to squid-dev.

 * Normalize the debug level 0 and 1 messages
  1. Convert all {{{debugs(*, 0, ...}}} lines to use DBG_CRITICAL
  1. Convert all {{{debugs(*, 1, ...}}} lines to use DBG_IMPORTANT
  1. Convert all {{{opt_parse_cfg_only?0:n}}} code to using DBG_PARSE_NOTE(n)
  1. verify all DBG_CRITICAL output conforms to the labeling criterion in [[SquidFaq/SquidLogs#Squid_Error_Messages|the FAQ]]
  1. verify all DBG_CRITICAL and DBG_IMPORTANT output has a KnowledgeBase page describing it (as per [[SquidFaq/SquidLogs#Squid_Error_Messages|the FAQ]])

=== Small Tasks ===

Small, but nagging annoyances. These might be done already if this page is not updated regularly.
Check with squid-dev to see if its already done.

 * Migrate Feature requests from bugzilla to wiki pages. (FrancescoChemolli, mostly done. Needs second round after Apr 20th, 2009)

 * Fix kqueue bugs once and for all (ie, delete events for closed FDs)
  . http://bugs.squid-cache.org/show_bug.cgi?id=1991
  . http://bugs.squid-cache.org/show_bug.cgi?id=2816
  . 

 * Language and Translation
  1. Verify or Update one of the non-modified [[Translations|translated Squid error pages]].
  2. Add a new language [[Translations|translation for Squid error pages]].
  3. log the language dialect(s) going through your Squid (logformat languages %{Accept-Language} ) and help supply the translations team (via squid-dev)

 * Cleanup Squid component macros that enable/disable components:
  1. make all the naming convention USE_* (with USE_SQUID_* for those which may clash with OS defines).

 * Fix Squid-3 MD5 layer:
  1. migrate MD5 code to libcompat
  2. ensure correct use of system libraries when such can be found
  3. ensure correct failover to squid code when such are missing
  4. port --without-system-md5 configure option to force the above

 * Helper and Tool Manuals
  1. Write a manual/man(8) page for a helpers/ program that does not have one.
  2. Update the existing README.txt and other help docs into proper manuals.
  3. Benchmark documentation.
    . How fast can each helper run?
    . For helpers with multiple backends (ie DB), how do they compare?

----
CategoryWish
