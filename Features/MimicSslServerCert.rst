##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: Mimic original SSL server certificate when bumping traffic =

 * '''Goal''': Pass original SSL server certificate information to the user. Allow the user to make an informed decision on whether to trust the server certificate.
 * '''Status''': In progress
 * '''ETA''': March 2012
 * '''Version''': 3.3
 * '''Priority''': 2
 * '''Developer''': AlexRousskov
 * '''More''': requires [[Features/BumpSslServerFirst|bump-server-first]] and benefits from [[Features/DynamicSslCert|Dynamic Certificate Generation]]


= Motivation =

One of the [[Features/SslBump|SslBump]] serious drawbacks is the loss of information embedded in SSL server certificate. There are two basic cases to consider from Squid point of view:

 * '''Valid server certificate:''' The user may still want to know who issued the original server certificate, when it expires, and other certificate details. In the worst case, what may appear as a valid certificate to Squid, may not pass HTTPS client tests, even if the client trusts Squid to bump the connection. 
 * '''Invalid server certificate:''' This is an especially bad case because it forces Squid to either bypass the certificate validation error (hiding potentially critical information from the trusting user!) or terminate the transaction (without giving the user a chance to make an informed exception).

Hiding original certificate information has never been the intent of lawful !SslBump deployments. Instead, it was an undesirable side-effect of the initial !SslBump implementation. Fortunately, this limitation can be removed in most cases, making !SslBump less intrusive and less dangerous.


= Implementation overview =

OpenSSL APIs allow us to extract and use origin server certificate properties when generating a fake server certificate. In general, we should mimic all properties except for signatures (reproducing the latter would make the certificate unusable for bumping the connection, of course).

The ssl_crtd daemon would have to receive original server certificate to mimic its properties.

A [[Features/BumpSslServerFirst|bump-server-first]] support is required to get the original server certificate before we have to send our fake certificate to the client.

Implementation details will be posted as they become available.


= Limitations =

The initial implementation is unlikely to support mimicking of certificate chains.

----
CategoryFeature
