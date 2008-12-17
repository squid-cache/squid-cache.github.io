##master-page:CategoryTemplate
#format wiki
#language en

= Dynamic SSL Certificate Generation =

 * '''Goal''': Reduce the number of "certificate mismatch" browser warnings when impersonating a site using the [[Features/SslBump|SslBump]] feature

 * '''Status''': In progress; phase2 almost completed

 * '''ETA''': February 15, 2008

 * '''Version''': v3.2

 * '''Priority''': 1

 * '''Developer''': AlexRousskov, Andrew Balabohin

 * '''More''': Requires [[Features/SslBump|SslBump]], development [[https://code.launchpad.net/~rousskov/squid/DynamicSslCert|branch]]

= Details =

This page describes dynamic SSL certificate generation feature for  [[Features/SslBump|SslBump]] environments. After a short introduction, we document the overall design, followed by the implementation plan. We expect the design and the implementation plan to be adjusted as we learn more about the environment.

== Motivation ==

[[Features/SslBump|SslBump]] users know how many certificate warnings a single complex site (using dedicated image, style, and/or advertisement servers for embedded content) can generate. The warnings are legitimate and are caused by Squid-provided site certificate. Two things may be wrong with that certificate:

 A. Squid certificate is not signed by a trusted authority.
 A. Squid certificate name does not match the site domain name.

Squid can do nothing about (A), but in most targeted environments, users will trust the "man in the middle" authority and install the corresponding root certificate.

To avoid mismatch (B), the !DynamicSslCert feature concentrates on generating site certificates that match the requested site domain name. Please note that the browser site name check does not really add much security in an !SslBump environment where the user already trusts the "man in the middle". The check only adds warnings and creates page rendering problems in browsers that try to reduce the number of warnings by blocking some embedded content.

== Design highlights ==

=== Certificate generator code ===

Generating certificates using OpenSSL command line interface is relatively simple but takes a few seconds per domain name. This delay may not be acceptable in high-performance environments. Squid uses OpenSSL libraries and avoids shell scripts to optimize certificate generation.

=== Certificate generator location ===

If certificate generation blocks Squid, all current users have to wait. A simple blocking solution may not work in a high-performance environment as it would be easy to take Squid "out" for a minute just by opening a few SSL connections.

To avoid blocking effects, Squid uses a pool of designated threads or processes to generate the needed certificates asynchronously. Using this approach, only the users establishing SSL connections have to wait for a few seconds, which is often acceptable.

=== Certificate reuse ===

Generated certificates are cached in RAM (to speed up hits) and also on disk (to maintain state across reboots and failures).

== Implementation plan ==

'''Phase 1''': Generate certificates in the main Squid process, using blocking OpenSSL shell scripts. No certificate caching. Other than performance, the end-user-visible functionality should be complete by the end of this Phase.

'''Phase 2''': Support RAM caching of generated certificates. We should be able to judge certificate "hit" performance by the end of Phase 2.

'''Phase 3a''': Support fast generation of certificates using OpenSSL libraries.

'''Phase 3b''': Move certificate generation to a separate thread or process. Use a pool of threads or processes if necessary.  We should be able to judge certificate "miss" performance by the end of Phase 3.

'''Phase 4''': Support disk caching of generated certificates. It is not yet clear whether the disk cache should be maintained by Squid core, a dedicated thread, or the thread generating the certificates.

----
CategoryFeature
