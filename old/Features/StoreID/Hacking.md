# Article: Store ID - The hackers side of the feature

  - **Goal**: Understand the danger in StoreID.

  - **Status**: 95%

  - **By**: [Eliezer
    Croitoru](https://wiki.squid-cache.org/Features/StoreID/Hacking/Eliezer%20Croitoru#)
    - [NgTech](http://www1.ngtech.co.il/)

  - **Disclaimer**: The StoreID feature is not a hacking tool and the
    creator doesn't encourage this kind of usage of the feature\!\! In
    this article I do not intend to give examples on how to use StoreID
    as a hacking tool but I do mean to describe the concept so it will
    be known and will not be ignored.

# Caching and Hacking

When handling a caching proxy settings sometimes the distance between
being an admin to a hacker is being stretched. The admin is expected to
understand all sort of small things in the HTTP protocol and the RFC so
he can debug and operate the service. The basic simple setup of a
caching proxy might not require that much from the admin but in many
cases the requirement for a caching proxy is due to some specific
traffic which requires the admin to delve the HTTP protocol and to
become a Hacker.

## Objects prediction

One of the most common tasks in this area which is related to squid is
to understand urls patterns in order to define a refresh\_pattern which
will "catch" objects for caching. It requires the admin to analyze and
understand the "target" well enough so he can define enough rules that
will predict what kind of url patterns should be cached and for how
long. This turns the situation into a "predator" fighting with a "prey"
in the http level. When the admin can predict the http objects and
define refresh\_patterns(the right way...) the situation is that he at
least hacked something and with the right tools he can theoretically
inject and poison a cache.

### Youtube and Linux distributions against objects prediction

From many admins point of view the ability to cache content such as
Youtube videos is a task to handle. But the ability to cache an object
by a prediction can lead to lots of very unpleasant situations in the
real world.

While admins don't like the fact that Youtube and other content
providers tries to protect their "in transit" data using some
cryptography tricks my point of view on it comes from the basic
understating of how dangerous it can be if anyone can predict what
videos someone can see.

Some believe that Youtube are doing wrong things but from my side of the
picture they are too naive. I will not say I and google or Youtube are
friends and I must admit that I do like to know the mysteries of the
universe and specifically Youtube. But on the other hand there are
consequences to the fact that an object can be predicted and can be
cached.

From a Linux admin point of view I would not like to find myself in a
situation which I cannot trust Fedora or other Linux distribution RPM or
DEB or other packages. Youtbue have been trying for a very long time to
make sure that their content distribution will not be affected by
hackers since they don't only distribute videos but also many other
kinds of content which is considered sensitive by many. At the same time
[RedHat](https://wiki.squid-cache.org/Features/StoreID/Hacking/RedHat#),
Fedora, Suse and many others are fighting hackers which tries every day
to infect the world with their "wisdom" which in many cases is related
directly to their ability to be cached or predicted for the matter.

## StoreID and objects injection

Since StoreID is a tool that enhance squid caching capability it can but
shouldn't be used as a hacking tool. The simple truth is that the
StoreID feature actually opens one of the most deep internals of Squid
to the cache admin or a hacker. This feature in the wrong hands can be
used to replace java scripts, binary files, pictures, html and other
content with malicious and poisoned content.

From my experience with this feature I know that more then once there
were trials to replace "apk" android packages which can infect a mobile
smart phone with malicious software. It can be used the same for
antivirus or even OS poisoning.

## Warning: Anonymous proxies can be bad\!\!

While some like the idea of an Anonymous proxy that will give you as a
user access to some content, it is a very dangerous thing\! The proxy
admin can collect and alter data when you are most vulnerable and in
many cases attack or exploit your misguided need for anonymity.

# Bottom line

The Internet world is like the streets and should be treated with the
same level of caution like in the real world. When you enter a site you
don't know be on alert that it might contain something you would not
expect.

Be aware that if the certificate of the site has an issue it might be a
result of an attack.

I am only one honest developer which do not intend to harm but it
possible that others are not as honest as I or the Squid project team.
