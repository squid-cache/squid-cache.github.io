A ZeroSizedReply error page is shown when squid successfully sends the request to the next hop server, and then the connection is dropped with no data sent back.

Common causes for repeated occurences of this are:
 * Broken firewalls such as Cisco PIX's expecting all the HTTP request headers in the first packet. (Worked around in current squid releases).
 * The origin server crashing due to a bug of some sort.
