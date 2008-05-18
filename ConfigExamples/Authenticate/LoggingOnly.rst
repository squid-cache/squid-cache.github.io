##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Logging usernames when using passthrough authentication =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Squid can log usernames for each request made. But it will only do this if an ACL demands authentication (and an authentication method is configured). If an upstream proxy requires authentication, and you require username logging, chances are you will not have access to the upstream password database (or you could probably just check the logs there instead).

== Dummy Auth Helper ==

Since Squid is only supplied with real authentication helpers (at the time of writing), you pretty much need to make your own. I simply cut down a supplied one to suite. It simply does NO authentication, and replies "OK" to any username/password combination.
This could probably be improved upon by someone with knowledge of C. For example, the "#define ERR" line is probably not necessary.
{{{
/* dummy_auth.c
 * AUTHOR: Tim Bates
 *
 * Dummy authentication program for Squid, based on the
 * getpwnam_auth.c example program supplied with Squid.
 */

#include <stdio.h>
#include <stdlib.h>

#define ERR    "ERR\n"
#define OK     "OK\n"

int main()
{
    char buf[256];
    struct passwd *pwd;
    char *user, *passwd, *p;

    setbuf(stdout, NULL);
    while (fgets(buf, 256, stdin) != NULL) {

   printf(OK);
    }
    exit(0);
}
}}}

You can compile this on most Linux  by saving the content to a file called "dummy_auth.c" and running "gcc dummy_auth.c -o dummy_auth".
Windows users will need to find a C compiler on their own (I believe GCC is also available for Windows, but I can't be sure).


== Squid Configuration File ==

Now that you have a dummy_auth program, you can tell Squid how to use it.
This section defines the authetication helper and related settings.
{{{
auth_param basic program /usr/lib/squid/dummy_auth
auth_param basic children 10
auth_param basic realm My Proxy
auth_param basic credentialsttl 1 hours
auth_param basic casesensitive off
}}}

And to make squid actually use it:
{{{
acl YourUsers src 192.168.1.0/24
acl dummyAuth proxy_auth REQUIRED
http_access allow dummyAuth YourUsers
}}}
Remember that http_access order is very important. If you allow access without the "dummyAuth" acl, you won't get usernames logged.

----
CategoryConfigExample
