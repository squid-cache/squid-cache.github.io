# New Logging Stuff

## What is it?

The Squid logging stuff isn't:

  - fast enough - stdio, same execution thread as Squid

  - flexible enough - only can write to a file; can't write over the
    network, to MySQL, etc.

The aim of this is to enumerate a replacement logging facility for Squid
which will be fast and flexible.

## Previous attempts

  - Some dead sourceforge project I think? Logging over TCP; saw
    messages being "lost" and thus was never finished

  - s26\_logfile sourceforge branch - Adrian's initial attempt at simply
    breaking the logging out to an external process; didn't lose
    messages and showed great promise but wasn't finished.

## Stuff learnt doing s26\_logfile

  - Logs need to be rotated at the point where the person runs "squid -k
    rotate"; this means the rotate command has to be in-line with the
    rest of the logging message data. It was initially implemented as a
    signal which worked great but missed out on those messages which
    were "in-flight" in the kernel socket buffer between processes, or
    still buffered in Squid and awaiting sending to the helper

  - stdio by default does character by character reading in certain
    situations - make sure you use setvbuf() appropriately or your
    performance will suck (ie, a -lot- of single byte read() syscalls.)

## Stuff the new logfile thing should do

  - Could be implemented varnish-style - shared memory ring buffer -
    fast, efficient, perhaps not portable to embedded environments (but
    is Squid currently portable to embedded environments?
    ![:)](https://wiki.squid-cache.org/wiki/squidtheme/img/smile.png)

  - UNIX stream sockets / pipes / loopback TCP: mostly portable
    everywhere, well-understood semantics. Need to be careful that you
    structure your messages in such a way that the OS has a chance of
    wrapping the messages up in VM trickery rather than having to copy
    the data around. Best way to ensure this - have your messages a
    fixed multiple of the page size and hope the application malloc()
    doesn't recycle those pages too quickly. Grr\!

  - Still, even at 10,000 req/sec with an average logging line length of
    160 characters thats 1.52 megabytes a second of data to copy; not
    exactly a huge amount for modern machines.

  - It shouldn't bother trying to enumerate the logging entries at all
    in the first pass. Just have them formatted in Squid and sent over
    as lines. It'd be nice if they were TLV encoded (it'd make the
    receiver's job easier if it wants to do any kind of processing - eg
    import into MySQL) but that can be version 2.

  - .. version the messages.

  - Sequence the messages - that way people implementing the logging
    process by blit-data-over-UDP will already have a nice,
    monotonically-incrementing sequence number they can use and don't
    have to fondle the packet themselves

  - Have certain "control" sequences:
    
      - "Rotate logfiles now"
    
      - "Flush what you have to disk now"
    
      - "Flush and shutdown"
    
      - What else?

  - s26\_logfile treated individual logfile lines as commands - a
    command was simply a line, and most of them would be logging lines.
    The most efficient method would be to bunch the logfile lines up
    into a big chunk that can be written all at once to disk or the UDP
    socket but, to be honest, people will probably like having each line
    seperately enumerated.

## Implementation details

  - Doing this using the Squid helper framework is fine

  - But you want to queue large amounts of data to write, not just
    write() line by line into the logging pipe; that makes 0 sense.

  - Change the Squid logfile\*() routine semantics a little; ie:
    
      - "start of line"
    
      - "append data"
    
      - "end of line"
    
      - Again, this is slightly overkill, but I think the current code
        assumes it can write the logfile lines out partially and have it
        assembled correctly at the end. Tsk.

  - Break the logging framework out into an API that can be served by
    different implementations, ie:
    
      - "sync logging" - ie, like now
    
      - "syslog logging" - which is currently implemented as \#ifdef's
        everywhere but probably shouldn't be
    
      - "logfile helper" - what this document discusses

## Initial logging helpers?

  - "Write this to disk please"

  - Find a volunteer to write a "write this to disk \_AND\_ write out to
    MySQL too whilst you're at it"

  - Find another volunteer to write a "write this to disk and/or TCP
    socket please."

  - Grab the Wikipedia patch which does logging over UDP and massage it
    into this framework

  - Anthing else?

## Version 2?

  - TLV the logfile lines (which should be easy for the custom logfile
    format)

  - shared memory ring buffers?

  - What else?

[CategoryFeature](/CategoryFeature#)
[CategoryWish](/CategoryWish#)
