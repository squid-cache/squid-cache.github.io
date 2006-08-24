This page just has a general TODO of various bogons noticed in squid.

 * internal requests - we change their protocol to HTTP in client_side, and then back to INTERNAL in client_side_reply. WTF.
 * delegate stuff like httpCachable to the request object, and from there to the URLScheme.
 * 
