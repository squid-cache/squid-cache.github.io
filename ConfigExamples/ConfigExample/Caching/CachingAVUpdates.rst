##master-page:CategoryTemplate
#format wiki
#language en

= Caching AV updates =

by ''YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

One of the most caching tasks is caching AV (antivirus) updates. 

== Usage ==

Yes, this is most common task to cache AV updates. To do this, you must specify refresh pattern which will be cache most common AV URL's.


== Squid Configuration File ==

Paste the configuration file like this:

{{{

# AV updates
refresh_pattern -i \.symantecliveupdate.com\/.*\.(7z|irn|m26)		4320	100%	43200	reload-into-ims
refresh_pattern -i .*dnl.*\.geo\.kaspersky\.(com|ru)\/.*\.(zip|avc|kdc|nhg|klz|d[at|if])	4320	100%	43200	reload-into-ims
refresh_pattern -i \.kaspersky-labs.(com|ru)\/.*\.(cab|zip|exe|ms[i|p])	4320	100%	43200	reload-into-ims
refresh_pattern -i \.kaspersky.(com|ru)\/.*\.(cab|zip|exe|ms[i|p]|avc)	4320	100%	43200	reload-into-ims
refresh_pattern -i \.avast.com\/.*\.(vp[u|aa])		4320	100%	43200	reload-into-ims
refresh_pattern -i \.avg.com\/.*\.(bin)		4320	100%	43200	reload-into-ims
refresh_pattern -i \.securiteinfo.com\/.*\.([h|n]db|ign2)	14400	100%	518400	reload-into-ims

}}}


----
CategoryConfigExample
