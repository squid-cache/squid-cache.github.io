#format wiki
#language en

= Tasks To Be Done =

This page accumulates the tasks which need to be done in Squid but are too minor to require a feature write-up on their own.

Feel free to jump in and try any of these tasks. Most can be done in small steps. Any contributions are welcome.

=== Large Incremental Tasks:  ===

These are large when looked at in full, but any small incremental part you can do is a lot of help.
Check with squid-dev mailing list to see what we are up to and how you can assist the move forward on these.

Some of the more urgent smaller tasks inside these big ones have been broken out.

 * Document the source code with Doxygen format
  1. src/Store.* and related
  2. src/comm.* and related
  3. src/DelayPools.* and related

 * Add unit tests for each class, API method and function already in existence to improve code quality and speedup future testing.
  1. src/acl/*
  2. src/ip/*

 * Removing useless includes.
  1. Pick a system .h listed in compat/types.h and drop all other places with #include by src/* and includes/* files.
  2. going through each .h file and minimizing the other .h it includes, using class pre-defines where possible. (This is being done during SourceLayout somewhat so contact squid-dev before attempting).

 * Check external Copyrights are up-to-date in CREDITS
 1. Go through the helper/* files and check ~/CREDITS contains one copy of each copyright for any files with header-copyright present.
 2. do the above for each lib/* and lib/libTrie file 
 3. highlight any non-GPLv2 compatible copyrights found to squid-dev.

=== Small Tasks ===

Small, but nagging. These might be done already if this page is not updated regularly.
Check with squid-dev to see if its already done.

 * Migrate Feature requests from bugzilla to wiki pages. (FrancescoChemolli, mostly done. Needs second round after Apr 20th, 2009)

 * Fix kqueue bugs once and for all (ie, delete events for closed FDs)
 * Implement /dev/poll support for Solaris 7/8/9/10 network IO

 * Copy-n-paste ''deprecated'' languages text snippets from old templates into new ''.po'' system. (taking ~1-3 hrs per language)
 * Verify or Update one of the non-modified [[../../Translations|translated Squid error pages]].
 * Add a new language [[../../Translations|translation for Squid error pages]].

 * Cleanup Squid component macros that enable/disable components:
  1. make all the naming convention USE_* (with USE_SQUID_* for those which may clash with OS defines).
  2. make all have the same #if...#endif syntax (currently a mix of #if and #ifdef)
  3. add a testbed scan to detect misuse of (2) syntax

 * Fix Squid-3 MD5 layer:
  1. migrate MD5 code to libcompat
  2. ensure correct use of system libraries when such can be found
  3. ensure correct failover to squid code when such are missing
  4. port --without-system-md5 configure option to force the above

 * SMP preparation
  1. remove all uses of LOCAL_ARRAY() macro

----
CategoryWish
