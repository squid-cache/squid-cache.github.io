---
categories: [ConfigExample]
FaqSection: operation
---
# Caching Windows Updates

by Yuri Voinov

## Outline

Windows Updates is one of most common task for caching.

## Usage

The Alternative is using WU server. When it's impossible for some
reasons your can use Squid to cache this.

## Squid Configuration File

Paste the configuration file like this:

    # Updates: Windows
    refresh_pattern -i windowsupdate.com/.*\.(cab|exe|ms[i|u|f|p]|[ap]sf|wm[v|a]|dat|zip|psf) 43200 80% 129600 reload-into-ims
    refresh_pattern -i microsoft.com/.*\.(cab|exe|ms[i|u|f|p]|[ap]sf|wm[v|a]|dat|zip|psf) 43200 80% 129600 reload-into-ims
    refresh_pattern -i windows.com/.*\.(cab|exe|ms[i|u|f|p]|[ap]sf|wm[v|a]|dat|zip|psf) 43200 80% 129600 reload-into-ims
    refresh_pattern -i microsoft.com.akadns.net/.*\.(cab|exe|ms[i|u|f|p]|[ap]sf|wm[v|a]|dat|zip|psf) 43200 80% 129600 reload-into-ims
    refresh_pattern -i deploy.akamaitechnologies.com/.*\.(cab|exe|ms[i|u|f|p]|[ap]sf|wm[v|a]|dat|zip|psf) 43200 80% 129600 reload-into-ims

## Troubleshooting

## How do I make Windows Updates cache?

Windows Update generally (but not always) uses HTTP Range-Offsets' (AKA
file partial ranges) to grab pieces of the Microsoft Update archive in
parallel or using a random-access algorithm trying to reduce the web
traffic. Some versions of Squid do not handle or store Ranges very well
yet.

A mix of configuration options are required to force caching of range
requests. Particularly when large objects are involved.

