= Internet Explorer Proxy Caching =

== Overview ==

Most User Agents which implement the proxy autoconfiguration script will call the '''FindProxyForURL()''' once for each object to be fetched. This may impose significant overheads to browsing on slower machines, with pages with many, many individual objects, or with a very large amount of JavaScript in the function call.

Internet Explorer by default caches the result from the function for that given host - it is known as the '''Automatic Proxy Result Cache'''. This results in less calls to the '''FindProxyForURL()''' function and may speed up browsing but it has a number of implications.

Users who deploy proxy autoconfiguration files for loadbalancing, failover or implementing multiple proxy selection or DIRECT fall-through. There is a documented workaround.

This isn't known to be a problem with other web browsers.

== Explanation ==

Internet Explorer records the chosen proxy server (or DIRECT? should verify -adrian) from a call to '''FindProxyForURL()''' against the hostname part of the URL. It then uses this for further URL accesses whose hostname matches the cached entry. If the proxy server then fails Internet Explorer will return a "Page can not be displayed" error.

Microsoft has published a Tech Note article on this behaviour and explains how to disable the behaviour via Group Policy and Registry modifications. Please read the article for further information.

== Links ==

 * Microsoft Tech Note arcticle: http://support.microsoft.com/?scid=kb%3Ben-us%3B271361&x=14&y=15
