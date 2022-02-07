#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
<<TableOfContents>>
= Introduction =

The Squid source code has evolved more from empirical observation and
tinkering, rather than a solid design process.  It carries a legacy of being
"touched" by numerous individuals, each with somewhat different techniques and
terminology.

Squid is a (mostly) single-process proxy server.  Every request is handled by
the main process, with the exception of FTP.  However, Squid does not use a
''threads package'' such has Pthreads.  While this might be easier to code, it
suffers from portability and performance problems.  Instead Squid maintains
data structures and state information for each active request.

The code is often difficult to follow because there are no explicit state
variables for the active requests.  Instead, thread execution progresses as a
sequence of ''callback functions'' which get executed when I/O is ready to
occur, or some other event has happened.  As a callback function completes, it
is responsible for registering the next callback function for subsequent I/O.

Note there is only a pseudo-consistent naming scheme.  In most cases functions
are named like {{{moduleFooBar()}}}.  However, there are also some functions
named like {{{module_foo_bar()}}}.

Note that the Squid source changes rapidly, and some parts of this document
may become out-of-date.  If you find any inconsistencies, please feel free to
modify this document.

= Conventions =

Function names and file names will be written in a courier
font, such as {{{store.c}}} and {{{storeRegister()}}}.  Data
structures and their members will be written in an italicized
font, such as ''!StoreEntry''.

= Coding Conventions =

== Infrastructure ==


Most custom types and tools are documented in the code or the relevant
portions of this manual. Some key points apply globally however.

=== Fixed width types ===

If you need to use specific width types - such as
a 16 bit unsigned integer, use one of the following types. To access
them simply include "config.h".

 * int16_t   - 16 bit signed.
 * u_int16_t - 16 bit unsigned.
 * int32t    - 32 bit signed.
 * u_int32_t - 32 bit unsigned.
 * int64_t   - 64 bit signed.
 * u_int64_t - 64 bit unsigned.
