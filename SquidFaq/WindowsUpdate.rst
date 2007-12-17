#language en
[[TableOfContents]]

##begin
== Why does it go so slowly through Squid? ==

Windows Update apparently uses HTTP Range-Offsets' (AKA file partial ranges) to grab pieces of the Microsoft Update archive in parallel or using a random-access algorithm trying to reduce the web tarffic. Some versions of Squid do not handle or store Ranges very well yet.

The work-around used by many cache maintainers has been to set the range_offset to -1. Meaning that squid is configured to always pull the entire file from the start when a range is requested.

Compounding the problem and ironically causing your slowdown is the fact that some of the Microsoft servers may be telling your Squid not to store the archive file. This means that Squid will pull the entire archive every time it needs any small piece.

You will need to test your squid config with and without the range_offset bypass and see which provides the best results for you.

== How do I stop Squid popping up the Authentication box for Windows Update? ==

Add the following to your squid.conf, assuming you have defined '''localnet''' to mean your local clients. It ''''MUST'''' be added near the top before any ACL that require authentication.

{{{
acl windowsupdate dstdomain windowsupdate.microsoft.com
acl windowsupdate dstdomain .update.microsoft.com
acl windowsupdate dstdomain download.windowsupdate.com
acl windowsupdate dstdomain redir.metaservices.microsoft.com
acl windowsupdate dstdomain images.metaservices.microsoft.com
acl windowsupdate dstdomain c.microsoft.com
acl windowsupdate dstdomain www.download.windowsupdate.com
acl windowsupdate dstdomain wustat.windows.com
acl windowsupdate dstdomain crl.microsoft.com


acl CONNECT method CONNECT
acl wuCONNECT dstdomain www.update.microsoft.com

http_access allow CONNECT securityCONNECT localnet
http_access allow windowsupdate localnet
}}}

The above config is also useful for other automatic update sites such as Anti-Virus vendors, just add their domains to the acl.

##end
----
Back to the SquidFaq
