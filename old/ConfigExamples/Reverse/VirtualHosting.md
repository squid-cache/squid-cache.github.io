# Reverse Proxy with HTTP/1.1 Domain Based Virtual Host Support

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

  - 
    
    <table>
    <tbody>
    <tr class="odd">
    <td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png" width="16" height="16" alt="{i}" /> NOTE:</p></td>
    <td><p>This configuration is for <a href="/Squid-3.1#">Squid-3.1</a> and older which are HTTP/1.0 proxies.</p>
    <p><a href="/Squid-3.2#">Squid-3.2</a> has virtual hosting support enabled by default as part of HTTP/1.1.</p></td>
    </tr>
    </tbody>
    </table>

## Squid Configuration

|                                                                      |                                                                                                                                                                                                                       |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ⚠️ | This configuration **MUST** appear at the top of squid.conf above any other forward-proxy configuration (http\_access etc). Otherwise the standard proxy access rules block some people viewing the accelerated site. |

If you are using
[Squid-3.1](/Releases/Squid-3.1)
or older has an accelerator for a domain based virtual host system then
you need to additionally specify the **vhost** option to
[http\_port](http://www.squid-cache.org/Doc/config/http_port)

    http_port 80 accel defaultsite=your.main.website.name vhost

  - **accel** tells Squid to handle requests coming in this port as if
    it was a Web Server

  - **defaultsite=X** tells Squid to assume the domain *X* is wanted.

  - **vhost** for
    [Squid-3.1](/Releases/Squid-3.1)
    or older enables HTTP/1.1 domain based virtual hosting support. Omit
    this option for
    [Squid-3.2](/Releases/Squid-3.2)
    or later versions.

When both defaultsite and vhost is specified, defaultsite specifies the
domain name old HTTP/1.0 clients not sending a Host header should be
sent to. Squid will run fine if you only use vhost, but there is still
some software out there not sending Host headers so it's recommended to
specify defaultsite as well. If defaultsite is not specified those
clients will get an "Invalid request" error.

Next, you need to tell Squid where to find the real web server:

    cache_peer backend.webserver.ip.or.dnsname parent 80 0 no-query originserver name=myAccel

And finally you need to set up access controls to allow access to your
site without pushing other web requests to your web server.

    acl our_sites dstdomain your.main.website.name
    http_access allow our_sites
    cache_peer_access myAccel allow our_sites
    cache_peer_access myAccel deny all

You should now be able to start Squid and it will serve requests as a
HTTP server.

### Testing and Live

Testing of reverse-proxies should be done with Squid configured properly
as it would be used in production. But the public DNS setting not
pointing at it. The /etc/hosts file of a test machine can be altered to
send test requests to the squid IP instead of the live webserver.

When that testing works, public DNS can be updated to send public
requests to the Squid proxy instead of the master web server and
Acceleration will begin immediately.

[CategoryConfigExample](/CategoryConfigExample)
