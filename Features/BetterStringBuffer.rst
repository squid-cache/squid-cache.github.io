##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Better String memory usage =

 * '''Goal''':  Improve the usage of short strings to use best-practice, efficient, pointer-safe APIs.
 * '''Status''': On hold
 * '''ETA''': unknown
 * '''Version''': Squid 3.1
 * '''Developer''': AmosJeffries
 * '''More''': TODO: Add a link to the existing patch here.

Improve the usage of memory-pooled strings and the string API. The code is presently not using best-practice or pointer-safety with regards to short strings. Nor is it using them widely in place of un-pooled character arrays where it could provide greater memory management easily.

The code is laid out and waiting to be merged in incremental steps during regular code maintenance.

Plans for the string API are intended to allow improved access at all current usage of strings (ESI, ICAP, others?) and allow for improved and safer access to larger buffers (HTTP parser, URI Parser, etc).

----
CategoryFeature | CategoryWish
