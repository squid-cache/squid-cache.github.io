---
---
# Misplaced ToDo's

> :warning:
    The right place to list bugs is the bugzilla database.

> :warning:
    The right place to list future improvements is the
    [Features](/Features) area, marking them as
    [WantedFeaeture](/Categories/WantedFeature.md)

> :warning:
    The right place to list minor tasks anyone can do is the
    [Roadmap Tasks list](/RoadMap/Tasks).

Please do not dump to-do items here. If you get a chance, move these
items to the right places.

This list page just has a general TODO of various bogons noticed in
squid.

- internal requests - we change their protocol to HTTP in
    client_side, and then back to INTERNAL in client_side_reply. WTF.
- delegate stuff like httpCachable to the request object, and from
    there to the URLScheme.
- HTTP is considered unrevalidatable in client_side. Fixable by
    delegation to the protocol
- why do we consider PUT requests to internal: etc servable ?
- HTCP requests are not listed in the client db
- ICP and HTCP are not protocols like the other protocols - split them
    out ?

# Ancient TODO list from Squid 1.1 thru 2.5

This TODO list is no longer accurate. For more updated Squid plans see:
[WantedFeatures](/Categories/WantedFeature)

<!-- end list -->

- [ ]  overlapping helper feature implementation (plain or stateful or
    both).
- [ ] always/never direct syntax cleanups.
- [ ] refactoring of acl driven types to reduce amount of duplicated
    code (acl_check, acl_tos, acl_address, acl_size_t, ...)
- [ ]  ETag caching (???)
- [ ] Generalize socket binding to allow for multiple ICP/HTCP/SNMP sockets
    (get rid of udp_incoming_address) (???)
- [ ]  Rework the store API like planned
- [ ] Improved event driven comm code
- [ ]  Buffer management (required by store API and comm code improvements)
- [ ]  Improved reply processing to not reparse the reply headers several
    times
- [ ] Implement HTCP authentication
- [ ]  Log HTCP queries somewhere, like htcp_query.log
- [ ]  There are various places where ICP means ICP/HTCP, and
    other places where it does not. For example, cachemgr 'counters'
    stats like icp.pkts_sent count only ICP. However, in
    'peer_select' stats, ICP does include HTCP as well.
- [ ]  dont re-sibling requests which came from a sibling
- [ ] A customizable cache replacement policy. Ugh, this could be
    interesting since we just optimized the LRU replacement with a
    doubly-linked list.
- [ ] Calculate Content-Length for multipart range replies (AR)
- [ ] Efficient public peer access control \*without ACLs\* :
    Bill Wichers `<billw@unix0.waveform.net>` Dave Zarzycki
    `<zarzycki@ricochet.net>` \# distant_peer_deny (icmp rtt)
    (hops) \# If the ICP client is farther than "z" hops away, \# or
    if more than y% of pings to the client exceed \# x milliseconds,
    then deny. distant_peer_deny 200 75 10
- [ ] What to do about ACL's and URL escaping?
- [ ] Review RFC 2068 and RFC 2109 for header handing, especially
    Cache-Control.
- [ ] Everywhere that we use 'pattern' or such, use ACL elements instead.
- [ ] stoplist_pattern, refresh_pattern, ... (DW)
- [ ] Refresh based on content types. This means we'll need an enum of
    known content types added to StoreEntry. Unknown types will
    lose.
- [ ] Write binary headers as metadata?
- [ ] HTML-escape special characters in errorConvert().
- [ ] X-Proxy-hops header?
- [ ]  \#ifdefs to disable IP caching
- [ ] REST for failed ftp transfers.
- [ ] MD5 acl type
