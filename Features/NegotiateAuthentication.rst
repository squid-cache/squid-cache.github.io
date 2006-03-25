#language en

There are four major flavours of authentication available in the HTTP world at this moment (October 2005):
 * Basic - been around since the very beginning
 * NTLM - Microsoft's first attempt at single-sign-on
 * Digest - w3c's attempt at having a secure authentication system
 * Negotiate (aka SPNEGO) - Microsoft's second attempt at single-sign-on
   Maybe, as it often happens to them, they'll get it right by version 3.0

There are reports of a "Kerberos" authentication scheme being seen in the wild (ISA Server 2004). If you see it, shoot on sight. Microsoft recommends to use Negotiate instead.

Squid supports Basic, NTLM (v1 and v2) and Digest. Support for Negotiate is being worked in 
for both squid 2.5 and 3.0

Currently only Firefox 1.5 and latest beta of Internet Explorer 7 are known to supporting Negotiate authentication with Squid and ISA server 2004

== So what is this "NEGOTIATE" thing anyways? ==

Negotiate is a wrapper protocol around GSSAPI, which in turn is a wrapper around either Kerberos or NTLM. Why a wrapper of a wrapper? No one outside Microsoft knows at this time. GSSAPI would have been more than enough.

The real significance is that supporting it allows to support transparent Kerberos authentication to a MS Windows domain. It is significantly more secure than NTLM and also poses much less burden on the Domain Controller.

== Experimental Squid native Windows build with NEGOTIATE support ==

For testing purpose is now available an experimental native Windows build of Squid 2.5 STABLE13 with Negotiate support. The code is based on the merge of negotiate-2.5 and nt-2.5 branches into the new nego-nt-2.5 branch.

== What do I need to do to support NEGOTIATE on Squid? ==

Just like any other security protocol, support for Negotiate in Squid is made up by two parts: code within Squid to talk to the client and one or more authentication helpers which perform the grunt work. Of course the protocol needs to be enabled in the configuration file for everything to work.

The production-level helper will be Samba4's ntlm_auth on Unix-like systems, and win32_negotiate_auth.exe on windows. Unfortunately Samba 4 is not quite there yet.

If you want to test the UNIX side of things out, there actually is a way to access the win32 helper from a Unix box, and that is by performing an "authorized man-in-the-middle attack", as follows:

 * You need to have an sshd running on the windows box (not a small feat by itself, but it's outside the scope of this document - see http://www.cygwin.com/ for details). Notice that it '''has''' to be running as the SYSTEM account.
 * Create an ssh keypair for the squid user on the Unix box - it's better if the public key is not password-protected.
 * If it doesn't already exist, create an entry in /etc/passwd for the user 'system', specifying an homedir for him (let's call it /home/system from now on).
 * Create a /home/system/.ssh directory on the windows box, and copy within its authorized_keys file the public key of the squid user on the unix box. Try connecting from the unix box (you can run bash over ssh), save the server key and check that everything works.
 * You need to have the ''setspn'' tool from the MS Windows Resource Kit. You need to add the service name of the squid box to the windows box machine account, using the command
   {{{
   setspn -A HTTP/netbiosname
   setspn -A HTTP/netbiosname.domain
}}}
 * configure as helper in squid.conf ssh calling into the helper (make sure that the helper is within %PATH%, i.e.
  {{{
   auth_param negotiate ssh system@netbiosname.domain "win32_negotiate_auth.exe"
}}}
