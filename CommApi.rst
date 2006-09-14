#language en
## add some descriptive text. A title is not necessary as the WikiPageName is already added here.
## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]
== Network Communications ==
=== Stuff to keep in mind ===
 * The comm code needs to say simple, light-weight and fast; its going to be called -a lot-
 * The comm code needs to be reasonably flexible wrt its IO buffering - ideally I'd like the Squid comm model to map reasonably cleanly onto Windows Completion Ports IO and any similar APIs that pop up for *NIX
=== How I view the communications layer ===
 * A way of scheduling reads and writes to network sockets
 * A simple way of filling/emptying data buffers
=== What stuff I'd like the comm layer to do and not do ===
 * be involved in scheduling read/write to stream sockets (currently comm_read and comm_write)
 * be involved in UDP datagram socket send/recv where possible
 * I'd also like the comm layer to get involved with delayed reads like it is right now
 * It should also take control of creating and tearing down sockets; tracking half-closed sockets and such
 * In theory, code shouldn't ever get its fingers into the fd_table[] and fdc_table[]; there should be really cheap inline methods to do so
=== The current comm API ===
{{{
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
}}}
=== What I'd like the comm layer to look like ===
