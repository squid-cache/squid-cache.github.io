#format wiki
#language en

<<TableOfContents>>

##begin
== Adding a Cache Dir ==

''by Chris Robertson''

Adding a new drive to Squids cache directory set is a useful thing to know. And simple as well.

Squid will handle the changes semi-automatically, but there are still a few operations that need to be kicked off manually.

Assuming your disk is attached, your OS recognizes it and the disk is formatted:

 1. Ensure the effective_squid_user has write capability on the mount point
 2. Add a cache_dir directive to squid.conf referencing the new mount point
 3. Stop squid
 4. Run squid -z (as root or as the effective_squid_user)
 5. Start squid

== Downtime reduction hack ==

''by Amos Jeffries''

Disclaimer: This hack is theoretical, still needing confirmation of success. There is a slight chance the squid -z will abort early if it discovers another running squid instance.

NP: this does not apply to large caches as there is no touching of the existing cache_dir anyway.

 1. Ensure the effective_squid_user has write capability on the mount point
 2. Add a cache_dir directive to squid.conf referencing the new mount point
 3. Run squid -z -f ./squid.conf (as root or as the effective_squid_user)
 4. Reconfigure the running squid (-k reconfigure)

##end
-----
Back to the SquidFaq
