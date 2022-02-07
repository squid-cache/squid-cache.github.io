## page was renamed from SquidFaq/SquidRedirectors
#language en
#faqlisted yes

= Feature: Redirection Helpers =

 * '''Goal''': Allow Squid to use custom helpers to redirect and/or hijack web requests on demand to another location.

 * '''Status''': completed

 * '''Version''': 2.5+

## * '''Developer''': unknown

## * '''More''': 


<<TableOfContents>>

 /!\ Some ''redirectors'' are properly called URL re-writers to reflect what they actually do. Which is to alter the URL being handled. Thanks to a long legacy in both Squid and other software (looking at Apache) there are many re-writers and few real redirectors.

== What is a redirector? or re-writer? ==

Squid has the ability to alter requested URLs.  Implemented as an external process, Squid can be configured to pass every incoming URL through a helper process that returns either a new URL, or a blank line to indicate no change.

'''Redirection''' is a defined feature of HTTP where a status code between 300 and 399 is sent to the requesting client along with an alternative URL. A '''redirector''' helper in Squid uses this feature of HTTP to ''bounce'' or re-direct the client browsers to alternative URLs. You may be familiar with '''302''' responses to POST requests or between domains such as www.example.com and example.com.

A '''re-writer''' does not use this feature of HTTP, but merely mangles the URL into a new form. Sometimes this is needed, usually not. HTTP defines many features which this breaks.

The helper program is '''__NOT__''' a standard part of the Squid package.  However, some examples are provided below, and in the "helpers/url_rewrite/" directory of the source distribution.  Since everyone has different needs, it is up to the individual administrators to write their own implementation.

== Why use a redirector? ==

A redirector allows the administrator to control the locations to which his users go.  Using this in conjunction with interception proxies allows simple but effective control.

== How does it work? ==

The helper program must read URLs (one per line) on standard input,
and write rewritten URLs or blank lines on standard output. Squid writes
additional information after the URL which a redirector can use to make
a decision.

<<Include(Features/AddonHelpers,,3,from="^## start urlhelper protocol$", to="^## end urlhelper protocol$")>>

=== Using an HTTP redirector ===

The ''redirector'' feature of HTTP is a "301", "307" or "302" redirect message
to the client specifying an alternative URL to work with.

For example; the following script might be used to redirect external clients to a secure Web server for internal documents:
{{{
#!/usr/bin/perl
$|=1;
while (<>) {
    chomp;
    @X = split;
    $url = $X[1];
    if ($url =~ /^http:\/\/internal\.example\.com/) {
        $url =~ s/^http/https/;
        $url =~ s/internal/secure/;
        print $X[0]." 302:$url\n";
    } else {
        print $X[0]." \n";
    }
}
}}}


<<Include(Features/AddonHelpers,,3,from="^## start redirector protocol$", to="^## end redirector protocol$")>>

=== Using a re-writer to mangle the URL as it passes ===

Normally, the ''redirector'' feature is used to inform the client of alternate URLs. However, in some situations, it may be required to rewrite requested URLs. Squid then transparently requesting the new URL from the web server. This can cause many problems at both the client and server ends so should be avoided in favor of true redirection whenever possible.

A simple very fast rewriter called 
[[http://squirm.foote.com.au/|SQUIRM]] is a good place to
start, it uses the regex lib to allow pattern matching.

An even faster and slightly more featured rewriter based on SQUIRM is [[http://ivs.cs.uni-magdeburg.de/~elkner/webtools/jesred/|jesred]].

The following Perl script may also be used as a template for writing
your own URL re-writer:
{{{
#!/usr/bin/perl
$|=1;
while (<>) {
    chomp;
    @X = split;
    $url = $X[1];
    if ($url =~ /^http:\/\/internal\.example\.com/) {
        print $X[0]." http://www.example.com/\n";
    } else {
        print $X[0]." \n";
    }
}
}}}

<<Include(Features/AddonHelpers,,3,from="^## start urlrewrite protocol$", to="^## end urlrewrite protocol$")>>

== Redirections by origin servers ==

Problem:
  You are using a re-writer to mangle the URL seen by the internal web service. These are not to be shown publicly. But the web server keeps redirecting clients to these internal URLs anyway.


The usual URL re-writer interface only acts on ''client requests''. If you wish to modify server-generated redirections (the HTTP ''Location'' header) you have to use a SquidConf:location_rewrite helper.

The server doing this is very likely also to be using these private URLs in things like cookies or embeded page content. There is nothing Squid can do about those. And worse they may not be reported by your visitors in any way indicating it is the re-writer. A browser-specific '''my login won't work''' is just one popular example of the cookie side-effect.

=== Can I use something other than perl? ===

Almost any external script can be used to perform a redirect. See [[ConfigExamples/PhpRedirectors]] for hints on writing complex redirectors using PHP.

== Troubleshooting ==
=== FATAL: All redirectors have exited! ===

A redirector process must exit (stop running) only when its
''stdin'' is closed.  If you see
the "All redirectors have exited" message, it probably means your
redirector program has a bug.  Maybe it runs out of memory or has memory
access errors.  You may want to test your redirector program outside of
squid with a big input list, taken from your ''access.log'' perhaps.
Also, check for coredump files from the redirector program (see
[[SquidFaq/TroubleShooting]] to define where).

=== unexpected reply on channel ... ===

Your Squid is configured to use concurrency but the helper is either no supporting it or sending back broken replies.

If the channel mentioned contains '''-1''' the helper does not support concurrency.

If the channel mentioned is from a redirector and has a large number ending in 301, 302 etc. The helper does not support concurrency.

NP: URL re-writers that do not support concurrency simply fail to do any re-writing.

SOLUTION: Configure concurrency to '''1''' for that helper.

=== Redirector interface is broken re IDENT values ===

''I added a redirector consisting of''
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

If you want to pause requests until ident lookup is completed, try something
like this:
{{{
acl foo ident REQUIRED
http_access allow foo
}}}


-----
