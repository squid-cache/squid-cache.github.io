##master-page:CategoryTemplate
#format wiki
#language en

= Media Streams: How can I proxy and cache Real Audio?  =

 by ''Rodney van den Oever'' and ''James R Grinter''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

HTTP is an alternative delivery mechanism introduced with version 3 players,
and it allows a reasonable approximation to "streaming" data - that is playing
it as you receive it.

It isn't available in the general case: only if someone has made the realaudio
file available via an HTTP server, or they're using a version 4 server, they've
switched it on, and you're using a version 4 client. If someone has made the
file available via their HTTP server, then it'll be cachable. Otherwise, it
won't be (as far as we can tell.)

The more common Real``Audio link connects via their own ''pnm:'' protocol and is
transferred using this proprietary protocol (via TCP or UDP) and not using
HTTP. It can't be cached nor proxied by Squid, and requires something such as
the simple proxy that Progressive Networks themselves have made available, if
you're in a firewall/no direct route situation. Their product does not cache
(and I don't know of any software available that does.)

Some confusion arises because there is also a configuration option to use an
HTTP proxy (such as Squid) with the Real``Audio/Real``Video players. This is
because the players can fetch the ".ram" file that contains the ''pnm:''
reference for the audio/video stream. They fetch that .ram file from an HTTP
server, using HTTP.


== Squid Configuration File ==

Note that the first request is a POST, and the second has a '?' in the URL, so
standard Squid configurations would treat it as non-cachable. It also looks
rather "magic."

Paste the configuration file like this:

{{{
acl GET method GET
acl POST method POST

acl RealAudio_url url_path_regex /SmpDsBhgRl(.*)
acl RealAudio_mime req_mime_type application/x-pncmd
}}}

 ''NP:'' The URL-Path regex in this is case-sensitive. DO NOT use the '''-i''' option on this pattern.

=== to block the media streams ... ===

Use the ACL above in '''http_access''':
{{{
http_access deny GET RealAudio_url
http_access deny POST RealAudio_mime
}}}

=== to cache the media stream ... ===

POST are not cacheable by default. To enable caching of !RealAudio POST:
{{{
cache allow POST RealAudio_mime
}}}

The followup GET request is a Dynamic URL.  Squid-3.0 and earlier come with defaults which prevents dynamic content being cached. This needs to be removed in order to cache the stream data GET request.

see [[../../DynamicContent|dynamic content]] configuration example for how to cache this.

== Real Audio Configuration ==

  * Point the Real``Player at your Squid server's HTTP port (e.g. 3128).
  * Using the Preferences->Transport tab, select ''Use specified transports'' and with the ''Specified Transports'' button, select use ''HTTP Only''.


###  legacy stuff from FAQ

== Real Audio documentation ==

The ''Real Player''(and ''Real Player Plus'') manual states:
{{{
Use HTTP Only
Select this option if you are behind a firewall and cannot
receive data through TCP.  All data will be streamed through
HTTP.

Note:  You may not be able to receive some content if you select
this option.
}}}

Again, from the documentation:
{{{
RealPlayer 4.0 identifies itself to the firewall when making a
request for content to a ''RealServer''.  The following string is
attached to any URL that the Player requests using HTTP GET:

/SmpDsBhgRl

Thus, to identify an HTTP GET request from the RealPlayer, look
for:

http://[^/]+/SmpDsBhgRl

The Player can also be identified by the mime type in a POST to
the RealServer.  The RealPlayer POST has the following mime
type:

"application/x-pncmd"
}}}

----
CategoryConfigExample
