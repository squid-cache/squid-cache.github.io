## page was renamed from NegotiateAuthentication
##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted yes

= Feature: Negotiate Authentication =

 * '''Goal''': Make Squid support Negotiate authentication protocol.

 * '''Status''': Complete.

 * '''Version''': 2.6+

 * '''Developer''': GuidoSerassio, HenrikNordstrom, RobertCollins, FrancescoChemolli

 * '''More''': http://squid.acmeconsulting.it/

<<TableOfContents>>

= Details =

'''Negotiate''' is a wrapper protocol around GSSAPI, which in turn is a wrapper around either Kerberos or NTLM authentication. Why a wrapper of a wrapper? No one outside Microsoft knows at this time. GSSAPI would have been more than enough.

The real significance is that supporting it allows support of transparent Kerberos authentication to a MS Windows domain. It is significantly more secure than NTLM and also poses much less burden on the Domain Controller.

See [[Features/Authentication]] for details on other schemes supported by Squid and how authentication in general works.


== How does it work in Squid? ==

Negotiate is at the one time both very simple and somewhat complex. Squids part has been kept intentionally minor and simple to improve the overall system security.

The authentication helper is left to perform all of the risky security encryption and validation processes. Squid may contact it initially for a challenge token and blindly relay this to the client. Any credentials or tokens presented by the client are passed untouched to the helper.

The protocol lines used to do this are described below. This same protocol is used to contact both NTLM and Negotiate authentication helpers. This allows Squid to support both Negotiate/Kerberos and Negotiate/NTLM flavours through the one protocol configuration.
 {i} This double support does lead to some administrative confusion when the helper does not support the same flavour as the client browser.

<<Include(Features/AddonHelpers,,3,from="^## start negotiateauth protocol$", to="^## end negotiateauth protocol$")>>

== Squid native Windows build with NEGOTIATE support ==

A native Windows build of Squid with Negotiate support. Binary package and source archive are available on http://squid.acmeconsulting.it/.


== What do I need to do to support NEGOTIATE on Squid? ==

 {X} This section appears to be extremely outdated. There have been Negotiate/Kerberos helpers for Unix, Linux, BSD and their derived systems for quite some time now.

Just like any other security protocol, support for Negotiate in Squid is made up by two parts: code within Squid to talk to the client and one or more authentication helpers which perform the grunt work. Of course the protocol needs to be enabled in the configuration file for everything to work.

The production-level helper on Unix-like systems will be Samba4's ntlm_auth or squid_kerb_auth by Markus Moeller, and win32_negotiate_auth.exe on windows. Unfortunately Samba 4 is not quite there yet (Note: statment made in 2005, is it still relevant?).

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

----
CategoryFeature
