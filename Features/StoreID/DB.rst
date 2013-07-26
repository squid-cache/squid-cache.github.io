A basic structure as an example for StoreID url DB "Many to One".

This DB design is from Alan at [[http://squid-web-proxy-cache.1019090.n4.nabble.com/store-id-pl-doesnt-cache-youtube-tp4660861p4660945.html|POST:"Fwd: [squid-users] store-id.pl doesnt cache youtube " ]]

If you understand the design and have a clue a about a pattern just add it and notice that there is a way to know what you have done...
{{{
^http:\/\/[^\.]+\.dl\.sourceforge\.net\/(.*)                    http://dl.sourceforge.net.squid.internal/$1
^http://epel.mirrors.arminco.com/(.*)                           http://fedora.epel.mirror.squid.internal/$1
^http://epel.mirror.mendoza-conicet.gob.ar/(.*)                 http://fedora.epel.mirror.squid.internal/$1
^http://mirror.optus.net/epel/(.*)                              http://fedora.epel.mirror.squid.internal/$1
}}}
