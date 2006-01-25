#language en
[[TableOfContents]]

== What is a redirector? ==


Squid has the ability to rewrite requested URLs.  Implemented
as an external process (similar to a dnsserver), Squid can be
configured to pass every incoming URL through a ''redirector'' process
that returns either a new URL, or a blank line to indicate no change.


The ''redirector'' program is '''__NOT__''' a standard part of the Squid
package.  However, some examples are provided below, and in the
"contrib/" directory of the source distribution.  Since everyone has
different needs, it is up to the individual administrators to write
their own implementation.


== Why use a redirector? ==


A redirector allows the administrator to control the locations to which
his users goto.  Using this in conjunction with interception proxies
allows simple but effective porn control.


== How does it work? ==


The redirector program must read URLs (one per line) on standard input,
and write rewritten URLs or blank lines on standard output.  Note that
the redirector program can not use buffered I/O.  Squid writes
additional information after the URL which a redirector can use to make
a decision.  The input line consists of four fields:
{{{
URL ip-address/fqdn ident method
}}}




== Do you have any examples? ==


A simple very fast redirector called 
[http://squirm.foote.com.au/ SQUIRM] is a good place to
start, it uses the regex lib to allow pattern matching.


Also see [http://ivs.cs.uni-magdeburg.de/%7eelkner/webtools/jesred/ jesred].


The following Perl script may also be used as a template for writing
your own redirector:
{{{
#!/usr/bin/perl
$|=1;
while (<>) {
    s@http://fromhost.com@http://tohost.org@;
    print;
}
}}}




== Can I use the redirector to return HTTP redirect messages? ==


Normally, the ''redirector'' feature is used to rewrite requested URLs.
Squid then transparently requests the new URL.  However, in some situations,
it may be desirable to return an HTTP "301" or "302" redirect message
to the client.  This is now possible with Squid version 1.1.19.


Simply modify your redirector program to prepend either "301:" or "302:"
before the new URL.  For example, the following script might be used
to direct external clients to a secure Web server for internal documents:
{{{#!perl
#!/usr/bin/perl
$|=1;
while (<>) {
    @X = split;
    $url = $X[0];
    if ($url =~ /^http:\/\/internal\.foo\.com/) {
        $url =~ s/^http/https/;
        $url =~ s/internal/secure/;
        print "302:$url\n";
    } else {
        print "$url\n";
    }
}
}}}



Please see sections 10.3.2 and 10.3.3 of [ftp://ftp.isi.edu/in-notes/rfc2068.txt RFC 2068]
for an explanation of the 301 and 302 HTTP reply codes.


== FATAL: All redirectors have exited! ==


A redirector process must exit (stop running) only when its
''stdin'' is closed.  If you see
the "All redirectories have exited" message, it probably means your
redirector program has a bug.  Maybe it runs out of memory or has memory
access errors.  You may want to test your redirector program outside of
squid with a big input list, taken from your ''access.log'' perhaps.
Also, check for coredump files from the redirector program (see
../TroubleShooting to define where).


== Redirector interface is broken re IDENT values ==


''I added a redirctor consisting of''
{{{
#! /bin/sh
/usr/bin/tee /tmp/squid.log
}}}

''and many of the redirector requests don't have a username in the
ident field.''


Squid does not delay a request to wait for an ident lookup,
unless you use the ident ACLs.  Thus, it is very likely that
the ident was not available at the time of calling the redirector,
but became available by the time the request is complete and
logged to access.log.

If you want to block requests waiting for ident lookup, try something
like this:
{{{
acl foo ident REQUIRED
http_access allow foo
}}}
