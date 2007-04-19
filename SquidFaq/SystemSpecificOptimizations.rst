##master-page:CategoryTemplate
#format wiki
#language en

## This page is meant to contain informations about system-specific settings

[[TableOfContents]]

##begin

== General advice ==
The settings detailed in this FAQ chapter are suggestion for operating-system-specific settings which '''may''' help when running busy caches.
It is recommended to check that the settings have the desired effect by using the [:../CacheManager:Cache Manager].

== FreeBSD ==

=== Filedescriptors ===
For busy caches, it makes sense to increase the number of system-wide available filedescriptors, by setting in:
in {{{/etc/sysctl.conf}}}
{{{
kern.maxfilesperproc=8192
}}}

=== Diskd ===

|| /!\ ||This information is out-of-date, as with newer FreeBSD versions these parameters can be tuned at runtime via sysctl. We're looking for contributions to update this page||


In order to run diskd you may need to tweak your kernel settings.
Try setting in the kernel config file (larger values may be needed for very busy caches):
{{{
options         MSGMNB=8192     # max # of bytes in a queue
options         MSGMNI=40       # number of message queue identifiers
options         MSGSEG=512      # number of message segments per queue
options         MSGSSZ=64       # size of a message segment
options         MSGTQL=2048     # max messages in system

options SHMSEG=16
options SHMMNI=32
options SHMMAX=2097152
options SHMALL=4096
options MAXFILES=16384
}}}


##end
-----
Back to the SquidFaq
