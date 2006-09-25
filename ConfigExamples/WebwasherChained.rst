#language en

= Configuring Squid and Webwasher in a proxy chain =

By ChristophHaas

[[TableOfContents]]

== Outline ==

Squid is a brilliant caching proxy software. But it lacks a component for content filtering.
Often Squid administrators get ordered to prevent downloading of virus-infected files or to
filter out adult content. There is software like Dansguardian or Squidguard that attempts to
do just that. But in a corporate environment this isn't sufficient at all.

Squid 3.x includes an ICAP client which at least allows you to connect ICAP-capable
content filters. But even with Squid 2.x you can connect other proxies in a ''proxy chain''.
So this article deals with the integration of the WebWasher proxy software (made by ''Secure Computing'').

<!> DISCLAIMER: Webwasher is a relatively expensive piece of software.
If you want to save your kids at home from porn web sites this article is not for you.
The reason this article exists is that we use it at work. It's not meant as an advertisement.

== The example setup ==

The setup that is described below works roughly like this:

 * Users point their browsers to the Squid proxy
 * When accessing the proxy the user gets asked for authentication (by verifying the credentials through LDAP)
 * Once the user is authenticated and let through according to ACLs the request is forwarded to the Webwasher
 * The Webwasher takes the authenticated username from Squid and assigns a ''profile'' (by looking up LDAP groups)
 * The transmitted content (request and response) are checked by the rules of the assigned profile and is either allowed or blocked

What the Webwasher does:

 * Virus scanning
 * URL blocking (huge database of URLs that allows you to block certain categories like web mail, porn or anonymous proxies)
 * Scanning of ''active content'' like Javascript, Java or ActiveX. It analyses what the Javascript or Java is actually doing and can block e.g. scripts that try to access the hard disk.
 * Checking of allowed content types (it does not just accept the content type that is sent by the browser but instead checks the actual content by so called ''magic bytes'' that are also used by the UNIX' '''file''' command)
 * Sanity checks: depth and size of archives, Microsoft Authenticode (most incorrectly signed scripts seem to come from Microsoft itself)

...

----
CategoryConfigExample
