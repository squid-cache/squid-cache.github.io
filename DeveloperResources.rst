#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

== The Bleeding Edge ==

CVS access instructions are detailed in CvsInstructions; to interactively browse the repository you can use [http://www.squid-cache.org/cgi-bin/cvsweb.cgi CVSWeb].

In order to use the CVS sources, or when developing some parts of Squid, you need to performe a source bootstrap operation. How and Why are described in SourceBootstrap.

== Developer Projects ==

To make life easier we provide space for each developer
interested in developing a feature in Squid. For more
information see http://devel.squid-cache.org/.

== Contributing ==

If you wish to become a developer the first step is to sign up to the squid-dev mailinglist. This is done by first posting an introduction of yourself to squid-dev@squid-cache.org, then send a subscription request to squid-dev-subscribe@squid-cache.org. Please note that all messages must be sent in plain-text only (no HTML email).

If you wish to contribute squid there are certain guidelines you need to follow in your coding style. They are explained in Squid2CodingGuidelines and Squid3CodingGuidelines. The ProgrammingGuide offers some (but certainly not enough) informations on the Squid internals.


If you are looking for a new project to work on,
query the bugzilla database for [http://www.squid-cache.org/bugs/buglist.cgi?component=feature&cmdtype=doit feature requests].

Squid is HTTP/1.0 due to the lack of certain features. RobertCollins has written a [http://devel.squid-cache.org/squidhttp1.1.htm checklist] for HTTP/1.1 compliance.

CppUnit is used to perform unit testing.

== Project organization ==

[ReleaseProcess describes the process and criterias used by the Squid Developers when making new Squid releases.
