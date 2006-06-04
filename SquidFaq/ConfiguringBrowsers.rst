#language en

[[TableOfContents]]

== Communication between browsers and Squid ==

Most web browsers available today support proxying and are easily configured
to use a Squid server as a proxy.  Some browsers support advanced features
such as lists of domains or URL patterns that shouldn't be fetched through
the proxy, or Java''''''Script automatic proxy configuration.

== Firefox and Thunderbird manual and automatic configuration ==

Both Firefox and Thunderbird are configured in the same way.  Look in the Tools menu, Options, General and then Connection Settings.  The options in there are fairly self explanatory.  Firefox and Thunderbird support manually specifying the proxy server, automatically downloading a wpad.dat file from a specified source, and additionally wpad auto-detection.

Thunderbird uses these settings for downloading HTTP images in emails.

In both cases if you are manually configuring proxies, make sure you should add relevant statements for your network in the "No Proxy For" boxes.


== Netscape manual configuration ==

Select '''Network Preferences''' from the
'''Options''' menu.  On the '''Proxies'''
page, click the radio button next to '''Manual Proxy
Configuration''' and then click on the '''View'''
button.  For each protocol that your Squid server supports (by default,
HTTP, FTP, and gopher) enter the Squid server's hostname or IP address
and put the HTTP port number for the Squid server (by default, 3128) in
the '''Port''' column.  For any protocols that your Squid
does not support, leave the fields blank.



== Netscape automatic configuration ==

Netscape Navigator's proxy configuration can be automated with
Java''''''Script (for Navigator versions 2.0 or higher).  Select
'''Network Preferences''' from the '''Options'''
menu.  On the '''Proxies''' page, click the radio button
next to '''Automatic Proxy Configuration''' and then
fill in the URL for your Java''''''Script proxy configuration file in the
text box.  The box is too small, but the text will scroll to the
right as you go.


You may also wish to consult Netscape's documentation for the Navigator
[http://wp.netscape.com/eng/mozilla/2.0/relnotes/demo/proxy-live.html JavaScript proxy configuration]

Here is a sample auto configuration file from Oskar Pearson (link to save at the bottom):

inline:sample1.pac.txt

== Lynx and Mosaic configuration ==

For Mosaic and Lynx, you can set environment variables
before starting the application.  For example (assuming csh or tcsh):

{{{
% setenv http_proxy http://mycache.example.com:3128/
% setenv gopher_proxy http://mycache.example.com:3128/
% setenv ftp_proxy http://mycache.example.com:3128/
}}}

For Lynx you can also edit the ''lynx.cfg'' file to configure
proxy usage.  This has the added benefit of causing all Lynx users on
a system to access the proxy without making environment variable changes
for each user.  For example:
{{{
http_proxy:http://mycache.example.com:3128/
ftp_proxy:http://mycache.example.com:3128/
gopher_proxy:http://mycache.example.com:3128/
}}}


== Redundant Proxy Auto-Configuration ==

by Rodney van den Oever

There's one nasty side-effect to using auto-proxy scripts: if you start
the web browser it will try and load the auto-proxy-script.

If your script isn't available either because the web server hosting the
script is down or your workstation can't reach the web server (e.g.
because you're working off-line with your notebook and just want to
read a previously saved HTML-file) you'll get different errors depending
on the browser you use.

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
{{{
proxy   IN      A       10.0.0.1 ; IP address of proxy1
        IN      A       10.0.0.2 ; IP address of proxy2
}}}

The clients just refer to 'http://proxy/proxy.pac'.  This script looks like this:

inline:sample2.pac.txt

I made sure every client domain has the appropriate 'proxy' entry.
The clients are automatically configured with two nameservers using
DHCP.

== Proxy Auto-Configuration with URL Hashing ==

