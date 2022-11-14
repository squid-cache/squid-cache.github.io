# Communication between browsers and Squid

Most web browsers available today support proxying and are easily
configured to use a Squid server as a proxy. Some browsers support
advanced features such as lists of domains or URL patterns that
shouldn't be fetched through the proxy, or JavaScript automatic proxy
configuration.

There are three ways to configure browsers to use Squid. The first
method involves manually configuring the proxy in each browser.
Alternatively, a proxy.pac file can be manually entered into each
browser so that it will download the proxy settings (partial auto
configuration), and lastly all modern browsers can also and indeed are
configured by default to fully automatically configure themselves if the
network is configured to support this.

# Recommended network configuration

For best use of the proxy we recommend a multiple-layers approach. The
following are the layers we recommend, in order of preference.

We are aware that many networks only implement layer 3 and 4 of this
design due to administrators familiarity with NAT, confusion about the
benefits, and historic problems with the upper two layers.

1.  [Web Proxy Automatic
    Detection](#Fully_Automatically_Configuring_Browsers_for_WPAD)
    (**WPAD**) (aka **transparent configuration**)
    
      - Browsers set to auto-detect the proxy for whatever network they
        are plugged into. This is particularly useful for mobile users.
    
      - The big problem with this layer is that there is no formal RFC
        standard to follow, so browsers implement and two separate DNS
        and DHCP systems to setup.
    
      - requires the PAC to be implemented.

2.  [Proxy auto-configuration](#Partially_Automatic_Configuration)
    (**PAC**) (aka *transparent proxy*)
    
      - As a backup to per-machine configuration.
    
      - Some systems support PAC file to be explicitly set in the
        machine-wide environment.

3.  Machine-wide Configuration
    
      - Using a system-wide environment variable **http\_proxy** (or GUI
        configuration which sets it). Most operating systems support
        this. Windows is the exception, however the IE settings are used
        in an equivalent way.
    
      - A lot of software supports it. Only set once per machine.
    
      - Some systems allow this to be pushed out across the network
        (Windows uses a Domain Policy)

4.  [NAT or TPROXY
    interception](/ConfigExamples/Intercept#).
    (aka *transparent proxy*)
    
      - Client software does not need to be touched.
    
      - security takes several major reductions (several whole families
        of vulnerability are created, proxy authentication disappears,
        peering abilities disappear)
    
      - System resources and connection reliability take several major
        reductions

5.  [Manual Configuration](#Manual_Browser_Configuration).
    
      - Nothing beats an explicit manual configuration for *it works*
        excitement. However doing it for each and every piece of
        software on a machine is quite a hassle. Doing it for a whole
        network is unrealistic outside of highly paranoid systems. It is
        mentioned here simply as an option.

6.  For completeness sake: the best underlying secure systems back
    several of these layers up with a complete firewall ban on web
    traffic. This prevents users and machines bypassing the proxy
    control points.

# Manual Browser Configuration

This involves manually specifying the proxy server and port name in each
browser.

## Firefox and Thunderbird manual configuration

Both Firefox and Thunderbird are configured in the same way. Look in the
Tools menu, Options, General and then Connection Settings. The options
in there are fairly self explanatory. Firefox and Thunderbird support
manually specifying the proxy server, automatically downloading a
wpad.dat file from a specified source, and additionally wpad
auto-detection.

Thunderbird uses these settings for downloading HTTP images in emails.

In both cases if you are manually configuring proxies, make sure you
should add relevant statements for your network in the "No Proxy For"
boxes.

## Microsoft Internet Explorer manual configuration

Select **Options** from the **View** menu. Click on the **Connection**
tab. Tick the **Connect through Proxy Server** option and hit the
**Proxy Settings** button. For each protocol that your Squid server
supports (by default, HTTP, FTP, and gopher) enter the Squid server's
hostname or IP address and put the HTTP port number for the Squid server
(by default, 3128) in the **Port** column. For any protocols that your
Squid does not support, leave the fields blank.

## Netscape manual configuration

Select **Network Preferences** from the **Options** menu. On the
**Proxies** page, click the radio button next to **Manual Proxy
Configuration** and then click on the **View** button. For each protocol
that your Squid server supports (by default, HTTP, FTP, and gopher)
enter the Squid server's hostname or IP address and put the HTTP port
number for the Squid server (by default, 3128) in the **Port** column.
For any protocols that your Squid does not support, leave the fields
blank.

## Lynx and Mosaic manual configuration

For Mosaic and Lynx, you can set environment variables before starting
the application. For example (assuming csh or tcsh):

    % setenv http_proxy http://mycache.example.com:3128/
    % setenv gopher_proxy http://mycache.example.com:3128/
    % setenv ftp_proxy http://mycache.example.com:3128/

For Lynx you can also edit the *lynx.cfg* file to configure proxy usage.
This has the added benefit of causing all Lynx users on a system to
access the proxy without making environment variable changes for each
user. For example:

    http_proxy:http://mycache.example.com:3128/
    ftp_proxy:http://mycache.example.com:3128/
    gopher_proxy:http://mycache.example.com:3128/

## Opera 2.12 manual configuration

by Hume Smith

Select *Proxy Servers...* from the *Preferences* menu. Check each
protocol that your Squid server supports (by default, HTTP, FTP, and
Gopher) and enter the Squid server's address as hostname:port (e.g.
mycache.example.com:3128 or 192.0.2.2:3128). Click on *Okay* to accept
the setup.

Notes:

  - Opera 2.12 doesn't support gopher on its own, but requires a proxy;
    therefore Squid's gopher proxying can extend the utility of your
    Opera immensely.

  - Unfortunately, Opera 2.12 chokes on some HTTP requests, for example
    [abuse.net](http://spam.abuse.net/spam/).

At the moment I think it has something to do with cookies. If you have
trouble with a site, try disabling the HTTP proxying by unchecking that
protocol in the *Preferences*|*Proxy Servers...* dialogue. Opera will
remember the address, so reenabling is easy.

## Netmanage Internet Chameleon WebSurfer manual configuration

Netmanage WebSurfer supports manual proxy configuration and exclusion
lists for hosts or domains that should not be fetched via proxy (this
information is current as of WebSurfer 5.0). Select **Preferences** from
the **Settings** menu. Click on the **Proxies** tab. Select the **Use
Proxy** options for HTTP, FTP, and gopher. For each protocol that enter
the Squid server's hostname or IP address and put the HTTP port number
for the Squid server (by default, 3128) in the **Port** boxes. For any
protocols that your Squid does not support, leave the fields blank.

On the same configuration window, you'll find a button to bring up the
exclusion list dialog box, which will let you enter some hosts or
domains that you don't want fetched via proxy.

# Partially Automatic Configuration

This involves the browser being preconfigured with the location of an
autoconfiguration script.

## Netscape automatic configuration

Netscape Navigator's proxy configuration can be automated with
JavaScript (for Navigator versions 2.0 or higher). Select **Network
Preferences** from the **Options** menu. On the **Proxies** page, click
the radio button next to **Automatic Proxy Configuration** and then fill
in the URL for your JavaScript proxy configuration file in the text box.
The box is too small, but the text will scroll to the r8ight as you go.

You may also wish to consult Netscape's documentation for the Navigator
[JavaScript proxy
configuration](http://wp.netscape.com/eng/mozilla/2.0/relnotes/demo/proxy-live.html)

Here is a sample auto configuration file from Oskar Pearson (link to
save at the bottom):

``` highlight
//We (www.is.co.za) run a central cache for our customers that they
//access through a firewall - thus if they want to connect to their intranet
//system (or anything in their domain at all) they have to connect
//directly - hence all the "fiddling" to see if they are trying to connect
//to their local domain.
//
//Replace each occurrence of company.com with your domain name
//and if you have some kind of intranet system, make sure
//that you put it's name in place of "internal" below.
//
//We also assume that your cache is called "cache.company.com", and
//that it runs on port 8080. Change it down at the bottom.
//
//(C) Oskar Pearson and the Internet Solution (http://www.is.co.za)

function FindProxyForURL(url, host)
{
    //If they have only specified a hostname, go directly.
    if (isPlainHostName(host))
            return "DIRECT";

    //These connect directly if the machine they are trying to
    //connect to starts with "intranet" - ie http://intranet
    //Connect  directly if it is intranet.*
    //If you have another machine that you want them to
    //access directly, replace "internal*" with that
    //machine's name
    if (shExpMatch( host, "intranet*")||
                    shExpMatch(host, "internal*"))
        return "DIRECT";

    //Connect directly to our domains (NB for Important News)
    if (dnsDomainIs( host,"company.com")||
    //If you have another domain that you wish to connect to
    //directly, put it in here
                    dnsDomainIs(host,"sistercompany.com"))
        return "DIRECT";

    //So the error message "no such host" will appear through the
    //normal Netscape box - less support queries :)
    if (!isResolvable(host))
            return "DIRECT";

    //We only cache http, ftp and gopher
    if (url.substring(0, 5) == "http:" ||
                    url.substring(0, 4) == "ftp:"||
                    url.substring(0, 7) == "gopher:")

    //Change the ":8080" to the port that your cache
    //runs on, and "cache.company.com" to the machine that
    //you run the cache on
            return "PROXY cache.company.com:8080; DIRECT";

    //We don't cache WAIS
    if (url.substring(0, 5) == "wais:")
            return "DIRECT";

    else
            return "DIRECT";
}
```

[sample1.pac.txt](/SquidFaq/ConfiguringBrowsers?action=AttachFile&do=get&target=sample1.pac.txt)

## Microsoft Internet Explorer

Microsoft Internet Explorer, versions 4.0 and above, supports JavaScript
automatic proxy configuration in a Netscape-compatible way. Just select
**Options** from the **View** menu. Click on the **Advanced** tab. In
the lower left-hand corner, click on the **Automatic Configuration**
button. Fill in the URL for your JavaScript file in the dialog box it
presents you. Then exit MSIE and restart it for the changes to take
effect. MSIE will reload the JavaScript file every time it starts.

# Fully Automatic Configuration

by Mark Reynolds

You may like to start by reading the [Expired
Internet-Draft](http://www.web-cache.com/Writings/Internet-Drafts/draft-ietf-wrec-wpad-01.txt)
that describes WPAD.

After reading the 8 steps below, if you don't understand any of the
terms or methods mentioned, you probably shouldn't be doing this.
Implementing wpad requires you to **fully** understand:

  - web server installations and modifications.

  - squid proxy server (or others) installation etc.

  - Domain Name System maintenance etc.

|                                                                           |                                                                                                                                                |
| ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| ![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png) | Please don't bombard the squid list with web server or DNS questions. See your system administrator, or do some more research on those topics. |

This is not a recommendation for any product or version. All major
browsers out now implementing WPAD. I think WPAD is an excellent feature
that will return several hours of life per month.

There are probably many more tricks and tips which hopefully will be
detailed here in the future. Things like *wpad.dat* files being served
from the proxy server themselves, maybe with a round robin dns setup for
the WPAD host.

I have only focused on the domain name method, to the exclusion of the
DHCP method. I think the dns method might be easier for most people. I
don't currently, and may never, fully understand wpad and IE5, but this
method worked for me. It **may** work for you.

But if you'd rather just have a go ...

## The PAC file

Create a standard Netscape *auto proxy* config file. The sample provided
above is more than adequate to get you going. No doubt all the other
load balancing and backup scripts will be fine also.

Store the resultant file in the document root directory of a handy web
server as *wpad.dat* (Not *proxy.pac* as you may have previously done.)
Andrei Ivanov notes that you should be able to use an HTTP redirect if
you want to store the wpad.dat file somewhere else. You can probably
even redirect *wpad.dat* to *proxy.pac*:

    Redirect /wpad.dat http://example.com/proxy.pac

If you do nothing more, a URL like [](http://www.example.com/wpad.dat)
should bring up the script text in your browser window.

Insert the following entry into your web server *mime.types* file. Maybe
in addition to your pac file type, if you've done this before.

    application/x-ns-proxy-autoconfig       dat

And then restart your web server, for new mime type to work.

## Browser Configurations

### Internet explorer 5

Under *Tools*, *Internet Options*, *Connections*, *Settings* **or** *Lan
Settings*, set **ONLY** *Use Automatic Configuration Script* to be the
URL for where your new *wpad.dat* file can be found.

i.e. [](http://www.example.com/wpad.dat).

Test that that all works as per your script and network. There's no
point continuing until this works ...

## Automatic WPAD with DNS

Create/install/implement a DNS record so that wpad.example.com resolves
to the host above where you have a functioning auto config script
running. You should now be able to use
[](http://wpad.example.com/wpad.dat) as the Auto Config Script location
in step 5 above.

And finally, go back to the setup screen detailed in 5 above, and choose
nothing but the *Automatically Detect Settings* option, turning
everything else off. Best to restart IE5, as you normally do with any
Microsoft product... And it should all work. Did for me anyway.

One final question might be "Which domain name does the client (IE5) use
for the wpad... lookup?" It uses the hostname from the control panel
setting. It starts the search by adding the hostname *wpad* to current
fully-qualified domain name. For instance, a client in *a.b.example.com*
would search for a WPAD server at *wpad.a.b.example.com*. If it could
not locate one, it would remove the bottom-most domain and try again;
for instance, it would try *wpad.b.example.com* next. IE 5 would stop
searching when it found a WPAD server or reached the bottom-level
domain, **wpad**.

## Automatic WPAD with DHCP

You can also use DHCP to configure browsers for WPAD. This technique
allows you to set any URL as the PAC URL. For ISC DHCPD, enter a line
like this in your *dhcpd.conf* file:

    option wpad code 252 = text;
    option wpad "http://www.example.com/proxy.pac";

Replace the hostname with the name or address of your own server.

Ilja Pavkovic notes that the DHCP mode does not work reliably with every
version of Internet Explorer. The DNS name method to find wpad.dat is
more reliable.

Another user adds that IE 6.01 seems to strip the last character from
the URL. By adding a trailing newline, he is able to make it work with
both IE 5.0 and 6.0:

    option wpad "http://www.example.com/proxy.pac\n";

# Redundant Proxy Auto-Configuration

by Rodney van den Oever

There's one nasty side-effect to using auto-proxy scripts: if you start
the web browser it will try and load the auto-proxy-script.

If your script isn't available either because the web server hosting the
script is down or your workstation can't reach the web server (e.g.
because you're working off-line with your notebook and just want to read
a previously saved HTML-file) you'll get different errors depending on
the browser you use.

The Netscape browser will just return an error after a timeout (after
that it tries to find the site 'www.proxy.com' if the script you use is
called 'proxy.pac').

The Microsoft Internet Explorer on the other hand won't even start, no
window displays, only after about 1 minute it'll display a window asking
you to go on with/without proxy configuration.

The point is that your workstations always need to locate the
proxy-script. I created some extra redundancy by hosting the script on
two web servers (actually Apache web servers on the proxy servers
themselves) and adding the following records to my primary nameserver:

    proxy   IN      A       192.0.2.1 ; IP address of proxy1
            IN      A       192.0.2.2 ; IP address of proxy2

The clients just refer to '[](http://proxy/proxy.pac)'. This script
looks like this:

``` highlight
function FindProxyForURL(url,host)
{
// Hostname without domainname or host within our own domain?
// Try them directly:
// http://www.domain.com actually lives before the firewall, so
// make an exception:
if ((isPlainHostName(host)||dnsDomainIs( host,".domain.com")) &&
        !localHostOrDomainIs(host, "www.domain.com"))
        return "DIRECT";

// First try proxy1 then proxy2. One server mostly caches '.com'
// to make sure both servers are not
// caching the same data in the normal situation. The other
// server caches the other domains normally.
// If one of 'm is down the client will try the other server.
else if (shExpMatch(host, "*.com"))
        return "PROXY proxy1.domain.com:8080; PROXY proxy2.domain.com:8081; DIRECT";
return "PROXY proxy2.domain.com:8081; PROXY proxy1.domain.com:8080; DIRECT";
}
```

[sample2.pac.txt](/SquidFaq/ConfiguringBrowsers?action=AttachFile&do=get&target=sample2.pac.txt)

I made sure every client domain has the appropriate 'proxy' entry. The
clients are automatically configured with two nameservers using DHCP.

# Proxy Auto-Configuration with URL Hashing

The [Sharp Super Proxy Script page](http://naragw.sharp.co.jp/sps/)
contains a lot of good information about hash-based proxy
auto-configuration scripts. With these you can distribute the load
between a number of caching proxies.

# Where can I find more information about PAC?

There is a community website explaining PAC features and functions at
[](http://findproxyforurl.com/).

# How do I tell Squid to use a specific username for FTP urls?

There are several ways the login can be done with FTP through Squid.

[ftp\_user](http://www.squid-cache.org/Doc/config/ftp_user#) directive
will accept the username or username:password values to be used by
default on **all** FTP login requests. It will be overridden by any
other available login credentials.

The strongest credentials that override all others are credentials added
to the URL itself.

Insert your username in the host part of the URL, for example:

    ftp://joecool@ftp.example.com/

Squid (from 2.6 through to 3.0) will then use a default password.

Alternatively, you can specify both your username and password in the
URL itself:

    ftp://joecool:secret@ftp.example.com/

However, we certainly do not recommend this, as it could be very easy
for someone to see or grab your password.

Starting with
[Squid-3.1](/Releases/Squid-3.1#),
the above will be tried then regular HTTP Basic authentication will be
used to recover new credentials. If login is required and none given a
regular website login popup box will appear asking for the credentials
to be entered.

# IE 5.0x crops trailing slashes from FTP URL's

by
[ReubenFarrelly](/ReubenFarrelly#)

There was a bug in the 5.0x releases of Internet Explorer in which IE
cropped any trailing slash off an FTP URL. The URL showed up correctly
in the browser's "Address:" field, however squid logs show that the
trailing slash was being taken off.

An example of where this impacted squid if you had a setup where squid
would go direct for FTP directory listings but forward a request to a
parent for FTP file transfers. This was useful if your upstream proxy
was an older version of Squid or another vendors software which
displayed directory listings with broken icons and you wanted your own
local version of squid to generate proper FTP directory listings
instead. The workaround for this is to add a double slash to any
directory listing in which the slash was important, or else upgrade IE
to at least 5.5. (Or use Firefox if you cannot upgrade your IE)

# IE 6.0 SP1 fails when using authentication

When using authentication with Internet Explorer 6 SP1, you may
encounter issues when you first launch Internet Explorer. The problem
will show itself when you first authenticate, you will receive a "Page
Cannot Be Displayed" error. However, if you click refresh, the page will
be correctly displayed.

This only happens immediately after you authenticate.

This is not a Squid error or bug. Microsoft broke the Basic
Authentication when they put out IE6 SP1.

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    this appears to be fixed again in later service packs and IE 7+

There is a knowledgebase article (
[KB 331906](http://support.microsoft.com/default.aspx?id=kb;en-us;331906))
regarding this issue, which contains a link to a downloadable "hot fix."
They do warn that this code is not "regression tested" but so far there
have not been any reports of this breaking anything else. The
problematic file is wininet.dll. Please note that this hotfix is
included in the latest security update.

Lloyd Parkes notes that the article references another article,
[KB 312176](http://support.microsoft.com/default.aspx?scid=kb;EN-US;312176).
He says that you must **not** have the registry entry that KB 312176
encourages users to add to their registry.

According to Joao Coutinho, this simple solution also corrects the
problem:

  - Go to Tools/Internet

  - Go to Options/Advanced

  - UNSELECT "Show friendly HTTP error messages" under Browsing.

Another possible workaround to these problems is to make the
ERR\_CACHE\_ACCESS\_DENIED larger than 1460 bytes. This should trigger
IE to handle the authentication in a slightly different manner.

Back to the
[SquidFaq](/SquidFaq#)
