---
categories: ReviewMe
published: false
---
# Single Sign-on with databases other than Microsoft's user databases

In \<
<OFFFA0E624.849C9A55-ON43256F7E.00374070-43256F7E.003972B7@zahid.com> \>
an user asked:

|                                                                                                                                                      |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| can I use single sigon authentication thru my ldap server for squid users instead of getting the prompt to authenticate. clients are using WinXP pro |

The short answer is: **no**, at least not out of the box. But it could
be done.

Long answer: in order to implement this you need to have access to a
database containing the user passwords, either in cleartext or at least
their NT- and LM-hashes (see
[](http://forum.hackinthebox.org/viewtopic.php?p=40224) for some info on
what those are). These password ***must*** be in sync with those
contained in Active Directory, or the first authentication of a session
will fail and the user will get the dreaded popup. Once you have those,
you "only" have to implement the NTLMSSP protocol (it is what the client
and the helper use) and the Squid NTLM authenticator protocol.

# 407/DENIED and NTLM

Due to the way NTLM authentication over HTTP has been designed by
Microsoft, each new TCP connection needs to be denied twice to perform
the authentication handshake. Then as long as it's kept alive it won't
need any further authentication. Yes, it breaks protocol layering. Yes,
it breaks HTTP's statelessness. And yes, it wastes lots of bandwidth
(two \~2kb denies for an average-sized 16k object means a whopping 20%
overhead in a bad-but-not-unreasonable scenario). For the gory details
of how auth is performed, see
[KnowledgeBase/NTLMAuthGoryDetails](/KnowledgeBase/NTLMAuthGoryDetails)

# Multi-Hop

The Squid mechanisms for adding Proxy-Authentication: headers on client
requests sent upstream does not support the NTLM handshake for login to
the next-hop proxy using NTLM.

> :information_source:
    Microsoft has officially deprecated NTLM in faviour of Kerberos.
    [Squid-3.2](/Releases/Squid-3.2)
    does support Kerberos (Negotiate) login to upstream proxies.
