#language en

Short report on the code sprint which took place in October 2005

Participants:

  * HenrikNordström
  * Francesco '["kinkie"]' Chemolli
  * GuidoSerassio

Primary goal:

  * Port NegotiateAuthentication support from the negotiate-2.5 branch to Squid-3.

Secondary goals:

  * Hack on whatever projects come up
  * Have fun

Accomplishments:

  * NegotiateAuthentication fully merged to HEAD
  * ["Squid-2.6"] development cycle started
  * ConnectionPinning implemented

Failures:

  * We did not manage to get Samba-4 running for the Negotiate tests. Instead a Windows host was used to verify the authentication exchanges.
