See [Discussed
Page](/ConfigExamples/Intercept/SslBumpWithIntermediateCA#)

For what version of squid is this article for?

  - \- Eliezer

At least 3.5.20, AFAIK.

  - \- Yuri

The wiki page describes the concepts but do not give a script or an
example of implementation using generic ssl tools and libs such as
openssl. There are some details at:
[](https://bugs.squid-cache.org/show_bug.cgi?id=3426#c13) If someone
have couple minutes to write an example of usage or implementation I
believe that it is a must for a proxy to have a key replacement policy.
I have seen that some proxy servers have a month intermediate CA key
replacement policy but it's up to the admin.

  - \- Eliezer