- **[maximum_object_size](http://www.squid-cache.org/Doc/config/maximum_object_size)**.
    Default value is a bit small. It needs to be somewhere 100MB or
higher to cope with the IE updates.
- **[range_offset_limit](http://www.squid-cache.org/Doc/config/range_offset_limit)**.
    Does the main work of converting range requests into cachable
    requests. Use the same size limit as
    [maximum_object_size](http://www.squid-cache.org/Doc/config/maximum_object_size)
    to prevent conversion of requests for objects which will not cache
    anyway. With    [Squid-3.2](/Releases/Squid-3.2)
    or later use the **windowsupdate** ACL list defined below to apply
    this offset limit only to windows updates.
- **[quick_abort_min](http://www.squid-cache.org/Doc/config/quick_abort_min)**.
    May need to be altered to allow the full object to download when the
    client software disconnects. Some Squid releases let
    [range_offset_limit](http://www.squid-cache.org/Doc/config/range_offset_limit)
    override properly, some have weird behavior when combined.

    range_offset_limit 200 MB windowsupdate
    maximum_object_size 200 MB
    quick_abort_min -1

> :warning: Windows 8.1 upgrade pack requires up to 5GB objects
    to be cached. It will however, cache nicely provided the size
    limit is set high enough.

> :information_source:
    Due to the slow-down problem below we recommend service packs be
    handled specially:
    Extend the maximum cached object size to the required size, then
    run a full download on a single machine, then run on a second
    machine to verify the cache is being used. Only after this
    verification succeeds open updating to all other machines
    through the proxy.

## Preventing Early or Frequent Replacement

Once you have done the above to cache updates you encounter the problem
that some software often forces a full object reload instead of
revalidation. Which pushes the cached content out and fetches new
objects very frequently.

An idea that was floating around suggested that you use a
[refresh_pattern](http://www.squid-cache.org/Doc/config/refresh_pattern)
regexp config to do your WU caching. I decided to test this idea out in
my squid proxy, along with one or 2 other ideas (the other ideas failed
hopelessly but the WU caching worked like a charm.)

The idea basically suggested this:

    refresh_pattern microsoft.com/.*\.(cab|exe|ms[i|u|f]|asf|wm[v|a]|dat|zip) 4320 80% 43200

The original idea seemed to work in theory, yet in practicality it was
pretty useless - the updates expired after 30 minutes, there were
download inconsistencies, and a whole array of issues. So looking at the
HTTP responses and documentation for
[refresh_pattern](http://www.squid-cache.org/Doc/config/refresh_pattern),
there was an extra clause that could be added. This is how it changed:

    refresh_pattern -i microsoft.com/.*\.(cab|exe|ms[i|u|f]|[ap]sf|wm[v|a]|dat|zip) 4320 80% 43200 reload-into-ims
    refresh_pattern -i windowsupdate.com/.*\.(cab|exe|ms[i|u|f]|[ap]sf|wm[v|a]|dat|zip) 4320 80% 43200 reload-into-ims

Now all that this line tells us to do is cache all .cab, .exe, .msu,
.msu, .msf, .asf, .psf, .wma,..... to .zip from microsoft.com, and the
lifetime of the object in the cache is 4320 minutes (aka 3 days) to
43200 minutes (aka 30 days). Each of the downloaded objects are added to
the cache, and then whenever a request arrives indicating the cache copy
must not be used it gets converted to an if-modified-since check instead
of a new copy reload request.

So adding it to the original Squid settings to do with
[refresh_pattern](http://www.squid-cache.org/Doc/config/refresh_pattern),
we get:

    # Add one of these lines for each of the websites you want to cache.
    refresh_pattern -i microsoft.com/.*\.(cab|exe|ms[i|u|f]|[ap]sf|wm[v|a]|dat|zip) 4320 80% 43200 reload-into-ims
    refresh_pattern -i windowsupdate.com/.*\.(cab|exe|ms[i|u|f]|[ap]sf|wm[v|a]|dat|zip) 4320 80% 43200 reload-into-ims
    refresh_pattern -i windows.com/.*\.(cab|exe|ms[i|u|f]|[ap]sf|wm[v|a]|dat|zip) 4320 80% 43200 reload-into-ims


    # DONT MODIFY THESE LINES
    refresh_pattern ^ftp:           1440    20%     10080
    refresh_pattern ^gopher:        1440    0%      1440
    refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
    refresh_pattern .               0       20%     4320

This should limit the system from downloading windows updates a trillion
times a minute. It'll hand out the Windows updates, and will keep them
stored in the squid cache.

I also recommend a 30 to 60GB
[cache_dir](http://www.squid-cache.org/Doc/config/cache_dir) size
allocation, which will let you download tonnes of windows updates and
other stuff and then you will not really have any major issues with cache
storage or cache allocation or any other issues to do with the cache.

## Why does it go so slowly through Squid?

The work-around used by many cache maintainers has been to set the above
config and force Squid to fetch the whole object when a range request
goes through.

> :information_source:
    Compounding the problem and ironically causing some slowdowns is the
    fact that some of the Microsoft servers may be telling your Squid
    not to store the archive file. This means that Squid will pull the
    entire archive every time it needs any small piece.

You will need to test your squid config with smaller values for the
[range_offset_limit](http://www.squid-cache.org/Doc/config/range_offset_limit)
bypass and see which provides the best results for you.

Another symptoms which occasionally appear when attempting to force
caching of windows updates is service packs.

> :information_source:
    If the
    [quick_abort_min](http://www.squid-cache.org/Doc/config/quick_abort_min),
    [quick_abort_max](http://www.squid-cache.org/Doc/config/quick_abort_max),
    [quick_abort_pct](http://www.squid-cache.org/Doc/config/quick_abort_pct)
    settings are set to abort a download incomplete and a client closes
    with almost but not quite enough of the service pack downloaded.
    That clients following requests will often timeout waiting for Squid
    to re-download the whole object from the start. Which naturally
    causes the problem to repeat on following restart attempts.

## How do I stop Squid popping up the Authentication box for Windows Update?

Add the following to your squid.conf, assuming you have defined
**localnet** to mean your local clients. It **'MUST**' be added near the
top before any ACL that require authentication.

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

The above config is also useful for other automatic update sites such as
Anti-Virus vendors, just add their domains to the
[acl](http://www.squid-cache.org/Doc/config/acl).

> :information_source:
    If you have squid listening on a localhost port with other software in
    front (ie dansGuardian). You will probably need to add permission
    for **localhost** address so the front-end service can relay the requests.

    ...
    http_access allow CONNECT wuCONNECT localnet
    http_access allow CONNECT wuCONNECT localhost
    http_access allow windowsupdate localnet
    http_access allow windowsupdate localhost

## Squid problems with Windows Update v5

### AKA, Why does Internet Explorer work but the background automatic updates fail?

  - *by Janno de Wit*

There seems to be some problems with Microsoft Windows to access the
Windows Update website. This is especially a problem when you block all
traffic by a firewall and force your users to go through a proxy.

Symptom: Windows Update gives error codes like 0x80072EFD and cannot
update, automatic updates aren't working too.

Cause: In earlier Windows-versions Windows Update takes the
proxy-settings from Internet Explorer. Since XP SP2 this is not sure. At
my machine I ran Windows XP SP1 without Windows Update problems. When I
upgraded to SP2 Windows Update started to give errors when searching
updates etc.

The problem was that WU did not go through the proxy and tries to
establish direct HTTP connections to Update-servers. Even when I set the
proxy in IE again, it didn't help . It isn't Squid's problem that
Windows Update doesn't work, but it is in Windows itself. The solution
is to use the 'proxycfg' or 'netsh' tool shipped with Windows. With this
tool you can set the proxy for WinHTTP.

> :information_source: Similar issues are found with other Microsoft products in the same
    Windows versions. The commands below often fix all Microsoft proxy
    issues at once.

### Proxy configuration with proxycfg

> :information_source: In Windows Vista, Server 2008 and later proxycfg is obsolete. Use
    netsh instead.

Commands:

    C:\> proxycfg
    # gives information about the current connection type. Note: 'Direct Connection' does not force WU to bypass proxy

    C:\> proxycfg -d
    # Set Direct Connection

    C:\> proxycfg -p wu-proxy.lan:8080
    # Set Proxy to use with Windows Update to wu-proxy.lan, port 8080

    C:\> proxycfg -u
    # Set proxy to Internet Explorer settings.

### Proxy configuration with netsh

  - *by Yuri Voinov*

Syntax:

    netsh winhttp set proxy ProxyName:80 "<local>"

    C:\> netsh winhttp set proxy 192.168.1.100:3128 "localhost;192.168.1.100"

To reset proxy settings for WinHTTP use:

    C:\> netsh winhttp reset proxy

## Squid with SSL-Bump and Windows Updates

  - *by Yuri Voinov*

In modern setups with Squid, Windows Update cannot be check updates with
error "WindowsUpdate_80072F8F"
or similar.

WU now uses its own pinned SSL certificate and must be spliced to work.
When you use sniffer, you can see many IP's with relatively big
subnetworks. This leads to problems with a
[Squid-3.4](/Releases/Squid-3.4) and causes serious problems when using
[Squid-3.5](/Releases/Squid-3.5) or above.

To use splicing, you need to know the names of the servers, however, a
recursive DNS query does not give a result.

To pass WU check through Squid splice, you only need to splice next MS
servers:

    update.microsoft.com
    update.microsoft.com.akadns.net

For use in real setups, write file url.nobump:

    # WU (Squid 3.5.x and above with SSL Bump)
    # Only this sites must be spliced.
    update\.microsoft\.com
    update\.microsoft\.com\.akadns\.net

Just add this file as Squid ACL as follows:

    acl DiscoverSNIHost at_step SslBump1
    acl NoSSLIntercept ssl::server_name_regex -i "/usr/local/squid/etc/url.nobump"
    ssl_bump splice NoSSLIntercept
    ssl_bump peek DiscoverSNIHost
    ssl_bump bump all

and you do not need to know all the IP authorization server for updates.

> :information_source:
    **NOTE:** In some countries WU can product
    SQUID_X509_V_ERR_DOMAIN_MISMATCH error via Akamai. To do WU,
    you can require to add this into your Squid's config:

        acl BrokenButTrustedServers dstdomain "/usr/local/squid/etc/dstdom.broken"
        acl DomainMismatch ssl_error SQUID_X509_V_ERR_DOMAIN_MISMATCH
        sslproxy_cert_error allow BrokenButTrustedServers DomainMismatch
        sslproxy_cert_error deny all

    and add this to **dstdom.broken**:

        download.microsoft.com
        update.microsoft.com
        update.microsoft.com.akadns.net
        update.microsoft.com.nsatc.net

> :information_source:
    **NOTE:** Depending your Squid's configuration, you may need to
    change your Squid's cipher configuration to this one:

        sslproxy_cipher HIGH:MEDIUM:RC4:3DES:!aNULL:!eNULL:!LOW:!MD5:!EXP:!PSK:!SRP:!DSS

    and add this one to your bumped port's configuration:

        cipher=HIGH:MEDIUM:RC4:3DES:!aNULL:!eNULL:!LOW:!MD5:!EXP:!PSK:!SRP:!DSS

    3DES and RC4 required to connect to WU and - **attention!** - Skype
    assets site.

> :warning:
    Some updates cannot be cached due to splice above. Beware!

> :warning:
    Adding 3DES and, especially, RC4, produces potentially
    weak ciphers via client and WU/Skype and some other sites. Be
    careful!

## Microsoft technical articles related to proxy issues and windows updates

[Microsoft KB](https://support.microsoft.com/en-us/kb/3084568)

## An example of refresh_pattern that is being used at OpnSense

<https://github.com/opnsense/core/issues/1691#issuecomment-340276788>
