#language en
<<TableOfContents>>

##begin
== How do I make Windows Updates cache? ==
Windows Update generally (but not always) uses HTTP Range-Offsets' (AKA file partial ranges) to grab pieces of the Microsoft Update archive in parallel or using a random-access algorithm trying to reduce the web traffic. Some versions of Squid do not handle or store Ranges very well yet.

A mix of configuration options are required to force caching of range requests. Particularly when large objects are involved.


 * '''SquidConf:maximum_object_size'''. Default value is a bit small. It needs to be somewhere 100MB or higher to cope with the IE updates.
  . '''UPDATE:''' Windows 8.1 upgrade pack requires up to 5GB objects to be cached. It will however, cache nicely provided the size limit is set high enough.

 * '''SquidConf:range_offset_limit'''. Does the main work of converting range requests into cacheable requests. Use the same size limit as SquidConf:maximum_object_size to prevent conversion of requests for objects which will not cache anyway. With [[Squid-3.2]] or later use the '''windowsupdate''' ACL list defined below to apply this offset limit only to windows updates.

 * '''SquidConf:quick_abort_min'''. May need to be altered to allow the full object to download when the client software disconnects. Some Squid releases let SquidConf:range_offset_limit override properly, some have weird behavior when combined.

{{{
range_offset_limit 200 MB windowsupdate
maximum_object_size 200 MB
quick_abort_min -1
}}}
 . {i} Due to the slow-down problem below we recommend service packs be handled specially:
  . Extend the maximum cached object size to the required size, then run a full download on a single machine, then run on a second machine to verify teh cache is being used. Only after this verification succeeds open updating to all other machines through the proxy.


== Preventing Early or Frequent Replacement ==

Once you have done the above to cache updates you encounter the problem that some software often forces a full object reload instead of revalidation. Which pushes the cached content out and fetches new objects very frequently.


An idea that was floating around suggested that you use a SquidConf:refresh_pattern regexp config to do your WU caching. I decided to test this idea out in my squid proxy, along with one or 2 other ideas (the other ideas failed hopelessly but the WU caching worked like a charm.)

The idea basically suggested this:

{{{
refresh_pattern microsoft.com/.*\.(cab|exe|ms[i|u|f]|asf|wm[v|a]|dat|zip) 4320 80% 43200
}}}

The original idea seemed to work in theory, yet in practicality it was pretty useless - the updates expired after 30 minutes, there were download inconsistencies, and a whole array of issues. So looking at the HTTP responses and documentation for SquidConf:refresh_pattern, there was an extra clause that could be added. This is how it changed:

{{{
refresh_pattern -i microsoft.com/.*\.(cab|exe|ms[i|u|f]|[ap]sf|wm[v|a]|dat|zip) 4320 80% 43200 reload-into-ims
refresh_pattern -i windowsupdate.com/.*\.(cab|exe|ms[i|u|f]|[ap]sf|wm[v|a]|dat|zip) 4320 80% 43200 reload-into-ims
}}}

Now all that this line tells us to do is cache all .cab, .exe, .msu, .msu, .msf, .asf, .psf, .wma,..... to .zip from microsoft.com, and the lifetime of the object in the cache is 4320 minutes (aka 3 days) to 43200 minutes (aka 30 days). Each of the downloaded objects are added to the cache, and then whenever a request arrives indicating the cache copy must not be used it gets converted to an if-modified-since check instead of a new copy reload request.

So adding it to the original Squid settings to do with SquidConf:refresh_pattern, we get:
{{{
# Add one of these lines for each of the websites you want to cache.

refresh_pattern -i microsoft.com/.*\.(cab|exe|ms[i|u|f]|[ap]sf|wm[v|a]|dat|zip) 4320 80% 43200 reload-into-ims

refresh_pattern -i windowsupdate.com/.*\.(cab|exe|ms[i|u|f]|[ap]sf|wm[v|a]|dat|zip) 4320 80% 43200 reload-into-ims

refresh_pattern -i windows.com/.*\.(cab|exe|ms[i|u|f]|[ap]sf|wm[v|a]|dat|zip) 4320 80% 43200 reload-into-ims


# DONT MODIFY THESE LINES
refresh_pattern \^ftp:           1440    20%     10080
refresh_pattern \^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
}}}

This should limit the system from downloading windows updates a trillion times a minute. It'll hand out the Windows updates, and will keep them stored in the squid cache.

I also recommend a 30 to 60GB SquidConf:cache_dir size allocation, which will let you download tonnes of windows updates and other stuff and then you won't really have any major issues with cache storage or cache allocation or any other issues to do with the cache. .  .


== Why does it go so slowly through Squid? ==
The work-around used by many cache maintainers has been to set the above config and force Squid to fetch the whole object when a range request goes through.

 . {i} Compounding the problem and ironically causing some slowdowns is the fact that some of the Microsoft servers may be telling your Squid not to store the archive file. This means that Squid will pull the entire archive every time it needs any small piece.

You will need to test your squid config with smaller values for the SquidConf:range_offset_limit bypass and see which provides the best results for you.

Another symptoms which occasionally appear when attempting to force caching of windows updates is service packs.

 . {i} If the SquidConf:quick_abort_min, SquidConf:quick_abort_max, SquidConf:quick_abort_pct settings are set to abort a download incomplete and a client closes with almost but not quite enough of the service pack downloaded. That clients following requests will often timeout waiting for Squid to re-download the whole object from the start. Which naturally causes the problem to repeat on following restart attempts.

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
|| {i} ||If you have squid listening on a localhost port with other software in front (ie dansGuardian). You will probably need to add permission for '''localhost''' address so the front-end service can relay the requests. ||




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

 . {i} Similar issues are found with other Microsoft products in the same Windows versions. The commands below often fix all Microsoft proxy issues at once.

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
