A basic structure as an example for StoreID url DB "Many to One".

This DB design is from Alan at [[http://squid-web-proxy-cache.1019090.n4.nabble.com/store-id-pl-doesnt-cache-youtube-tp4660861p4660945.html|POST:"Fwd: [squid-users] store-id.pl doesnt cache youtube " ]]

If you understand the design and have a clue a about a pattern just add it and notice that there is a way to know what you have done...
{{{
^http:\/\/[^\.]+\.dl\.sourceforge\.net\/(.*)		sub { "http://dl.sourceforge.net.squid.internal/$1" }
^http:\/\/[1-4]\.bp\.(blogspot\.com)\/			sub { "http://blog-cdn$1" }
^http:\/\/[^\.]+\.c\.youtube\.com\/videoplayback\?.*?id=([^&]+)&.*?itag=([^&]+)&.*?range=([^&]+).*	sub { "http://video-srv.youtube.com.squid.internal/$1&$2&$3" }
}}}
