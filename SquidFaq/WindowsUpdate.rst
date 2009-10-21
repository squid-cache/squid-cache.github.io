#language en
<<TableOfContents>>

##begin
== Why does it go so slowly through Squid? ==

Windows Update apparently uses HTTP Range-Offsets' (AKA file partial ranges) to grab pieces of the Microsoft Update archive in parallel or using a random-access algorithm trying to reduce the web traffic. Some versions of Squid do not handle or store Ranges very well yet.

The work-around used by many cache maintainers has been to set the '''SquidConf:range_offset_limit -1'''. Meaning that squid is configured to always pull the entire file from the start when a range is requested.

 {i} Compounding the problem and ironically causing some slowdowns is the fact that some of the Microsoft servers may be telling your Squid not to store the archive file. This means that Squid will pull the entire archive every time it needs any small piece.

You will need to test your squid config with and without the SquidConf:range_offset_limit bypass and see which provides the best results for you.

Another symptoms which occasionally appear when attempting to force caching of windows updates is service packs.

 {i} If the SquidConf:quick_abort_min, SquidConf:quick_abort_max, SquidConf:quick_abort_pct settings are set to abort a download incomplete and a client closes with almost but not quite enough of the service pack downloaded. That clients following requests will often timeout waiting for Squid to re-download the whole object from the start. Which naturally causes the problem to repeat on following restart attempts.


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
acl windowsupdate dstdomain sls.microsoft.com
acl windowsupdate dstdomain productactivation.one.microsoft.com
acl windowsupdate dstdomain ntservicepack.microsoft.com

acl CONNECT method CONNECT
acl wuCONNECT dstdomain www.update.microsoft.com
acl wuCONNECT dstdomain sls.microsoft.com

http_access allow CONNECT wuCONNECT localnet
http_access allow windowsupdate localnet
}}}

The above config is also useful for other automatic update sites such as Anti-Virus vendors, just add their domains to the SquidConf:acl.

|| {i} || If you have squid listening on a localhost port with other software in front (ie dansGuardian). You will probably need to add permission for '''localhost''' address so the front-end service can relay the requests. ||

{{{
...
http_access allow CONNECT wuCONNECT localnet
http_access allow CONNECT wuCONNECT localhost
http_access allow windowsupdate localnet
http_access allow windowsupdate localhost
}}}


== Squid problems with Windows Update v5 ==
=== AKA, Why does Internet Explorer work but the background automatic updates fail? ===
By Janno de Wit

There seems to be some problems with Microsoft Windows to access the Windows Update website. This is especially a problem when you block all traffic by a firewall and force your users to go through a proxy.

Symptom: Windows Update gives error codes like 0x80072EFD and cannot update, automatic updates aren't working too.

Cause: In earlier Windows-versions Windows Update takes the proxy-settings from Internet Explorer. Since XP SP2 this is not sure. At my machine I ran Windows XP SP1 without Windows Update problems. When I upgraded to SP2 Windows Update started to give errors when searching updates etc.

The problem was that WU did not go through the proxy and tries to establish direct HTTP connections to Update-servers. Even when I set the proxy in IE again, it didn't help . It isn't Squid's problem that Windows Update doesn't work, but it is in Windows itself. The solution is to use the 'proxycfg' tool shipped with Windows XP. With this tool you can set the proxy for WinHTTP.

 {i} Similar issues are found with other Microsoft products in the same Windows versions. The commands below often fix all Microsoft proxy issues at once.

Commands:

{{{
C:\> proxycfg
# gives information about the current connection type. Note: 'Direct Connection' does not force WU to bypass proxy

C:\> proxycfg -d
# Set Direct Connection

C:\> proxycfg -p wu-proxy.lan:8080
# Set Proxy to use with Windows Update to wu-proxy.lan, port 8080

c:\> proxycfg -u
# Set proxy to Internet Explorer settings.
}}}

##end
----
Back to the SquidFaq
