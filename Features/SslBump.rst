##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Squid-in-the-middle SSL Bump =

 * '''Goal''': Enable ICAP inspection of SSL traffic.
 * '''Status''': Done; waiting for commit to Squid3 HEAD
 * '''ETA''': December 1, 2007
 * '''Version''': Squid 3.1
 * '''Developer''': AlexRousskov

Squid-in-the-middle decryption and encryption of straight CONNECT and transparently redirected SSL traffic, using configurable client- and server-side certificates. While decrypted, the traffic can be expected using ICAP.

By default, most user agents will warn end-users about a possible man-in-the-middle attack.

----
CategoryFeature
