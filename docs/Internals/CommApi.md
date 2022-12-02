# Network Communications

## Stuff to keep in mind

  - The comm code needs to say simple, light-weight and fast; its going
    to be called -a lot-
  - The comm code needs to be reasonably flexible wrt its IO buffering -
    ideally I'd like the Squid comm model to map reasonably cleanly onto
    Windows Completion Ports IO and any similar APIs that pop up for
    \*NIX

## How I view the communications layer

  - A way of scheduling reads and writes to network sockets
  - A simple way of filling/emptying data buffers

## What stuff I'd like the comm layer to do and not do

  - be involved in scheduling read/write to stream sockets (currently
    comm_read and comm_write)
  - be involved in UDP datagram socket send/recv where possible
  - I'd also like the comm layer to get involved with delayed reads like
    it is right now
  - It should also take control of creating and tearing down sockets;
    tracking half-closed sockets and such
  - In theory, code shouldn't ever get its fingers into the
    fd_table[] and fdc_table[]; there should be really cheap
    inline methods to do so

### The current comm API
```
comm_read
comm_fill_immediate
comm_empty_os_read_buffers
comm_has_pending_read_callback
comm_has_pending_read
comm_read_cancel
fdc_open
comm_udp_recvfrom
comm_udp_recv
comm_udp_send
comm_has_incomplete_write
comm_write
comm_local_port
commBind
comm_open
comm_openex
commConnectStart
commSetTimeout
comm_connect_addr
comm_lingering_close
comm_reset_close
comm_close
comm_add_close_handler
comm_remove_close_handler
commSetNonBlocking
commUnsetNonBlocking
comm_init
comm_old_write
comm_old_write_mbuf
ignoreErrno
checkTimeouts
comm_listen
comm_accept_try
comm_accept
commMarkHalfClosed
commIsHalfClosed
commCheckHalfClosed
DeferredRead::DeferredRead()
CommSelectEngine::checkEvents()
```

### What I'd like the network comm layer to look like

- There should only be one pending read and one pending write IO op
  per filedescriptor
- .. and therefore, only one pending read/write IO callback per
  filedescriptor
- The comm_read/comm_write routines should use a statically
  allocated - one per FD - read/write callback structure. This
  structure should have a dlink_node to 'thread' them together to
  form a completed callback list.
- The UDP send/receive routines should become callback-driven
- The buffer management should be done by the comm layer and a
  reference to completed buffers should be given to the callee. Why?
  - I'd like the comm code to fill/empty the buffers as appropriate;
  - and if producers/consumers wish to consume less (eg delay pools)
    then the comm buffer will fill up and the comm layer will cease
    scheduling IO until the buffer is close to or empty;
  - It also means we could cut down on IO scheduling overhead (which
    Steve Wilton managed to "do" as an optimisation in the epoll
    code, ta Steve\!) to schedule IO changes whenever they happen,
    not each read/write
  - I'd like to support Windows Completion IO and whatever strange
    and wonderful things the \*NIX world comes up with in the future
    to cut back on that extra copy
- Finally, it has to stay simple and lightweight but filling and
  emptying buffers as quickly and efficiently as possible.

### What needs to be thought about!

- The whole "pack header into contiguous memory range and then write
  that out once" when we really should be using writev().
- If the average 'web' object size is still under 64k in size then we
  should be able to do all of that in a single write() (or writev())
  without any copying.
- Whats the most optimal size to read/write?