The
[http://naragw.sharp.co.jp/sps/ Sharp Super Proxy Script page]
contains a lot of good information about hash-based proxy auto-configuration
scripts.  With these you can distribute the load between a number
of caching proxies.

== Microsoft Internet Explorer configuration ==

Select '''Options''' from the '''View'''
menu.  Click on the '''Connection''' tab.  Tick the
'''Connect through Proxy Server''' option and hit the
'''Proxy Settings''' button.  For each protocol that
your Squid server supports (by default, HTTP, FTP, and gopher)
enter the Squid server's hostname or IP address and put the HTTP
port number for the Squid server (by default, 3128) in the
'''Port''' column.  For any protocols that your Squid
does not support, leave the fields blank.


Microsoft Internet Explorer, versions 4.0 and above, supports Java''''''Script automatic proxy configuration in a Netscape-compatible way. Just select
'''Options''' from the '''View''' menu.
Click on the '''Advanced''' tab.  In the lower left-hand
corner, click on the '''Automatic Configuration'''
button.  Fill in the URL for your Java''''''Script file in the dialog
box it presents you.  Then exit MSIE and restart it for the changes
to take effect.  MSIE will reload the Java''''''Script file every time
it starts.

== Netmanage Internet Chameleon WebSurfer configuration ==

Netmanage Web''''''Surfer supports manual proxy configuration and exclusion
lists for hosts or domains that should not be fetched via proxy
(this information is current as of Web''''''Surfer 5.0).  Select
'''Preferences''' from the '''Settings'''
menu.  Click on the '''Proxies''' tab.  Select the
'''Use Proxy''' options for HTTP, FTP, and gopher.  For
each protocol that enter the Squid server's hostname or IP address
and put the HTTP port number for the Squid server (by default,
3128) in the '''Port''' boxes.  For any protocols that
your Squid does not support, leave the fields blank.


On the same configuration window, you'll find a button to bring up
the exclusion list dialog box, which will let you enter some hosts
or domains that you don't want fetched via proxy.

== Opera 2.12 proxy configuration ==

by Hume Smith

Select ''Proxy Servers...'' from the ''Preferences'' menu.  Check each
protocol that your Squid server supports (by default, HTTP, FTP, and
Gopher) and enter the Squid server's address as hostname:port (e.g.
mycache.example.com:3128 or 123.45.67.89:3128).  Click on ''Okay'' to accept the
setup.

