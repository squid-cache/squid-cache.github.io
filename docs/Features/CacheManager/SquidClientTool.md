# squidclient Tool

This tool is a command line utility for performing web requests.

It also has the ability to send cache manager requests to Squid
proxies.

:warning: The `squidclient` tool is no longer distributed with
Squid 7 and later. Squid-4 and later offer access to the cache
manager over HTTP, which can be accessed using any web browser
or command line tools such as `curl`

To access it:
`curl -u user:pass http://127.0.0.1:3128/squid-internal-mgr/menu`
(`user` can be any, `pass` is the password set with `cachemgr_passwd` in `squid.conf`.)

Replace `menu` with the cache manager report you are interested in,
and 127.0.0.1 with host running squid. Make sure that the cache's `http_access`
rules grant access to the cache itself.


## Cache manager access from squidclient
:warning: this section is for historic reference only.

A simple way to test the access to the cache manager is:
```
squidclient mgr:info
```

> :information_source:
  If you are using a port other than *3128* on your Squid you will
  need to use the **-p** option to specify it.

See `squidclient -h` for more options.

To send a manager password (more on that below) there are two ways
depending on your Squid version.
  - squidclient version 3.1.\* and older you add **@** then the password
    to the URL. So that it looks like this `mgr:info@admin`.
  - squidclient version 3.2.\* use the proxy login options **-u** and
    **w** to pass your admin login to the cache manager.
