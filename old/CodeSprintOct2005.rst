#language en

This code sprint took place in October 2005 and was hosted by GuidoSerassio in Rivoli. A few [[http://www.kinkie.it/gallery/2005-squid-code-sprint|pictures]] from the event are available.

Participants:

  * HenrikNordström
  * FrancescoChemolli (kinkie)
  * GuidoSerassio

Primary goal:

  * Port [[Features/NegotiateAuthentication]] support from the negotiate-2.5 branch to Squid-3.

Secondary goals:

  * Hack on whatever projects come up
  * Have fun

Accomplishments:

  * [[Features/NegotiateAuthentication]] fully merged to HEAD
  * [[Squid-2.6]] development cycle started
  * [[Features/ConnPin|Connection Pinning]] implemented in Squid-2.

Failures:

  * We did not manage to get Samba-4 running for the Negotiate tests. Instead a [[Features/NegotiateAuthentication|Windows host was used to verify the authentication exchanges]].
  * UPDATE: using latest Samba-4 snapshot (04-Nov-2005) Negotiate support now seems to work.
