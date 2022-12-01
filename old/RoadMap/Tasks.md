# Tasks To Be Done

This page accumulates the tasks which need to be done in Squid but are
too minor to require a feature write-up on their own.

Feel free to jump in and try any of these tasks. Most can be done in
small steps. Any contributions are welcome.

## Incremental Tasks:

Tasks in this section need to be done in a rough order to make the
changes easy. These may look large in full, but any small incremental
part you can do is a lot of help. Check with squid-dev mailing list to
see what we are up to and how you can assist the move forward on these.

  - Document the source code with Doxygen format
    
    1.  src/Store.\* and related
    
    2.  src/comm.\* and related
    
    3.  src/DelayPools.\* and related

  - Migration to smart Pointer framework
    
    1.  update a
        [HttpRequest](/HttpRequest)
        raw pointer to a
        [HttpRequest](/HttpRequest)::Pointer.
        Including all code performing locking on it
    
    2.  update a
        [HttpReply](/HttpReply)
        raw pointer to a
        [HttpReply](/HttpReply)::Pointer.
        Including all code performing locking on it
    
    3.  update a
        [HttpMsg](/HttpMsg)
        raw pointer to a
        [HttpMsg](/HttpMsg)::Pointer.
        Including all code performing locking on it
    
    4.  update a CBDATA raw pointer to a CbcPointer. Including all code
        performing validation tests and locking on it.

  - Migration to the STUB.h framework
    
    1.  create a src/tests/stub_libX.cc for each convenience library
        API using src/tests/STUB.h
    
    2.  find unit tests which can be linked to the stub instead of the
        library and update the makefiles
    
    3.  find unit tests with unnecessary linkages and remove (mostly in
        src/Makefile.am)
    
    4.  :information_source:
        This is being tracked in
        [Features/SourceLayout](/Features/SourceLayout).

  - Add unit tests for each class, API method and function already in
    existence to improve code quality and speedup future testing.
    
    1.  src/acl/\*
    
    2.  src/ip/\*

  - Removing useless includes.
    
    1.  going through each .h file and minimizing the other .h it
        includes, using class pre-defines where possible. (This is being
        done during
        [Features/SourceLayout](/Features/SourceLayout)
        somewhat so contact squid-dev before attempting).

  - Normalize the debug level 0 and 1 messages
    
    1.  verify all DBG_CRITICAL output conforms to the labeling
        criterion in [the
        FAQ](/SquidFaq/SquidLogs#Squid_Error_Messages)
    
    2.  verify all DBG_CRITICAL and DBG_IMPORTANT output has a
        [KnowledgeBase](/KnowledgeBase)
        page describing it (as per [the
        FAQ](/SquidFaq/SquidLogs#Squid_Error_Messages))
        or a Feature page troubleshooting entry.

  - Improve stats collection and reporting APIs
    
      - `StatHist` has a bigger than needed API, showing its age and
        heritage. Stats collection and stats reporting should be
        disassociated, in order to allow unit tests to only include the
        former while only using stubs of the latter.

## Small Tasks

Small, but nagging annoyances. These might be done already if this page
is not updated regularly. Check with squid-dev to see if its already
done.

  - Fix kqueue bugs once and for all (ie, delete events for closed FDs)
    
      - [](http://bugs.squid-cache.org/show_bug.cgi?id=1991)
    
      - [](http://bugs.squid-cache.org/show_bug.cgi?id=2816)
    
      - 
  - Language and Translation
    
    1.  Verify or Update one of the non-modified [translated Squid error
        pages](/Translations).
    
    2.  Add a new language [translation for Squid error
        pages](/Translations).
    
    3.  log the language dialect(s) going through your Squid (logformat
        languages %{Accept-Language} ) and help supply the translations
        team (via squid-dev)

  - Cleanup Squid component macros that enable/disable components:
    
    1.  .convention for Makefile.am conditionals is ENABLE_\* (currenty
        some have incorrect USE_\* maro names)

  - Helper and Tool Manuals
    
    1.  Write a manual/man(8) page for a helpers/ program that does not
        have one.
    
    2.  Update the existing README.txt and other helper docs into proper
        manuals ([todo
        list](/ProgrammingGuide/ManualDocumentation#TODO))
    
    3.  Benchmark documentation.
        
          - How fast can each helper run?
        
          - For helpers with multiple backends (ie DB), how do they
            compare?

[CategoryWish](/CategoryWish)
