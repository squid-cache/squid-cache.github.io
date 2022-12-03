## HTTP File Helper

### Contacts

Henrik Nordstrom, Amos Jeffries

### Description

A small but useful feature would be for squid to contain a simple dumb
HTTP server capable of providing content such as error page images and
CSS. Possibly also PAC files, either static or built from squid.conf.
This feature would sort out a number of long standing issues Squid has.
As envisioned this would serve its files from a standard network port
(defaults: 80 or 81) such that squid can generate links to ip:port in
pages and process any resulting requests as a standard HTTP request.

### Progress

The existence of such a helper is still very much on the drawing board.

Please contact the Squid developer team if you're interested in
discussing the implementation of this feature.
