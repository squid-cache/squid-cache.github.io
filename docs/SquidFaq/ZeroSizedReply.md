# What is the meaning of a Zero Sized Reply?

A ZeroSizedReply error page is shown when squid successfully sends the
request to the next hop server, and then the connection is dropped with
no data sent back.

Common causes for repeated occurrences of this are:
- Poorly implemented firewalls firewalls
- The origin server crashing due to a bug of some sort.
- persistent connections from Squid to server, with a low client
  request rate going down them. At around the same frequency as the
  server timeout closes the link there is a race condition whether the
  send happens before the read that detects the link closed.