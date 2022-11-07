Memory management is a thorny issue in Squid. Its single-process nature
makes it very important no to leak memory in any circumstance, as even a
single leaked byte per request can grind a proxy to a halt in a few
hours of production useage.

# leakFinder

  - 
    
    |                                                                      |                                                                                                                                                                                                                                             |
    | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) | Leak Finder is known to crash [Squid-3.3](/Squid-3.3#) and older when AUFS or threading is used. Please use valgrind (below) if you need to debug in those components. |
    

*src/leakfinder.c* contains some routines useful for debugging and
finding memory leaks. It is not enabled by default. To enable it, use

    configure --enable-leakfinder ...

The module has three public functions: *leakAdd*, *leakFree*, and
*leakTouch* Note, these are actually macros that insert `__FILE__` and
`__LINE__` arguments to the real functions.

*leakAdd* should be called when a pointer is first created. Usually this
follows immediately after a call to malloc or some other memory
allocation function. For example:

``` 
    ...
    void *p;
    p = malloc(100);
    leakAdd(p);
    ...
```

*leakFree* is the opposite. Call it just before releasing the pointer
memory, such as a call to free. For example:

``` 
    ...
    leakFree(foo);
    free(foo);
    return;
```

NOTE: *leakFree* aborts with an assertion if you give it a pointer that
was never added with *leakAdd*.

The definition of a leak is memory that was allocated but never freed.
Thus, to find a leak we need to track the pointer between the time it
got allocated and the time when it should have been freed. Use
*leakTouch* to accomplish this. You can sprinkle *leakTouch* calls
throughout the code where the pointer is used. For example:

    void
    myfunc(void *ptr)
    {
        ...
        leakTouch(ptr);
        ...
    }

NOTE: *leakTouch* aborts with an assertion if you give it a pointer that
was never added with *leakAdd*, or if the pointer was already freed.

For each pointer tracked, the module remembers the filename, line
number, and time of last access. You can view this data with the cache
manager by selecting the *leaks* option. You can also do it from the
command line:

    % client mgr:leaks | less

The way to identify possible leaks is to look at the time of last
access. Pointers that haven't been accessed for a long time are
candidates for leaks. The filename and line numbers tell you where that
pointer was last accessed. If there is a leak, then the bug occurs
somewhere after that point of the code.

# Valgrind

[Valgrind](http://valgrind.org/) is an advanced runtime profiler that
can be very useful for finding memory leaks. Unfortunately, if you are
not a Squid developer, you will need to work with one to correctly
interpret valgrind results because Squid memory usage often triggers
false valgrind leak reports.

Squid can be executed within a valgrind environment "as is", but to
reduce the number of false positives, it is best to `./configure` Squid
`--with-valgrind-debug`. `./configure --disable-optimizations` helps
when interpreting valgrind reports (but slows Squid down). Disabling
memory pools
([memory\_pools](http://www.squid-cache.org/Doc/config/memory_pools#)
off) further reduces the number of false positives. Another essential
technique for minimizing false positives, is using valgrind
suppressions. The attached suppressions
[file](/ProgrammingGuide/LeakHunting?action=AttachFile&do=get&target=valgrind.supp)
will probably be out of date when you need to use it (or will not be
compatible with your Squid version), so adjust it as needed. Such
adjustments require good understanding of Squid code.

Here is one way to start Squid under valgrind control:

    valgrind -v \
        --trace-children=yes \
        --num-callers=50 \
        --log-file=valgrind-%p.log \
        --leak-check=full \
        --leak-resolution=high \
        --show-reachable=yes \
        --gen-suppressions=all \
        --suppressions=etc/valgrind.supp \
        sbin/squid ...

With the above command line options, detected problems (including leaks)
are detailed throughout each valgrind report (one report for each
process started by Squid).

There is a useful summary at the end of a report. For example:

    ==11905== LEAK SUMMARY:
    ==11905==    definitely lost: 0 bytes in 0 blocks
    ==11905==    indirectly lost: 0 bytes in 0 blocks
    ==11905==      possibly lost: 36 bytes in 1 blocks
    ==11905==    still reachable: 1,905,982 bytes in 111 blocks
    ==11905==         suppressed: 1,026,644 bytes in 10,263 blocks

When Squid is `./configure`d `--with-valgrind-debug`, the memory usage
information reported via the cache manager interface (e.g., `squidclient
mgr:mem`) includes a valgrind report.