Notes:

  * Opera 2.12 doesn't support gopher on its own, but requires a proxy; therefore Squid's gopher proxying can extend the utility of your Opera immensely.
  * Unfortunately, Opera 2.12 chokes on some HTTP requests, for example [http://spam.abuse.net/spam/ abuse.net].
At the moment I think it has something to do with cookies.  If you have trouble with a site, try disabling the HTTP proxying by unchecking that protocol in the ''Preferences''|''Proxy Servers...'' dialogue.  Opera will remember the address, so reenabling is easy.

== How do I tell Squid to use a specific username for FTP urls? ==

Insert your username in the host part of the URL, for example:
{{{
ftp://joecool@ftp.foo.org/
}}}

Squid should then prompt you for your account password.  Alternatively,
you can specify both your username and password in the URL itself:
{{{
ftp://joecool:secret@ftp.foo.org/
}}}

However, we certainly do not recommend this, as it could be very
easy for someone to see or grab your password.

== Configuring Browsers for WPAD ==
by Mark Reynolds

You may like to start by reading the
[http://www.web-cache.com/Writings/Internet-Drafts/draft-ietf-wrec-wpad-01.txt Expired Internet-Draft]
that describes WPAD.

After reading the 8 steps below, if you don't understand any of the
terms or methods mentioned, you probably shouldn't be doing this.
Implementing wpad requires you to '''fully''' understand:

  * web server installations and modifications.
  * squid proxy server (or others) installation etc.
  * Domain Name System maintenance etc.

|| <!> ||Please don't bombard the squid list with web server or DNS questions. See your system administrator, or do some more research on those topics.||

This is not a recommendation for any product or version. As far as I
know IE5 is the only browser out now implementing wpad. I think wpad
is an excellent feature that will return several hours of life per month.
Hopefully, all browser clients will implement it as well. But it will take
years for all the older browsers to fade away though.

I have only focused on the domain name method, to the exclusion of the
DHCP method. I think the dns method might be easier for most people.
I don't currently, and may never, fully understand wpad and IE5, but this
method worked for me. It '''may''' work for you.

But if you'd rather just have a go ...

Create a standard Netscape ''auto proxy'' config file.  The sample provided above is more than adequate to get you going.  No doubt all the other load balancing and backup scripts will be fine also.

Store the resultant file in the document root directory of a handy web server as ''wpad.dat'' (Not ''proxy.pac'' as you may have previously done.) Andrei Ivanov notes that you should be able to use an HTTP redirect if you want to store the wpad.dat file somewhere else.  You can probably even redirect ''wpad.dat'' to ''proxy.pac'':

{{{
Redirect /wpad.dat http://racoon.riga.lv/proxy.pac
}}}

If you do nothing more, a URL like http://www.your.domain.name/wpad.dat
should bring up the script text in your browser window.

Insert the following entry into your web server ''mime.types''
file. Maybe in addition to your pac file type, if you've done this before.
{{{
application/x-ns-proxy-autoconfig       dat
}}}
And then restart your web server, for new mime type to work.

Assuming Internet Explorer 5, under ''Tools'', ''Internet
Options'', ''Connections'', ''Settings'' '''or''' ''Lan
Settings'', set '''ONLY''' ''Use Automatic Configuration Script''
to be the URL for where your new ''wpad.dat'' file can be found.
i.e.  http://www.your.domain.name/wpad.dat. Test that
that all works as per your script and network.  There's no point
continuing until this works ...

Create/install/implement a DNS record so that
wpad.your.domain.name< resolves to the host above where
you have a functioning auto config script running. You should
now be able to use http://wpad.your.domain.name/wpad.dat
as the Auto Config Script location in step 5 above.

And finally, go back to the setup screen detailed in 5 above,
and choose nothing but the ''Automatically Detect Settings''
option, turning everything else off. Best to restart IE5, as
you normally do with any Microsoft product... And it should all
work. Did for me anyway.

One final question might be "Which domain name does the client
(IE5) use for the wpad... lookup?" It uses the hostname from
the control panel setting.  It starts the search by adding the
hostname ''wpad'' to current fully-qualified domain name.  For
instance, a client in ''a.b.Microsoft.com'' would search for a WPAD
server at ''wpad.a.b.microsoft.com''. If it could not locate one,
it would remove the bottom-most domain and try again; for
instance, it would try ''wpad.b.microsoft.com'' next. IE 5 would
stop searching when it found a WPAD server or reached the
third-level domain, ''wpad.microsoft.com''.

Anybody using these steps to install and test, please feel free to make
notes, corrections or additions for improvements, and post back to the
squid list...

There are probably many more tricks and tips which hopefully will be
detailed here in the future. Things like ''wpad.dat'' files being served
from the proxy server themselves, maybe with a round robin dns setup
for the WPAD host.

== Configuring Browsers for WPAD with DHCP ==

You can also use DHCP to configure browsers for WPAD.
This technique allows you to set any URL as the PAC
URL.  For ISC DHCPD, enter a line like this in your
''dhcpd.conf'' file:
{{{
option wpad code 252 = text;
option wpad "http://www.example.com/proxy.pac";
}}}

Replace the hostname with the name or address of your
own server.

Ilja Pavkovic notes that the DHCP mode does not work reliably with
every version of Internet Explorer. The DNS name method to find
wpad.dat is more reliable.

Another user adds that IE 6.01 seems to strip the last character
from the URL.  By adding a trailing newline, he is able to make
it work with both IE 5.0 and 6.0:
{{{
option wpad "http://www.example.com/proxy.pac\n";
}}}

== IE 5.0x crops trailing slashes from FTP URL's ==

by Reuben Farrelly

There was a bug in the 5.0x releases of Internet Explorer in which IE
cropped any trailing slash off an FTP URL.  The URL showed up correctly in
the browser's "Address:" field, however squid logs show that the trailing
slash was being taken off.

An example of where this impacted squid if you had a setup where squid
would go direct for FTP directory listings but forward a request to a
parent for FTP file transfers.  This was useful if your upstream proxy was
an older version of Squid or another vendors software which displayed
directory listings with broken icons and you wanted your own local version
of squid to generate proper FTP directory listings instead.
The workaround for this is to add a double slash to any directory listing
in which the slash was important, or else upgrade to IE 5.5.  (Or use Firefox if you cannot upgrade your IE)

== IE 6.0 SP1 fails when using authentication ==

When using authentication with Internet Explorer 6 SP1, you may
encounter issues when you first launch Internet Explorer.
The problem will show itself when you first authenticate, you will
receive a "Page Cannot Be Displayed" error. However, if you click
refresh, the page will be correctly displayed.

This only happens immediately after you authenticate.

This is not a Squid error or bug.   Microsoft broke the Basic
Authentication when they put out IE6 SP1.

There is a knowledgebase article
(
[http://support.microsoft.com/default.aspx?id=kb;en-us;331906 KB 331906])
regarding this issue, which contains a link to a downloadable
"hot fix." They do warn that this code is not "regression tested"
but so far there have not been any reports of this breaking anything
else. The problematic file is wininet.dll. Please note that this
hotfix is included in the latest security update.

Lloyd Parkes notes that the article references another article,
[http://support.microsoft.com/default.aspx?scid=kb;EN-US;312176 KB 312176].
He says that you must '''not''' have the registry entry that KB
312176 encourages users to add to their registry.

According to Joao Coutinho, this simple solution also corrects the problem:

  * Go to Tools/Internet
  * Go to Options/Advanced
  * UNSELECT "Show friendly HTTP error messages" under Browsing.

Another possible workaround to these problems is to make the
ERR_CACHE_ACCESS_DENIED larger than 1460 bytes. This should trigger
IE to handle the authentication in a slightly different manner.

-----
Back to the SquidFaq
