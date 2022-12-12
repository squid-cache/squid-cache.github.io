---
---
Memory management is a thorny issue in Squid. Its single-process nature
makes it very important no to leak memory in any circumstance, as even a
single leaked byte per request can grind a proxy to a halt in a few
hours of production useage.

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
([memory_pools](http://www.squid-cache.org/Doc/config/memory_pools)
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
