##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

= Feature: HTTPS (Secure HTTP or TLS explicit proxy) =

 * '''Version''': 2.5
 * '''More''': RFC RFC:2817, [[Features/HTTPS]], [[Features/S-HTTP]]

<<TableOfContents>>

= Encrypted browser-Squid connection =

Squid can accept regular proxy traffic using SquidConf:https_port in the same way Squid does it using an SquidConf:http_port directive. Unfortunately, popular modern browsers do not permit configuration of TLS/SSL encrypted proxy connections. There are open bug reports against most of those browsers now, waiting for support to appear. If you have any interest, please assist browser teams with getting that to happen.

Meanwhile, tricks using stunnel or SSH tunnels are required to encrypt the browser-to-proxy connection before it leaves the client machine. These are somewhat heavy on the network and can be slow as a result.

== Chrome ==

The Chrome browser is able to connect to proxies over SSL connections if configured to use one in a PAC file or command line switch. GUI configuration appears not to be possible (yet).

More details at http://dev.chromium.org/developers/design-documents/secure-web-proxy

== Firefox ==

The Firefox 33.0 browser is able to connect to proxies over TLS connections if configured to use one in a PAC file. GUI configuration appears not to be possible (yet), though there is a config hack for [[https://bugzilla.mozilla.org/show_bug.cgi?id=378637#c68|embedding PAC logic]].

There is still an important bug open:
 * Using a client certificate authentication to a proxy: https://bugzilla.mozilla.org/show_bug.cgi?id=209312

If you have trouble with adding trust for the proxy cert, there is [[https://bugzilla.mozilla.org/show_bug.cgi?id=378637#c65|a process]] by Patrick McManus to workaround that. 

----
CategoryFeature
