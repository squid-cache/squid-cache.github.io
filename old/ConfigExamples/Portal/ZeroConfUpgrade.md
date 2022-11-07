# Portal with Browser configuration detection

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

Squid when acting as a web portal sometimes is required to perform
things such as
[authentication](/Features/Authentication#)
or
[ssl-bump](/Features/SslBump#)
which are not possible on a transparent interception proxy. And Yet the
portal is also required to intercept port 80 traffic.

The best solution presently is for browsers to use transparent
configuration in the form of WPAD and PAC zero-conf systems which allow
the portal to point them cleanly at a forward-proxy port and keep them
off of port 80.

This in turn brings up the problem that a large amount of browsers have
these settings are turned off. Possibly too many for the network admin
to visit each problem user and fix their browser.

This example contains the configuration needed in Squid to catch
browsers using port 80 and redirect them to a splash page instructing
the user on how to make the browser changes themselves.

## Instruction Pages

The squid [langpack](http://www.squid-cache.org/Versions/langpack)
bundle of error pages contains two template files called
*ERR\_AGENT\_WPAD* and *ERR\_AGENT\_CONFIGURE* with instructions for the
most popular browsers and a generic instruction for less popular ones.
As with all our bundled pages these come translated in many languages
for easier user reading.

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    When using ERR\_AGENT\_CONFIGURE with Squid older than
    [Squid-3.1.20](/Squid-3.1#)
    you will have to edit the file and change the %b to the squid port
    you want the users configuring. This can be done with:

<!-- end list -->

``` 
 sed --in-place s/%b/3128/ ERR_AGENT_CONFIGURE
```

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    [3.1.20](/Squid-3.1#)
    will fill out the %b value with port 3128. Use the above replacement
    to use another port.
    
    ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    [Squid-3.2](/Squid-3.2#)
    will fill out the %b value with the proxies first *normal*
    (forward-proxy) listening port.

## Squid Configuration File

Setup an ACL to detect web browsers which can display the redirected
page. It is not much use doing this when the program at the other end is
an automated software updater for example.

    acl bounce browser MSIE Gecko Firefox Chrome Opera Safari

We need a way to detect that the traffic came in on the intercept port.
For this the myportname ACL type is used.

    http_port 1234 intercept name=rat-catcher
    acl caught myportname rat-catcher

Finally we put it all together and redirect the web browsers caught on
the intercepted port.

    deny_info ERR_AGENT_WPAD bounce
    http_access deny caught bounce

These are just the snippets of config which cause the splash page and
redirect to be done. Rules which permit the visitor use of the proxy are
expected to be placed as appropriate below them. The basic default
safety nets should as always be above them.

[CategoryConfigExample](/CategoryConfigExample#)
