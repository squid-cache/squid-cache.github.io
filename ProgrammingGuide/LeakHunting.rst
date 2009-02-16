## page was renamed from ProgrammingGuide/LeakFinder
#language en

<<TableOfContents>>

= leakFinder =


''src/leakfinder.c'' contains some routines useful for debugging
and finding memory leaks.  It is not enabled by default.  To enable
it, use
{{{
configure --enable-leakfinder ...
}}}


The module has three public functions: ''leakAdd'',
''leakFree'', and ''leakTouch'' Note, these are actually
macros that insert {{{__FILE__}}} and {{{__LINE__}}} arguments to the real
functions.

''leakAdd'' should be called when a pointer is first created.
Usually this follows immediately after a call to malloc or some
other memory allocation function.  For example:
{{{
    ...
    void *p;
    p = malloc(100);
    leakAdd(p);
    ...
}}}


''leakFree'' is the opposite.  Call it just before releasing
the pointer memory, such as a call to free.  For example:
{{{
    ...
    leakFree(foo);
    free(foo);
    return;
}}}
NOTE: ''leakFree'' aborts with an assertion if you give it a
pointer that was never added with ''leakAdd''.



The definition of a leak is memory that was allocated but never
freed.  Thus, to find a leak we need to track the pointer between
the time it got allocated and the time when it should have been
freed.  Use ''leakTouch'' to accomplish this.  You can sprinkle
''leakTouch'' calls throughout the code where the pointer is
used.  For example:
{{{
void
myfunc(void *ptr)
{
    ...
    leakTouch(ptr);
    ...
}
}}}
NOTE:  ''leakTouch'' aborts with an assertion if you give it
a pointer that was never added with ''leakAdd'', or if the
pointer was already freed.


For each pointer tracked, the module remembers the filename, line
number, and time of last access.  You can view this data with the
cache manager by selecting the ''leaks'' option.  You can also
do it from the command line:
{{{
% client mgr:leaks | less
}}}


The way to identify possible leaks is to look at the time of last
access.  Pointers that haven't been accessed for a long time are
candidates for leaks.  The filename and line numbers tell you where
that pointer was last accessed.  If there is a leak, then the bug
occurs somewhere after that point of the code.
