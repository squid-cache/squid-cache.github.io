# Enable squid to detect Variant URI

### Contacts

Anyone on Development Team

### Description

A number of sites around the web send out identical content on different
URI. This is often found occuring due to:
- bad designs in load-balancing
- attempts at explicit cache-busting
- non-compliance with HTTP privacy standards
- dynamic pages redirecting internally
- URI-based user sessions
- some site mirror setups

Enabling squid to detect such duplication and serve the content from
cache, without pulling the entire new URI object down from the web and
storing it separately would greatly increase the cachability of many
popular website.

### Progress

The existence has not yet even made it to the drawing board properly. A
number of problems have been identified, but not all solved as yet.
Please contact the Squid developer team if you're interested in
discussing the implementation of this feature.
