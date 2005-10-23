#language en

During the sprint it was recognised that it would be beneficial to collect all of the available completed Squid-2.5 based works into a Squid-2.6 release while we work on getting Squid-3.0 ready.

There is very a large list of completed features developed for Squid-2.5 over the years and
then ported and merged to Squid-3, but in reality production environments are all running the Squid-2.5 versions with different amounts of extra patches today.
Not surprising given the fact that Squid-2.5 has been feature frozen for 3 years now.

The general consensus among the code sprint participants (Henrik, Kinkie & our kind host Guido) is that there is a benefit in collecting all of this already
existing and proven Squid-2.x work into a Squid-2.6 release. It is a fairly low effort, especially considering that each of these pieces have been fairly well
validated separately both by Squid developers and independenly by numerous users of these features, but will buy us a great deal in momentum while working on
Squid-3.0 to stabilize.

List of things we have thought of include in a Squid-2.6 release include

  - cbdatareference
  - windows cygwin service support
  - negotiate (+ NTLM cleanup)
  - reverse proxy improvements
  - ssl client + fixes
  - epoll
  - digest LDAP helper
  - overlapping helper requests
  - external acl improvements
  - UNIX sockets IPC
  - custom log formats
