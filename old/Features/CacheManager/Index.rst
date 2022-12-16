= index report =

When an HTML template named '''MGR_INDEX''' is installed in the '''templates/''' error page directory this report will return its contents after [[Features/CustomErrors|macro expansion]].

This allows creation of a scripted user interface for the cache manager loaded from that template.

== Example JS reporting tool ==

FrancescoChemolli and AmosJeffries have developed a javascript based tool using the MGR_INDEX interface which can be found at https://github.com/yadij/cachemgr.js

It is worth noting that prettiness of the reporting tool GUI is affected by the report format produced by your Squid. Most existing Squids have rather basic text/plain outputs intended for the cachemgr.CGI tool. It is hoped that future releases will be more flexible.

## TODO: add a demo picture of the JS GUI with Squid Foundation branding.
