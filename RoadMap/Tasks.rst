#format wiki
#language en

= Tasks To Be Done =

This page accumulates the tasks which need to be done in Squid but are too minor to require a feature write-up on their own.

Feel free to jump in and try any of these tasks. Most can be done in small steps. Any contributions are welcome.

=== Large Incremental Tasks:  ===

These are large when looked at in full, but any small incremental part you can do is a lot of help.
Check with squid-dev mailing list to see what we are up to and how you can assist the move forward on these.

 * Document the source code with Doxygen format.

 * Add unit tests for each class, API method and function already in existence to improve code quality and speedup future testing.

=== Small Tasks ===

Small, but nagging. These might be done already if this page is not updated regularly.
Check with squid-dev to see if its already done.

 * Migrate Feature requests from bugzilla to wiki pages.

 * Fix kqueue bugs once and for all (ie, delete events for closed FDs)
 * Implement /dev/poll support for Solaris 7/8/9/10 network IO

 * Copy-n-paste ''deprecated'' languages text snippets from old templates into new ''.po'' system. (taking ~1-3 hrs per language)
 * Verify or Update one of the non-modified [[../../Translations|translated Squid error pages]].
 * Add a new language [[../../Translations|translation for Squid error pages]].

 * Cleanup Squid component macros that enable/disable components:
  1. make all the naming convention USE_* (with USE_SQUID_* for those which may clash with OS defines).
  2. make all have the same #if...#endif syntax (currently a mix of #if and #ifdef)
  3. add a testbed scan to detect misuse of (2) syntax

----
CategoryWish
